<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Support\PublicStorageUrl;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
            'firebase_uid' => ['nullable', 'string', 'max:128', 'unique:users,firebase_uid'],
        ]);

        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => $data['password'],
            'firebase_uid' => $data['firebase_uid'] ?? null,
        ]);

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'message' => 'Registered successfully.',
            'user' => $this->userPayload($user),
            'token' => $token,
        ], 201);
    }

    public function login(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $user = User::where('email', $data['email'])->first();

        if (! $user || ! Hash::check($data['password'], $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Invalid credentials.'],
            ]);
        }

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'message' => 'Logged in successfully.',
            'user' => $this->userPayload($user),
            'token' => $token,
        ]);
    }

    /**
     * Sync user after Firebase Auth sign-in (Spark plan is free).
     */
    public function firebaseSync(Request $request): JsonResponse
    {
        $data = $request->validate([
            'firebase_uid' => ['required', 'string', 'max:128'],
            'email' => ['required', 'email', 'max:255'],
            'name' => ['required', 'string', 'max:255'],
        ]);

        $user = User::updateOrCreate(
            ['firebase_uid' => $data['firebase_uid']],
            [
                'email' => $data['email'],
                'name' => $data['name'],
                'password' => Hash::make(str()->random(32)),
            ]
        );

        if ($user->wasRecentlyCreated === false && $user->email !== $data['email']) {
            $user->update(['email' => $data['email'], 'name' => $data['name']]);
        }

        $user->tokens()->delete();
        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'message' => 'Firebase account synced.',
            'user' => $this->userPayload($user),
            'token' => $token,
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()?->delete();

        return response()->json(['message' => 'Logged out successfully.']);
    }

    private function userPayload(User $user): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'profile_image' => PublicStorageUrl::for($user->profile_image),
            'firebase_uid' => $user->firebase_uid,
        ];
    }
}
