<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Lease extends Model
{
    use HasFactory;

    protected $fillable = [
        'startDate',
        'endDate',
        'tenant_id',
        'unity_id',
        'property_id',
        'frequency',
        'document',
        'ammount'
    ];
}
