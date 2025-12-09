<?php

namespace App\Models;

use App\Traits\HasImageUpload;
use Illuminate\Database\Eloquent\Model;

class Provider extends Model
{
    use HasImageUpload;
    protected $fillable = [
        'user_id', 'department_id', 'image_url', 'avg_rating',
        'current_lat', 'current_lng', 'experience_years', 'is_available'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function department()
    {
        return $this->belongsTo(Department::class);
    }
    public function scopeAvailable($q)
    {
        return $q->where('is_available', true);
    }
    public function scopeDepartment($q, $departmentId)
    {
        if (!$departmentId) return $q;

        return $q->where('department_id', $departmentId);
    }
    public function scopeSearch($q, $value)
    {
        if (!$value) return $q;

        return $q->whereHas('user', function ($q) use ($value) {
            $q->where('full_name', 'like', "%$value%");
        });
    }
    public function scopeMinRating($q, $rating)
    {
        if (!$rating) return $q;

        return $q->where('avg_rating', '>=', $rating);
    }
    public function scopeMaxRating($q, $rating)
    {
        if (!$rating) return $q;

        return $q->where('avg_rating', '<=', $rating);
    }
    public function scopeOrderByRatingDesc($q)
    {
        return $q->orderBy('avg_rating', 'desc');
    }
    public function scopeOrderByRatingAsc($q)
    {
        return $q->orderBy('avg_rating', 'asc');
    }
    public function scopeLatestFirst($q)
    {
        return $q->orderBy('created_at', 'desc');
    }
    public function scopeOldestFirst($q)
    {
        return $q->orderBy('created_at', 'asc');
    }

    public function scopeExperienceBetween($q, $min, $max)
    {
        if ($min) $q->where('experience_years', '>=', $min);
        if ($max) $q->where('experience_years', '<=', $max);

        return $q;
    }


}
