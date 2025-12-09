<?php

namespace App\Providers;

use App\Models\Department;
use App\Models\Profile;
use App\Models\Provider;
use App\Policies\DepartmentPolicy;
use App\Policies\ProfilePolicy;
use App\Policies\ProviderPolicy;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [
        Profile::class => ProfilePolicy::class,
        Provider::class => ProviderPolicy::class,
        Department::class => DepartmentPolicy::class,
    ];

    /**
     * Register services.
     */
    public function register(): void
    {

    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        $this->registerPolicies();
    }
}
