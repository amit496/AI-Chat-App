<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AiUsageLog;
use App\Models\ErrorLog;
use App\Support\AdminId;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AnalyticsController extends Controller
{
    public function aiUsage(): JsonResponse
    {
        $logs = AiUsageLog::with(['user:id,name,email', 'chat:id,title'])
            ->latest()
            ->paginate(50);

        $logs->getCollection()->transform(function (AiUsageLog $log) {
            $data = $log->toArray();
            $data['eid'] = AdminId::encode($log->id);

            return $data;
        });

        return response()->json($logs);
    }

    public function errors(): JsonResponse
    {
        $logs = ErrorLog::with('user:id,name,email')
            ->latest()
            ->paginate(50);

        $logs->getCollection()->transform(function (ErrorLog $log) {
            $data = $log->toArray();
            $data['eid'] = AdminId::encode($log->id);

            return $data;
        });

        return response()->json($logs);
    }

    public function showAiUsage(Request $request, string $id): JsonResponse
    {
        $log = AiUsageLog::query()->findOrFail(AdminId::decodeOrFail($id));
        $log->load(['user:id,name,email', 'chat:id,title,user_id']);

        $data = $log->toArray();
        $data['eid'] = AdminId::encode($log->id);

        return response()->json(['log' => $data]);
    }

    public function showError(Request $request, string $id): JsonResponse
    {
        $log = ErrorLog::query()->findOrFail(AdminId::decodeOrFail($id));
        $log->load('user:id,name,email');

        $data = $log->toArray();
        $data['eid'] = AdminId::encode($log->id);

        return response()->json(['log' => $data]);
    }
}
