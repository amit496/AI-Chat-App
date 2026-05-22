<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Chat;
use App\Support\AdminId;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    public function show(Request $request, string $id): JsonResponse
    {
        $chat = Chat::query()->findOrFail(AdminId::decodeOrFail($id));
        $chat->load([
            'user:id,name,email',
            'messages' => fn ($q) => $q->orderBy('created_at')->limit(200),
        ]);

        return response()->json([
            'chat' => [
                'id' => $chat->id,
                'eid' => AdminId::encode($chat->id),
                'title' => $chat->title,
                'user_id' => $chat->user_id,
                'user' => $chat->user,
                'created_at' => $chat->created_at,
                'updated_at' => $chat->updated_at,
            ],
            'messages' => $chat->messages->map(fn ($m) => [
                'id' => $m->id,
                'sender_type' => $m->sender_type,
                'message' => $m->message,
                'image_path' => $m->image_path,
                'created_at' => $m->created_at,
            ]),
        ]);
    }
}
