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
import '../../../API_services/all_maintenance_services.dart';
import '../../../components/button_form_dialogbox.dart';
import '../../../models/all_maintenance_model.dart';

class UserMaintenanceFragment extends StatefulWidget {
  UserMaintenanceFragment({super.key});

  @override
  State<UserMaintenanceFragment> createState() => _UserMaintenanceFragmentState();
}

class _UserMaintenanceFragmentState extends State<UserMaintenanceFragment> {
  bool isLoading = true;
  List<AllTenantsModel> tenants = [];
  List<AllPropertyModel> properties = [];
  List<AllUnityModel> unities = [];
  List<AllMaintenanceModel> maintenances = [];

  AllPropertyModel? _selectedProperty;

  final AllTenantsService allTenantsService = AllTenantsService();
  final AllUnityServices allUnityServices = AllUnityServices();
  final AllPropertyService allPropertyService = AllPropertyService();
  final AllMaintenanceService allMaintenanceService = AllMaintenanceService();

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMaintenances();
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



  Future<void> _fetchMaintenances() async {
    try {
      List<AllUnityModel> allUnities = await allUnityServices.getAllUnities();
      List<AllPropertyModel> allProperties = await allPropertyService.getAllProperties();
      List<AllTenantsModel> allTenants = await allTenantsService.getAllTenants();
      List<AllMaintenanceModel> allMaintenances = await allMaintenanceService.getAllMaintenance();

      setState(() {
        unities = allUnities;
        properties = allProperties;
        tenants = allTenants;
        maintenances = allMaintenances;
        isLoading = false;
      });
    } catch (e) {
      showErrorMsg(context, "Error, $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  String displayPropertyName(int propertyId){
    for(var prop in properties){
      if(prop.id == propertyId){
        return prop.name;
      }
    }
    return '';
  }


  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => MyCreateNewDialog(
          maintenances: maintenances,
          fetchMaintenance: _fetchMaintenances,
          properties: properties
      ),
    );
  }


