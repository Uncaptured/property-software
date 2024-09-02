import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_real_estate/API_services/all_roles_services.dart';
import 'package:flutter_real_estate/API_services/all_users_services.dart';
import 'package:flutter_real_estate/components/notification.dart';
import 'package:flutter_real_estate/components/pink_new_button.dart';
import 'package:flutter_real_estate/constants.dart';
import 'package:flutter_real_estate/models/all_users_model.dart';
import '../components/button_form_dialogbox.dart';
import '../models/roles_model.dart';

class UserFragment extends StatefulWidget {
  UserFragment({super.key});

  @override
  State<UserFragment> createState() => _UserFragmentState();
}

class _UserFragmentState extends State<UserFragment> {
  bool isLoading = true;
  List<AllUsersModel> users = [];
  List<Roles> roles = [];
  Roles? _selectedRole;

  final AllUsersService usersService = AllUsersService();
  final RolesService rolesService = RolesService();

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      List<AllUsersModel> allUsers = await usersService.getAllUsers();
      List<Roles> fetchedRoles = await rolesService.getAllRoles();
      setState(() {
        users = allUsers;
        roles = fetchedRoles;
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
      builder: (context) => MyCreateNewDialog(roles: roles, fetchUsers: _fetchUsers),
    );
  }


  String roleName(int id) {
    for (var role in roles) {
      if (role.id == id) {
        return role.name;
      }
    }
    return "Error role not found";
  }


  Future<void> _deleteuser(int userId) async {
    setState((){
      isLoading = true;
    });

    final response = await usersService.deleteUser(userId);

    if(response.statusCode == 200){
      setState(() {
        users.removeWhere((user) => user.id == userId);
        _fetchUsers();
        isLoading = false;
      });
      Navigator.pop(context);
      showSuccessMsg(context, "User Deleted Successfully");
    }else{
      isLoading = false;
      Navigator.pop(context);
      showErrorMsg(context, "User Delete Unsuccessfully");
    }
  }


  void viewUserData(int userId) {
    for(var myUser in users) {
      if(myUser.id == userId) {
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
                      Text("View User", style: TextStyle(fontWeight: FontWeight.bold)),
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

                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            showContentDialog(columnName: "FirstName", content: myUser.firstname),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "LastName", content: myUser.lastname),
                          ],
                        ),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Email Address", content: myUser.email),

