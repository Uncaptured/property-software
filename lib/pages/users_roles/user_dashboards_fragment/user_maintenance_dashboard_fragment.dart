import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_real_estate/API_services/all_collection_services.dart';
import 'package:flutter_real_estate/API_services/all_maintenance_services.dart';
import 'package:flutter_real_estate/API_services/all_roles_services.dart';
import 'package:flutter_real_estate/API_services/all_tenants_service.dart';
import 'package:flutter_real_estate/API_services/all_unity_services.dart';
import 'package:flutter_real_estate/API_services/all_users_services.dart';
import 'package:flutter_real_estate/models/all_maintenance_model.dart';
import 'package:flutter_real_estate/models/all_tenants_model.dart';
import 'package:flutter_real_estate/models/all_units_model.dart';
import 'package:flutter_real_estate/models/all_users_model.dart';
import 'package:flutter_real_estate/models/roles_model.dart';
import '../../../API_services/all_lease_services.dart';
import '../../../API_services/all_properties_services.dart';
import '../../../components/notification.dart';
import '../../../models/all_collection_model.dart';
import '../../../models/all_lease_model.dart';
import '../../../models/all_property_model.dart';
import '../../../models/auth_user.dart';


class UserMaintenanceDashboardFragment extends StatefulWidget {
  final Function(int) onSelectPage;

  UserMaintenanceDashboardFragment({
    super.key,
    required this.onSelectPage,
  });

  @override
  State<UserMaintenanceDashboardFragment> createState() => _UserMaintenanceDashboardFragmentState();
}

class _UserMaintenanceDashboardFragmentState extends State<UserMaintenanceDashboardFragment> {
  final AuthUser user = AuthUser();
  bool isLoading = true;

  List<AllPropertyModel> properties = [];
  List<AllUnityModel> unities = [];
  List<AllUsersModel> users = [];
  List<Roles> roles = [];
  List<AllTenantsModel> tenants = [];
  List<AllMaintenanceModel> maintenances = [];
  List<AllLeaseModel> leases = [];
  List<AllCollectionModel> collections = [];

  late AllPropertyService allPropertyService = AllPropertyService();
  late AllUnityServices allUnityServices = AllUnityServices();
  late AllUsersService allUsersService = AllUsersService();
  late RolesService rolesService = RolesService();
  late AllTenantsService allTenantsService = AllTenantsService();
  late AllLeaseService allLeaseService = AllLeaseService();
  late AllMaintenanceService allMaintenanceService = AllMaintenanceService();
  late AllCollectionService allCollectionService = AllCollectionService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }


  Future<void> _fetchData() async {
    try {
      List<AllPropertyModel> allProperty = await allPropertyService.getAllProperties();
      List<AllUnityModel> allUnity = await allUnityServices.getAllUnities();
      List<AllUsersModel> allUsers = await allUsersService.getAllUsers();
      List<Roles> allRoles = await rolesService.getAllRoles();
      List<AllTenantsModel> allTenants = await allTenantsService.getAllTenants();
      List<AllLeaseModel> allLeases = await allLeaseService.getAllLease();
      List<AllMaintenanceModel> allMaintenance = await allMaintenanceService.getAllMaintenance();
      List<AllCollectionModel> allCollections  = await allCollectionService.getAllCollection();


      setState(() {
        properties = allProperty;
        unities = allUnity;
        users = allUsers;
        roles = allRoles;
        tenants = allTenants;
        leases = allLeases;
        maintenances = allMaintenance;
        collections = allCollections;

        isLoading = false;
      });
    } catch (e) {
      showErrorMsg(context, "Error, $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
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
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(text: "Hi ${user.firstname}\n"),
                    const TextSpan(
                      text: "Welcome Back",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
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

            Wrap(
              spacing: 20, // Horizontal spacing between items
              runSpacing: 20, // Vertical spacing between rows
              children: [

                Dashboardinks(
                  icon: Icons.build,
                  title: "Maintenance",
                  count: maintenances.length,
                  onTapFunction: () => widget.onSelectPage(1),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}



class Dashboardinks extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? count;
  final Function()? onTapFunction;

  const Dashboardinks({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            // Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Count
                Text(
                  "$count",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Icon
                Icon(icon, color: Colors.grey.withOpacity(0.5), size: 77),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
