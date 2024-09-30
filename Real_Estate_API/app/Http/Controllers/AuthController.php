<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\Staff;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    public function logoutUser(){
        if(Auth::guard('staff')->check()){
            Auth::guard('staff')->user()->token()->revoke();

            return response()->json([
                'status'    => 200,
                'message'   => "User Logout Succesfully",
            ], 200);
        }elseif(Auth::guard('admin')->check()){
            Auth::guard('admin')->user()->token()->revoke();

            return response()->json([
                'status'    => 200,
                'message'   => "Admin Logout Succesfully",
            ], 200);
        }
        else{
            return response()->json([
                'status'    => 401,
                'message'   => "User Logout Unsuccesfully",
            ], 401);
        }
    }


    public function loginUser(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'role_id' => 'required|string',
            'password' => 'required',
        ]);

        $credentials = $request->only('email', 'password');
        $role_name = $request->input('role_id');

        $role = Role::where('role_name', $role_name)->first();

        if($role_name != 'Admin'){
            if (!Auth::guard('staff')->attempt($credentials)) {
                return response()->json([
                    'status' => 403,
                    'message' => 'Invalid Credentials',
                ], 403);
            }

            $staff = Auth::guard('staff')->user();

            $token = $staff->createToken('authToken')->plainTextToken;

            return response()->json([
                'status' => 200,
                'message' => 'User Login Successfully',
                'token' => $token,
                'staff' => $staff,
            ], 200);
        }else{
            if (!Auth::guard('admin')->attempt($credentials)) {
                return response()->json([
                    'status' => 403,
                    'message' => 'Invalid Credentials',
                ], 403);
            }

            $admin = Auth::guard('admin')->user();

            $token = $admin->createToken('authToken')->plainTextToken;

            return response()->json([
                'status' => 200,
                'message' => 'Admin Login Successfully',
                'token' => $token,
                'staff' => $admin,
            ], 200);
        }
    }

    public function registerUser(Request $request){
          // Validate the request data
          $validator = Validator::make($request->all(), [
            'firstname' => 'required|string|max:255',
            'lastname' => 'required|string|max:255',
            'email' => 'required|string|email|unique:staff',
            'phone' => 'required|string|max:15',
            'role_id' => 'required',
            'password' => 'required|string|min:8',
        ]);

        // If validation fails, return a 400 Bad Request response
        if ($validator->fails()) {
            return response()->json([
                'status' => 400,
                'message' => 'Validation Error',
                'errors' => $validator->errors()
            ], 400);
        }

        $role_name = $request->input('role_id');

        $role = Role::where('role_name', $role_name)->first();

        if($role->role_name != 'Admin'){
            // Create the user
            $staff = Staff::create([
                'firstname' => $request->input('firstname'),
                'lastname' => $request->input('lastname'),
                'email' => $request->input('email'),
                'phone' => $request->input('phone'),
                'role_id' => $role->id,
                'password' => Hash::make($request->input('password')),
            ]);

            // Return a 200 OK response with a success message
            return response()->json([
                'status' => 200,
                'message' => 'User successfully registered',
                'token' => $staff->createToken('secret')->plainTextToken,
                'staff' => $staff,
            ], 200);
        }

        // if somebody click Admin Role
        return response()->json([
            'status' => 401,
            'message' => 'Admin User Not-Rigestered Here',
        ], 401);
    }

    public function authResetForgotPassword(Request $request){
        $credentials = $request->validate([
            'EmailorPhone' => 'required',
            'password' => 'required|min:8|max:100|string'
        ]);

        $staff = Staff::where('email', $credentials['EmailorPhone'])
                      ->orWhere('phone', $credentials['EmailorPhone'])
                      ->first();

        if($staff){
            $credentials['password'] = Hash::make($credentials['password']);

            $staff->update([
                'password' => $credentials['password']
            ]);

            return response()->json([
                'status' => 200,
                'message' => 'User Password Reset Succesfully',
            ], 200);
        }

        return response()->json([
            'status' => 405,
            'message' => 'User Not-Found',
        ], 405);
    }
}
