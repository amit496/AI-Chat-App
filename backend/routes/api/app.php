<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ChatController;
use App\Http\Controllers\Api\ProfileController;
use Illuminate\Support\Facades\Route;

/*
| Mobile app API — /api/*
| Flutter: flutter_app/
| Controllers: app/Http/Controllers/Api/
*/
Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:10,1');
Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:10,1');
Route::post('/auth/firebase-sync', [AuthController::class, 'firebaseSync'])->middleware('throttle:20,1');

Route::middleware(['auth:sanctum', 'throttle:60,1'])->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/profile', [ProfileController::class, 'show']);
    Route::post('/update-profile', [ProfileController::class, 'update']);

    Route::post('/send-message', [ChatController::class, 'sendMessage'])->middleware('throttle:30,1');
    Route::get('/chat-history', [ChatController::class, 'history']);
    Route::get('/chats/{chat}', [ChatController::class, 'show']);
    Route::delete('/delete-chat/{chat}', [ChatController::class, 'deleteChat']);
    Route::delete('/clear-chat-history', [ChatController::class, 'clearHistory']);
});
