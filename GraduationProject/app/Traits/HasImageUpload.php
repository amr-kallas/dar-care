<?php

namespace App\Traits;

use Illuminate\Support\Facades\Storage;

trait HasImageUpload
{
    public function uploadImage($file, $path, $oldFile = null)
    {

        if ($oldFile && Storage::disk('public')->exists($oldFile)) {
            Storage::disk('public')->delete($oldFile);
        }

        return $file->store($path, 'public');
    }

    public function deleteImage($file)
    {
        if ($file && Storage::disk('public')->exists($file))
        {
            Storage::disk('public')->delete($file);
        }
    }
}
