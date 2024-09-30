<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Unity extends Model
{
    use HasFactory;

    protected $fillable = [
        'unity_name',
        'unity_beds',
        'unity_baths',
        'sqm',
        'unity_price',
        'property_id',
        'status'
    ];
}
