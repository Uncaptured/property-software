<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\Admin;
use App\Models\Lease;
use App\Models\Staff;
use App\Models\Unity;
use App\Models\Tenant;
use App\Models\Property;
use App\Models\Collection;
use App\Models\Maintenance;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class AdminController extends Controller
{
    public function adminGetAllStaff(){
        $staffs = Staff::orderBy('created_at', 'desc')->get();
        return response()->json($staffs, 200);
    }

    public function adminGetAllAdmins(){
        $admin = Auth::guard('admin')->user();
        // $admins = Admin::where('email', '!=', $admin->email)->orderBy('created_at', 'desc')->get();
        $admins = Admin::orderBy('created_at', 'desc')->get();
        return response()->json($admins, 200);
    }

    public function getAllCollections(){
        $collections = Collection::orderBy('created_at', 'desc')->get();
        return response()->json($collections, 200);
    }

    public function getAllProperties(){
        $properties = Property::orderBy('created_at', 'desc')->get();
        return response()->json($properties, 200);
    }
    public function adminGetAllRoles(){
        $roles = Role::orderBy('created_at', 'desc')->get();
        return response()->json($roles, 200);
    }

    public function getAllUnity(){
        $unitys = Unity::orderBy('created_at', 'desc')->get();
        return response()->json($unitys, 200);
    }

    public function getAllTenants(){
        $tenants = Tenant::orderBy('created_at', 'desc')->get();
        return response()->json($tenants, 200);
    }

    public function getAllStaffs(){
        $staffs = Staff::orderBy('created_at', 'desc')->get();
        return response()->json($staffs, 200);
    }

    public function getAllLease(){
        $leases = Lease::orderBy('created_at', 'desc')->get();
        return response()->json($leases, 200);
    }

    public function getAllMaintenance(){
        $maintenances = Maintenance::orderBy('created_at', 'desc')->get();
        return response()->json($maintenances, 200);
    }

    //  =====================================================================================================  \\
    public function adminCreateAdmin(Request $request){
        $credentials = $request->validate([
            'firstname' => 'required|string|min:2|max:200',
            'lastname' => 'required|string|min:2|max:200',
            'email' => 'required|email',
            'phone' => 'required|string|min:2|max:20',
            'password' => 'required|string|min:8|max:70',
        ]);

        $credentials['password'] = Hash::make($credentials['password']);

        Admin::create($credentials);

        return response()->json([
            'message' => "Admin Create Successfully",
            'status' => 200
        ], 200);
    }

    public function adminUpdateAdmin(Request $request){
        $credentials = $request->validate([
            'id' => 'required',
            'firstname' => 'required|string|min:2|max:200',
            'lastname' => 'required|string|min:2|max:200',
            'email' => 'required|email',
            'phone' => 'required|string|min:2|max:20'
        ]);

        $admin = Admin::find($credentials['id']);

        $admin->update($credentials);

        return response()->json([
            'message' => "Admin Updated Successfully",
            'status' => 200
        ], 200);
    }

    public function deleteAdmin($id){
        $admin = Admin::find($id);
        $admin->delete();

        return response()->json([
            'message' => "Admin Deleted Successfully",
            'status' => 200
        ], 200);
    }

    public function createMaintenance(Request $request){
        $credentials = $request->validate([
            'property_id' => 'required|string|min:2|max:200',
            'item' => 'required|string|min:2|max:220',
            'status' => 'required|string|min:2|max:200',
            'description' => 'required|string|min:2|max:200',
            'subject' => 'required|string|min:2|max:200',
            'price' => 'required|string|min:2|max:200'
        ]);

        Maintenance::create($credentials);

        return response()->json([
            'message' => "Maintenance Added Successfully",
            'status' => 200
        ], 200);
    }

    public function addRole(Request $request){
        $validator = Validator::make($request->all(), [
            'role_name' => ['required', 'string'],
            'description' => ['required', 'string']
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 400,
                'message' => 'Validation Error',
                'errors' => $validator->errors()
            ], 400);
        }

        $sendRole = Role::create([
            'role_name' => $request->input('role_name'),
            'description' => $request->input('description'),
        ]);

        if($sendRole){
            return response()->json([
                'message' => "Role Added Successfully",
                'status' => 200
            ], 200);
        }

        return response()->json([
            'message' => "Role Not Added",
            'status' => 403
        ], 403);
    }

    public function deleteMaintenance($id){
        $maintenance = Maintenance::find($id);
        $maintenance->delete();

        return response()->json([
            'message' => "Maintenance Deleted Successfully",
            'status' => 200
        ], 200);
    }

    public function deleteProperty($id) {
        $property = Property::find($id);
        $property->delete();

        return response()->json([
            'message' => "Property Deleted Successfully",
            'status' => 200
        ], 200);
    }

    public function deleteUnity($id){
        $unity = Unity::find($id);
        $unity->delete();

        return response()->json([
            'message' => "Unity Deleted Successfully",
            'status' => 20
        ], 200);
    }

    public function deleteRole($id){
        $roleId = Role::find($id);

        $roleId->delete();

        return response()->json([
            'message' => "Role Deleted Successfully",
            'status' => 200
        ], 200);
    }

    public function updateMaintenance(Request $request){
        $credentials = $request->validate([
            'id' => ['required'],
            'property_id'=>['required','min:1','max:100','string'],
            'subject'=>['required','min:1','max:100','string'],
            'item' =>['required','min:1','max:100','string'],
            'description' =>['required','min:1','max:200','string'],
            'price'=>['required','min:1','max:100','string'],
            'status' => ['required']
        ]);

        $maintenance = Maintenance::find($credentials['id']);

        $maintenance->update($credentials);

        return response()->json([
            'message' => 'Maintenance Updated Succesfully',
            'status' => 200
        ], 200);
    }

    public function updateUnityData(Request $request){
        $credentials = $request->validate([
            'id' => ['required'],
            'unity_name'=>['required','min:1','max:100','string'],
            'unity_beds'=>['required','min:1','max:100','string'],
            'unity_baths'=>['required','min:1','max:100','string'],
            'sqm'=>['required','min:1','max:100','string'],
            'unity_price'=>['required','min:1','max:100','string'],
            'status' => ['required']
        ]);

        $unity = Unity::find($credentials['id']);

        $unity->update([
            'unity_name' => $credentials['unity_name'],
            'unity_beds' => $credentials['unity_beds'],
            'unity_baths' => $credentials['unity_baths'],
            'sqm' => $credentials['sqm'],
            'unity_price' => $credentials['unity_price'],
            'status' => $credentials['status']
        ]);

        return response()->json([
            'message' => "Unity Updated Successfully",
            'status' => 200
        ], 200);
    }

    public function createUnityData(Request $request){
        $credentials = $request->validate([
            'unity_name' => 'required|string|max:100',
            'unity_beds' => 'required|string|max:100',
            'unity_baths' => 'required|string|max:100',
            'sqm' => 'required|string|min:2|max:100',
            'unity_price' => 'required|string|min:2|max:100',
            'property_id' => 'required'
        ]);

        $property = Property::where('property_name', $credentials['property_id'])->first();
        $credentials['property_id'] = $property->id; // save as id

        $unities = Unity::where('property_id', $credentials['property_id'])
                        ->where('unity_name', $credentials['unity_name'])
                        ->get();

        $count  = $unities->count();

        if($count > 0){
             return response()->json([
                'message' => "Unity-Name Taken Already, Create Another",
                'status' => 200
            ], 400);
        }
        else{
            Unity::create([
                'unity_name' => $credentials['unity_name'],
                'unity_beds' => $credentials['unity_beds'],
                'unity_baths' => $credentials['unity_baths'],
                'unity_price' => $credentials['unity_price'],
                'sqm' => $credentials['sqm'],
                'property_id' => $credentials['property_id'],
                'status' => 'not-taken'
            ]);

            return response()->json([
                'message' => "Unity Created Successfully",
                'status' => 200
            ], 200);
        }
    }

    public function updateTenant(Request $request){
        $credentials = $request->validate([
            'id' => 'required',
            'firstname' => 'required|string|min:2|max:100',
            'lastname' => 'required|string|min:2|max:100',
            'email' => 'required|email',
            'phone' => 'required|string|min:2|max:20',
            'company_name' => 'nullable|string|min:2|max:100',
            'unity_id' => 'required',
        ]);
        //kazi anayo prince kudadeki

        $tenant = Tenant::find($credentials['id']);
        $unity = Unity::find($credentials['unity_id']);

        if($tenant->unity_id == $credentials['unity_id']){
            $tenant->update([
                'firstname' => $credentials['firstname'],
                'lastname' => $credentials['lastname'],
                'email' => $credentials['email'],
                'phone' => $credentials['phone'],
                'company_name' => $credentials['company_name'],
                'unity_id' => $credentials['unity_id'],
                'status' => 'Not-Paid'
            ]);

            return response()->json([
                'message' => "Tenant Updated Successfully",
                'status' => 200
            ], 200);
        }else{
            $unity->update([
                'status' => 'not-taken'
            ]);

            $tenant->update([
                'firstname' => $credentials['firstname'],
                'lastname' => $credentials['lastname'],
                'email' => $credentials['email'],
                'phone' => $credentials['phone'],
                'company_name' => $credentials['company_name'],
                'unity_id' => $credentials['unity_id'],
                'status' => 'Not-Paid'
            ]);


            return response()->json([
                'message' => "Tenant Updated Successfully",
                'status' => 200
            ], 200);
        }
    }

    public function createTenant(Request $request)
    {
        $credentials = $request->validate([
            'firstname' => 'required|string|min:2|max:100',
            'lastname' => 'required|string|min:2|max:100',
            'email' => 'required|email|unique:tenants',
            'phone' => 'required|string|min:2|max:20',
            'company_name' => 'nullable|string|min:2|max:100',
            'unity_id' => 'required',
        ]);

        $unity = Unity::where('unity_name', $credentials['unity_id'])->first();

        if (!$unity) {
            return response()->json([
                'message' => "Unity not found",
                'status' => 404
            ], 404);
        }

        $credentials['unity_id'] = $unity->id; // save as id

        $unity->update([
            'status' => 'pending'
        ]);

        $tenant = Tenant::where('email', $credentials['email'])->first();

        Tenant::create([
            'firstname' => $credentials['firstname'],
            'lastname' => $credentials['lastname'],
            'email' => $credentials['email'],
            'phone' => $credentials['phone'],
            'company_name' => $credentials['company_name'],
            'unity_id' => $credentials['unity_id'],
            'status' => 'Not-Paid'
        ]);

        return response()->json([
            'message' => "Tenant Created Successfully",
            'status' => 200
        ], 200);
    }


    public function updateRole(Request $request){
        $credentials = $request->validate([
            'id' => ['required'],
            'role_name' => ['required', 'string'],
            'description' => ['required', 'string']
        ]);

        $roleId = Role::find($credentials['id']);

        $roleId->update([
            'role_name' => $credentials['role_name'],
            'description' => $credentials['description'],
        ]);

        return response()->json([
            'message' => "Role Updated Successfully",
            'status' => 200
        ], 200);
    }

    public function userUpdateProfile(Request $request){
        $credentials = $request->validate([
            'id' => ['required'],
            'firstname' => ['required', 'string'],
            'lastname' => ['required', 'string'],
            'email' => ['required', 'email'],
            'phone' => ['required', 'string'],
        ]);

        $staff = Staff::find($credentials['id']);

        $staff->update([
            'firstname' => $credentials['firstname'],
            'lastname' => $credentials['lastname'],
            'email' => $credentials['email'],
            'phone' => $credentials['phone'],
        ]);

        return response()->json([
            'message' => "User Profile Updated Successfully",
            'status' => 200
        ], 200);
    }

    public function createUser(Request $request){
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
    }

    public function deleteTenant($id){
        $tenant = Tenant::find($id);
        $unity = Unity::find($tenant->unity_id);

        $unity->update([
            'status' => 'not-taken'
        ]);

        $tenant->delete();

        $collection = Collection::where('subject', $unity->name)
                                ->where('type', 'Lease')
                                ->where('description', 'Price for the Unit')
                                ->first();

        $collection->delete();

        return response()->json([
            'status' => 200,
            'message' => 'Tenant Successfully Deleted'
        ], 200);
    }

    public function deleteLease($id){
        $lease = Lease::find($id);

        $documentPath = $lease->document;

        if(Storage::exists($documentPath)){
            Storage::delete($documentPath);
        }

        $lease->delete();

        return response()->json([
            'status' => 200,
            'message' => 'Lease Successfully Deleted'
        ], 200);
    }

    public function deleteUser($id){
        $staff = Staff::find($id);

        $staff->delete();

        return response()->json([
            'status' => 200,
            'message' => 'User Successfully deleted'
        ], 200);
    }

    public function userUpdateData(Request $request){
        $credentials = $request->validate([
            'id' => 'required',
            'firstname' => 'required|string|min:2|max:100',
            'lastname' => 'required|string|min:2|max:100',
            'email' => 'required|email|string',
            'phone' => 'required|string',
            'role_id' => 'required'// not id its role name
        ]);

        $role = Role::where('role_name', $credentials['role_id'])->first();
        $credentials['role_id'] = $role->id;

        $staff = Staff::find($credentials['id']);

        $staff->update($credentials);

        return response()->json([
            'message' => 'User Updated Succesfully',
            'status' => 200
        ], 200);
    }


    public function createPropertyUnity(Request $request) {
        Log::info('Request Data:', $request->all());

        $credentials = $request->validate([
            'property_name' => 'required|string|min:2|max:100',
            'property_type' => 'required|string|min:2|max:100',
            'property_address' => 'required|string',
            'units' => 'required|array',
            'units.*.unit_name' => 'required|string|min:2|max:100',
            'units.*.unit_beds' => 'required|string|min:1|max:50',
            'units.*.unit_baths' => 'required|string|min:1|max:50',
            'units.*.unit_sqm' => 'required|string|min:1|max:50',
            'units.*.unit_price' => 'required|string|min:1|max:50',
        ]);

        DB::beginTransaction();

        try {
            $property = Property::create([
                'property_name' => $credentials['property_name'],
                'property_type' => $credentials['property_type'],
                'property_address' => $credentials['property_address'],
            ]);

            if($property) {
                $propertyId = $property->id;

                foreach ($credentials['units'] as $unit) {
                    Unity::create([
                        'unity_name' => $unit['unit_name'],
                        'unity_beds' => $unit['unit_beds'],
                        'unity_baths' => $unit['unit_baths'],
                        'sqm' => $unit['unit_sqm'],
                        'unity_price' => $unit['unit_price'],
                        'property_id' => $propertyId,
                        'status' => 'not-taken'
                    ]);
                }

                DB::commit();

                return response()->json([
                    'message' => "Property and Units created successfully",
                    'status' => 200
                ], 200);
            } else {
                DB::rollBack();
                return response()->json([
                    'message' => "Property creation failed",
                    'status' => 500
                ], 500);
            }
        } catch (\Exception $e) {
            DB::rollBack();

            Log::error('Error creating Property and Units: ' . $e->getMessage());

            return response()->json([
                'message' => "An error occurred: " . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    public function updateProperty(Request $request){
        $credentials = $request->validate([
            'id' => 'required',
            'property_name' => 'required|string|min:2|max:100',
            'property_address' => 'required|string|min:2|max:100',
            'property_type' => 'required|string|min:2|max:100'
        ]);

        $property = Property::find($credentials['id']);

        $property->update($credentials);

        return response()->json([
            'message' => 'Property Updated Succesfully',
            'status' => 200
        ], 200);
    }

    // public function updateLease(Request $request){
    //     $request->validate([
    //         'id'=>'required',
    //         'startDate' => 'required',
    //         'endDate' => 'required',
    //         'ammount' => 'required',
    //         'document' => 'nullable|file|mimes:pdf,doc,docx|max:10240',
    //         'frequency' => 'required',
    //         'tenant_id' => 'required',
    //     ]);

    //     $lease = Lease::find($request->input('id'));

    //     $oldTenant = Tenant::find($lease->tenant_id);
    //     $oldUnit = Unity::find($oldTenant->unity_id);
    //     $Oldproperty = Property::find($oldUnit->property_id);

    //     $collection = Collection::where('property_id', $Oldproperty->id)
    //                             ->where('subject', $oldUnit->name)
    //                             ->where('type', 'Lease')
    //                             ->first();

    //     $tenant = Tenant::findOrFail($request->input('tenant_id'));
    //     $unity = Unity::findOrFail($tenant->unity_id);
    //     $property = Property::findOrFail($unity->property_id);

    //     if($lease->document == $request->input['document']){
    //         $lease->update([
    //             'startDate' => $request->input('startDate'),
    //             'endDate' => $request->input('endDate'),
    //             'ammount' => $request->input('ammount'),
    //             'unity_id' => $unity->id,
    //             'tenant_id' => $request->input('tenant_id'),
    //             'property_id' => $property->id,
    //             'frequency' => $request->input('frequency'),
    //         ]);

    //         $collection->update([
    //             'ammount' =>  $request->input('ammount'),
    //             'property_id' => $property->id,
    //             'subject' => $unity->name,
    //             'type' => 'Lease',
    //             'description' => 'Price for the Unit',
    //             'status' => 'Not-Paid'
    //         ]);

    //         return response()->json([
    //             'message' => 'Lease created successfully',
    //             'status' => 200
    //         ], 200);
    //     }
    //     else if($lease->document != $request->input['document'])
    //     {
    //         $file = $request->file('document');
    //         $filename = time() . '-' . $file->getClientOriginalName();
    //         $path = $file->storeAs('lease_documents', $filename, 'public');

    //         Storage::disk('public')->delete($lease->document);

    //         $lease->update([
    //             'startDate' => $request->input('startDate'),
    //             'endDate' => $request->input('endDate'),
    //             'ammount' => $request->input('ammount'),
    //             'unity_id' => $unity->id,
    //             'document' => $path,
    //             'tenant_id' => $request->input('tenant_id'),
    //             'property_id' => $property->id,
    //             'frequency' => $request->input('frequency'),
    //         ]);

    //         $collection->update([
    //             'ammount' =>  $request->input('ammount'),
    //             'property_id' => $property->id,
    //             'subject' => $unity->name,
    //             'type' => 'Lease',
    //             'description' => 'Price for the Unit',
    //             'status' => 'Not-Paid'
    //         ]);

    //         return response()->json([
    //             'message' => 'Lease created successfully',
    //             'status' => 200
    //         ], 200);
    //     }

    //     return response()->json([
    //         'message' => 'Document upload failed',
    //         'status' => 400
    //     ], 400);
    // }

    public function updateLease(Request $request) {
        $request->validate([
            'id' => 'required',
            'startDate' => 'required',
            'endDate' => 'required',
            'ammount' => 'required',
            'document' => 'nullable|file|mimes:pdf,doc,docx|max:10240',
            'frequency' => 'required',
            'tenant_id' => 'required',
        ]);

        $lease = Lease::find($request->input('id'));
        if (!$lease) {
            return response()->json(['message' => 'Lease not found', 'status' => 404], 404);
        }

        // Finding previous tenant and unit details
        $oldTenant = Tenant::find($lease->tenant_id);
        $oldUnit = Unity::find($oldTenant->unity_id);
        $oldProperty = Property::find($oldUnit->property_id);

        $collection = Collection::where('property_id', $oldProperty->id)
                                ->where('subject', $oldUnit->name)
                                ->where('type', 'Lease')
                                ->first();

        $tenant = Tenant::findOrFail($request->input('tenant_id'));
        $unity = Unity::findOrFail($tenant->unity_id);
        $property = Property::findOrFail($unity->property_id);

        $updateData = [
            'startDate' => $request->input('startDate'),
            'endDate' => $request->input('endDate'),
            'ammount' => $request->input('ammount'),
            'unity_id' => $unity->id,
            'tenant_id' => $request->input('tenant_id'),
            'property_id' => $property->id,
            'frequency' => $request->input('frequency'),
        ];

        // Check if a new document is uploaded
        if ($request->hasFile('document')) {
            // Delete old document if it exists
            if ($lease->document) {
                Storage::disk('public')->delete($lease->document);
            }
            $file = $request->file('document');
            $filename = time() . '-' . $file->getClientOriginalName();
            $path = $file->storeAs('lease_documents', $filename, 'public');
            $updateData['document'] = $path; // Add new document path to update data
        }

        // Update lease details
        $lease->update($updateData);

        // Update collection details
        $collection->update([
            'ammount' => $request->input('ammount'),
            'property_id' => $property->id,
            'subject' => $unity->name,
            'type' => 'Lease',
            'description' => 'Price for the Unit',
            'status' => 'Not-Paid'
        ]);

        return response()->json(['message' => 'Lease updated successfully', 'status' => 200], 200);
    }


    public function createLease(Request $request)
    {
        // Validate request data
        $request->validate([
            'startDate' => 'required',
            'endDate' => 'required',
            'ammount' => 'required',
            'document' => 'required|file|mimes:pdf,doc,docx|max:10240',
            'frequency' => 'required',
            'tenant_id' => 'required',
        ]);

        // Find related entities
        $tenant = Tenant::findOrFail($request->input('tenant_id'));
        $unity = Unity::findOrFail($tenant->unity_id);
        $property = Property::findOrFail($unity->property_id);

        // Handle file upload
        if ($request->hasFile('document')) {
            $file = $request->file('document');
            $filename = time() . '-' . $file->getClientOriginalName();
            $path = $file->storeAs('lease_documents', $filename, 'public');

            // Create lease record
            Lease::create([
                'startDate' => $request->input('startDate'),
                'endDate' => $request->input('endDate'),
                'ammount' => $request->input('ammount'),
                'unity_id' => $unity->id,
                'document' => $path,
                'tenant_id' => $request->input('tenant_id'),
                'property_id' => $property->id,
                'frequency' => $request->input('frequency'),
            ]);

            Collection::create([
                'ammount' =>  $request->input('ammount'),
                'property_id' => $property->id,
                'subject' => $unity->name,
                'type' => 'Lease',
                'description' => 'Price for the Unit',
                'status' => 'Not-Paid'
            ]);

            return response()->json([
                'message' => 'Lease created successfully',
                'status' => 200
            ], 200);
        }

        return response()->json([
            'message' => 'Document upload failed',
            'status' => 400
        ], 400);
    }


    public function deleteCollection($id){
        $collection = Collection::find($id);
        $collection->delete();

        return response()->json([
            'message' => 'Collection Delete Successfully',
            'status' => 200
        ], 200);
    }

    public function createCollection(Request $request){
        $credentials = $request->validate([
            'property_id' => 'required',
            'subject' => 'required|string|min:2|max:100',
            'type' => 'required|string|min:2|max:100',
            'ammount' =>'required|string|min:2|max:100',
            'description' =>'required|string|min:2|max:200',
            'status' =>'required|string|min:2|max:100',
        ]);

        Collection::create($credentials);

        return response()->json([
            'message' => 'Collection Created Successfully',
            'status' => 200
        ], 200);
    }

    public function updateCollection(Request $request){
        $credentials = $request->validate([
            'id' => 'required',
            'property_id' => 'required',
            'subject' => 'required|string|min:2|max:100',
            'type' => 'required|string|min:2|max:100',
            'ammount' => 'required|string|min:2|max:100',
            'description' => 'required|string|min:2|max:200',
            'status' => 'required|string|min:2|max:100',
        ]);

        $collection = Collection::find($credentials['id']);

        $collection->update($credentials);

        return response()->json([
            'message' => 'Collection Updated Successfully',
            'status' => 200
        ], 200);
    }

}
