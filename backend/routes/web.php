<?php

use Illuminate\Support\Facades\Route;

Route::get('/', fn () => view('home', ['title' => config('app.name')]))->name('home');

Route::get('/admin', fn () => view('admin'))->name('admin');
