<?php

use Illuminate\Support\Facades\Route;

Route::get('/', fn () => view('home', ['title' => 'NovaAI']))->name('home');

Route::get('/admin', fn () => view('admin'))->name('admin');
