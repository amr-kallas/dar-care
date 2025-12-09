<?php

namespace App\Policies;

use App\Models\Provider;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class ProviderPolicy
{
    public function viewAny(User $user): bool
    {
        return $user->role === 'admin';
    }
    public function view(User $user, Provider $provider): bool
    {
        return $user->id === $provider->user_id || $user->role === 'admin';
    }

    public function create(User $user): bool
    {
        return $user->role === 'provider';
    }

    public function update(User $user, Provider $provider): bool
    {
        return $user->id === $provider->user_id;
    }
    public function delete(User $user, Provider $provider): bool
    {
        return $user->id === $provider->user_id;
    }
    public function restore(User $user, Provider $provider): bool
    {
        return $user->role === 'admin';
    }
    public function forceDelete(User $user, Provider $provider): bool
    {
        return $user->role === 'admin';
    }

}
