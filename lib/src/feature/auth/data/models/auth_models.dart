class UserModel {
  UserModel({required this.id, required this.name, required this.email, this.photoUrl});
  final String id;
  final String name;
  final String email;
  final String? photoUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? json['fullName'] ?? json['username'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        photoUrl: (json['photoUrl'] == null) ? null : json['photoUrl'].toString(),
      );
}

class AuthResponse {
  AuthResponse({required this.token, required this.user});
  final String token;
  final UserModel user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: (json['token'] ?? '').toString(),
        user: UserModel.fromJson((json['user'] ?? <String, dynamic>{}) as Map<String, dynamic>),
      );
}