  void viewMaintenanceData(int maintenanceId) {
    for(var myMaintenance in maintenances) {
      if(myMaintenance.id == maintenanceId) {
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
                          const Text("View Maintenance", style: TextStyle(fontWeight: FontWeight.bold)),

                          Badge(
                            backgroundColor:  myMaintenance.status == 'Paid' ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
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
                                    myMaintenance.status,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.5
                                    ),
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
                            showContentDialog(columnName: "Property Name", content: displayPropertyName(myMaintenance.property_id)),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "Type", content: '${myMaintenance.subject} (${myMaintenance.item})'),
                          ],
                        ),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Price", content: myMaintenance.price),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Description", content: myMaintenance.description, width: 500,),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Created Time", content: "${myMaintenance.formattedDate} (${myMaintenance.timeAgo})"),

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


  Future<void> deleteMaintenance(int maintenanceId) async {
    isLoadingState();
    final response = await allMaintenanceService.deleteMaintenance(maintenanceId);
    if(response.statusCode == 200){
      setState(() {
        maintenances.removeWhere((maintenance) => maintenance.id == maintenanceId);
        _fetchMaintenances();
      });
      Navigator.pop(context);
      showSuccessMsg(context, "Maintenance Deleted Successfully");
    }else{
      Navigator.pop(context);
      showErrorMsg(context, "Maintenance Delete Unsuccessfully");
    }
  }



  void showUpdateMaintenance(int maintenanceId) {
    for(var myMaintenance in maintenances){
      if(myMaintenance.id == maintenanceId){
        showDialog(
            context: context,
            builder: (context) {

              final _updateItemController = TextEditingController(text: myMaintenance.item);
              final _updateSubjectController = TextEditingController(text: myMaintenance.subject);
              final _updateDescriptionController = TextEditingController(text: myMaintenance.description);
              final _updateStatusController = TextEditingController(text: myMaintenance.status);
              final _updatePriceController = TextEditingController(text: myMaintenance.price);

              _selectedProperty = properties.firstWhere((prop) => prop.id == myMaintenance.property_id);

              return AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 5,
                  title: const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update Maintenance", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Divider(),
                      ],
                    ),
                  ),
                  content: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45, // Adjust width here
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.99,),
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
                            child: TextField(
                              controller: _updateItemController,
                              decoration: const InputDecoration(
                                labelText: 'Item',
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
                            child: TextField(
                              controller: _updatePriceController,
                              decoration: const InputDecoration(
                                labelText: 'Price (Tzs)',
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
                                labelText: 'Unit Status',  // Optionally add a label
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
                      onPressFunction: () => _updateMaintenance(
                          myMaintenance.id,
                          _updateItemController.text,
                          _updateDescriptionController.text,
                          _updateSubjectController.text,
                          _selectedProperty!.id.toString(),
                          _updatePriceController.text,
                          _updateStatusController.text
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
        value: _selectedProperty,
        onChanged: (value) {
          setState(() {
            _selectedProperty == value;
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



  Future<void> _updateMaintenance(
      int id,
      String item,
      String description,
      String subject,
      String propertyId,
      String price,
      String status
      ) async {

    isLoadingState();

    if(
    item.isEmpty ||
        description.isEmpty ||
        subject.isEmpty ||
        propertyId.isEmpty ||
        price.isEmpty ||
        status.isEmpty
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await allMaintenanceService.updateMaintenance({
        'id': id,
        'property_id': propertyId,
        'item': item,
        'subject': subject,
        'description': description,
        'price': price,
        'status': status
      });

      if(response.statusCode == 200){
        _fetchMaintenances();
        Navigator.pop(context);
        Navigator.pop(context);
        showSuccessMsg(context, 'Maintenance Updated Successfully');
      }else{
        Navigator.pop(context);
        showErrorMsg(context, "Maintenance Updated Unsuccessfully");
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    double constaintWidth = MediaQuery.of(context).size.width;
    int id = 1;

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 30.0,
          ),
          child: isLoading
              ?
          const Center(child: CircularProgressIndicator(),)
              :
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                          "Maintenance",
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

                    LayoutBuilder(builder: (context, constraints){
                      if(constraints.maxWidth < 500){
                        return MyNewPinkButton(width: 200, title: '+', onPressFunction: _showDialog);
                      }else{
                        return MyNewPinkButton(width: 200, title: '+ New Maintenance', onPressFunction: _showDialog);
                      }
                    }),

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
                        DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold),)),
                      ],
                      rows: [
                        if(isLoading == false && maintenances.isNotEmpty)
                          for(var myMaintenance in maintenances)
                            DataRow(cells: [
                              DataCell(Text('${id++}')),
                              DataCell(Text(displayPropertyName(myMaintenance.property_id), overflow: TextOverflow.ellipsis,)),
                              DataCell(Text('${myMaintenance.item} (${myMaintenance.subject})')),
                              DataCell(Text(stringLimit(myMaintenance.description, 18))),
                              if(myMaintenance.status == 'Paid')
                                DataCell(Text(myMaintenance.status, style: const TextStyle(color: CupertinoColors.activeGreen),))
                              else
                                DataCell(Text(myMaintenance.status, style: const TextStyle(color: CupertinoColors.destructiveRed),)),
                              DataCell(Text(myMaintenance.timeAgo, overflow: TextOverflow.ellipsis,)),
                              DataCell(Row(
                                children: [

                                  // view btn
                                  IconButton(
                                    onPressed: () => viewMaintenanceData(myMaintenance.id),
                                    icon: const Icon(Icons.remove_red_eye),
                                    color: CupertinoColors.systemBlue,
                                  ),

                                  // update btn
                                  IconButton(
                                    onPressed: () => showUpdateMaintenance(myMaintenance.id),
                                    icon: const Icon(Icons.mode_edit_outline),
                                    color: CupertinoColors.systemGreen,
                                  ),

                                  // delete btn
                                  IconButton(
                                    onPressed: () => deleteMaintenance(myMaintenance.id),
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
                            DataCell(Text('Empty Maintenance Data', style: TextStyle(color: Colors.red),)),
                            DataCell(Text('')),
                            DataCell(Text('')),
                            DataCell(Text('')),
                          ])
                      ]
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}





class MyCreateNewDialog extends StatefulWidget {
  final List<AllMaintenanceModel> maintenances;
  final VoidCallback fetchMaintenance;
  final List<AllPropertyModel> properties;

  MyCreateNewDialog({super.key, required this.maintenances, required this.fetchMaintenance, required this.properties});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final TextEditingController _propertyIdController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _paymentStatusController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final AllMaintenanceService allMaintenanceService = AllMaintenanceService();
  AllPropertyModel? _selectedProperty;
  String? selectStatus;

  Future<void> _createNewMaintenance() async {
    isLoadingState();
    if(
    _itemController.text.isEmpty ||
        selectStatus.toString().isEmpty ||
        _subjectController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedProperty == null
    ){
      Navigator.pop(context);
      Navigator.pop(context);
      showErrorMsg(context, "All fields are Required");
    }else{
      _propertyIdController.text = _selectedProperty!.id.toString();
      _paymentStatusController.text = selectStatus.toString();

      final response = await allMaintenanceService.createMaintenance({
        'property_id': _propertyIdController.text.toString(),
        'item': _itemController.text.toString(),
        'price': _priceController.text.toString(),
        'status': _paymentStatusController.text.toString(),
        'subject': _subjectController.text.toString(),
        'description': _descriptionController.text.toString()
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        Navigator.pop(context);
        setState(() {
          widget.fetchMaintenance();
        });
        showSuccessMsg(context, "Maintenance Created Successfully");
      }else{
        Navigator.pop(context);
        showErrorMsg(context, "Maintenance Created Unsuccessfully");
      }
    }
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



  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 200),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.78,
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
                            "Create New Maintenance",
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
                                .map((AllPropertyModel prop) => DropdownMenuItem<AllPropertyModel>(
                              value: prop,
                              child: Text(prop.name),
                            ))
                                .toList(),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Property',
                            ),
                          ),
                        ),

                        const SizedBox(height: 18,),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            _buildTextField(
                                context,
                                _subjectController,
                                'Subject',
                                MediaQuery.of(context).size.width / 3.14
                            ),
                            _buildTextField(
                                context,
                                _itemController,
                                'Item',
                                MediaQuery.of(context).size.width / 3.14
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
                                _priceController,
                                'Price',
                                MediaQuery.of(context).size.width / 3.14
                            ),

                            _buildDropdownField(
                                context,
                                'Payment Status',
                                MediaQuery.of(context).size.width / 3.14,
                                ['Paid','Not-Paid'],
                                selectStatus
                            ),

                          ],
                        ),

                        const SizedBox(height: 18),

                        _buildTextField(
                            context,
                            _descriptionController,
                            'Description',
                            MediaQuery.of(context).size.width,
                            height: 80
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
                              title: 'Save',
                              color: Colors.pink.shade400,
                              onPressFunction: _createNewMaintenance,
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
            selectStatus = newValue; // Update selectedPropertyType here
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


  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String labelText, double width, {bool obscureText = false, double? height = 50}) {
    return Container(
      width: width,
      height: height,
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
  final double? width;

  const showContentDialog({
    super.key,
    required this.columnName,
    required this.content,
    this.width = 340
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
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
