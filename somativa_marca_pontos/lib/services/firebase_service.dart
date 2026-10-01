import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/punch_record_model.dart';
import '../models/user_model.dart';

class FirebaseService {
  bool _isInitialized = false;
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  bool get isAvailable => _isInitialized;
  FirebaseAuth? get auth => _auth;
  FirebaseFirestore? get firestore => _firestore;

  Future<bool> initialize() async {
    try {
      if (Firebase.apps.isNotEmpty) {
        _isInitialized = true;
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;
        return true;
      }

      await Firebase.initializeApp();
      _isInitialized = true;
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      return true;
    } catch (e) {
      debugPrint('Firebase não inicializado com projeto nativo (Modo Local/Fallback ativo): $e');
      _isInitialized = false;
      return false;
    }
  }

  // Autenticação Firebase Auth
  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    if (!_isInitialized || _auth == null) {
      return null;
    }
    try {
      final UserCredential credential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        // Tentar obter dados adicionais do Firestore se existir
        String name = user.displayName ?? email.split('@').first;
        String nif = 'NIF-${user.uid.substring(0, 6).toUpperCase()}';
        String role = 'Colaborador';

        if (_firestore != null) {
          try {
            final doc = await _firestore!.collection('users').doc(user.uid).get();
            if (doc.exists && doc.data() != null) {
              final data = doc.data()!;
              name = data['name'] ?? name;
              nif = data['nif'] ?? nif;
              role = data['role'] ?? role;
            }
          } catch (_) {}
        }

        return UserModel(
          id: user.uid,
          email: user.email ?? email,
          name: name,
          nif: nif,
          role: role,
        );
      }
    } catch (e) {
      debugPrint('Erro no Firebase Auth: $e');
      rethrow;
    }
    return null;
  }

  // Salvar registro de ponto no Cloud Firestore
  Future<bool> savePunchRecord(PunchRecordModel record) async {
    if (!_isInitialized || _firestore == null) {
      return false;
    }
    try {
      await _firestore!
          .collection('punch_records')
          .doc(record.id)
          .set(record.toMap());
      return true;
    } catch (e) {
      debugPrint('Erro ao salvar no Firestore: $e');
      return false;
    }
  }

  // Buscar registros no Firestore por usuário
  Future<List<PunchRecordModel>> fetchUserPunchRecords(String userId) async {
    if (!_isInitialized || _firestore == null) {
      return [];
    }
    try {
      final snapshot = await _firestore!
          .collection('punch_records')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => PunchRecordModel.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Erro ao buscar no Firestore: $e');
      return [];
    }
  }

  // Sincronizar registros pendentes
  Future<int> syncPendingRecords(List<PunchRecordModel> records) async {
    if (!_isInitialized || _firestore == null) return 0;
    int syncedCount = 0;
    for (final record in records) {
      if (!record.syncedWithFirebase) {
        final success = await savePunchRecord(record.copyWith(syncedWithFirebase: true));
        if (success) syncedCount++;
      }
    }
    return syncedCount;
  }

  Future<void> signOut() async {
    if (_isInitialized && _auth != null) {
      await _auth!.signOut();
    }
  }
}
