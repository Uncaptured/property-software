class AuthUser {
  static final AuthUser _instance = AuthUser._internal();

  factory AuthUser() {
    return _instance;
  }

  AuthUser._internal(); // Private constructor

  int id = 0;
  String firstname = '';
  String lastname = '';
  String email = '';
  String phone = '';
  String roleId = '';
  String createdAt = '';

  // Method to update the singleton instance from JSON
  void updateFromJson(Map<String, dynamic> json) {
    try {
      _instance.id = json['id'] ?? 0;
      _instance.firstname = json['firstname'] ?? '';
      _instance.lastname = json['lastname'] ?? '';
      _instance.email = json['email'] ?? '';
      _instance.phone = json['phone'] ?? '';
      _instance.roleId = json['role_id'] ?? '';
      _instance.createdAt = json['created_at'] ?? '';
    } catch (e) {
      print('Error updating user from JSON: $e');
      // Handle any additional error processing if needed
    }
  }

  // Method to get the singleton instance
  static AuthUser get instance => _instance;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'role_id': roleId,
      'created_at': createdAt,
    };
  }
}
