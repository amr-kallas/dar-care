<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProviderResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user' => [
                'id' => $this->user->id,
                'name' => $this->user->name,
            ],
            'department' => [
                'id' => $this->department->id,
                'name' => $this->department->name,
            ],
            'current_lat' => $this->current_lat,
            'current_lng' => $this->current_lng,
            'avg_rating' => $this->avg_rating,
            'image_url' => $this->image_url ? asset('storage/' . $this->image_url) : null,
            'experience_years' => $this->experience_years,
            'is_available' => $this->is_available,
            'created_at' => $this->created_at->toDateTimeString(),
            ];

    }
}
