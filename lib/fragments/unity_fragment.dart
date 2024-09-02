import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/API_services/all_properties_services.dart';
import 'package:flutter_real_estate/API_services/all_unity_services.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/models/all_property_model.dart';
import 'package:flutter_real_estate/models/all_units_model.dart';
import 'package:get/get.dart';
import '../components/button_form_dialogbox.dart';
import '../components/notification.dart';


class UnityFragment extends StatefulWidget {
  const UnityFragment({super.key});

  @override
  State<UnityFragment> createState() => _UnityFragmentState();
}

class _UnityFragmentState extends State<UnityFragment> {
  bool isLoading = true;
  List<AllUnityModel> unities = [];
  List<AllPropertyModel> properties = [];

  final TextEditingController searchController = TextEditingController();
  final AllUnityServices allUnityServices = AllUnityServices();
  final AllPropertyService allPropertyService = AllPropertyService();

  @override
  void initState() {
    super.initState();
    _fetchUnities();
  }


  Future<void> _fetchUnities() async {
    // Show loading indicator
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return const Center(child: CircularProgressIndicator());
    //   },
    // );

    try {
      List<AllUnityModel> allUnities = await allUnityServices.getAllUnities();
      List<AllPropertyModel> allProperties = await allPropertyService.getAllProperties();
      setState(() {
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



  Future<void> _deleteUnity(int unityId) async {
    // Show loading indicator
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return const Center(child: CircularProgressIndicator());
    //   },
    // );

    final response = await allUnityServices.deleteUnity(unityId);

    if(response.statusCode == 200){
      setState(() {
        unities.removeWhere((unity) => unity.id == unityId);
        _fetchUnities();
        isLoading = false;
      });
      showSuccessMsg(context, "Unity Deleted Successfully");
    }else{
      isLoading = false;
      showErrorMsg(context, "Unity Delete Unsuccessfully");
    }
  }



  void viewUnityData(int unityId) {
    for(var myUnity in unities) {
      if(myUnity.id == unityId) {
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
                      Text("View Unity", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Divider(),
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
                            showContentDialog(columnName: "Unity Name", content: myUnity.name),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "Unity PropertyName", content: propertyName(myUnity.property_id)),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            showContentDialog(columnName: "Unity beds", content: myUnity.beds),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "Unity baths", content: myUnity.baths),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            showContentDialog(columnName: "Unity SQM", content: myUnity.sqm),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "Unity Price", content: 'Tzs ${myUnity.price}'),
                          ],
                        ),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Created Time", content: "${myUnity.formattedDate} (${myUnity.timeAgo})"),

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




  Future<void> showUpdateUnity(int unityId) async {
    for(var myUnity in unities){
      if(myUnity.id == unityId){
        showDialog(
            context: context,
            builder: (context) {

              final _updateNameController = TextEditingController(text: myUnity.name);
              final _updateBedsController = TextEditingController(text: myUnity.beds);
              final _updateBathsController = TextEditingController(text: myUnity.baths);
              final _updatePriceController = TextEditingController(text: myUnity.price);
              final _updateSqmController = TextEditingController(text: myUnity.sqm);

              return AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 5,
                  title: const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update Unity", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Divider(),
                      ],
                    ),
                  ),
                  content: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45, // Adjust width here
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.53,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: _updateNameController,
                              decoration: const InputDecoration(
                                labelText: 'Unity Name',
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
                              controller: _updateBedsController,
                              decoration: const InputDecoration(
                                labelText: 'Unity Beds',
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
                              controller: _updateBathsController,
                              decoration: const InputDecoration(
                                labelText: 'Unity Baths',
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
                              controller: _updateSqmController,
                              decoration: const InputDecoration(
                                labelText: 'Unity SQM',
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
                                labelText: 'Unity Price (Tzs)',
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
                      onPressFunction: () => _updateUnity(
                         unityId,
                        _updateNameController.text,
                        _updateBedsController.text,
                        _updateBathsController.text,
                        _updateSqmController.text,
                        _updatePriceController.text,
                      ),
                    ),
                  ]
              );
            }
        );
      }
    }
  }



  Future<void> _updateUnity(int id, String name, String beds, String baths, String sqm, String price) async {
    setState(() {
      const Center(
        child: CircularProgressIndicator(),
      );
    });

    if(
        name.isEmpty ||
        beds.isEmpty ||
        baths.isEmpty ||
        sqm.isEmpty ||
        price.isEmpty
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await allUnityServices.updateUnityData({
        'id': id,
        'unity_name': name,
        'unity_beds': beds,
        'unity_baths': baths,
        'sqm': sqm,
        'unity_price': price
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        _fetchUnities();
        showSuccessMsg(context, 'Unity Updated Successfully');
      }else{
        Navigator.pop(context);
        showErrorMsg(context, "Unity Updated Unsuccessfully");
      }
    }
  }


  String propertyName(int unityPropId){
    for(var prop in properties){
      if(prop.id == unityPropId){
        return prop.name;
      }
    }
    return 'Error return PropertyName';
  }



  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => MyCreateNewDialog(properties: properties, fetchUnities: _fetchUnities),
    );
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

                      // Text
                      const Text(
                        "Unity",
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
                      title: "+ New Unity",
                      onPressFunction: _showDialog,
                  ),

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
                      DataColumn(label: Text("#", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Unity", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Property Name", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("SQM", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Beds", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Baths", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Price", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Created_at", style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                    rows: [
                      if(unities.isNotEmpty)
                        for(var unity in unities)
                          DataRow(cells: [
                            DataCell(Text('${id++}')),
                            DataCell(Text(unity.name)),
                            DataCell(Text(propertyName(unity.property_id))),
                            DataCell(Text(unity.sqm)),
                            DataCell(Text(unity.beds)),
                            DataCell(Text(unity.baths)),
                            DataCell(Text('Tzs ${unity.formatPrice}')),
                            DataCell(Text(unity.timeAgo)),
                            DataCell(Row(
                              children: [
                                // view btn
                                IconButton(
                                  onPressed: () => viewUnityData(unity.id),
                                  icon: const Icon(Icons.remove_red_eye),
                                  color: CupertinoColors.systemBlue,
                                ),

                                // update btn
                                IconButton(
                                  onPressed: () => showUpdateUnity(unity.id),
                                  icon: const Icon(Icons.mode_edit_outline),
                                  color: CupertinoColors.systemGreen,
                                ),

                                // delete btn
                                IconButton(
                                  onPressed: () => _deleteUnity(unity.id),
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
                          DataCell(Center(child: Text('Empty Unity', style: TextStyle(color: Colors.red),))),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                        ]
                      )
                    ]
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
  final VoidCallback fetchUnities;

  MyCreateNewDialog({super.key, required this.properties, required this.fetchUnities});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _BedsController = TextEditingController();
  final TextEditingController _BathsController = TextEditingController();
  final TextEditingController _PriceController = TextEditingController();
  final TextEditingController _SqmController = TextEditingController();
  final TextEditingController _PropertyController = TextEditingController();

  AllPropertyModel? _selectedProperty;
  AllUnityServices allUnityServices = AllUnityServices();

  Future<void> _createNewUnity() async {
    if(
        _NameController.text.isEmpty ||
        _BedsController.text.isEmpty ||
        _BathsController.text.isEmpty ||
        _SqmController.text.isEmpty ||
        _PriceController.text.isEmpty ||
        _selectedProperty == null
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All fields are Required");
    }else{
      _PropertyController.text = _selectedProperty!.name.toString();

      final response = await allUnityServices.createUnity({
        'unity_name': _NameController.text.toString(),
        'unity_beds': _BedsController.text.toString(),
        'unity_baths': _BathsController.text.toString(),
        'sqm': _SqmController.text.toString(),
        'unity_price': _PriceController.text.toString(),
        'property_id': _PropertyController.text.toString(),
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        setState(() {
          widget.fetchUnities();
        });
        showSuccessMsg(context, "Unity Created Successfully");
      }else if(response.statusCode == 400){
        showErrorMsg(context, "Unity Name Already Taken, Use Another");
      }else{
        showErrorMsg(context, "Unity Created Unsuccessfully ${response.body}");
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
            height: MediaQuery.of(context).size.height * 0.68,
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
                            "Create New Unity",
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
                                _NameController,
                                'Unity Name',
                                MediaQuery.of(context).size.width * 0.31
                            ),

                            _buildTextField(
                                context,
                                _BedsController,
                                'Unity beds',
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
                                _BathsController,
                                'Unity Baths',
                                MediaQuery.of(context).size.width * 0.31
                            ),

                            _buildTextField(
                                context,
                                _PriceController,
                                'Unity Price',
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
                                _SqmController,
                                'Unity SQM',
                                MediaQuery.of(context).size.width * 0.31
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
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

                          ],
                        ),

                        const SizedBox(height: 90),

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
                  ],
                ),
              ),
            ),
          );
        },
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