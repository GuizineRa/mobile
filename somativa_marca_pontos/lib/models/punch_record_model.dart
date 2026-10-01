import 'dart:convert';
import 'package:intl/intl.dart';

class PunchRecordModel {
  final String id;
  final String userId;
  final String userName;
  final String userNif;
  final DateTime timestamp;
  final String type; // Entrada, Saída Almoço, Retorno Almoço, Saída
  final double latitude;
  final double longitude;
  final double distanceFromOffice;
  final bool withinAllowedPerimeter;
  final String authMethod; // Biometria ou NIF / Senha
  final bool syncedWithFirebase;
  final String receiptCode;
  final String? notes;

  PunchRecordModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userNif,
    required this.timestamp,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceFromOffice,
    required this.withinAllowedPerimeter,
    required this.authMethod,
    this.syncedWithFirebase = false,
    required this.receiptCode,
    this.notes,
  });

  String get formattedTime => DateFormat('HH:mm:ss').format(timestamp);
  String get formattedDate => DateFormat('dd/MM/yyyy').format(timestamp);
  String get formattedDateTime => DateFormat('dd/MM/yyyy HH:mm:ss').format(timestamp);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userNif': userNif,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'distanceFromOffice': distanceFromOffice,
      'withinAllowedPerimeter': withinAllowedPerimeter,
      'authMethod': authMethod,
      'syncedWithFirebase': syncedWithFirebase,
      'receiptCode': receiptCode,
      'notes': notes,
    };
  }

  factory PunchRecordModel.fromMap(Map<String, dynamic> map) {
    return PunchRecordModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userNif: map['userNif'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      type: map['type'] ?? 'Entrada',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceFromOffice: (map['distanceFromOffice'] as num?)?.toDouble() ?? 0.0,
      withinAllowedPerimeter: map['withinAllowedPerimeter'] ?? true,
      authMethod: map['authMethod'] ?? 'Biometria',
      syncedWithFirebase: map['syncedWithFirebase'] ?? false,
      receiptCode: map['receiptCode'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PunchRecordModel.fromJson(String source) => PunchRecordModel.fromMap(json.decode(source));

  PunchRecordModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userNif,
    DateTime? timestamp,
    String? type,
    double? latitude,
    double? longitude,
    double? distanceFromOffice,
    bool? withinAllowedPerimeter,
    String? authMethod,
    bool? syncedWithFirebase,
    String? receiptCode,
    String? notes,
  }) {
    return PunchRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userNif: userNif ?? this.userNif,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceFromOffice: distanceFromOffice ?? this.distanceFromOffice,
      withinAllowedPerimeter: withinAllowedPerimeter ?? this.withinAllowedPerimeter,
      authMethod: authMethod ?? this.authMethod,
      syncedWithFirebase: syncedWithFirebase ?? this.syncedWithFirebase,
      receiptCode: receiptCode ?? this.receiptCode,
      notes: notes ?? this.notes,
    );
  }
}
