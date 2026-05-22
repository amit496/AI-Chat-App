<?php

use Illuminate\Support\Facades\Route;

/*
| Back office (admin panel) — HTML shell
| React: resources/js/Pages/Admin/
| View: resources/views/admin/
*/
Route::get('/admin', fn () => view('admin.app'))->name('admin');
Route::redirect('/admin/login', '/admin');
Route::redirect('/admin/dashboard', '/admin');
