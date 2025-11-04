<?php

use App\Http\Controllers\TodolistController;
use App\Http\Controllers\UserController;
use App\Http\Middleware\EnsureTokenIsValid;
use App\Models\User;
use GuzzleHttp\Psr7\Request;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use Laravel\Prompts\Concerns\Fallback;

Route::get('/', function () {
    return Inertia::render('welcome');
})->name('home');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('dashboard', function () {
        return Inertia::render('dashboard');
    })->name('dashboard');

    //greetings route's contoller call
    Route::resource('greetings', UserController::class, )//doesn't work for index,create,store
        ->middleware('throttle:greetings-limit')->missing(function (Request $req) {
            return Redirect::route('greetings.index');//return to the greetings page if some req does not exist
    });

    //parametered route
    Route::get('userz', function () {
        return Inertia::render('user', ['name' => 'Negro de papa']);
    });

    Route::get('todolist',  [TodolistController::class,'index'])->name('todolist');
    Route::post('todolist',  [TodolistController::class,'store'])->name('todolist.store');
    Route::delete('todolist/{id}', [TodolistController::class,'destroy'])->name('todolist.destroy');
  //todolists router
   
    //fallback for all routes
    Route::fallback(function () {
        return "This is a fall back http!";
    })->middleware('throttle:pagenotfound-limit');

    //get token if it's valid
    Route::get('isvalid',function () {
        return "valid token";
    })->middleware(EnsureTokenIsValid::class);

    Route::get('test', function () {
        return redirect()->away('https://facebook.com');
    });

    
    
});

require __DIR__.'/settings.php';
require __DIR__.'/auth.php';