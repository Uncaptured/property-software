import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_real_estate/API_services/all_lease_services.dart';
import 'package:flutter_real_estate/API_services/all_tenants_service.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/models/all_tenants_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../API_services/all_properties_services.dart';
import '../API_services/all_unity_services.dart';
import '../components/button_form_dialogbox.dart';
import '../components/notification.dart';
import '../models/all_lease_model.dart';
import '../models/all_property_model.dart';
import '../models/all_units_model.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure you have url_launcher dependency in pubspec.yaml
import 'package:path/path.dart' as path;
import 'package:month_year_picker/month_year_picker.dart';


class LeaseFragment extends StatefulWidget {
  LeaseFragment({super.key});

  @override
  State<LeaseFragment> createState() => _LeaseFragmentState();
}

class _LeaseFragmentState extends State<LeaseFragment> {
  bool isLoading = true;
  File? _documentFile;
  String _amount = '';
  String _frequency = '';
  String? _pickedFileGlobalName;
  String _pickedFileName = '';
  Uint8List? _documentBytes;

  List<AllUnityModel> unities = [];
  List<AllPropertyModel> properties = [];
  List<AllLeaseModel> leases = [];
  List<AllLeaseModel> filteredLease = [];
  List<AllTenantsModel> tenants = [];

  final TextEditingController searchController = TextEditingController();
  final AllUnityServices allUnityServices = AllUnityServices();
  final AllPropertyService allPropertyService = AllPropertyService();
  final AllLeaseService allLeaseService = AllLeaseService();
  final AllTenantsService allTenantsService = AllTenantsService();
  final TextEditingController _documentUrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLeases();
    searchController.addListener(_filterLease);
  }

  Future<void> _fetchLeases() async {
    try {
      List<AllLeaseModel> allLeases = await allLeaseService.getAllLease();
      List<AllUnityModel> allUnities = await allUnityServices.getAllUnities();
      List<AllPropertyModel> allProperties = await allPropertyService.getAllProperties();
      List<AllTenantsModel> allTenants = await allTenantsService.getAllTenants();

      setState(() {
        unities = allUnities;
        properties = allProperties;
        filteredLease = allLeases;
        leases = allLeases;
        tenants = allTenants;
        isLoading = false;
      });
    } catch (e) {
      showErrorMsg(context, "Error, $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterLease() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredLease = leases;
      } else {
        final query = searchController.text.toLowerCase();
        filteredLease = leases.where((lease) {
          return lease.ammount.toLowerCase().contains(query) ||
              lease.startDate.toLowerCase().contains(query) ||
              lease.endDate.toLowerCase().contains(query) ||
              lease.frequency.toLowerCase().contains(query) ||
              displayUnityName(lease.unity_id).toLowerCase().contains(query) ||
              displayTenantName(lease.unity_id).toLowerCase().contains(query);
        }).toList();
      }
    });
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => MyCreateNewDialog(properties: properties, tenants: tenants, unities: unities, fetchLeases: _fetchLeases),
    );
  }


  void isLoadingState(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const Center(child: CircularProgressIndicator(
            color: CupertinoColors.white,
          ),
        );
      },
    );
  }

  String displayPropertyName(int leasePropId){
    for(var prop in properties){
      if(prop.id == leasePropId){
        return prop.name;
      }
    }
    return 'Error return PropertyName';
  }

  String displayUnityName(int leaseUnitId){
    for(var unit in unities){
      if(unit.id == leaseUnitId){
        return unit.name;
      }
    }
    return 'Error return UnityName';
  }

  String displayTenantName(int leaseUnitId){
    for(var unit in unities){
      for(var ten in tenants){
        if(unit.id == leaseUnitId){
          if(ten.unity_id == unit.id){
            return '${ten.firstname} ${ten.lastname}';
          }
        }
      }
    }
    return 'Error return TenantUnityName';
  }

  String displayTenantUnityName(int leaseUnitId){
    for(var unit in unities){
      for(var ten in tenants){
        if(unit.id == leaseUnitId){
          if(ten.unity_id == unit.id){
            return '${ten.firstname} ${ten.lastname} (${unit.name})';
          }
        }
      }
    }
    return 'Error return TenantUnityName';
  }

  String formatDateString(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);

      return DateFormat('MMM d, yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

  void _viewDocument(String documentPath) async {
    final url = 'http://127.0.0.1:8000/storage/$documentPath'; // Adjust the URL based on your Laravel setup

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void viewLeaseData(int leaseId) {
    for(var myLease in leases) {
      if(myLease.id == leaseId) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("View Lease", style: TextStyle(fontWeight: FontWeight.bold)),

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
                            showContentDialog(columnName: "Start Date", content: formatDateString(myLease.startDate)),

                            showContentDialog(columnName: "End Date", content: formatDateString(myLease.startDate)),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [

                            showContentDialog(columnName: "Tenant (Unit)", content: displayTenantUnityName(myLease.unity_id)),

                            showContentDialog(columnName: "Duration", content: '${myLease.frequency} Months'),

                          ],
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [

                            showContentDialog(columnName: "Total Amount", content: 'Tzs ${myLease.formatPrice}'),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  'Attached Document',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    _viewDocument(myLease.document);
                                  },
                                  child: const Icon( Icons.insert_drive_file_sharp, color: Colors.lightBlue, size: 19,),
                                )

                              ]
                            ),

                          ],
                        ),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Created Time", content: "${myLease.formattedDate} (${myLease.timeAgo})"),

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



  Future<void> _deleteLease(int leaseId) async {
    isLoadingState();

    final response = await allLeaseService.deleteLease(leaseId);

    if(response.statusCode == 200){
      setState(() {
        leases.removeWhere((lease) => lease.id == leaseId);
        _fetchLeases();
      });
      Navigator.pop(context);
      showSuccessMsg(context, "Tenant Deleted Successfully");
    }else{
      isLoading = false;
      Navigator.pop(context);
      showErrorMsg(context, "Tenant Delete Unsuccessfully");
    }
  }

  // Future<void> _documentPickFile(BuildContext context, TextEditingController _updateDocumentNameController) async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx'],
  //   );
  //
  //   if (result == null || result.files.isEmpty) return;
  //
  //   final pickedFile = result.files.first;
  //   final now = DateTime.now();
  //
  //   setState((){
  //     String newfileName = '${now.toIso8601String()}-${pickedFile.name}';setState(() {
  //       _pickedFileName = newfileName;
  //       _updateDocumentNameController.text = newfileName;
  //       print(_updateDocumentNameController.text);
  //
  //       // Store the file in memory or local storage
  //       if (kIsWeb) {
  //         _documentBytes = pickedFile.bytes;
  //       } else {
  //         _documentFile = File(pickedFile.path!);
  //       }
  //     });
  //
  //   });
  // }

  void _documentPickFile(TextEditingController _updateDocumentNameController) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null || result.files.isEmpty) return;

    final pickedFile = result.files.first;
    final now = DateTime.now();

    setState(() {
      String newfileName = '${now.toIso8601String()}-${pickedFile.name}';
      _pickedFileName = newfileName;
      _updateDocumentNameController.text = newfileName;
      print(_updateDocumentNameController.text);

      // Store the file in memory or local storage
      if (kIsWeb) {
        _documentBytes = pickedFile.bytes;
      } else {
        _documentFile = File(pickedFile.path!);
      }
    });
  }

  Future<void> showUpdateTenants(int leaseId) async {
    for (var myLease in leases) {
      if (myLease.id == leaseId) {
        showDialog(
          context: context,
          builder: (context) {

            final _updateStartDateController = TextEditingController(text: myLease.startDate);
            final _updateEndDateController = TextEditingController(text: myLease.endDate);
            final _updateDurationController = TextEditingController(text: myLease.frequency);
            final TextEditingController _updateDocumentNameController = TextEditingController(text: myLease.document);

            AllUnityModel? _selectedUnity = unities.firstWhere((unit) => unit.id == myLease.unity_id);

            String displayTenantName(int id){
              for(var tenant in tenants){
                if(tenant.unity_id == id){
                  return "${tenant.firstname} ${tenant.lastname}";
                }
              }
              return "Error display Tenant name";
            }

            String displayTenandId(int id){
              for(var tenant in tenants){
                if(tenant.unity_id == id){
                  return '${tenant.id}';
                }
              }
              return "Error display Tenant id";
            }

            // bool isChanged(){
            //   if(_updateDocumentNameController.text.isEmpty){
            //     return false;
            //   }
            //   return true;
            // }

            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    title: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update Lease", style: TextStyle(fontWeight: FontWeight.bold)),
                        Divider()
                      ],
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Wrap(
                              runSpacing: 20,
                              spacing: 20,
                              children: [
                                // Start Date
                                _buildDatePickerField(
                                  context,
                                  _updateStartDateController,
                                  'Start Date',
                                  onDateSelected: (DateTime date) {
                                    setState(() {
                                      _updateStartDateController.text = DateFormat('yyyy-MM').format(date);

                                      if (_updateEndDateController.text.isNotEmpty) {
                                        _updateDurationController.text = displayDiffInMonths(
                                          _updateStartDateController.text,
                                          _updateEndDateController.text,
                                        ).toString();
                                      }
                                    });
                                  },
                                ),

                                // End Date
                                _buildDatePickerField(
                                  context,
                                  _updateEndDateController,
                                  'End Date',
                                  onDateSelected: (DateTime date) {
                                    setState(() {
                                      _updateEndDateController.text = DateFormat('yyyy-MM').format(date);

                                      if (_updateStartDateController.text.isNotEmpty) {
                                        _updateDurationController.text = displayDiffInMonths(
                                          _updateStartDateController.text,
                                          _updateEndDateController.text,
                                        ).toString();
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _updateDurationController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: "Duration (months)",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField<AllUnityModel>(
                                value: _selectedUnity,
                                onChanged: (AllUnityModel? value) {
                                  setState(() {
                                    _selectedUnity = value!;
                                  });
                                },
                                items: unities.where((unit) => unit.status == 'taken' || unit.status == 'pending').map((AllUnityModel unit) {
                                  return DropdownMenuItem<AllUnityModel>(
                                    value: unit,
                                    child: Text('${unit.name} (${displayTenantName(unit.id)})'),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Unity',
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            GestureDetector(
                              onTap: () => _documentPickFile(_updateDocumentNameController),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade400),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.folder, color: Colors.blue, size: 32),
                                    const SizedBox(width: 10),
                                    ValueListenableBuilder<TextEditingValue>(
                                      valueListenable: _updateDocumentNameController,
                                      builder: (context, value, child) {
                                        return Text(
                                          _updateDocumentNameController.text,
                                          style: const TextStyle(color: Colors.black87),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ButtonDialogBox(title: "Cancel", color: Colors.grey, onPressFunction: () => Navigator.pop(context)),
                      ButtonDialogBox(
                        title: "Update",
                        color: Colors.pink.shade400,
                        onPressFunction: () => updateLease(
                            myLease.id,
                            _updateStartDateController.text,
                            _updateEndDateController.text,
                            _selectedUnity!.id.toString(),
                            _updateDurationController.text, // duration in months
                            calculateTotalAmount(_updateStartDateController.text, _updateEndDateController.text, _selectedUnity!.price),
                            _updateDocumentNameController.text,
                            _updateDocumentNameController.text ==  myLease.document ? false : true,
                            displayTenandId(_selectedUnity!.id)
                        ),
                      ),
                    ],
                  );
                }
            );
          },
        );
      }
    }
  }


  Widget _buildTextField(
      BuildContext context,
      TextEditingController controller,
      String labelText, {
        double? width,
        bool enabled = true
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

  Widget _buildDatePickerField(
      BuildContext context,
      TextEditingController controller,
      String labelText, {
        required Function(DateTime) onDateSelected,
      }) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width / 3.16,
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
        onTap: () async {
          DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2050),
          );

          if (date != null) {
            setState(() {
              onDateSelected(date);
            });
          }
        },
        readOnly: true,
      ),
    );
  }


  Widget _buildDocumentPicker(
      BuildContext context,
      TextEditingController controller
      ) {
    return GestureDetector(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx'],
        );

        if (result == null || result.files.isEmpty) return;

        final pickedFile = result.files.first;
        final now = DateTime.now();

        String newfileName = '${now.toIso8601String()}-${pickedFile.name}';setState(() {
          print('FileName: $newfileName');
          controller.text = newfileName;
          _pickedFileName = newfileName;
          print('Controller Data: ${controller.text}');
          print('Controller Data: $_pickedFileName');

          // Store the file in memory or local storage
          if (kIsWeb) {
            _documentBytes = pickedFile.bytes;
          } else {
            _documentFile = File(pickedFile.path!);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.folder, color: Colors.blue, size: 32),
            const SizedBox(width: 10),
            Text(
              _pickedFileName,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }




// Duration Calculation
  int displayDiffInMonths(String startDate, String endDate) {
    DateTime start = DateFormat('yyyy-MM').parse(startDate);
    DateTime end = DateFormat('yyyy-MM').parse(endDate);
    int yearsDiff = end.year - start.year;
    int monthsDiff = end.month - start.month;
    return (yearsDiff * 12) + monthsDiff;
  }

// Calculate Total Amount based on the lease period and price
  String calculateTotalAmount(String startDate, String endDate, String price) {
    int months = displayDiffInMonths(startDate, endDate);
    double monthlyPrice = double.parse(price);
    return (months * monthlyPrice).toStringAsFixed(2);
  }

  //
  // Future<void> updateLease(
  //     int id, String startDateMonth,String endDateMonth, String selectedUnity,
  //     String duration, String totalAmount, String documentFile, bool isChanged
  // ) async {
  //   isLoadingState(); // Loading state indicator
  //
  //   if (
  //       startDateMonth.isEmpty ||
  //       endDateMonth.isEmpty ||
  //       documentFile.isEmpty ||
  //       duration.isEmpty ||
  //       totalAmount.isEmpty ||
  //       selectedUnity.isEmpty
  //   ) {
  //     Navigator.pop(context);
  //     showErrorMsg(context, "All fields are required");
  //     return;
  //   }
  //
  //   AllTenantsModel tenantId = tenants.firstWhere((tenant) => tenant.unity_id == selectedUnity.toString());
  //
  //   dynamic document;
  //   String documentName;
  //
  //   if (kIsWeb) {
  //     if (_documentBytes == null) {
  //       Navigator.pop(context);
  //       showErrorMsg(context, "No document selected");
  //       return;
  //     }
  //     document = _documentBytes;
  //     documentName = documentFile;
  //   } else {
  //     if (_documentFile == null) {
  //       Navigator.pop(context);
  //       showErrorMsg(context, "No document selected");
  //       return;
  //     }
  //     document = _documentFile; // File for mobile
  //     documentName = path.basename(_documentFile!.path);
  //   }
  //
  //
  //   try {
  //     final response = await allLeaseService.updateLease(
  //       id: id.toString(),
  //       startDate: startDateMonth, // Using current date
  //       endDate: endDateMonth,
  //       ammount: totalAmount,
  //       document: document,
  //       documentName: documentName,
  //       frequency: duration,
  //       tenant_id: tenantId.toString(),
  //       isChanged: isChanged,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       Navigator.pop(context);
  //       setState(() {
  //         _fetchLeases();
  //       });
  //       showSuccessMsg(context, "Lease Updated Successfully");
  //     } else {
  //       Navigator.pop(context);
  //       showErrorMsg(context, "Lease Updated Unsuccessful: ${response.body}");
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     showErrorMsg(context, "An error occurred: ${e.toString()}");
  //   }
  // }


  // Future<void> updateLease(
  //     BuildContext context, // Added context
  //     int id,
  //     String startDateMonth,
  //     String endDateMonth,
  //     String selectedUnity,
  //     String duration,
  //     String totalAmount,
  //     String documentFile,
  //     bool isChanged
  //     ) async {
  //   isLoadingState(); // Loading state indicator
  //
  //   if (
  //   startDateMonth.isEmpty ||
  //       endDateMonth.isEmpty ||
  //       documentFile.isEmpty ||
  //       duration.isEmpty ||
  //       totalAmount.isEmpty ||
  //       selectedUnity.isEmpty
  //   ) {
  //     Navigator.pop(context);
  //     showErrorMsg(context, "All fields are required");
  //     return;
  //   }
  //
  //   AllTenantsModel tenant = tenants.firstWhere((tenant) => tenant.unity_id == selectedUnity.toString());
  //
  //   dynamic document;
  //   String documentName;
  //
  //   if (kIsWeb) {
  //     if (_documentBytes == null) {
  //       Navigator.pop(context);
  //       showErrorMsg(context, "No document selected");
  //       return;
  //     }
  //     document = _documentBytes;
  //     documentName = documentFile;
  //   } else {
  //     if (_documentFile == null) {
  //       Navigator.pop(context);
  //       showErrorMsg(context, "No document selected");
  //       return;
  //     }
  //     document = _documentFile;
  //     documentName = path.basename(_documentFile!.path);
  //   }
  //
  //   try {
  //     final response = await allLeaseService.updateLease(
  //       id: id.toString(),
  //       startDate: startDateMonth,
  //       endDate: endDateMonth,
  //       ammount: totalAmount,
  //       document: document,
  //       documentName: documentName,
  //       frequency: duration,
  //       tenant_id: tenant.id.toString(), // Using the correct ID
  //       isChanged: isChanged,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       Navigator.pop(context);
  //       setState(() {
  //         _fetchLeases(); // Refetch leases after successful update
  //       });
  //       showSuccessMsg(context, "Lease Updated Successfully");
  //     } else {
  //       Navigator.pop(context);
  //       showErrorMsg(context, "Lease Update Unsuccessful: ${response.body}");
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     showErrorMsg(context, "An error occurred: ${e.toString()}");
  //   }
  // }

  Future<void> updateLease(
      int id, String startDateMonth, String endDateMonth, String selectedUnity,
      String duration, String totalAmount, String documentFile, bool isChanged, String tenantId
      ) async {
    isLoadingState();

    // Log the information before API call
    print("Preparing to update lease...");
    print("Lease ID: $id, Start Date: $startDateMonth, End Date: $endDateMonth, tenantId: $tenantId, isChanged: $isChanged, unity Id: $selectedUnity, Amount: $totalAmount, Document Name: $documentFile");

    if ( startDateMonth.isEmpty || endDateMonth.isEmpty || documentFile.isEmpty ||
         duration.isEmpty || totalAmount.isEmpty || selectedUnity.isEmpty) {
      Navigator.pop(context);
      showErrorMsg(context, "All fields are required");
      return;
    }

    dynamic document;
    String documentName;

    if (kIsWeb) {
      if (_documentBytes == null) {
        Navigator.pop(context);
        showErrorMsg(context, "No document selected");
        return;
      }

      document = _documentBytes;
      documentName = documentFile;
    } else {
      if (_documentFile == null) {
        Navigator.pop(context);
        showErrorMsg(context, "No document selected");
        return;
      }
      document = _documentFile; // Mobile document
      documentName = path.basename(_documentFile!.path);
    }

    print("Preparing to update lease...");
    print("Lease ID: $id, Start Date: $startDateMonth, End Date: $endDateMonth, Amount: $totalAmount, Document Name: $documentName");

    try {
      final response = await allLeaseService.updateLease(
        id: id.toString(),
        startDate: startDateMonth,
        endDate: endDateMonth,
        ammount: totalAmount,
        document: document,
        documentName: documentName,
        frequency: duration,
        tenant_id: tenantId,
        isChanged: isChanged,
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        setState(() {
          _fetchLeases();
        });
        showSuccessMsg(context, "Lease Updated Successfully");
      } else {
        showErrorMsg(context, "Lease Updated Unsuccessful: ${response.body}");
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorMsg(context, "An error occurred: ${e.toString()}");
    }
  }




  // Future<void> updateLease(
  //   int id, String startDate, String endDate, String selectedUnity,
  //   String duration, String totalAmount, String document
  // ) async {
  //   isLoadingState();
  //   if(
  //     id.toString().isEmpty ||
  //     startDate.toString().isEmpty ||
  //     endDate.toString().isEmpty ||
  //     selectedUnity.toString().isEmpty ||
  //     duration.toString().isEmpty ||
  //     totalAmount.toString().isEmpty ||
  //     document.toString().isEmpty
  //   ){
  //     Navigator.pop(context);
  //     showErrorMsg(context, 'All Fields are Required');
  //   }else{
  //
  //     final response = await allLeaseService.updateLease({
  //       'startDate': startDate.toString(),
  //       'endDate': endDate.toString(),
  //       'unity_id': selectedUnity.toString(),
  //       'frequency': duration.toString(),
  //       'totalAmount': totalAmount,
  //       'document': document
  //     });
  //
  //     if(response.statusCode == 200){
  //       _fetchLeases();
  //       Navigator.pop(context);
  //       showSuccessMsg(context, "Lease Updated Successfully");
  //     }else{
  //         Navigator.pop(context);
  //         showErrorMsg(context, 'Lease Updated Unsuccessfully');
  //     }
  //
  //   }
  // }



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

                      // Text
                      const Text(
                        "Lease",
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

                  MyNewPinkButton(width: 200, title: "+ New Lease", onPressFunction: _showDialog),
                ],
              ),
            ),



            // Divider line
            Container( // Make it take the full width
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
                            borderRadius: BorderRadius.circular(30)
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

                      //  tables
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
                              DataColumn(label: Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("End Date", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Tenant (Unit)", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Duration", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Attach", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                            rows: filteredLease.isEmpty
                                ? [
                              const DataRow(cells: [
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Center(child: Text('Empty Lease Data', style: TextStyle(color: Colors.red)))),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                              ]),
                            ]
                                : List<DataRow>.generate(
                              filteredLease.length,
                                  (index) {
                                final lease = filteredLease[index];
                                return DataRow(cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(formatDateString(lease.startDate))),
                                  DataCell(Text(formatDateString(lease.endDate))),
                                  DataCell(Text(displayTenantUnityName(lease.unity_id), overflow: TextOverflow.ellipsis)),
                                  DataCell(Text(lease.frequency)),
                                  DataCell(Text('Tzs ${lease.formatPrice}')),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        _viewDocument(lease.document);
                                      },
                                      icon: const Icon(Icons.insert_drive_file_sharp, color: Colors.lightBlue, size: 17),
                                    ),
                                  ),
                                  DataCell(Text(lease.timeAgo, overflow: TextOverflow.ellipsis)),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => viewLeaseData(lease.id),
                                        icon: const Icon(Icons.remove_red_eye),
                                        color: CupertinoColors.systemBlue,
                                      ),
                                      IconButton(
                                        onPressed: () => showUpdateTenants(lease.id),
                                        icon: const Icon(Icons.mode_edit_outline),
                                        color: CupertinoColors.systemGreen,
                                      ),
                                      IconButton(
                                        onPressed: () => _deleteLease(lease.id),
                                        icon: const Icon(Icons.delete),
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  )),
                                ]);
                              },
                            ),
                          ),

                          // child: DataTable(
                          //     columns: const [
                          //       DataColumn(label: Text("#", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("start-Date", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("End-Date", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("Property (Unit)", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("Duration", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("Ammount", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("Attach", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //       DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold),)),
                          //     ],
                          //     rows: filteredLease = null && filteredLease.isEmpty
                          //         ?
                          //     [
                          //           const DataRow(cells: [
                          //             DataCell.empty,
                          //             DataCell.empty,
                          //             DataCell.empty,
                          //             DataCell.empty,
                          //           DataCell(Center(child: Text('Empty Lease Data', style: TextStyle(color: Colors.red),))),
                          //             DataCell.empty,
                          //             DataCell.empty,
                          //             DataCell.empty,
                          //             DataCell.empty,
                          //         ])
                          //     ]
                          //       :
                          //     List<DataRow>.generate(
                          //       filteredLease.length,
                          //           (index) {
                          //         final lease = filteredLease[index];
                          //         return  DataRow(cells: [
                          //           DataCell(Text('${index + 1}')),
                          //           DataCell(Text(formatDateString(lease.startDate))),
                          //           DataCell(Text(formatDateString(lease.endDate))),
                          //           DataCell(Text('${displayPropertyName(lease.property_id)} (${displayUnityName(lease.unity_id)})', overflow: TextOverflow.ellipsis,)),
                          //           DataCell(Text(lease.frequency)),
                          //           DataCell(Text('Tzs ${lease.formatPrice}')),
                          //           DataCell(
                          //             IconButton(
                          //               // lease.document => url, how to store onCreate document using flutter - and view it
                          //               onPressed: (){
                          //                 _viewDocument(lease.document);
                          //               },
                          //               icon: const Icon( Icons.insert_drive_file_sharp, color: Colors.lightBlue, size: 17,),
                          //             ),
                          //           ),
                          //           DataCell(Text(lease.timeAgo, overflow: TextOverflow.ellipsis,)),
                          //           DataCell(Row(
                          //             children: [
                          //               // view btn
                          //               IconButton(
                          //                 onPressed: () => viewLeaseData(lease.id),
                          //                 icon: const Icon(Icons.remove_red_eye),
                          //                 color: CupertinoColors.systemBlue,
                          //               ),
                          //
                          //               // update btn
                          //               IconButton(
                          //                 onPressed: () => showUpdateTenants(lease.id),
                          //                 icon: const Icon(Icons.mode_edit_outline),
                          //                 color: CupertinoColors.systemGreen,
                          //               ),
                          //
                          //               // delete btn
                          //               IconButton(
                          //                 onPressed: () => _deleteLease(lease.id),
                          //                 icon: const Icon(Icons.delete),
                          //                 color: Colors.redAccent,
                          //               ),
                          //             ],
                          //           )),
                          //         ]),
                          //       },
                          //     ),
                          // ),
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





class showContentDialog extends StatelessWidget {
  final String content;
  final String columnName;

  const showContentDialog({
    super.key,
    required this.columnName,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          columnName,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),

        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
        ),

      ],
    );
  }
}


