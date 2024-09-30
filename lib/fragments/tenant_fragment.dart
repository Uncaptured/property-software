import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/all_properties_services.dart';
import 'package:flutter_real_estate/API_services/all_tenants_service.dart';
import 'package:flutter_real_estate/API_services/all_unity_services.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/fragments/role_fragment.dart';
import 'package:flutter_real_estate/models/all_property_model.dart';
import 'package:flutter_real_estate/models/all_tenants_model.dart';
import 'package:flutter_real_estate/models/all_units_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../components/button_form_dialogbox.dart';



class TenantFragment extends StatefulWidget {
  TenantFragment({super.key});

  @override
  State<TenantFragment> createState() => _TenantFragmentState();
}

class _TenantFragmentState extends State<TenantFragment> {
  bool isLoading = true;
  bool _isUnityEnabled = false;
  bool _isCompanyNameEnabled = false;
  
  AllUnityModel? _selectedUnity;
  AllPropertyModel? _selectedProperty;
  AllUnityModel? unity;
  
  List<AllUnityModel> _filteredUnities = [];
  List<AllTenantsModel> filteredTenants = [];
  List<AllTenantsModel> tenants = [];
  List<AllPropertyModel> properties = [];
  List<AllUnityModel> unities = [];

  final AllTenantsService allTenantsService = AllTenantsService();
  final AllUnityServices allUnityServices = AllUnityServices();
  final AllPropertyService allPropertyService = AllPropertyService();

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTenants();
    searchController.addListener(_filterTenants);
  }

  Future<void> _fetchTenants() async {
    try {
      List<AllTenantsModel> allTenants = await allTenantsService.getAllTenants();
      List<AllUnityModel> allUnities = await allUnityServices.getAllUnities();
      List<AllPropertyModel> allProperties = await allPropertyService.getAllProperties();
      setState(() {
        tenants = allTenants;
        filteredTenants = allTenants;
        unities = allUnities;
        properties = allProperties;
        isLoading = false;
      });
    } catch (e) {
      showErrorMsg(context, "Error, $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  void _loadingState(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white,))
    );
  }

  Future<void> _filterTenants() async {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredTenants = tenants;
      } else {
        final query = searchController.text.toLowerCase();
        filteredTenants = tenants.where((tenant) {
          return tenant.status.toLowerCase().contains(query) ||
              tenant.phone.toLowerCase().contains(query) ||
              tenant.firstname.toLowerCase().contains(query) ||
              tenant.lastname.toLowerCase().contains(query) ||
              (tenant.company_name?.toLowerCase().contains(query) ?? false) ||  // Null-safe access
              displayPropertyName(tenant.unity_id).toLowerCase().contains(query) ||
              displayPropertyTypeName(tenant.unity_id).toLowerCase().contains(query) ||
              displayUnityName(tenant.unity_id).toLowerCase().contains(query);
        }).toList();
      }
    });
  }



  Future<void> _deleteTenant(int tenantId) async {
    _loadingState();
    final response = await allTenantsService.deleteTenant(tenantId);

    if(response.statusCode == 200){
      setState(() {
        tenants.removeWhere((tenant) => tenant.id == tenantId);
        _fetchTenants();
      });
      Navigator.pop(context);
      showSuccessMsg(context, "Tenant Deleted Successfully");
    }else{
      Navigator.pop(context);
      showErrorMsg(context, "Tenant Delete Unsuccessfully");
    }
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => MyCreateNewDialog(
          properties: properties,
          unities: unities,
          fetchTenants: _fetchTenants
      ),
    );
  }


  // void _onPropertyChanged(AllPropertyModel? selectedProperty) {
  //   setState(() {
  //     _selectedProperty = selectedProperty;
  //
  //     _isUnityEnabled = selectedProperty != null;
  //
  //     _isCompanyNameEnabled = selectedProperty != null &&
  //         (selectedProperty.type == "Business" || selectedProperty.type == "Both");
  //
  //     if (selectedProperty != null) {
  //       _filteredUnities = unities.where((unit) => unit.property_id == selectedProperty.id).toList();
  //     } else {
  //       _filteredUnities = unities;
  //     }
  //
  //     if (_selectedUnity != null && _selectedUnity!.property_id != selectedProperty?.id) {
  //       _selectedUnity = null;
  //     }
  //   });
  // }