                        const SizedBox(height: 15),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [
                            showContentDialog(columnName: "Phone Number", content: myUser.phone),
                            // const SizedBox(height: 15),
                            showContentDialog(columnName: "Role", content: roleName(myUser.roleId)),
                          ],
                        ),

                        const SizedBox(height: 15),

                        showContentDialog(columnName: "Created Time", content: "${myUser.formattedDate} (${myUser.timeAgo})"),

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


  Future<void> showUpdateUser(int userId) async {
    for (var myUser in users) {
      if (myUser.id == userId) {
        showDialog(
          context: context,
          builder: (context) {
            final _updateFnameController = TextEditingController(text: myUser.firstname);
            final _updateLnameController = TextEditingController(text: myUser.lastname);
            final _updateEmailController = TextEditingController(text: myUser.email);
            final _updatePhoneController = TextEditingController(text: myUser.phone);

            _selectedRole = roles.firstWhere((role) => role.id == myUser.roleId);

            return AlertDialog(
              backgroundColor: Colors.white,
              elevation: 5,
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Update User", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Divider(),
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children: [
                          Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: _updateFnameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              controller: _updateLnameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
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
                          controller: _updateEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children: [
                          Container(
                            width: 300,
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

                          Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonFormField<Roles>(
                              value: _selectedRole,
                              onChanged: (Roles? value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                              items: roles
                                  .map((Roles role) => DropdownMenuItem<Roles>(
                                value: role,
                                child: Text(role.name),
                              ))
                                  .toList(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Role',
                              ),
                            ),
                          ),
                        ],
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
                  onPressFunction: () => _updateUser(
                    myUser.id,
                    _updateFnameController.text,
                    _updateLnameController.text,
                    _updateEmailController.text,
                    _updatePhoneController.text,
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


  Future<void> _updateUser(
      int id, String fname, String lname, String email, String phone
      ) async {
    isLoading = true;
    if(
        id.isNaN ||
        fname.isEmpty ||
        lname.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        _selectedRole!.name.isEmpty
    ){
      isLoading = false;
      Navigator.pop(context);
      showErrorMsg(context, "All Fields are Required");
    }
    else{
      final response = await usersService.updateUserData({
        'id': id.toString(),
        'firstname': fname.toString(),
        'lastname': lname.toString(),
        'email': email.toString(),
        'phone': phone.toString(),
        'role_id': _selectedRole?.name.toString() // role name not id (role_id)
      });

      if(response.statusCode == 200){
        isLoading = false;
        Navigator.pop(context);
        _fetchUsers();
        showSuccessMsg(context, 'User Updated Successfully');
      }else{
        isLoading = false;
        Navigator.pop(context);
        showErrorMsg(context, "User Updated Unsuccessfully");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    int id = 1;

    String roleName(int id) {
      for (var role in roles) {
        if (role.id == id) {
          return role.name;
        }
      }
      return "Error role not found";
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 30.0,
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                        "Users",
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
                    title: "+ New User",
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
            // Tables
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
                        )),
                    DataColumn(
                        label: Text(
                          "FirstName",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    DataColumn(
                        label: Text(
                          "LastName",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    DataColumn(
                        label: Text(
                          "Email",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    DataColumn(
                        label: Text(
                          "Phone",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    DataColumn(
                        label: Text(
                          "Role",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    DataColumn(
                        label: Text(
                          "CreatedAt",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    DataColumn(
                        label: Text(
                          "Actions",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                  rows: [
                    for (var user in users)
                      DataRow(cells: [
                        DataCell(Text("${id++}")),
                        DataCell(Text(user.firstname)),
                        DataCell(Text(user.lastname)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.phone)),
                        DataCell(Text(roleName(user.roleId))),
                        DataCell(Text(user.timeAgo)),
                        DataCell(Row(
                          children: [
                            // view btn
                            IconButton(
                              onPressed: () => viewUserData(user.id),
                              icon: const Icon(Icons.remove_red_eye),
                              color: CupertinoColors.systemBlue,
                            ),
                            // update btn
                            IconButton(
                              onPressed: () => showUpdateUser(user.id),
                              icon: const Icon(Icons.mode_edit_outline),
                              color: CupertinoColors.systemGreen,
                            ),
                            // delete btn
                            IconButton(
                              onPressed: () => _deleteuser(user.id),
                              icon: const Icon(Icons.delete),
                              color: Colors.redAccent,
                            ),
                          ],
                        )),
                      ])
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





class MyCreateNewDialog extends StatefulWidget {
  final List<Roles> roles;
  final VoidCallback fetchUsers;

  MyCreateNewDialog({super.key, required this.roles, required this.fetchUsers});

  @override
  State<MyCreateNewDialog> createState() => _MyCreateNewDialogState();
}

class _MyCreateNewDialogState extends State<MyCreateNewDialog> {
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleIdController = TextEditingController();

  Roles? _selectedRole;
  AllUsersService usersService = AllUsersService();

  Future<void> _createNewUser() async {
    setState(() {
      const Center(
        child: CircularProgressIndicator(),
      );
    });

    if(
          _fNameController.text.isEmpty ||
          _lNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _selectedRole == null
    ){
      Navigator.pop(context);
      showErrorMsg(context, "All fields are Required");
    }else{
      _roleIdController.text = _selectedRole!.name.toString();
      final response = await usersService.createUser({
        'firstname': _fNameController.text.toString(),
        'lastname': _lNameController.text.toString(),
        'email': _emailController.text.toString(),
        'phone': _phoneController.text.toString(),
        'role_id': _roleIdController.text.toString(),
        'password': _passwordController.text.toString()
      });

      if(response.statusCode == 200){
        Navigator.pop(context);
        setState(() {
           widget.fetchUsers();
        });
        showSuccessMsg(context, "User Created Successfully");
      }else{
        showErrorMsg(context, "User Created Unsuccessfully");
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
            height: MediaQuery.of(context).size.height * 0.88,
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
                            "Create New User",
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
                              MediaQuery.of(context).size.width * 0.31
                            ),
                            _buildTextField(
                              context,
                              _lNameController,
                              'Last Name',
                                MediaQuery.of(context).size.width * 0.31
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        _buildTextField(
                          context,
                          _emailController,
                          'Email',
                          MediaQuery.of(context).size.width * 0.63
                        ),

                        const SizedBox(height: 18),

                        Wrap(
                          runSpacing: 15,
                          spacing: 15,
                          children: [

                            _buildTextField(
                                context,
                                _phoneController,
                                'Phone',
                                MediaQuery.of(context).size.width * 0.31
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.31,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField<Roles>(
                                value: _selectedRole,
                                onChanged: (Roles? value) {
                                  setState(() {
                                    _selectedRole = value!;
                                  });
                                },
                                items: widget.roles
                                    .map((Roles role) => DropdownMenuItem<Roles>(
                                  value: role,
                                  child: Text(role.name),
                                ))
                                    .toList(),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Role',
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 18),

                        _buildTextField(
                          context,
                          _passwordController,
                          'Password',
                          MediaQuery.of(context).size.width * 0.63,
                          obscureText: true,
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
                              onPressFunction: _createNewUser,
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
