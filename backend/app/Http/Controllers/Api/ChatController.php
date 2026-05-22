<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Chat;
use App\Models\Message;
use App\Services\GeminiService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ChatController extends Controller
{
    public function __construct(private readonly GeminiService $gemini) {}

    public function sendMessage(Request $request): JsonResponse
    {
        $data = $request->validate([
            'chat_id' => ['nullable', 'integer', 'exists:chats,id'],
            'message' => ['required', 'string', 'max:8000'],
            'image' => ['nullable', 'image', 'max:5120'],
        ]);

        $user = $request->user();

        $chat = isset($data['chat_id'])
            ? Chat::where('user_id', $user->id)->findOrFail($data['chat_id'])
            : Chat::create([
                'user_id' => $user->id,
                'title' => Str::limit($data['message'], 40),
            ]);

        $imagePath = null;
        $imageBase64 = null;

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('chat-images', 'public');
            $imageBase64 = base64_encode(Storage::disk('public')->get($imagePath));
        }

        $userMessage = Message::create([
            'chat_id' => $chat->id,
            'sender_type' => 'user',
            'message' => $data['message'],
            'image_path' => $imagePath,
        ]);

        $history = $chat->messages()
            ->where('id', '<', $userMessage->id)
            ->latest()
            ->take(20)
            ->get()
            ->reverse()
            ->map(fn (Message $m) => [
                'role' => $m->sender_type,
                'text' => $m->message,
            ])
            ->values()
            ->all();

        try {
            $result = $this->gemini->chat($history, $data['message'], $imageBase64);

            $aiMessage = Message::create([
                'chat_id' => $chat->id,
                'sender_type' => 'ai',
                'message' => $result['text'],
            ]);

            $this->gemini->logUsage($user->id, $chat->id, $result['model'], $result['usage']);
        } catch (\Throwable $e) {
            $this->gemini->logError($user->id, '/api/send-message', $e->getMessage());

            return response()->json([
                'message' => 'Something went wrong',
                'error' => config('app.debug') ? $e->getMessage() : null,
            ], 502);
        }

        return response()->json([
            'chat' => [
                'id' => $chat->id,
                'title' => $chat->title,
            ],
            'messages' => [
                $this->messagePayload($userMessage),
                $this->messagePayload($aiMessage),
            ],
        ]);
    }

    public function history(Request $request): JsonResponse
    {
        $chats = Chat::query()
            ->where('user_id', $request->user()->id)
            ->with(['messages' => fn ($q) => $q->latest()->take(1)])
            ->latest()
            ->get()
            ->map(fn (Chat $chat) => [
                'id' => $chat->id,
                'title' => $chat->title,
                'created_at' => $chat->created_at,
                'last_message' => $chat->messages->first()
                    ? $this->messagePayload($chat->messages->first())
                    : null,
            ]);

        return response()->json(['chats' => $chats]);
    }

    public function show(Request $request, Chat $chat): JsonResponse
    {
        abort_unless($chat->user_id === $request->user()->id, 403);

        $messages = $chat->messages()->orderBy('created_at')->get()
            ->map(fn (Message $m) => $this->messagePayload($m));

        return response()->json([
            'chat' => ['id' => $chat->id, 'title' => $chat->title],
            'messages' => $messages,
        ]);
    }

    public function deleteChat(Request $request, Chat $chat): JsonResponse
    {
        abort_unless($chat->user_id === $request->user()->id, 403);

        $chat->delete();

        return response()->json(['message' => 'Chat deleted successfully.']);
    }

    public function clearHistory(Request $request): JsonResponse
    {
        Chat::where('user_id', $request->user()->id)->delete();

        return response()->json(['message' => 'All chats cleared.']);
    }

    private function messagePayload(Message $message): array
    {
        return [
            'id' => $message->id,
            'sender_type' => $message->sender_type,
            'message' => $message->message,
            'image_url' => $message->image_path
                ? Storage::disk('public')->url($message->image_path)
                : null,
            'created_at' => $message->created_at,
        ];
    }
}
