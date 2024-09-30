import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/API_services/all_unity_services.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/fragments/role_fragment.dart';
import 'package:flutter_real_estate/models/all_units_model.dart';
import '../API_services/all_properties_services.dart';
import '../components/button_form_dialogbox.dart';
import '../components/notification.dart';
import '../models/all_property_model.dart';

class PropertyFragment extends StatefulWidget {
  PropertyFragment({super.key});

  @override
  State<PropertyFragment> createState() => _PropertyFragmentState();
}

class _PropertyFragmentState extends State<PropertyFragment> {
  bool isLoading = true;
  List<AllPropertyModel> properties = [];
  List<AllUnityModel> unities = [];
  List<AllPropertyModel> filteredProperty = [];
  String? selectedPropertyType;

  final AllPropertyService allPropertyService = AllPropertyService();
  final AllUnityServices allUnityServices = AllUnityServices();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchProperties();
    searchController.addListener(_filterProperty);
  }


  void _filterProperty() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredProperty = properties;
      } else {
        final query = searchController.text.toLowerCase();
        filteredProperty = properties.where((prop) {
          return prop.name.toLowerCase().contains(query.toLowerCase()) ||
              prop.type.toLowerCase().contains(query.toLowerCase()) ||
              prop.address.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }


  Future<void> _fetchProperties() async {
    try {
      List<AllPropertyModel> allProperty = await allPropertyService.getAllProperties();
      List<AllUnityModel> allUnities = await allUnityServices.getAllUnities();
      setState(() {
        properties = allProperty;
        filteredProperty = allProperty;
        unities = allUnities;
        isLoading = false;
      });
    } catch (e) {
      showErrorMsg(context, "Error, $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  void _viewProperty(int propertyId) {
    for(var myProp in properties) {
      if(myProp.id == propertyId) {
        // Show dialog with role details
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("View Property", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Divider(),
                    ],
                  ),
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.5, // Adjust width here
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7,),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        showContentDialog(columnName: "Property Name", content: myProp.name),
                        const SizedBox(height: 15),
                        showContentDialog(columnName: "Property Address", content: myProp.address),
                        const SizedBox(height: 15),
                        showContentDialog(columnName: "Property Type", content: myProp.type),
                        const SizedBox(height: 15),
                        showContentDialog(columnName: "Total Unity", content: countPropertyUnits(myProp.id).toString()),
                        const SizedBox(height: 15),
                        showContentDialog(columnName: "Created Time", content: "${myProp.formattedDate} (${myProp.timeAgo})"),
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


  Future<void> showUpdateProperty(int propertyId) async {
    for (var myProp in properties) {
      if (myProp.id == propertyId) {
        showDialog(
          context: context,
          builder: (context) {

            final TextEditingController _updateNameController = TextEditingController(text: myProp.name);
            final TextEditingController _updateAddressController = TextEditingController(text: myProp.address);

            selectedPropertyType = myProp.type;

            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 5,
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Update Property", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Divider(),
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.38,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: 630,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _updateNameController,
                          decoration: const InputDecoration(
                            labelText: 'Property Name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),


                      const SizedBox(height: 15),

                      _buildDropdownField(
                          context,
                          "Property Type",
                          630,
                          ['Business', 'Residential','Both'],
                          selectedPropertyType
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: 630,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _updateAddressController,
                          decoration: const InputDecoration(
                            labelText: 'Property Address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              actions: [
                ButtonDialogBox(title: "Cancel", color: Colors.grey, onPressFunction: () => Navigator.pop(context)),
                ButtonDialogBox(
                  title: "Update",
                  color: Colors.pink.shade400,
                  onPressFunction: () => _updateProperty(
                    myProp.id,
                    _updateNameController.text.toString(),
                    _updateAddressController.text.toString(),
                    selectedPropertyType.toString()
                  ),
                ),
              ],
            );
          },
        );
        break;
      }
    }
  }


  void isLoadingState(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white,),
        )
    );
  }


  Future<void> _updateProperty(
      int id, String name, String address, String type
      ) async {

    isLoadingState();

    if(
        id.isNaN ||
        name.isEmpty ||
        address.isEmpty ||
        type.isEmpty
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await allPropertyService.updatePropertyData({
        'id': id.toString(),
        'property_name': name.toString(),
        'property_address': address.toString(),
        'property_type': type.toString()
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        Navigator.pop(context);
        _fetchProperties();
        showSuccessMsg(context, 'Property Updated Successfully');
      }else{
        Navigator.pop(context);
        Navigator.pop(context);
        showErrorMsg(context, "Property Updated Unsuccessfully");
      }
    }
  }



  Future<void> _deleteProperty(int propertyId) async {
   isLoadingState();
    final response = await allPropertyService.deleteProperty(propertyId);

    if(response.statusCode == 200){
      setState(() {
        properties.removeWhere((property) => property.id == propertyId);
        _fetchProperties();
        Navigator.pop(context);
      });
      showSuccessMsg(context, "Property Deleted Successfully");
    }else{
      Navigator.pop(context);
      showErrorMsg(context, "Property Delete Unsuccessfully");
    }
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => MyCreateNewDialog(fetchProperty: _fetchProperties,),
    );
  }



  int countPropertyUnits(int propertyId){
    List<AllUnityModel> propertyUnits = unities.where((unity) => unity.property_id == propertyId).toList();
    return propertyUnits.length;
  }

  @override
  Widget build(BuildContext context) {
    int id = 1;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 30.0,
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
                        "Property",
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
                  MyNewPinkButton(
                    width: 200,
                    title: "+ New Property",
                    onPressFunction: _showDialog,
                  ),
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

                      const SizedBox(height: 20),

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

                      const SizedBox(height: 20),

                      // Table
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
                              DataColumn(
                                label: Text(
                                  "#",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Property Name",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Property Type",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Property Address",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Total Unity",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Created_at",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  "Actions",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: filteredProperty.isEmpty
                                ? [
                              const DataRow(
                                cells: [
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell(
                                    Center(
                                      child: Text(
                                        'Empty Property Data',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell.empty,
                                  DataCell.empty,
                                  DataCell.empty,
                                ],
                              ),
                            ]
                                : List<DataRow>.generate(
                              filteredProperty.length,
                                  (index) {
                                final prop = filteredProperty[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(Text(prop.name)),
                                    DataCell(Text(prop.type)),
                                    DataCell(Text(prop.address)),
                                    DataCell(Text('${countPropertyUnits(prop.id)}')),
                                    DataCell(Text(prop.timeAgo)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => _viewProperty(prop.id),
                                            icon: const Icon(Icons.remove_red_eye),
                                            color: CupertinoColors.systemBlue,
                                          ),
                                          IconButton(
                                            onPressed: () => showUpdateProperty(prop.id),
                                            icon: const Icon(Icons.mode_edit_outline),
                                            color: CupertinoColors.systemGreen,
                                          ),
                                          IconButton(
                                            onPressed: () => _deleteProperty(prop.id),
                                            icon: const Icon(Icons.delete),
                                            color: Colors.redAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

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



  // Helper method to build dropdown fields
  Widget _buildDropdownField(BuildContext context,
      String label,
      double width,
      List<String> items,
      String? selectedItem,) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.23),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        value: selectedItem,
        onChanged: (String? newValue) {
          setState(() {
            selectedPropertyType = newValue; // Update selectedPropertyType here
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}





class MyCreateNewDialog extends StatefulWidget {
  final VoidCallback fetchProperty;

  MyCreateNewDialog({super.key, required this.fetchProperty});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final AllPropertyService allPropertyService = AllPropertyService();
  String? selectedPropertyType;

  // List to store the unit controllers
  List<Map<String, TextEditingController>> _units = [];

  @override
  void initState() {
    super.initState();
    // Initialize with one default unit row
    _addUnit();
  }

  // Function to add a new unit row
  void _addUnit() {
    setState(() {
      _units.add({
        'unit_name': TextEditingController(),
        'unit_price': TextEditingController(),
        'unit_beds': TextEditingController(),
        'unit_baths': TextEditingController(),
        'unit_sqm': TextEditingController(),
      });
    });
  }

  // Function to remove a unit row
  void _removeUnit(int index) {
    if (_units.length > 1) {
      setState(() {
        _units.removeAt(index);
      });
    }
  }


  Future<void> _createNewProperty() async {
    setState(() {
      const Center(
        child: CircularProgressIndicator(),
      );
    });

    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        selectedPropertyType == null) {
      Navigator.pop(context);
      showErrorMsg(context, "All fields are Required");
    } else {
      _typeController.text = selectedPropertyType!.toString();

      // Prepare the units data
      final List<Map<String, String>> unitData = _units.map((unit) {
        return {
          'unit_name': unit['unit_name']!.text,
          'unit_price': unit['unit_price']!.text,
          'unit_beds': unit['unit_beds']!.text,
          'unit_baths': unit['unit_baths']!.text,
          'unit_sqm': unit['unit_sqm']!.text,
        };
      }).toList();

      final response = await allPropertyService.createProperty({
        'property_name': _nameController.text.toString(),
        'property_type': _typeController.text.toString(),
        'property_address': _addressController.text.toString(),
        'units': unitData, // Sending the unit data array
      });

      if (response.statusCode == 200) {
        Navigator.pop(context);
        setState(() {
          widget.fetchProperty();
        });
        showSuccessMsg(context, "Property and Units Created Successfully");
      } else {
        showErrorMsg(context, "Property and Units Created Unsuccessfully");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 170),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.9,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Create New Property",
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

                        const SizedBox(height: 18),

                        _buildTextField(
                            context,
                            _nameController,
                            'Property Name',
                            MediaQuery
                                .of(context)
                                .size
                                .width
                        ),

                        const SizedBox(height: 18),

                        _buildDropdownField(
                            context,
                            "Property Type",
                            MediaQuery
                                .of(context)
                                .size
                                .width,
                            ['Business', 'Residential', 'Both'],
                            selectedPropertyType
                        ),

                        const SizedBox(height: 18),

                        _buildTextField(
                            context,
                            _addressController,
                            'Property Address',
                            MediaQuery
                                .of(context)
                                .size
                                .width
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Add Units",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Render each unit row
                        ..._units
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          Map<String, TextEditingController> unit = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: [

                                _buildTextField(
                                    context,
                                    unit['unit_name']!,
                                    'Unit Name',
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.12
                                ),

                                _buildTextField(
                                    context,
                                    unit['unit_price']!,
                                    'Unit Price',
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.12
                                ),

                                _buildTextField(
                                    context,
                                    unit['unit_beds']!,
                                    'Unit Beds',
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.12
                                ),

                                _buildTextField(
                                    context,
                                    unit['unit_baths']!,
                                    'Unit Baths',
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.12
                                ),

                                _buildTextField(
                                    context,
                                    unit['unit_sqm']!,
                                    'SQM',
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.12
                                ),

                                // Show the remove button for rows except the first one
                                if (index != 0)
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      _removeUnit(index);
                                    },
                                  ),

                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 10),

                        // Add Unit + button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            GestureDetector(
                              onTap: _addUnit,
                              child: const Text(
                                "Add Unit +",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 50),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            ButtonDialogBox(title: "Cancel",
                                color: Colors.grey,
                                onPressFunction: () => Navigator.pop(context)),

                            const SizedBox(width: 20),

                            ButtonDialogBox(title: "Save",
                                color: Colors.pink.shade400,
                                onPressFunction: _createNewProperty),

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


  // Helper method to build text fields
  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String label, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.23),
          borderRadius: BorderRadius.circular(14)
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }


// Helper method to build dropdown fields
  Widget _buildDropdownField(BuildContext context,
      String label,
      double width,
      List<String> items,
      String? selectedItem,) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.23),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        value: selectedItem,
        onChanged: (String? newValue) {
          setState(() {
            selectedPropertyType = newValue; // Update selectedPropertyType here
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