// Method to show the dialog for updating tenant
  Future<void> showUpdateTenants(int tenantId) async {
    for (var myTen in tenants) {
      if (myTen.id == tenantId) {
        AllUnityModel? _selectedUnity = unities.firstWhereOrNull((unit) => unit.id == myTen.unity_id);
        AllPropertyModel? _selectedProperty = properties.firstWhereOrNull((prop) => prop.id == _selectedUnity?.property_id);

        setState((){
          if (_selectedProperty != null) {
            _filteredUnities = unities.where((unit) => unit.property_id == _selectedProperty?.id).toList();
            _isUnityEnabled = true;
            _isCompanyNameEnabled = _selectedProperty?.type == "Business" || _selectedProperty?.type == "Both";
          }
        });

        showDialog(
          context: context,
          builder: (context) {
            final _updateFNameController = TextEditingController(text: myTen.firstname);
            final _updateLNameController = TextEditingController(text: myTen.lastname);
            final _updateEmailController = TextEditingController(text: myTen.email);
            final _updatePhoneController = TextEditingController(text: myTen.phone);
            final _updateCNameController = TextEditingController(text: myTen.company_name);

            String displayPName(int proId){
              for(var p in properties){
                if(p.id == proId){
                  return p.name;
                }
              }
              return "Error displaying property name";
            }

            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Update Tenant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: [
                                _buildTextField(context, _updateFNameController, 'First Name', MediaQuery.of(context).size.width * 0.31),
                                _buildTextField(context, _updateLNameController, 'Last Name', MediaQuery.of(context).size.width * 0.31),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(context, _updateEmailController, 'Email', MediaQuery.of(context).size.width * 0.63),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: [

                                // Property dropdown
                                DropdownButtonFormField<AllUnityModel>(
                                  value: _selectedUnity,
                                  onChanged: (AllUnityModel? value) {
                                    setState(() {
                                      _selectedUnity = value;
                                    });
                                  },
                                  items: unities.where((un) => un.status != 'taken').map((AllUnityModel unit) {
                                    return DropdownMenuItem<AllUnityModel>(
                                      value: unit,
                                      child: Text('${unit.name} (${displayPName(unit.property_id)}) (${unit.status})'),
                                    );
                                  }).toList(),
                                  decoration: const InputDecoration(labelText: 'Unit'),
                                ),

                                // Unity dropdown
                                // DropdownButtonFormField<AllUnityModel>(
                                //   value: _selectedUnity,
                                //   onChanged: _isUnityEnabled ? (AllUnityModel? value) {
                                //     setState(() {
                                //       _selectedUnity = value;
                                //     });
                                //   } : null,
                                //   items: _filteredUnities.map((AllUnityModel unit) {
                                //     return DropdownMenuItem<AllUnityModel>(
                                //       value: unit,
                                //       child: Text(unit.name),
                                //     );
                                //   }).toList(),
                                //   decoration: const InputDecoration(labelText: 'Unity'),
                                //   disabledHint: const Text('Select a Property first'),
                                // ),

                              ],
                            ),

                            // Phone and Company Name
                            Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: [
                                _buildTextField(context, _updatePhoneController, 'Phone', MediaQuery.of(context).size.width * 0.31),

                                _buildTextField(
                                  context,
                                  _updateCNameController,
                                  'Company Name',
                                  MediaQuery.of(context).size.width * 0.31,
                                  enabled: true,
                                ),

                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                ButtonDialogBox(title: "Cancel", color: Colors.grey, onPressFunction: () => Navigator.pop(context)),
                                ButtonDialogBox(
                                  title: "Update",
                                  color: Colors.pink.shade400,
                                  onPressFunction: () => _updateTenant(
                                    tenantId,
                                    _updateFNameController.text,
                                    _updateLNameController.text,
                                    _updateEmailController.text,
                                    _updatePhoneController.text,
                                    _selectedUnity?.id.toString() ?? '',
                                    _updateCNameController.text,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      }
    }
  }

  // Text field builder
  Widget _buildTextField(
      BuildContext context,
      TextEditingController controller,
      String labelText,
      double? width, {
        bool enabled = true,
      }) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width * 0.45,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
        ),
        enabled: enabled,
      ),
    );
  }



  Future<void> _updateTenant(int id, String fname, String lname, String email, String phone, String unity_id, String cName) async {
    if (_selectedProperty != null) {
      _loadingState();
      if (_selectedProperty!.type.toString() == "Business" || _selectedProperty!.type.toString() == "Both") {
        if(
            fname.isEmpty ||
            lname.isEmpty ||
            email.isEmpty ||
            phone.isEmpty ||
            unity_id.isEmpty ||
            cName.isEmpty
        ){
          Navigator.pop(context);
          showErrorMsg(context, "All Fields are Required");
        }
        else{
          final response = await allTenantsService.updateTenant({
            'id': id,
            'firstname': fname,
            'lastname': lname,
            'email': email,
            'phone': phone,
            'unity_id': unity_id,
            'company_name': cName
          });

          if(response.statusCode == 200){
            Navigator.pop(context);
            Navigator.pop(context);
            _fetchTenants();
            showSuccessMsg(context, 'Tenant Updated Successfully');
          }else{
            Navigator.pop(context);
            Navigator.pop(context);
            showErrorMsg(context, "Tenant Updated Unsuccessfully");
          }
        }
      } else {
        if (
            fname.isEmpty ||
            lname.isEmpty ||
            email.isEmpty ||
            phone.isEmpty ||
            unity_id.isEmpty
        ) {
          Navigator.pop(context);
          showErrorMsg(context, "All fields are Required, Except Company Name");
        } else {
          final response = await allTenantsService.updateTenant({
            'id': id,
            'firstname': fname.toString(),
            'lastname': lname.toString(),
            'email': email.toString(),
            'phone': phone.toString(),
            'company_name': cName.toString(),
            'unity_id': unity_id.toString()
          });

          if (response.statusCode == 200) {
            Navigator.pop(context);
            Navigator.pop(context);
            _fetchTenants();
            showSuccessMsg(context, "Tenant Updated Successfully");
          } else {
            Navigator.pop(context);
            Navigator.pop(context);
            showErrorMsg(context, "Tenant Update Unsuccessfully");
          }
        }
      }
    } else {
      showErrorMsg(context, "Please select a property.");
    }
  }


  void viewTenantData(int tenantId) {
    for(var myTen in tenants) {
      if(myTen.id == tenantId) {
        // Show dialog with role details
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("View Tenant", style: TextStyle(fontWeight: FontWeight.bold)),

                          Badge(
                            backgroundColor:  myTen.status == 'Paid' ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                            largeSize: 33,
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25
                              ),
                              child: Row(
                                children: [

                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(width: 8,),

                                  Text(
                                      myTen.status == 'taken' ? 'Taken' : myTen.status == 'Paid' ? 'Paid' : 'Not-Paid',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.5
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      const Divider(),
                    ],
                  ),
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.6, // Adjust width here
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7,),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            showContentDialog(columnName: "First Name", content: myTen.firstname),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "Last Name", content: myTen.lastname),
                          ],
                        ),

                        const SizedBox(height: 15),
                        
                        showContentDialog(columnName: "Email Address", content: myTen.email),
                        
                        const SizedBox(height: 15),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            showContentDialog(columnName: "Phone Number", content: myTen.phone),
                            showContentDialog(columnName: "Company Name", content: myTen.company_name == null ? 'null' :  myTen.company_name!),
                          ],
                        ),
                        
                        const SizedBox(height: 15),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            showContentDialog(columnName: "Property Name (Type)", content: displayPropertyWithType(myTen.unity_id)),
                            showContentDialog(columnName: "Unity Name", content: displayUnityName(myTen.unity_id)),
                          ],
                        ),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Created Time", content: "${myTen.formattedDate} (${myTen.timeAgo})"),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ButtonDialogBox(title: "Cancel", color: Colors.grey, onPressFunction: () => Navigator.pop(context)),
                ],
              );
            });
      }
    }
  }


  
  String displayPropertyWithType(int unityId) {
    for (var unit in unities) {
      if (unit.id == unityId) {
        for (var prop in properties) {
          if (prop.id == unit.property_id) {
            return "${prop.name} (${prop.type})";
          }
        }
      }
    }
    return 'Error getting data';
  }
  
  
  String displayUnityPrice(int unityId) {
    for (var unit in unities) {
      if (unit.id == unityId) {
        return 'Tzs ${formatPrice(int.parse(unit.price))}';
      }
    }
    return 'Error getting data';
  }

  /// FORMAT PRICE TO THOUSANDS
  String formatPrice(int price) {
    final NumberFormat formatter = NumberFormat('#,##0');
    return formatter.format(price);
  }

  String displayUnityName(int unityId) {
    for (var unit in unities) {
      if (unit.id == unityId) {
        return unit.name;
      }
    }
    return 'Error getting data';
  }



  String displayPropertyName(int unityId) {
    for (var unit in unities) {
      if (unit.id == unityId) {
        for (var prop in properties) {
          if (prop.id == unit.property_id) {
            return prop.name;
          }
        }
      }
    }
    return 'Error getting data';
  }



  String displayPropertyTypeName(int unityId) {
    for (var unit in unities) {
      if (unit.id == unityId) {
        for (var prop in properties) {
          if (prop.id == unit.property_id) {
            return prop.type;
          }
        }
      }
    }
    return 'Error getting data';
  }


  @override
  Widget build(BuildContext context) {
    int id = 1;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 30.0
        ),
        child: isLoading
        ?
            const Center(child: CircularProgressIndicator())
        :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Head
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Title
                      const Text(
                        "Tenants",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),

                      // Color mark
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: kbuttonNewColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),

                  MyNewPinkButton(width: 200, title: "+ New Tenant", onPressFunction: _showDialog,),

                ],
              ),
            ),

            // Divider line
            Container(
              height: 1,
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 20,),

                      // Search Box
                      Container(
                        width: 500,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Search",
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),

                      // Data Table
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("#", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Tenant Name", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Email Address", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Phome Number", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Company Name", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("PropertyName (Type)", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Unity Name", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                            ],

                            rows: filteredTenants.isEmpty
                                ? [
                              const DataRow(
                                cells: [
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell(
                                    Center(
                                      child: Text(
                                        'Empty Tenants Data',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                ],
                              ),
                            ]
                                : filteredTenants.map((tenant) {
                              return DataRow(
                                cells: [
                                  // Index
                                  DataCell(Text('${id++}')),

                                  // Full name
                                  DataCell(Text('${tenant.firstname} ${tenant.lastname}')),

                                  // Email
                                  DataCell(Text(tenant.email)),

                                  // Phone
                                  DataCell(Text(tenant.phone)),

                                  // Company Name with null/empty check
                                  DataCell(
                                    tenant.company_name == null || tenant.company_name!.isEmpty
                                        ? Text(
                                      'null',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                        : Text(tenant.company_name!),
                                  ),

                                  // Property with type
                                  DataCell(Text(displayPropertyWithType(tenant.unity_id))),

                                  // Unity name
                                  DataCell(Text(displayUnityName(tenant.unity_id))),

                                  // Unity price
                                  DataCell(Text(displayUnityPrice(tenant.unity_id))),

                                  // Status with color coding for 'Paid' and others
                                  DataCell(
                                    tenant.status == 'Paid'
                                        ? Text(
                                      tenant.status,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.activeGreen,
                                      ),
                                    )
                                        : Text(
                                      tenant.status,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.destructiveRed,
                                      ),
                                    ),
                                  ),

                                  // Time Ago
                                  DataCell(Text(tenant.timeAgo)),

                                  // Action buttons (View, Edit, Delete)
                                  DataCell(
                                    Row(
                                      children: [
                                        // View button
                                        IconButton(
                                          onPressed: () => viewTenantData(tenant.id),
                                          icon: const Icon(Icons.remove_red_eye),
                                          color: CupertinoColors.systemBlue,
                                        ),
                                        // Edit button
                                        IconButton(
                                          onPressed: () => showUpdateTenants(tenant.id),
                                          icon: const Icon(Icons.mode_edit_outline),
                                          color: CupertinoColors.systemGreen,
                                        ),
                                        // Delete button
                                        IconButton(
                                          onPressed: () => _deleteTenant(tenant.id),
                                          icon: const Icon(Icons.delete),
                                          color: Colors.redAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),

                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}




class MyCreateNewDialog extends StatefulWidget {
  final VoidCallback fetchTenants;
  final List<AllPropertyModel> properties;
  final List<AllUnityModel> unities;

  const MyCreateNewDialog({super.key, required this.properties, required this.unities, required this.fetchTenants});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}


class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cNameController = TextEditingController();
  final TextEditingController _unityIdController = TextEditingController();

  AllUnityModel? _selectedUnity;
  AllPropertyModel? _selectedProperty;

  List<AllUnityModel> _filteredUnities = [];
  bool _isUnityEnabled = false;
  bool _isCompanyNameEnabled = false;

  final AllTenantsService allTenantsService = AllTenantsService();

  @override
  void initState() {
    super.initState();
    _filteredUnities = widget.unities;
  }

  void _onPropertyChanged(AllPropertyModel? selectedProperty) {
    setState(() {
      _selectedProperty = selectedProperty;
      _isUnityEnabled = selectedProperty != null;
      _isCompanyNameEnabled = selectedProperty?.type == "Business" ||
          selectedProperty?.type == "Both";

      if (selectedProperty != null) {
        // Filter unities based on the selected property ID
        _filteredUnities = widget.unities.where((unit) => unit.property_id ==
            selectedProperty.id && unit.status == 'not-taken').toList();
      } else {
        _filteredUnities = widget.unities;
      }
    });
  }


  Future<void> _createNewTenant() async {
    if (_selectedProperty != null) {
      isLoadingState();
      if (_selectedProperty!.type.toString() == "Business" || _selectedProperty!.type.toString() == "Both") {
        if (_fNameController.text.isEmpty ||
            _lNameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _phoneController.text.isEmpty ||
            _cNameController.text.isEmpty ||
            _selectedUnity == null) {
          Navigator.pop(context);
          showErrorMsg(context, "All fields are Required");
        } else {
          _unityIdController.text = _selectedUnity!.name.toString();
          final response = await allTenantsService.createTenant({
            'firstname': _fNameController.text.toString(),
            'lastname': _lNameController.text.toString(),
            'email': _emailController.text.toString(),
            'phone': _phoneController.text.toString(),
            'company_name': _cNameController.text.toString(),
            'unity_id': _unityIdController.text.toString()
          });

          if (response.statusCode == 200) {
            Navigator.pop(context);
            Navigator.pop(context);
            widget.fetchTenants();
            showSuccessMsg(context, "Tenant Created Successfully");
          } else {
            Navigator.pop(context);
            showErrorMsg(context, "Tenant Created Unsuccessfully, ${response.body}");
          }
        }
      } else {
        isLoadingState();
        if (_fNameController.text.isEmpty ||
            _lNameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _phoneController.text.isEmpty ||
            _selectedUnity == null) {
          Navigator.pop(context);
          showErrorMsg(context, "All fields are Required, Except Company Name");
        } else {
          _unityIdController.text = _selectedUnity!.name.toString();
          final response = await allTenantsService.createTenant({
            'firstname': _fNameController.text.toString(),
            'lastname': _lNameController.text.toString(),
            'email': _emailController.text.toString(),
            'phone': _phoneController.text.toString(),
            'company_name': _cNameController.text.toString(),
            'unity_id': _unityIdController.text.toString()
          });

          if (response.statusCode == 200) {
            Navigator.pop(context);
            Navigator.pop(context);
            widget.fetchTenants();
            showSuccessMsg(context, "Tenant Created Successfully");
          } else {
            Navigator.pop(context);
            showErrorMsg(context, "Tenant Created Unsuccessfully ${response.body}");
          }
        }
      }
    } else {
      showErrorMsg(context, "Please Select a Property.");
    }
  }

  void isLoadingState(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.75,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create New Tenant",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.pink.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            _buildTextField(
                                context,
                                _fNameController,
                                'First Name',
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.31),
                            _buildTextField(
                                context,
                                _lNameController,
                                'Last Name',
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.31),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _buildTextField(
                            context,
                            _emailController,
                            'Email',
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.63
                        ),

                        const SizedBox(height: 18),

                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField<AllPropertyModel>(
                                value: _selectedProperty,
                                onChanged: _onPropertyChanged,
                                items: widget.properties.map((AllPropertyModel prop) {
                                  // Count the unities for each property with status "not-taken"
                                  int count = widget.unities.where((unit) => unit.property_id == prop.id && unit.status == "not-taken").length;

                                  return DropdownMenuItem<AllPropertyModel>(
                                    value: prop,
                                    child: Text('${prop.name} (${prop.type}) (A.U: $count)'),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Property',
                                ),
                              ),
                            ),



                            // UNIT
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.31,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField<AllUnityModel>(
                                value: _selectedUnity,
                                onChanged: _isUnityEnabled // Use _isUnityEnabled
                                    ? (AllUnityModel? value) {
                                  setState(() {
                                    _selectedUnity = value!;
                                  });
                                }
                                    : null,
                                items: _filteredUnities
                                    .map((AllUnityModel unit) =>
                                    DropdownMenuItem<AllUnityModel>(
                                      value: unit,
                                      child: Text(unit.name),
                                    ))
                                    .toList(),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Unity',
                                ),
                                disabledHint: const Text(
                                    'Select a Property first'),
                              ),
                            ),
                          ],
                        ),


                        const SizedBox(height: 18,),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [

                            _buildTextField(
                              context,
                              _phoneController,
                              'Phone',
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.31,
                            ),

                            _buildTextField(
                              context,
                              _cNameController,
                              'Company Name',
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.31,
                              enabled: _isCompanyNameEnabled, // Use _isCompanyNameEnabled
                            ),

                          ],
                        ),

                        const SizedBox(height: 60),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonDialogBox(
                              title: 'Cancel',
                              color: Colors.grey,
                              onPressFunction: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 15),
                            ButtonDialogBox(
                              title: 'Submit',
                              color: Colors.pink.shade400,
                              onPressFunction: _createNewTenant,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(BuildContext context,
      TextEditingController controller,
      String label,
      double width, {
        bool enabled = true,
      }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
      ),
    );
  }
}