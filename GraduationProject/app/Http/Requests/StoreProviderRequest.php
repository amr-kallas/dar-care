<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreProviderRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'department_id' => 'required|exists:departments,id',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'avg_rating' => 'required|numeric|min:0|max:5',
            'current_lat' => 'required|numeric',
            'current_lng' => 'required|numeric',
            'experience_years' => 'required|integer|min:0',
            'is_available' => 'boolean',
        ];
    }
}
