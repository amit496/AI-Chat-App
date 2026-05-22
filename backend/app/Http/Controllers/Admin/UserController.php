<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Support\AdminId;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function index(): JsonResponse
    {
        $users = User::query()
            ->withCount('chats')
            ->latest()
            ->paginate(50);

        $users->getCollection()->transform(function (User $user) {
            $data = $user->toArray();
            $data['eid'] = AdminId::encode($user->id);

            return $data;
        });

        return response()->json($users);
    }

    public function show(Request $request, string $id): JsonResponse
    {
        $user = User::query()->findOrFail(AdminId::decodeOrFail($id));
        $user->loadCount('chats');

        $chats = $user->chats()
            ->withCount('messages')
            ->latest()
            ->limit(100)
            ->get(['id', 'title', 'created_at', 'updated_at'])
            ->map(fn ($chat) => [
                'id' => $chat->id,
                'eid' => AdminId::encode($chat->id),
                'title' => $chat->title,
                'messages_count' => $chat->messages_count,
                'created_at' => $chat->created_at,
                'updated_at' => $chat->updated_at,
            ]);

        return response()->json([
            'user' => [
                'id' => $user->id,
                'eid' => AdminId::encode($user->id),
                'name' => $user->name,
                'email' => $user->email,
                'profile_image' => $user->profile_image,
                'firebase_uid' => $user->firebase_uid,
                'chats_count' => $user->chats_count,
                'created_at' => $user->created_at,
                'updated_at' => $user->updated_at,
            ],
            'chats' => $chats,
        ]);
    }
}
