<?php

namespace App\Services;

use App\Models\AiUsageLog;
use App\Models\ErrorLog;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Str;

class GeminiService
{
    /**
     * Uses Gemini free tier (gemini-2.0-flash) via Google AI Studio API key.
     */
    public function chat(array $history, string $userMessage, ?string $imageBase64 = null): array
    {
        $apiKey = config('services.gemini.api_key');
        $model = config('services.gemini.model', 'gemini-2.0-flash');

        if (empty($apiKey)) {
            throw new \RuntimeException('Gemini API key is not configured.');
        }

        if ($this->isDemoKey($apiKey)) {
            return $this->demoResponse($userMessage);
        }

        $contents = [];

        foreach ($history as $item) {
            $role = $item['role'] === 'ai' ? 'model' : 'user';
            $contents[] = [
                'role' => $role,
                'parts' => [['text' => $item['text']]],
            ];
        }

        $userParts = [['text' => $userMessage]];

        if ($imageBase64) {
            $userParts[] = [
                'inline_data' => [
                    'mime_type' => 'image/jpeg',
                    'data' => $imageBase64,
                ],
            ];
        }

        $contents[] = ['role' => 'user', 'parts' => $userParts];

        $url = "https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent";

        $response = Http::timeout(60)
            ->retry(2, 500)
            ->post("{$url}?key={$apiKey}", [
                'contents' => $contents,
            ]);

        if ($response->failed()) {
            throw new \RuntimeException(
                $response->json('error.message') ?? 'Gemini API request failed.'
            );
        }

        $text = data_get($response->json(), 'candidates.0.content.parts.0.text', '');

        if ($text === '') {
            throw new \RuntimeException('Empty response from Gemini API.');
        }

        return [
            'text' => $text,
            'model' => $model,
            'usage' => data_get($response->json(), 'usageMetadata', []),
        ];
    }

    public function logUsage(?int $userId, ?int $chatId, string $model, array $usage, string $status = 'success'): void
    {
        AiUsageLog::create([
            'user_id' => $userId,
            'chat_id' => $chatId,
            'model' => $model,
            'prompt_tokens' => (int) data_get($usage, 'promptTokenCount', 0),
            'response_tokens' => (int) data_get($usage, 'candidatesTokenCount', 0),
            'status' => $status,
        ]);
    }

    public function logError(?int $userId, string $endpoint, string $message, array $context = []): void
    {
        ErrorLog::create([
            'user_id' => $userId,
            'source' => 'api',
            'endpoint' => $endpoint,
            'message' => Str::limit($message, 1000),
            'context' => $context,
        ]);
    }

    private function isDemoKey(string $apiKey): bool
    {
        return str_contains($apiKey, 'Dummy') || str_contains($apiKey, 'REPLACE');
    }

    private function demoResponse(string $userMessage): array
    {
        $model = config('services.gemini.model', 'gemini-2.0-flash');

        return [
            'text' => "[Demo mode — replace GEMINI_API_KEY in .env]\n\nYou said: \"{$userMessage}\"\n\nThis is a sample Zynthio reply. Add your real Gemini key from https://aistudio.google.com/apikey for live AI responses.",
            'model' => $model.'-demo',
            'usage' => ['promptTokenCount' => 0, 'candidatesTokenCount' => 0],
        ];
    }
}
