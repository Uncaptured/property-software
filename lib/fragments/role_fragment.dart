import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/API_services/all_roles_services.dart';
import 'package:flutter_real_estate/components/button_form_dialogbox.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/models/roles_model.dart';

class RoleFragment extends StatefulWidget {
  RoleFragment({super.key});

  @override
  State<RoleFragment> createState() => _RoleFragmentState();
}

class _RoleFragmentState extends State<RoleFragment> {
  List<Roles> roles = [];
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();
  final RolesService rolesService = RolesService();

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    try{
      List<Roles> fetchedRoles = await rolesService.getAllRoles();
      setState(() {
        roles = fetchedRoles;
        isLoading = false;
      });
    } catch(e){
      showErrorMsg(context, "Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> deleteRole(int roleId) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final response = await rolesService.deleteRole(roleId);

    if(response.statusCode == 200){
      setState(() {
        roles.removeWhere((role) => role.id == roleId);
        _fetchRoles();
      });
      Navigator.pop(context);
      showSuccessMsg(context, "Role Deleted Successfully");
    }else{
      Navigator.pop(context);
      showErrorMsg(context, "Role Delete Unsuccessfully");
    }
  }



  Future<void> showRole(int roleId) async {
    for(var myRole in roles) {
      if(myRole.id == roleId) {
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
                    Text("View Role", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Divider(),
                  ],
                ),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.45, // Adjust width here
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.33,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showContentDialog(columnName: "Role Name", content: myRole.name),
                    const SizedBox(height: 17),
                    showContentDialog(columnName: "Description", content: myRole.description),
                    const SizedBox(height: 17),
                    showContentDialog(columnName: "Created Time", content: "${myRole.formattedDate} (${myRole.timeAgo})"),
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



  Future<void> showUpdateRole(int roleId) async {
    for(var myRole in roles){
      if(myRole.id == roleId){
        showDialog(
            context: context,
            builder: (context) {

              final _updateroleNameController = TextEditingController(text: myRole.name);
              final _updateroleDescriptionController = TextEditingController(text: myRole.description);

              return AlertDialog(
                backgroundColor: Colors.white,
                elevation: 5,
                title: const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Update Role", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Divider(),
                    ],
                  ),
                ),
                content: Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.45, // Adjust width here
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.33,),
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
                          controller: _updateroleNameController,
                          decoration: const InputDecoration(
                            labelText: 'Role Name',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.only(
                          top: 1,
                          bottom: 50,
                          left: 15,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _updateroleDescriptionController,
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
                    onPressFunction: () => _updateRole(
                        roleId,
                        _updateroleNameController.text,
                        _updateroleDescriptionController.text
                    ),
                ),
              ]
            );
          }
        );
      }
    }
  }


  Future<void> _updateRole(int id, String name, String description) async {
    setState(() {
      const Center(
        child: CircularProgressIndicator(),
      );
    });

    if(
      id.isNaN ||
      name.isEmpty ||
      description.isEmpty
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await rolesService.updateRoleService({
        'id': id,
        'role_name': name,
        'description': description
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        _fetchRoles();
        showSuccessMsg(context, 'Role Updated Successfully');
      }else{
        Navigator.pop(context);
        showErrorMsg(context, "Role Updated Unsuccessfully");
      }
    }
  }

  void _showDialogRole(){
    showDialog(
        context: context,
        builder: (context) => MyCreateNewDialog(fetchRoles: _fetchRoles)
    );
  }

  @override
  Widget build(BuildContext context) {

    // declaring id inside widget to rebuild too
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
                      const Text(
                        "Roles",
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
                    title: "+ New Role",
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
                    DataColumn(label: Text("#",style: TextStyle(fontWeight: FontWeight.bold),),),
                    DataColumn(label: Text("Role Name",style: TextStyle(fontWeight: FontWeight.bold),),),
                    DataColumn(label: Text("Description",style: TextStyle(fontWeight: FontWeight.bold),),),
                    DataColumn(label: Text("Created At",style: TextStyle(fontWeight: FontWeight.bold),),),
                    DataColumn(label: Text("Actions",style: TextStyle(fontWeight: FontWeight.bold),),),
                  ],
                  rows: [
                    for(var role in roles)
                      DataRow(cells: [
                        DataCell(Text('${id++}')),
                        DataCell(Text(role.name)),
                        DataCell(Text(role.description)),
                        DataCell(Text(role.timeAgo)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => showRole(role.id),
                                icon: const Icon(Icons.remove_red_eye),
                                color: CupertinoColors.systemBlue,
                              ),
                              IconButton(
                                onPressed: () => showUpdateRole(role.id),
                                icon: const Icon(Icons.mode_edit_outline),
                                color: CupertinoColors.systemGreen,
                              ),
                              IconButton(
                                onPressed: () => deleteRole(role.id),
                                icon: const Icon(Icons.delete),
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
                        ),
                      ]),
                  ],
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
  final Future<void> Function() fetchRoles;

  const MyCreateNewDialog({super.key, required this.fetchRoles});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final RolesService rolesService = RolesService();

  final TextEditingController _roleNameController = TextEditingController();
  final TextEditingController _roleDescriptionController = TextEditingController();

  Future<void> _addRole(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    if (_roleNameController.text.isEmpty || _roleDescriptionController.text.isEmpty) {
      Navigator.pop(context);
      showErrorMsg(context, "All Fields Required");
    } else {
      final response = await rolesService.sendRole({
        'role_name': _roleNameController.text.toString(),
        'description': _roleDescriptionController.text.toString(),
      });

      Navigator.pop(context);

      if (response.statusCode == 200) {
        // Fetch roles after adding a new role
        await widget.fetchRoles();
        Navigator.pop(context); // Close the dialog
        showSuccessMsg(context, "Role Added Successfully");
      } else {
        showErrorMsg(context, "Role Not Added, Try Again");
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
            height: MediaQuery.of(context).size.height * 0.77,
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
                            "Create New Role",
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
                            controller: _roleNameController,
                            decoration: const InputDecoration(
                              labelText: 'Role Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.only(
                            top: 1,
                            bottom: 50,
                            left: 15,
                            right: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: _roleDescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
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
                          onPressFunction: () => _addRole(context),
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