class MyCreateNewDialog extends StatefulWidget {
  final List<AllPropertyModel> properties;
  final List<AllUnityModel> unities;
  final List<AllTenantsModel> tenants;
  final VoidCallback fetchLeases;

  MyCreateNewDialog({
    super.key,
    required this.properties,
    required this.tenants,
    required this.unities,
    required this.fetchLeases,
  });

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _tenantController = TextEditingController();
  final TextEditingController _documentUrl = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  AllTenantsModel? _selectedTenant;
  File? _documentFile;
  String _amount = ''; // Amount variable to display
  String _frequency = ''; // Frequency variable to display
  String? _pickedFileGlobalName;
  Uint8List? _documentBytes;

  AllLeaseService allLeaseService = AllLeaseService();

  @override
  void initState() {
    super.initState();
    _frequencyController.text = '1'; // Default frequency
  }

  DateTime getCurrentDate() {
    return DateTime.now();
  }
  
  String calculateEndDate(int months) {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month + months, now.day);
    return formatDateTime(endDate);
  }
  
  String formatDateTime(DateTime date){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }


  void _updateFrequencyAndAmount() {
    int frequency = int.tryParse(_frequencyController.text) ?? 1;
    // DateTime endDate = calculateEndDate(frequency);
    // String endDateFormatted = DateFormat('yyyy-MM-dd').format(endDate);

    setState(() {
      _frequency = frequency.toString();
      if (_selectedTenant != null) {
        for (var unit in widget.unities) {
          if (unit.id == _selectedTenant?.unity_id) {
            String tenantPrice = unit.price;
            final amount = (double.tryParse(tenantPrice) ?? 0) * frequency;
            _amount = amount.toStringAsFixed(0); // Format amount with 2 decimal places
          }
        }
      }
    });
  }


  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result == null || result.files.isEmpty) return;

    final pickedFile = result.files.first;
    final now = DateTime.now();
    final fileName = '${now.toIso8601String()}-${pickedFile.name}';

    setState(() {
      _pickedFileGlobalName = pickedFile.name;

      // Check if running on the web
      if (kIsWeb) {
        _documentBytes = pickedFile.bytes;
      } else {
        _documentFile = File(pickedFile.path!);
      }

      _documentUrl.text = fileName; // Only setting the filename here
    });
  }




  Future<void> _createNewLease() async {
    isLoadingState(); // Loading state indicator

    if (_frequencyController.text.isEmpty ||
        _selectedTenant == null ||
        _documentUrl.text.isEmpty) {
      Navigator.pop(context);
      showErrorMsg(context, "All fields are required");
      return;
    }

    _tenantController.text = _selectedTenant!.id.toString();

    String endDate = calculateEndDate(int.parse(_frequencyController.text));
    _endDateController.text = endDate;

    dynamic document;
    String documentName;

    if (kIsWeb) {
      if (_documentBytes == null) {
        Navigator.pop(context);
        showErrorMsg(context, "No document selected");
        return;
      }
      document = _documentBytes; // Uint8List for web
      documentName = _pickedFileGlobalName!;
    } else {
      if (_documentFile == null) {
        Navigator.pop(context);
        showErrorMsg(context, "No document selected");
        return;
      }
      document = _documentFile; // File for mobile
      documentName = path.basename(_documentFile!.path);
    }

    try {
      final response = await allLeaseService.createLease(
        startDate: formatDateTime(getCurrentDate()), // Using current date
        endDate: _endDateController.text.toString(),
        ammount: _amount,
        document: document,
        documentName: documentName,
        frequency: _frequency,
        tenant_id: _tenantController.text,
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        setState(() {
          widget.fetchLeases();
        });
        showSuccessMsg(context, "Lease Created Successfully");
      } else {
        Navigator.pop(context);
        showErrorMsg(context, "Lease Creation Unsuccessful: ${response.body}");
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorMsg(context, "An error occurred: ${e.toString()}");
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Create New Lease",
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
                          Text(
                            _amount.isEmpty
                                ? ''
                                : '($_frequency month/s) $_amount',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<AllTenantsModel>(
                            value: _selectedTenant,
                            onChanged: (AllTenantsModel? value) {
                              setState(() {
                                _selectedTenant = value;
                                _updateFrequencyAndAmount();
                              });
                            },
                            items: widget.tenants
                                .where((tenant) => tenant.status == 'Not-Paid')
                                .map((AllTenantsModel tenant) =>
                                DropdownMenuItem<AllTenantsModel>(
                                  value: tenant,
                                  child: Text(
                                      '${tenant.firstname} ${tenant.lastname}'),
                                ))
                                .toList(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Tenant',
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _frequencyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Frequency (months)',
                              hintText: 'Enter number of months',
                            ),
                            onChanged: (value) {
                              _updateFrequencyAndAmount();
                            },
                          ),
                        ),

                        const SizedBox(height: 18),

                        GestureDetector(
                          onTap: _pickDocument,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _pickedFileGlobalName != null && _pickedFileGlobalName!.isNotEmpty
                                ? Row(
                              children: [
                                const Center(child: Icon(Icons.folder, size: 50, color: Colors.blue)),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    _pickedFileGlobalName!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                                : const Center(
                              child: Text(
                                "Choose File",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),


                        // GestureDetector(
                        //   onTap: _pickDocument,
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     padding: EdgeInsets.all(20),
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.grey.shade400),
                        //       borderRadius: BorderRadius.circular(10)
                        //     ),
                        //     child: _pickedFileGlobalName == ''
                        //         ?
                        //         Row(
                        //           children: [
                        //             const Center(child: Icon(Icons.folder, size: 50, color: Colors.blue,)),
                        //
                        //             const SizedBox(width: 5,),
                        //
                        //             Text(
                        //               _pickedFileGlobalName!,
                        //             ),
                        //           ],
                        //         )
                        //         :
                        //         const Center(child: Text("Choose File", textAlign: TextAlign.center,))
                        //     ,
                        //   ),
                        // ),

                        const SizedBox(height: 90),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonDialogBox(
                              title: 'Cancel',
                              color: Colors.grey.shade400,
                              onPressFunction: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 10),
                            ButtonDialogBox(
                              title: 'Save',
                              color: Colors.pink.shade400,
                              onPressFunction: _createNewLease,
                            ),
                          ],
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
  }

  Widget _buildTextField(
      BuildContext context,
      TextEditingController controller,
      String label,
      double width,
      {bool obscureText = false, Function(String)? onChanged}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
        ),
      ),
    );
  }
}
