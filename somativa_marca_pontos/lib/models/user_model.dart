import 'dart:convert';

class UserModel {
  final String id;
  final String nif;
  final String email;
  final String name;
  final String role;
  final String? photoUrl;
  final bool biometricEnabled;

  UserModel({
    required this.id,
    required this.nif,
    required this.email,
    required this.name,
    required this.role,
    this.photoUrl,
    this.biometricEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nif': nif,
      'email': email,
      'name': name,
      'role': role,
      'photoUrl': photoUrl,
      'biometricEnabled': biometricEnabled,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nif: map['nif'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'Colaborador',
      photoUrl: map['photoUrl'],
      biometricEnabled: map['biometricEnabled'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
