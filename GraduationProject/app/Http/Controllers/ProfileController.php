<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreProfileRequest;
use App\Http\Requests\UpdateProfileRequest;
use App\Http\Resources\ProfileResource;
use App\Models\Profile;
use App\Traits\HasImageUpload;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    use AuthorizesRequests;
    use HasImageUpload;
    public function index()
    {
        $this->authorize('viewAny', Profile::class);

        $profiles = Profile::with('user')->paginate(10);
        return ProfileResource::collection($profiles);
    }

    public function store(StoreProfileRequest $request)
    {
        $this->authorize('create', Profile::class);

        $user = Auth::user();
        $data = $request->validated();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->uploadImage($request->file('image'), 'profiles');
        }

        $data['user_id'] = Auth::id();
        $profile = Profile::create($data);

        return new ProfileResource($profile);
    }

    public function show($id)
    {
        $profile = Profile::with('user')->find($id);
        if (!$profile) {
            return response()->json(['message' => 'Profile not found'], 404);
        }

        $this->authorize('view', $profile);

        return new ProfileResource($profile);
    }

    public function update(UpdateProfileRequest $request, $id)
    {
        $profile = Profile::find($id);
        if (!$profile) {
            return response()->json(['message' => 'Profile not found'], 404);
        }

        $this->authorize('update', $profile);

        $data = $request->validated();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->uploadImage($request->file('image'), 'profiles', $profile->image_url);
        }

        $profile->update($data);
        return new ProfileResource($profile);
    }

    public function destroy($id)
    {
        $profile = Profile::find($id);
        if (!$profile) {
            return response()->json(['message' => 'Profile not found'], 404);
        }

        $this->authorize('delete', $profile);

        $this->deleteImage($profile->image_url);

        $profile->delete();
        return response()->json(['message' => 'Profile deleted']);
    }

}
