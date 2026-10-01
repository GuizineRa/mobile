import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../config/constants.dart';
import '../models/punch_record_model.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/biometric_service.dart';
import '../services/firebase_service.dart';

class PunchResult {
  final bool success;
  final String message;
  final PunchRecordModel? record;

  PunchResult({
    required this.success,
    required this.message,
    this.record,
  });
}

class PunchProvider extends ChangeNotifier {
  final StorageService _storageService;
  final BiometricService _biometricService;
  final FirebaseService _firebaseService;

  List<PunchRecordModel> _records = [];
  bool _isLoading = false;
  String? _errorMessage;

  PunchProvider({
    required StorageService storageService,
    required BiometricService biometricService,
    required FirebaseService firebaseService,
  })  : _storageService = storageService,
        _biometricService = biometricService,
        _firebaseService = firebaseService;

  List<PunchRecordModel> get records => _records;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Filtra batidas de hoje
  List<PunchRecordModel> get todayRecords {
    final now = DateTime.now();
    return _records.where((r) {
      return r.timestamp.year == now.year &&
          r.timestamp.month == now.month &&
          r.timestamp.day == now.day;
    }).toList();
  }

  // Sugestão automática do próximo tipo de batida
  String get suggestedNextType {
    final today = todayRecords;
    if (today.isEmpty) return AppConstants.punchTypeEntry;
    final last = today.first; // ordenado por mais recente
    switch (last.type) {
      case AppConstants.punchTypeEntry:
        return AppConstants.punchTypeLunchOut;
      case AppConstants.punchTypeLunchOut:
        return AppConstants.punchTypeLunchIn;
      case AppConstants.punchTypeLunchIn:
        return AppConstants.punchTypeExit;
      case AppConstants.punchTypeExit:
        return 'Entrada Extra';
      default:
        return AppConstants.punchTypeEntry;
    }
  }

  Future<void> initialize(String? userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Carregar registros do storage local
      _records = await _storageService.getPunchRecords();

      // 2. Se Firebase estiver disponível e houver usuário, tentar buscar do Firestore
      if (_firebaseService.isAvailable && userId != null) {
        final fbRecords = await _firebaseService.fetchUserPunchRecords(userId);
        if (fbRecords.isNotEmpty) {
          // Mesclar registros únicos
          final Map<String, PunchRecordModel> merged = {};
          for (var r in fbRecords) {
            merged[r.id] = r;
          }
          for (var r in _records) {
            merged[r.id] = r;
          }
          _records = merged.values.toList();
          _records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          await _storageService.savePunchRecords(_records);
        }
      }
    } catch (e) {
      debugPrint('Erro ao inicializar PunchProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Executa o registro de ponto com validação biométrica e de distância
  Future<PunchResult> registerPunch({
    required UserModel user,
    required String type,
    required double latitude,
    required double longitude,
    required double distanceMeters,
    required bool isWithinAllowedRadius,
    bool forceBiometrics = true,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Validação de Raio de Localização (Geolocalização máxima 100m)
      if (!isWithinAllowedRadius) {
        _isLoading = false;
        notifyListeners();
        return PunchResult(
          success: false,
          message:
              'Registro bloqueado! Você está a ${distanceMeters.toStringAsFixed(1)} metros da sede. O limite permitido é de até ${AppConstants.maxAllowedDistanceMeters.toInt()}m.',
        );
      }

      // 2. Validação Biometria / Reconhecimento Facial
      String authMethodUsed = AppConstants.authMethodBiometric;
      if (forceBiometrics) {
        final bioResult = await _biometricService.authenticate(
          reason: 'Confirme seu reconhecimento facial ou biometria para bater ponto como ${user.name}.',
        );

        if (bioResult['success'] != true) {
          _isLoading = false;
          notifyListeners();
          return PunchResult(
            success: false,
            message: bioResult['error'] ?? 'Falha na validação biométrica. Ponto não registrado.',
          );
        }
      } else {
        authMethodUsed = AppConstants.authMethodCredentials;
      }

      // 3. Gerar código de recibo/comprovante único
      final now = DateTime.now();
      final randomHex = Random().nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();
      final receiptCode = 'REC-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$randomHex';

      final record = PunchRecordModel(
        id: const Uuid().v4(),
        userId: user.id,
        userName: user.name,
        userNif: user.nif,
        timestamp: now,
        type: type,
        latitude: latitude,
        longitude: longitude,
        distanceFromOffice: distanceMeters,
        withinAllowedPerimeter: true,
        authMethod: authMethodUsed,
        syncedWithFirebase: false,
        receiptCode: receiptCode,
      );

      // 4. Salvar localmente
      await _storageService.addPunchRecord(record);
      _records.insert(0, record);

      // 5. Tentar salvar no Firebase Firestore
      bool synced = false;
      if (_firebaseService.isAvailable) {
        synced = await _firebaseService.savePunchRecord(record.copyWith(syncedWithFirebase: true));
        if (synced) {
          final updated = record.copyWith(syncedWithFirebase: true);
          _records[0] = updated;
          await _storageService.savePunchRecords(_records);
        }
      }

      _isLoading = false;
      notifyListeners();

      return PunchResult(
        success: true,
        message: 'Ponto registrado com sucesso!',
        record: _records.first,
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro ao processar batida: $e';
      notifyListeners();
      return PunchResult(
        success: false,
        message: 'Erro ao registrar ponto: $e',
      );
    }
  }

  // Sincronizar batidas pendentes com o Firebase
  Future<int> syncPendingWithFirebase() async {
    if (!_firebaseService.isAvailable) return 0;
    _isLoading = true;
    notifyListeners();

    try {
      final count = await _firebaseService.syncPendingRecords(_records);
      if (count > 0) {
        _records = _records.map((r) => r.copyWith(syncedWithFirebase: true)).toList();
        await _storageService.savePunchRecords(_records);
      }
      return count;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearAll() async {
    _records.clear();
    await _storageService.savePunchRecords([]);
    notifyListeners();
  }
}
