<?php

namespace App\Support;

use Illuminate\Filesystem\FilesystemAdapter;
use Illuminate\Support\Facades\Storage;

final class PublicStorageUrl
{
    public static function for(?string $path): ?string
    {
        if ($path === null || $path === '') {
            return null;
        }

        $disk = Storage::disk('public');

        if ($disk instanceof FilesystemAdapter) {
            return $disk->url($path);
        }

        $base = config('filesystems.disks.public.url', '/storage');

        return rtrim((string) $base, '/').'/'.ltrim($path, '/');
    }
}
