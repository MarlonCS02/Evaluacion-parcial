class User {
  final int id;
  final String email;
  final String name;
  final String? profileImage;
  final String role;
  bool isActive;
  DateTime? lastLogin;
  int loginCount;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    required this.role,
    this.isActive = false,
    this.lastLogin,
    this.loginCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profile_image'],
      role: json['role'] ?? 'user',
      lastLogin: json['last_login'] != null 
          ? DateTime.tryParse(json['last_login']) 
          : null,
      loginCount: json['login_count'] ?? 0,
    );
  }

  void login() {
    isActive = true;
  }

  void logout() {
    isActive = false;
  }
}