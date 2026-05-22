<?php

use App\Http\Controllers\Admin\AnalyticsController as AdminAnalyticsController;
use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Admin\ChatController as AdminChatController;
use App\Http\Controllers\Admin\DashboardController as AdminDashboardController;
use App\Http\Controllers\Admin\UserController as AdminUserController;
use Illuminate\Support\Facades\Route;

/*
| Back office API — /api/admin/*
| Controllers: app/Http/Controllers/Admin/
*/
Route::prefix('admin')->group(function () {
    Route::post('/login', [AdminAuthController::class, 'login'])->middleware('throttle:10,1');

    Route::middleware(['auth:sanctum', 'admin'])->group(function () {
        Route::post('/logout', [AdminAuthController::class, 'logout']);
        Route::get('/stats', [AdminDashboardController::class, 'stats']);
        Route::get('/users', [AdminUserController::class, 'index']);
        Route::get('/users/{id}', [AdminUserController::class, 'show'])->where('id', '.+');
        Route::get('/chats/{id}', [AdminChatController::class, 'show'])->where('id', '.+');
        Route::get('/ai-usage', [AdminAnalyticsController::class, 'aiUsage']);
        Route::get('/ai-usage/{id}', [AdminAnalyticsController::class, 'showAiUsage'])->where('id', '.+');
        Route::get('/errors', [AdminAnalyticsController::class, 'errors']);
        Route::get('/errors/{id}', [AdminAnalyticsController::class, 'showError'])->where('id', '.+');
    });
});
