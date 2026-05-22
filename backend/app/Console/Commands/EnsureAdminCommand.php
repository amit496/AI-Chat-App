<?php

namespace App\Console\Commands;

use App\Models\Admin;
use Illuminate\Console\Command;

class EnsureAdminCommand extends Command
{
    protected $signature = 'admin:ensure';

    protected $description = 'Create or reset default admin (admin@zynthio.test / password)';

    public function handle(): int
    {
        $admin = Admin::updateOrCreate(
            ['email' => 'admin@zynthio.test'],
            ['name' => 'Zynthio Admin'],
        );

        $admin->password = 'password';
        $admin->save();

        $this->info('Admin ready: admin@zynthio.test / password');
        $this->info('Panel URL: '.url('/admin'));

        return self::SUCCESS;
    }
}
