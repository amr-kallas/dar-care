<?php

namespace App\Models;

use App\Traits\HasImageUpload;
use Illuminate\Database\Eloquent\Model;

class Profile extends Model
{
    use HasImageUpload;
    protected $fillable = [
        'user_id', 'image_url', 'detailed_address', 'current_lat', 'current_lng'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
