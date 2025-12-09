<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class CheckProfileCompleted
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next)
    {
        $user = Auth::user();

        if ($user->role === 'admin') return $next($request);

        if ($user->role === 'user' && !$user->profile) {
            return response()->json(['error' => 'Complete your profile before using this feature'], 403);
        }

        if ($user->role === 'provider' && !$user->provider) {
            return response()->json(['error' => 'Complete your provider profile first'], 403);
        }

        return $next($request);
    }
}
