import 'dart:convert';
import '../config/constants.dart';

class WorkLocationModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double maxRadiusMeters;
  final String address;

  WorkLocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.maxRadiusMeters = AppConstants.maxAllowedDistanceMeters,
    this.address = 'Endereço Corporativo',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'maxRadiusMeters': maxRadiusMeters,
      'address': address,
    };
  }

  factory WorkLocationModel.fromMap(Map<String, dynamic> map) {
    return WorkLocationModel(
      id: map['id'] ?? 'default',
      name: map['name'] ?? AppConstants.defaultOfficeName,
      latitude: (map['latitude'] as num?)?.toDouble() ?? AppConstants.defaultOfficeLatitude,
      longitude: (map['longitude'] as num?)?.toDouble() ?? AppConstants.defaultOfficeLongitude,
      maxRadiusMeters: (map['maxRadiusMeters'] as num?)?.toDouble() ?? AppConstants.maxAllowedDistanceMeters,
      address: map['address'] ?? 'Endereço Corporativo',
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkLocationModel.fromJson(String source) => WorkLocationModel.fromMap(json.decode(source));

  WorkLocationModel copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    double? maxRadiusMeters,
    String? address,
  }) {
    return WorkLocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      maxRadiusMeters: maxRadiusMeters ?? this.maxRadiusMeters,
      address: address ?? this.address,
    );
  }
}
