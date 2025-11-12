<?php

namespace App\Providers;

use GuzzleHttp\Psr7\Response;
use Illuminate\Support\ServiceProvider;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
 
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {

        //gor greetings
        RateLimiter::for('greetings-limit', function(Request $request){
            return Limit::perMinute(5)->by( $request->user()?->id ?: $request->ip());
        });

        //for fallback
        RateLimiter::for('pagenotfound-limit', function (Request $request) {
            return Limit::perMinute(5)
                ->by($request->user()?->id ?: $request->ip());
        });


       

    }
}