<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreProviderRequest;
use App\Http\Requests\UpdateProviderRequest;
use App\Http\Resources\ProviderResource;
use App\Models\Provider;
use App\Traits\HasImageUpload;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class ProviderController extends Controller
{
    use AuthorizesRequests;
    use HasImageUpload;

    public function index(Request $request)
    {
        $this->authorize('viewAny', Provider::class);

        $providers = Provider::query()
            ->available()
            ->department($request->department_id)
            ->search($request->search)
            ->minRating($request->min_rating)
            ->maxRating($request->max_rating)
            ->experienceBetween($request->exp_min, $request->exp_max)
            ->orderByRatingDesc()
            ->latestFirst()
            ->paginate(10);

        return ProviderResource::collection($providers);
    }

    public function store(StoreProviderRequest $request)
    {
        $this->authorize('create', Provider::class);

        $user = Auth::user();
        $data = $request->validated();

        if ($request->hasFile('image')) {
        $data['image_url'] = $this->uploadImage($request->file('image'), 'providers');
    }

        $data['user_id'] = Auth::id();
        $data['avg_rating'] = 0;

        $provider = Provider::create($data);

        return new ProviderResource($provider);
    }

    public function show($id)
    {
        $provider = Provider::with(['user','department'])->find($id);
        if (!$provider) {
            return response()->json(['message' => 'Provider not found'], 404);
        }

        $this->authorize('view', $provider);
        return new ProviderResource($provider);
    }

    public function update(UpdateProviderRequest $request, $id)
    {
        $provider = Provider::find($id);
        if (!$provider) {
            return response()->json(['message' => 'Provider not found'], 404);
        }

        $this->authorize('update', $provider);
        $data = $request->validated();

        if ($request->hasFile('image')) {
            $data['image_url'] = $this->uploadImage($request->file('image'), 'providers', $provider->image_url);
        }

        $provider->update($data);
        return new ProviderResource($provider);
    }

    public function destroy($id)
    {
        $provider = Provider::find($id);
        if (!$provider) {
            return response()->json(['message' => 'Provider not found'], 404);
        }

        $this->authorize('delete', $provider);

        $this->deleteImage($provider->image_url);

        $provider->delete();
        return response()->json(['message' => 'Provider deleted']);
    }
    public function filter(Request $request)
    {
        $providers = Provider::query()
            ->available()
            ->department($request->department_id)
            ->search($request->search)
            ->minRating($request->min_rating)
            ->maxRating($request->max_rating)
            ->experienceBetween($request->min_exp, $request->max_exp)
            ->latestFirst()
            ->paginate(10);

        return response()->json($providers);
    }

}
