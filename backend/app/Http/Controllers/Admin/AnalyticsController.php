<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AiUsageLog;
use App\Models\ErrorLog;
use Illuminate\Http\JsonResponse;

class AnalyticsController extends Controller
{
    public function aiUsage(): JsonResponse
    {
        $logs = AiUsageLog::with(['user:id,name,email', 'chat:id,title'])
            ->latest()
            ->paginate(30);

        return response()->json($logs);
    }

    public function errors(): JsonResponse
    {
        $logs = ErrorLog::with('user:id,name,email')
            ->latest()
            ->paginate(30);

        return response()->json($logs);
    }
}
