<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AiUsageLog;
use App\Models\Chat;
use App\Models\ErrorLog;
use App\Models\Message;
use App\Models\User;
use Illuminate\Http\JsonResponse;

class DashboardController extends Controller
{
    public function stats(): JsonResponse
    {
        return response()->json([
            'users' => User::count(),
            'chats' => Chat::count(),
            'messages' => Message::count(),
            'ai_requests' => AiUsageLog::count(),
            'errors' => ErrorLog::count(),
            'ai_usage_today' => AiUsageLog::whereDate('created_at', today())->count(),
        ]);
    }
}
