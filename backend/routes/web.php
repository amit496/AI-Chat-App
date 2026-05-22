<?php

use Illuminate\Support\Facades\Route;

/*
| Storefront (user website)
| React: resources/js/Pages/Storefront/
| View: resources/views/storefront/
*/
Route::get('/', fn () => view('storefront.home', ['title' => config('app.name')]))->name('home');

require __DIR__.'/admin/web.php';
