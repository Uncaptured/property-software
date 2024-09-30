import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/API_services/all_admin_services.dart';
import 'package:flutter_real_estate/API_services/all_roles_services.dart';
import 'package:flutter_real_estate/components/button_form_dialogbox.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/models/all_admins_model.dart';
import 'package:flutter_real_estate/models/roles_model.dart';

class AdminFragment extends StatefulWidget {
  AdminFragment({super.key});

  @override
  State<AdminFragment> createState() => _AdminFragmentState();
}

class _AdminFragmentState extends State<AdminFragment> {
  List<AllAdminsModel> admins = [];
  bool isLoading = true;
  List<AllAdminsModel> filteredAdmin = [];

  final TextEditingController searchController = TextEditingController();
  final AllAdminsService allAdminsService = AllAdminsService();

  @override
  void initState() {
    super.initState();
    _fetchAdmins();
    searchController.addListener(_filterAdmins);  // Listen for changes in the search box
  }

  Future<void> _fetchAdmins() async {
    try {
      List<AllAdminsModel> fetchedAdmins = await allAdminsService.getAllAdmins();
      setState(() {
        admins = fetchedAdmins;
        filteredAdmin = fetchedAdmins;
        isLoading = false;
      });
    } catch (e) {
      showErrorMsg(context, "Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // void _filterRoles(String query) {
  //   setState(() {
  //     filteredRoles = roles.where((role) {
  //       return role.name.toLowerCase().contains(query.toLowerCase()) ||
  //           role.description.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   });
  // }


  void _filterAdmins() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredAdmin = admins;
      } else {
        final query = searchController.text.toLowerCase();
        filteredAdmin = admins.where((admin) {
          return admin.firstname.toLowerCase().contains(query.toLowerCase()) ||
                 admin.lastname.toLowerCase().contains(query.toLowerCase()) ||
                 admin.email.toLowerCase().contains(query.toLowerCase()) ||
                 admin.phone.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void isLoadingState(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator(color: Colors.white,));
      },
    );
  }


  Future<void> deleteAdmin(int adminId) async {
    isLoadingState();

    final response = await allAdminsService.deleteAdmin(adminId);

    if(response.statusCode == 200){
      setState(() {
        admins.removeWhere((admin) => admin.id == adminId);
        _fetchAdmins();
      });
      Navigator.pop(context);
      showSuccessMsg(context, "Admin Deleted Successfully");
    }else{
      Navigator.pop(context);
      showErrorMsg(context, "Admin Deleted Unsuccessfully");
    }
  }



  Future<void> showAdmin(int adminId) async {
    for(var myAdmin in admins) {
      if(myAdmin.id == adminId) {
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
                      Text("View Admin", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Divider(),
                    ],
                  ),
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.45, // Adjust width here
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showContentDialog(columnName: "First Name", content: myAdmin.firstname),
                      const SizedBox(height: 17),
                      showContentDialog(columnName: "Last Name", content: myAdmin.lastname),
                      const SizedBox(height: 17),
                        showContentDialog(columnName: "Email Address", content: myAdmin.email),
                      const SizedBox(height: 17),
                      showContentDialog(columnName: "Phone", content: myAdmin.phone),
                      const SizedBox(height: 17),
                      showContentDialog(columnName: "Created Time", content: "${myAdmin.formattedDate} (${myAdmin.timeAgo})"),
                      const SizedBox(height: 20),
                    ],
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



  Future<void> showUpdateAdmin(int adminId) async {
    for(var myAdmin in admins){
      if(myAdmin.id == adminId){
        showDialog(
            context: context,
            builder: (context) {

              final _updateFNameController = TextEditingController(text: myAdmin.firstname);
              final _updateLNameController = TextEditingController(text: myAdmin.lastname);
              final _updateEmailController = TextEditingController(text: myAdmin.email);
              final _updatePhoneController = TextEditingController(text: myAdmin.phone);

              return AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 5,
                  title: const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update Admin", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Divider(),
                      ],
                    ),
                  ),
                  content: Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45, // Adjust width here
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45,),
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
                              controller: _updateFNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
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
                              controller: _updateLNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
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
                              controller: _updateEmailController,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
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
                              controller: _updatePhoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),
                        ],
                      ),

                    ),
                  ),
                  actions: [
                    ButtonDialogBox(title: "Cancel", color: Colors.grey, onPressFunction: () => Navigator.pop(context)),
                    ButtonDialogBox(
                      title: "Update",
                      color: Colors.pink.shade400,
                      onPressFunction: () => _updateAdmin(
                          myAdmin.id,
                          _updateFNameController.text,
                          _updateLNameController.text,
                          _updateEmailController.text,
                          _updatePhoneController.text
                      ),
                    ),
                  ]
              );
            }
        );
      }
    }
  }


  Future<void> _updateAdmin(int id, String fname, String lname, String email, String phone) async {
    isLoadingState();
    if(
        id.isNaN ||
        fname.isEmpty ||
        lname.isEmpty ||
        email.isEmpty ||
        phone.isEmpty
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await allAdminsService.updateAdminData({
        'id': id,
        'firstname': fname,
        'lastname': lname,
        'email': email,
        'phone': phone
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        Navigator.pop(context);
        _fetchAdmins();
        showSuccessMsg(context, 'Admin Updated Successfully');
      }else{
        Navigator.pop(context);
        Navigator.pop(context);
        showErrorMsg(context, "Admin Updated Unsuccessfully");
      }
    }
  }

  void _showDialogRole(){
    showDialog(
        context: context,
        builder: (context) => MyCreateNewDialog(fetchAdmins: _fetchAdmins)
    );
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
                       Row(
                         children: [

                           const Text(
                            "Admins ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                           ),

                           Text(
                             " (${admins.length}+you)",
                             style: TextStyle(
                               color: Colors.grey.shade600,
                               fontSize: 14,
                             ),
                           ),

                         ],
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
                    title: "+ New Admin",
                    onPressFunction: _showDialogRole,
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

            // Table + LOOP
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
                    DataColumn(label: Text("First Name", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Email Address", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Created At", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: filteredAdmin.isEmpty
                      ? [
                    const DataRow(
                      cells: [
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(
                          Center(
                            child: Text(
                              'Empty Admins Data',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text('')),
                        DataCell(Text('')),
                        DataCell(Text('')),
                      ],
                    ),
                  ]
                      : List<DataRow>.generate(
                    filteredAdmin.length,
                        (index) {
                      final admin = filteredAdmin[index];
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(admin.firstname)),
                          DataCell(Text(admin.lastname)),
                          DataCell(Text(admin.email)),
                          DataCell(Text(admin.phone)),
                          DataCell(Text(admin.timeAgo)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => showAdmin(admin.id),
                                  icon: const Icon(Icons.remove_red_eye),
                                  color: CupertinoColors.systemBlue,
                                ),
                                IconButton(
                                  onPressed: () => showUpdateAdmin(admin.id),
                                  icon: const Icon(Icons.mode_edit_outline),
                                  color: CupertinoColors.systemGreen,
                                ),
                                IconButton(
                                  onPressed: () => deleteAdmin(admin.id),
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
            )

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
  final Future<void> Function() fetchAdmins;

  const MyCreateNewDialog({super.key, required this.fetchAdmins});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final AllAdminsService allAdminsService = AllAdminsService();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void isLoadingState(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator(color: Colors.white,));
      },
    );
  }

  Future<void> _addAdmin(BuildContext context) async {
    isLoadingState();
    if (
        _fnameController.text.isEmpty ||
        _lnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty
    ) {
      Navigator.pop(context);
      showErrorMsg(context, "All Fields Required");
    } else {
      final response = await allAdminsService.createAdmin({
        'firstname': _fnameController.text.toString(),
        'lastname': _lnameController.text.toString(),
        'email': _emailController.text.toString(),
        'phone': _phoneController.text.toString(),
        'password': _passwordController.text.toString(),
      });

      Navigator.pop(context);

      if (response.statusCode == 200) {
        await widget.fetchAdmins();
        Navigator.pop(context);
        showSuccessMsg(context, "Admin Added Successfully");
      } else {
        showErrorMsg(context, "Admin Not Added, Try Again");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 200), // Padding on sides
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 50,
                ), // Internal padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Head
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Create New Admin",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),

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
                    ),

                    // Divider line
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _fnameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _lnameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 150),

                    const Divider(),

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
                          onPressFunction: () => _addAdmin(context),
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
}