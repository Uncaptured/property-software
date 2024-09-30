<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\AuthController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');


// ADMIN ROUTES
Route::get('/all-admins', [AdminController::class, 'adminGetAllAdmins']);
Route::post('/create-admin', [AdminController::class, 'adminCreateAdmin']);
Route::post('/update-admin', [AdminController::class, 'adminUpdateAdmin']);
Route::get('/delete-admin/{id}', [AdminController::class, 'deleteAdmin']);

Route::get('/staffs', [AdminController::class, 'adminGetAllStaff']);
Route::get('/auth-roles', [AdminController::class, 'adminGetAllRoles']);
Route::get('/roles', [AdminController::class, 'adminGetAllRoles']);

Route::post('/add-role', [AdminController::class, 'addRole']);
Route::get('/delete-role/{id}', [AdminController::class, 'deleteRole']);
Route::post('/update-role', [AdminController::class, 'updateRole']);

Route::post('/create-user', [AdminController::class, 'createUser']);
Route::get('/delete-user/{id}', [AdminController::class, 'deleteUser']);

Route::post('/update-user-profile', [AdminController::class, 'userUpdateProfile']);
Route::get('/all-users', [AdminController::class, 'getAllStaffs']);

Route::post('/update-user', [AdminController::class, 'userUpdateData']);
Route::get('/all-properties', [AdminController::class, 'getAllProperties']);
Route::get('/delete-property/{id}', [AdminController::class, 'deleteProperty']);
Route::post('/create-propertyUnit', [AdminController::class, 'createPropertyUnity']);

Route::post('/update-property', [AdminController::class, 'updateProperty']);
Route::get('/all-unities', [AdminController::class, 'getAllUnity']);
Route::get('/delete-unity/{id}', [AdminController::class, 'deleteUnity']);

Route::post('/create-unity', [AdminController::class, 'createUnityData']);
Route::post('/update-unity', [AdminController::class, 'updateUnityData']);


// ADMIN TENANTS
Route::get('/all-tenants', [AdminController::class, 'getAllTenants']);
Route::post('/create-tenant', [AdminController::class, 'createTenant']);
Route::get('/delete-tenant/{id}', [AdminController::class, 'deleteTenant']);
Route::post('/update-tenant', [AdminController::class, 'updateTenant']);


// ADMIN LEASE
Route::get('/all-lease', [AdminController::class, 'getAllLease']);
Route::post('/create-lease', [AdminController::class, 'createLease']);
Route::get('/delete-lease/{id}', [AdminController::class, 'deleteLease']);
Route::post('/update-lease', [AdminController::class, 'updateLease']);



// ADMIN MAINTENANCE
Route::get('/all-maintenance', [AdminController::class, 'getAllMaintenance']);
Route::post('/create-maintenance', [AdminController::class, 'createMaintenance']);
Route::get('/delete-maintenance/{id}', [AdminController::class, 'deleteMaintenance']);
Route::post('/update-maintenance', [AdminController::class, 'updateMaintenance']);


// ADMIN COLLECTIONS
Route::get('/all-collections', [AdminController::class, 'getAllCollections']);
Route::get('/delete-collection/{id}', [AdminController::class, 'deleteCollection']);
Route::post('/create-collection', [AdminController::class, 'createCollection']);
Route::post('/update-collection', [AdminController::class, 'updateCollection']);

// AUTH ROUTES
Route::post('/register-user', [AuthController::class, 'registerUser']);
Route::post('/login-user', [AuthController::class, 'loginUser']);
Route::get('/logout-user', [AuthController::class, 'logoutUser']);

Route::post('/reset-user-password', [AuthController::class, 'authResetForgotPassword']);
