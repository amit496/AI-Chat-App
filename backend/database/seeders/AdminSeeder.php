<?php

namespace Database\Seeders;

use App\Models\Admin;
use Illuminate\Database\Seeder;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        $admin = Admin::updateOrCreate(
            ['email' => 'admin@zynthio.test'],
            ['name' => 'Zynthio Admin'],
        );

        // Always reset password so login works (admin@zynthio.test / password)
        $admin->password = 'password';
        $admin->save();
    }
}
