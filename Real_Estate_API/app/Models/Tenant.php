<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Tenant extends Model
{
    use HasFactory;
    protected $fillable = [
        'firstname',
        'lastname',
        'email',
        'phone',
        'company_name',
        'unity_id',
        'status',
    ];
}
