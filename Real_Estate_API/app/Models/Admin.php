<?php

namespace App\Models;

use Illuminate\Contracts\Auth\Authenticatable;
use Illuminate\Auth\Authenticatable as AuthenticatableTrait;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Admin extends Model implements Authenticatable
{
    use HasApiTokens, HasFactory, AuthenticatableTrait;

    protected $fillable = [
        'firstname',
        'lastname',
        'email',
        'phone',
        'password'
    ];
}
