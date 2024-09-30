<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('unities', function (Blueprint $table) {
            $table->id();
            $table->string('unity_name');
            $table->string('unity_beds');
            $table->string('unity_baths');
            $table->string('sqm');
            $table->string('unity_price');
            $table->unsignedBigInteger('property_id');
            $table->timestamps();

            $table->foreign('property_id')->references('id')->on('properties')->onUpdate('cascade')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('unities');
    }
};
