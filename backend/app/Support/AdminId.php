<?php

namespace App\Support;

use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Crypt;
use InvalidArgumentException;

class AdminId
{
    public static function encode(int $id): string
    {
        return rawurlencode(Crypt::encryptString((string) $id));
    }

    public static function decode(string $token): int
    {
        try {
            $value = Crypt::decryptString(rawurldecode($token));
        } catch (DecryptException) {
            throw new InvalidArgumentException('Invalid resource id.');
        }

        if (! is_numeric($value) || (int) $value < 1) {
            throw new InvalidArgumentException('Invalid resource id.');
        }

        return (int) $value;
    }

    public static function decodeOrFail(string $token): int
    {
        try {
            return self::decode($token);
        } catch (InvalidArgumentException) {
            abort(404, 'Resource not found.');
        }
    }
}
