import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/all_properties_services.dart';
import 'package:flutter_real_estate/API_services/all_tenants_service.dart';
import 'package:flutter_real_estate/API_services/all_unity_services.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/models/all_tenants_model.dart';
import 'package:flutter_real_estate/models/all_units_model.dart';

import '../API_services/all_collection_services.dart';
import '../components/button_form_dialogbox.dart';
import '../components/notification.dart';
import '../models/all_collection_model.dart';
import '../models/all_property_model.dart';

class CollectionFragment extends StatefulWidget {
  CollectionFragment({super.key});

  @override
  State<CollectionFragment> createState() => _CollectionFragmentState();
}

class _CollectionFragmentState extends State<CollectionFragment> {
  bool isLoading = true;
  
  List<AllCollectionModel> collections = [];
  List<AllPropertyModel> properties = [];
  List<AllUnityModel> unities = [];
  List<AllCollectionModel> filteredCollections = [];
  List<AllTenantsModel> tenants = [];
  
  AllPropertyModel? _selectedProperty;
  AllPropertyModel? _myselectedProperty;
  AllUnityModel? _selectedUnity;

  final AllCollectionService allCollectionService = AllCollectionService();
  final AllPropertyService allPropertyService = AllPropertyService();
  final AllUnityServices allUnityServices = AllUnityServices();
  final AllTenantsService allTenantsService = AllTenantsService();

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchCollections();
    searchController.addListener(_filterCollections);
  }

  Future<void> _fetchCollections() async {
    try {
      List<AllUnityModel> allUnities = await allUnityServices.getAllUnities();
      List<AllTenantsModel> allTenants = await allTenantsService.getAllTenants();
      List<AllPropertyModel> allProperties = await allPropertyService.getAllProperties();
      List<AllCollectionModel> allCollections = await allCollectionService.getAllCollection();
      setState(() {
        unities = allUnities;
        properties = allProperties;
        collections = allCollections;
        filteredCollections = allCollections;
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


  void _filterCollections() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredCollections = collections;  // Show all users if the search field is empty
      } else {
        final query = searchController.text.toLowerCase();
        filteredCollections = collections.where((col) {
          return col.subject.toLowerCase().contains(query) ||
              col.type.toLowerCase().contains(query) ||
              col.description.toLowerCase().contains(query) ||
              col.ammount.toLowerCase().contains(query) ||
              col.status.toLowerCase().contains(query) ||
              displayPropertyName(col.property_id).toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  String displayPropertyName(int collectionId){
    for(var prop in properties){
      if(prop.id == collectionId){
        return prop.name;
      }
    }
    return 'Error return PropertyName';
  }

  String displayUnitName(int collectionId){
    for(var unit in unities){
      if(unit.id == collectionId){
        return unit.name;
      }
    }
    return 'Error return UnityName';
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


  String stringLimit(String text, int limit) {
    if (text.length <= limit) {
      return text;
    } else {
      return "${text.substring(0, limit)}...";
    }
  }



  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => MyCreateNewDialog(properties: properties, fetchCollections: _fetchCollections,),
    );
  }



  Future<void> _deleteCollection(int collectionId) async {
    isLoadingState();
    final response = await allCollectionService.deleteCollection(collectionId);

    if(response.statusCode == 200){
      setState(() {
        collections.removeWhere((collection) => collection.id == collectionId);
        _fetchCollections();
        Navigator.pop(context);
      });
      showSuccessMsg(context, "Collection Deleted Successfully");
    }else{
      Navigator.pop(context);
      showErrorMsg(context, "Collection Delete Unsuccessfully");
    }
  }



  void viewCollectionData(int collectionId) {
    for(var myCollection in collections) {
      if(myCollection.id == collectionId) {
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
                          const Text("View Collection", style: TextStyle(fontWeight: FontWeight.bold)),

                          Badge(
                            backgroundColor:  myCollection.status == 'Paid' ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
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
                                      myCollection.status,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.5
                                        // color: myUnity.status == 'taken' ? CupertinoColors.activeGreen : (myUnity.status == 'pending' ? CupertinoColors.systemYellow : CupertinoColors.destructiveRed),
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
                            // showContentDialog(columnName: "Unit Name", content: myUnity.name),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "PropertyName", content: displayPropertyName(myCollection.property_id)),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            showContentDialog(columnName: "Type", content: myCollection.type),
                            // const SizedBox(height: 15),
                            if(myCollection.type == 'Lease')
                              showContentDialog(columnName: "Subject", content: 'Unit-${myCollection.subject}')
                            else
                              showContentDialog(columnName: "Subject", content: myCollection.subject),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            showContentDialog(columnName: "Amount", content: 'Tzs ${myCollection.formatPrice}'),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "Description", content: myCollection.description),
                          ],
                        ),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Created Time", content: "${myCollection.formattedDate} (${myCollection.timeAgo})"),

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




  void showUpdateCollection(int collectionId) async {
    for(var myCollection in collections){
      if(myCollection.id == collectionId){
        showDialog(
            context: context,
            builder: (context) {

              final TextEditingController _updateTypeController = TextEditingController(text: myCollection.type);
              final TextEditingController _updateSubjectController = TextEditingController(text: myCollection.subject);
              final TextEditingController _updateAmmountController = TextEditingController(text: myCollection.ammount);
              final TextEditingController _updateDescriptionController = TextEditingController(text: myCollection.description);
              final TextEditingController _updateStatusController = TextEditingController(text: myCollection.status);

              _myselectedProperty = properties.firstWhere((prop) => prop.id == myCollection.property_id);

              return AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 5,
                  title: const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update Collection", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Divider(),
                      ],
                    ),
                  ),
                  content: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45, // Adjust width here
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          _buildPropertyDropdown(),

                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: _updateSubjectController,
                              decoration: const InputDecoration(
                                labelText: 'Subject',
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _updateTypeController.text,  // Set initial value from the controller
                              items: ["Lease", "Maintenance"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _updateTypeController.text = newValue ?? "";  // Update the controller's text with the new value
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Type',  // Optionally add a label
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: _updateAmmountController,
                              decoration: const InputDecoration(
                                labelText: 'Amount (Tzs)',
                                border: InputBorder.none,
                              ),
                            ),
                          ),


                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _updateStatusController.text,  // Set initial value from the controller
                              items: ["Paid", "Not-Paid"]
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _updateStatusController.text = newValue ?? "";  // Update the controller's text with the new value
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Status',  // Optionally add a label
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: _updateDescriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Description',
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
                      onPressFunction: () => _updateCollection(
                          myCollection.id,
                          _myselectedProperty!.id.toString(),
                          _updateSubjectController.text,
                          _updateTypeController.text,
                          _updateAmmountController.text,
                          _updateStatusController.text,
                          _updateDescriptionController.text
                      ),
                    ),
                  ]
              );
            }
        );
      }
    }
  }




  // Property Dropdown
  Widget _buildPropertyDropdown() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<AllPropertyModel>(
        value: _myselectedProperty,
        onChanged: (value) {
          setState(() {
            _myselectedProperty == value;
          });
        },
        items: properties.map((AllPropertyModel prop) => DropdownMenuItem<AllPropertyModel>(
          value: prop,
          child: Text('${prop.name} (${prop.type})'),
        )).toList(),
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: 'Property',
        ),
      ),
    );
  }

  Future<void> _updateCollection(int id, String propertyId, String subject, String type, String ammount, String status, String description) async {
    isLoadingState();
    if(
        propertyId.isEmpty ||
        subject.isEmpty ||
        type.isEmpty ||
        ammount.isEmpty ||
        status.isEmpty ||
        description.isEmpty
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await allCollectionService.updateCollectionData({
        'id': id,
        'property_id': propertyId,
        'subject': subject,
        'type': type,
        'ammount': ammount,
        'description': description,
        'status': status
      });

      if(response.statusCode == 200){
        _fetchCollections();
        Navigator.pop(context);
        Navigator.pop(context);
        showSuccessMsg(context, 'Collection Updated Successfully');
      }else{
        Navigator.pop(context);
        Navigator.pop(context);
        showErrorMsg(context, "Collection Updated Unsuccessfully");
      }
    }
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
            const Center(child: CircularProgressIndicator(),)
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

                      // Text
                      const Text(
                        "Collections",
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

                  MyNewPinkButton(width: 200, title: "+ New Collection", onPressFunction: _showDialog),
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
                    DataColumn(label: Text("#", style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Property Name", style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Type", style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Description", style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],
                  rows: filteredCollections.isEmpty
                      ? [
                    const DataRow(
                      cells: [
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('Empty Collections Data', style: TextStyle(color: CupertinoColors.destructiveRed),)),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                      ],
                    ),
                  ]
                      : List<DataRow>.generate(
                    filteredCollections.length,
                        (index) {
                      final myCollection = filteredCollections[index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),  // Index starts from 1
                          DataCell(Text(displayPropertyName(myCollection.property_id), overflow: TextOverflow.ellipsis,)),
                          if(myCollection.type == 'Lease')
                            DataCell(Text('${myCollection.type} (Unit-${myCollection.subject})'))
                          else
                            DataCell(Text('${myCollection.type} (${myCollection.subject})')),
                          DataCell(Text(stringLimit(myCollection.description, 15))),
                          DataCell(Text('Tzs ${myCollection.formatPrice}')),
                          if(myCollection.status == 'Paid')
                            DataCell(Text(myCollection.status, style: const TextStyle(color: CupertinoColors.activeGreen),))
                          else
                            DataCell(Text(myCollection.status, style: const TextStyle(color: CupertinoColors.destructiveRed),)),
                          DataCell(Text(myCollection.timeAgo, overflow: TextOverflow.ellipsis,)),
                          DataCell(Row(
                            children: [
                              // view btn
                              IconButton(
                                onPressed: () => viewCollectionData(myCollection.id),
                                icon: const Icon(Icons.remove_red_eye),
                                color: CupertinoColors.systemBlue,
                              ),

                              // update btn
                              IconButton(
                                onPressed: () => showUpdateCollection(myCollection.id),
                                icon: const Icon(Icons.mode_edit_outline),
                                color: CupertinoColors.systemGreen,
                              ),

                              // delete btn
                              IconButton(
                                onPressed: () => _deleteCollection(myCollection.id),
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                              ),
                            ],
                          )),
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
    );
  }
}







class MyCreateNewDialog extends StatefulWidget {
  final List<AllPropertyModel> properties;
  final VoidCallback fetchCollections;

  MyCreateNewDialog({super.key, required this.properties, required this.fetchCollections});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _propertyIdController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _ammountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  String? selectStatus;
  String? _selectedType;

  AllPropertyModel? _selectedProperty;
  AllUnityServices allUnityServices = AllUnityServices();
  AllCollectionService allCollectionService = AllCollectionService();

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


  Future<void> _createNewUnity() async {
    isLoadingState();
    if(
        _selectedType == null ||
        _subjectController.text.isEmpty ||
        _ammountController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        selectStatus == null ||
        _selectedProperty == null
    ){

      print('status: ${_statusController.text}');
      print('type: ${_typeController.text}');

      Navigator.pop(context);
      showErrorMsg(context, "All fields are Required");
    }else{
      _propertyIdController.text = _selectedProperty!.id.toString();
      _statusController.text = selectStatus.toString();
      _typeController.text = _selectedType.toString();

      print('status: ${_statusController.text}');
      print('type: ${_typeController.text}');

      final response = await allCollectionService.createCollection({
        'type': _typeController.text.toString(),
        'property_id': _propertyIdController.text.toString(),
        'subject': _subjectController.text.toString(),
        'ammount': _ammountController.text.toString(),
        'description': _descriptionController.text.toString(),
        'status': _statusController.text.toString(),
      });

      if(response.statusCode == 200){
        setState(() {
          widget.fetchCollections();
        });
        Navigator.pop(context);
        Navigator.pop(context);
        showSuccessMsg(context, "Collections Created Successfully");
      }else{
        Navigator.pop(context);
        showErrorMsg(context, "Collections Created Unsuccessfully, ${response.body}");
      }
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
            height: MediaQuery.of(context).size.height * 0.83,
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
                            "Create New Collection",
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

                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonFormField<AllPropertyModel>(
                            value: _selectedProperty,
                            onChanged: (AllPropertyModel? value) {
                              setState(() {
                                _selectedProperty = value!;
                              });
                            },
                            items: widget.properties
                                .map((AllPropertyModel myProp) => DropdownMenuItem<AllPropertyModel>(
                              value: myProp,
                              child: Text(myProp.name),
                            ))
                                .toList(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Property Name',
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [

                            _buildDropdownField(
                                context,
                                'Type',
                                MediaQuery.of(context).size.width * 0.31,
                                ['Lease', 'Maintenance'],
                                _selectedType
                            ),

                            _buildTextField(
                                context,
                                _subjectController,
                                'Subject',
                                MediaQuery.of(context).size.width * 0.31
                            ),

                          ],
                        ),

                        const SizedBox(height: 18),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [

                            _buildTextField(
                                context,
                                _ammountController,
                                'Ammount',
                                MediaQuery.of(context).size.width * 0.31
                            ),

                            _buildDropdownField(
                                context,
                                'Status',
                                MediaQuery.of(context).size.width * 0.31,
                                ['Paid', 'Not-Paid'],
                                selectStatus
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
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Description',
                              ),
                            ),
                          ),

                          ],
                        ),

                    const SizedBox(height: 50),

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
                              title: 'Save',
                              color: Colors.pink.shade400,
                              onPressFunction: _createNewUnity,
                            ),

                          ],
                        ),

                      ],
                    ),
                ),
            )
          );
        },
      ),
    );
  }



  Widget _buildDropdownField(BuildContext context,
      String label,
      double width,
      List<String> items,
      String? selectedItem,
    ) {
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
            selectedItem = newValue;
          });
          if (label == 'Type') {
            _selectedType = newValue;
          } else if (label == 'Status') {
            selectStatus = newValue;
          }
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



  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String labelText, double width, {bool obscureText = false}) {
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
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
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
    return Container(
      width: 340,
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
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
      ),
    );
  }
}