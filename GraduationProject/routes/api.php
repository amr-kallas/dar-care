<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\DepartmentController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProviderController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);
Route::get('providerss',[ProviderController::class,'filter']);

Route::middleware('jwt')->group(function(){

    Route::post('/logout',[AuthController::class,'logout']);

    Route::apiResource('profiles',ProfileController::class);
    Route::apiResource('providers',ProviderController::class);
    Route::apiResource('departments',DepartmentController::class);
});

