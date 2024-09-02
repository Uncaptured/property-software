import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/all_properties_services.dart';
import 'package:flutter_real_estate/API_services/all_tenants_service.dart';
import 'package:flutter_real_estate/API_services/all_unity_services.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/models/all_property_model.dart';
import 'package:flutter_real_estate/models/all_tenants_model.dart';
import 'package:flutter_real_estate/models/all_units_model.dart';
import 'package:intl/intl.dart';
import '../components/button_form_dialogbox.dart';

class TenantFragment extends StatefulWidget {
  TenantFragment({super.key});

  @override
  State<TenantFragment> createState() => _TenantFragmentState();
}

class _TenantFragmentState extends State<TenantFragment> {
  bool isLoading = true;
  List<AllTenantsModel> tenants = [];
  List<AllPropertyModel> properties = [];
  List<AllUnityModel> unities = [];
  AllUnityModel? unity;

  final AllTenantsService allTenantsService = AllTenantsService();
  final AllUnityServices allUnityServices = AllUnityServices();
  final AllPropertyService allPropertyService = AllPropertyService();

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTenants();
  }

  Future<void> _fetchTenants() async {
    try {
      List<AllTenantsModel> allTenants = await allTenantsService.getAllTenants();
      List<AllUnityModel> allUnities = await allUnityServices.getAllUnities();
      List<AllPropertyModel> allProperties = await allPropertyService.getAllProperties();
      setState(() {
        tenants = allTenants;
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


  @override
  Widget build(BuildContext context) {
    int id = 1;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 30.0
        ),
        child: Column(
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
                    DataColumn(label: Text("Company Name", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("PropertyName (Type)", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Unity Name", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    if(tenants.isNotEmpty)
                      for(var tenant in tenants)
                        DataRow(cells: [
                          DataCell(Text('${id++}')),
                          DataCell(Text('${tenant.firstname} ${tenant.lastname}')),
                          DataCell(
                            tenant.company_name == null || tenant.company_name!.isEmpty
                            ?
                            Text(
                              'null',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontStyle: FontStyle.italic
                              ),
                            )
                            :
                            Text(tenant.company_name!.toString()),
                          ),
                          DataCell(Text(displayPropertyWithType(tenant.unity_id))),
                          DataCell(Text(displayUnityName(tenant.unity_id))),
                          DataCell(Text(displayUnityPrice(tenant.unity_id))),
                          DataCell(
                            tenant.status == 'paid' ?
                            Text(
                              tenant.status,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.activeGreen,
                              ),
                            ) :
                            Text(
                              tenant.status,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.destructiveRed,
                              ),
                            )
                          ),
                          DataCell(Text(tenant.timeAgo)),
                          DataCell(Row(
                            children: [
                              // View button
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(Icons.remove_red_eye),
                                color: CupertinoColors.systemBlue,
                              ),
                              // Edit button
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(Icons.mode_edit_outline),
                                color: CupertinoColors.systemGreen,
                              ),
                              // Delete button
                              IconButton(
                                onPressed: (){},
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                              ),
                            ],
                          )),
                        ])
                    else
                      const DataRow(cells: [
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Center(child: Text('Empty Tenants Data', style: TextStyle(color: Colors.red),))),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                      ]),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


//
// class MyCreateNewDialog extends StatefulWidget {
//   final VoidCallback fetchTenants;
//   final List<AllPropertyModel> properties;
//   final List<AllUnityModel> unities;
//
//   const MyCreateNewDialog({super.key, required this.properties, required this.unities, required this.fetchTenants});
//
//   @override
//   State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
// }
//
// class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
//   final TextEditingController _fNameController = TextEditingController();
//   final TextEditingController _lNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _cNameController = TextEditingController();
//   final TextEditingController _unityIdController = TextEditingController();
//
//   AllUnityModel? _selectedUnity;
//   AllPropertyModel? _selectedProperty;
//
//   final AllTenantsService allTenantsService = AllTenantsService();
//
//   Future<void> _createNewTenant() async {
//     setState(() {
//       const Center(
//         child: CircularProgressIndicator(),
//       );
//     });
//
//     print(_selectedProperty!.type.toString());
//
//     if(_selectedProperty!.type.toString() == "Business"){
//       if(
//           _fNameController.text.isEmpty ||
//           _lNameController.text.isEmpty ||
//           _emailController.text.isEmpty ||
//           _phoneController.text.isEmpty ||
//           _cNameController.text.isEmpty ||
//           _selectedUnity == null
//       ){
//         Navigator.pop(context);
//         showErrorMsg(context, "All fields are Required");
//       }else{
//         _unityIdController.text = _selectedUnity!.name.toString();
//         final response = await allTenantsService.createTenant({
//           'firstname': _fNameController.text.toString(),
//           'lastname': _lNameController.text.toString(),
//           'email': _emailController.text.toString(),
//           'phone': _phoneController.text.toString(),
//           'company_name': _cNameController.text.toString(),
//           'unity_id': _unityIdController.text.toString()
//         });
//
//         if(response.statusCode == 200){
//           Navigator.pop(context);
//           setState(() {
//             widget.fetchTenants();
//           });
//           showSuccessMsg(context, "Tenant Created Successfully");
//         }else{
//           showErrorMsg(context, "Tenant Created Unsuccessfully");
//         }
//       }
//     }else{
//       if(
//           _fNameController.text.isEmpty ||
//           _lNameController.text.isEmpty ||
//           _emailController.text.isEmpty ||
//           _phoneController.text.isEmpty ||
//           _selectedUnity == null
//       ){
//         Navigator.pop(context);
//         showErrorMsg(context, "All fields are Required, Except Company Name");
//       }else{
//         _unityIdController.text = _selectedUnity!.name.toString();
//         final response = await allTenantsService.createTenant({
//           'firstname': _fNameController.text.toString(),
//           'lastname': _lNameController.text.toString(),
//           'email': _emailController.text.toString(),
//           'phone': _phoneController.text.toString(),
//           'company_name': _cNameController.text.toString(),
//           'unity_id': _unityIdController.text.toString()
//         });
//
//         if(response.statusCode == 200){
//           Navigator.pop(context);
//           setState(() {
//             widget.fetchTenants();
//           });
//           showSuccessMsg(context, "Tenant Created Successfully");
//         }else{
//           showErrorMsg(context, "Tenant Created Unsuccessfully");
//         }
//       }
//     }
//   }
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 200),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return SizedBox(
//             height: MediaQuery.of(context).size.height * 0.75,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 50,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Create New Tenant",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 25,
//                             ),
//                           ),
//                           Container(
//                             width: 50,
//                             height: 4,
//                             decoration: BoxDecoration(
//                               color: Colors.pink.shade400,
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     Container(
//                       height: 1,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Wrap(
//                           runSpacing: 15,
//                           spacing: 15,
//                           children: [
//                             _buildTextField(
//                                 context,
//                                 _fNameController,
//                                 'First Name',
//                                 MediaQuery.of(context).size.width * 0.31
//                             ),
//                             _buildTextField(
//                                 context,
//                                 _lNameController,
//                                 'Last Name',
//                                 MediaQuery.of(context).size.width * 0.31
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 18),
//
//                         _buildTextField(
//                             context,
//                             _emailController,
//                             'Email',
//                             MediaQuery.of(context).size.width * 0.63
//                         ),
//
//                         const SizedBox(height: 18),
//
//                         Wrap(
//                           runSpacing: 15,
//                           spacing: 15,
//                           children: [
//
//                             _buildTextField(
//                                 context,
//                                 _phoneController,
//                                 'Phone',
//                                 MediaQuery.of(context).size.width * 0.31
//                             ),
//
//                             _buildTextField(
//                               context,
//                               _cNameController,
//                               'Company Name',
//                               MediaQuery.of(context).size.width * 0.31,
//                             ),
//
//                           ],
//                         ),
//
//                         const SizedBox(height: 18),
//
//                         Wrap(
//                           spacing: 15,
//                           runSpacing: 15,
//                           children: [
//
//                             // PROPERTY
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.31,
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: DropdownButtonFormField<AllPropertyModel>(
//                                 value: _selectedProperty,
//                                 onChanged: (AllPropertyModel? value) {
//                                   setState(() {
//                                     _selectedProperty = value!;
//                                   });
//                                 },
//                                 items: widget.properties
//                                     .map((AllPropertyModel prop) => DropdownMenuItem<AllPropertyModel>(
//                                   value: prop,
//                                   child: Text('${prop.name} (${prop.type})'),
//                                 ))
//                                     .toList(),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   labelText: 'Property',
//                                 ),
//                               ),
//                             ),
//
//
//                             // UNIT
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.31,
//                               padding: const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: DropdownButtonFormField<AllUnityModel>(
//                                 value: _selectedUnity,
//                                 onChanged: (AllUnityModel? value) {
//                                   setState(() {
//                                     _selectedUnity = value!;
//                                   });
//                                 },
//                                 items: widget.unities
//                                     .map((AllUnityModel unit) => DropdownMenuItem<AllUnityModel>(
//                                   value: unit,
//                                   child: Text(unit.name),
//                                 ))
//                                     .toList(),
//                                 decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   labelText: 'Unity',
//                                 ),
//                               ),
//                             ),
//
//                           ],
//                         ),
//
//
//                         const SizedBox(height: 60),
//
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//
//                             ButtonDialogBox(
//                               title: 'Cancel',
//                               color: Colors.grey,
//                               onPressFunction: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//
//                             const SizedBox(width: 15),
//
//                             ButtonDialogBox(
//                               title: 'Save',
//                               color: Colors.pink.shade400,
//                               onPressFunction: _createNewTenant,
//                             ),
//
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//
//
//   Widget _buildTextField(BuildContext context, TextEditingController controller,
//       String labelText, double width, {bool obscureText = false}) {
//     return Container(
//       width: width,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           labelText: labelText,
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class showContentDialog extends StatelessWidget {
//   final String content;
//   final String columnName;
//
//   const showContentDialog({
//     super.key,
//     required this.columnName,
//     required this.content
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 340,
//       constraints: const BoxConstraints(maxWidth: 600),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             columnName,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//           ),
//
//           Text(
//             content,
//             style: const TextStyle(
//               fontSize: 18,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


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
            selectedProperty.id).toList();
      } else {
        _filteredUnities = widget.unities;
      }
    });
  }

  Future<void> _createNewTenant() async {
    if (_selectedProperty != null) {
      if (_selectedProperty!.type.toString() == "Business") {
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
            widget.fetchTenants();
            showSuccessMsg(context, "Tenant Created Successfully");
          } else {
            showErrorMsg(context, "Tenant Created Unsuccessfully");
          }
        }
      } else {
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
            widget.fetchTenants();
            showSuccessMsg(context, "Tenant Created Successfully");
          } else {
            showErrorMsg(context, "Tenant Created Unsuccessfully");
          }
        }
      }
    } else {
      showErrorMsg(context, "Please select a property.");
    }
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

                            // PROPERTY
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
                              child: DropdownButtonFormField<AllPropertyModel>(
                                value: _selectedProperty,
                                onChanged: _onPropertyChanged,
                                items: widget.properties
                                    .map((AllPropertyModel prop) =>
                                    DropdownMenuItem<AllPropertyModel>(
                                      value: prop,
                                      child: Text(
                                          '${prop.name} (${prop.type})'),
                                    ))
                                    .toList(),
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