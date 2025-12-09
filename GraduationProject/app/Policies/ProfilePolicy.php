<?php

namespace App\Policies;

use App\Models\Profile;
use App\Models\User;
use Illuminate\Auth\Access\Response;

class ProfilePolicy
{
    public function viewAny(User $user): bool
    {
        return $user->role === 'admin';
    }
    public function view(User $user, Profile $profile): bool
    {
        return $user->id === $profile->user_id || $user->role === 'admin';
    }

    public function create(User $user): bool
    {
        return $user->role === 'user';
    }

    public function update(User $user, Profile $profile): bool
    {
        return $user->id === $profile->user_id;
    }
    public function delete(User $user, Profile $profile): bool
    {
        return $user->id === $profile->user_id;
    }
    public function restore(User $user, Profile $profile): bool
    {
        return $user->role === 'admin';
    }
    public function forceDelete(User $user, Profile $profile): bool
    {
        return $user->role === 'admin';
    }

}
