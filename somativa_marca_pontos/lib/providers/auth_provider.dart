import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/biometric_service.dart';
import '../services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final StorageService _storageService;
  final BiometricService _biometricService;
  final FirebaseService _firebaseService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isBiometricSupported = false;
  bool _isBiometricRemembered = false;

  AuthProvider({
    required StorageService storageService,
    required BiometricService biometricService,
    required FirebaseService firebaseService,
  })  : _storageService = storageService,
        _biometricService = biometricService,
        _firebaseService = firebaseService;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isBiometricSupported => _isBiometricSupported;
  bool get isBiometricRemembered => _isBiometricRemembered;
  bool get isFirebaseConnected => _firebaseService.isAvailable;

  // Usuários de demonstração corporativos
  static final List<UserModel> demoUsers = [
    UserModel(
      id: 'usr_001',
      nif: '102030',
      email: 'joao.silva@empresa.com.br',
      name: 'João Silva',
      role: 'Desenvolvedor Flutter Jr',
      biometricEnabled: true,
    ),
    UserModel(
      id: 'usr_002',
      nif: '405060',
      email: 'maria.souza@empresa.com.br',
      name: 'Maria Souza',
      role: 'Analista de Sistemas',
      biometricEnabled: true,
    ),
  ];

  Future<void> initialize() async {
    _setLoading(true);
    try {
      _isBiometricSupported = await _biometricService.isBiometricHardwareAvailable();
      _isBiometricRemembered = await _storageService.isBiometricRemembered();

      // Recuperar usuário salvo na sessão local
      final savedUser = await _storageService.getCurrentUser();
      if (savedUser != null) {
        _currentUser = savedUser;
      }
    } catch (e) {
      debugPrint('Erro ao inicializar AuthProvider: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithCredentials({
    required String identifier, // NIF ou E-mail
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // 1. Tentar autenticação via Firebase caso esteja com formato de email
      if (_firebaseService.isAvailable && identifier.contains('@')) {
        try {
          final fbUser = await _firebaseService.signInWithEmailPassword(identifier, password);
          if (fbUser != null) {
            _currentUser = fbUser;
            await _storageService.saveCurrentUser(fbUser);
            await _storageService.setBiometricRemembered(true);
            _isBiometricRemembered = true;
            _setLoading(false);
            notifyListeners();
            return true;
          }
        } catch (e) {
          debugPrint('Falha ao autenticar no Firebase, checando local: $e');
        }
      }

      // 2. Validação local (NIF ou E-mail)
      final cleanId = identifier.trim().toLowerCase();
      UserModel? matchedUser;

      for (final user in demoUsers) {
        if (user.nif.toLowerCase() == cleanId || user.email.toLowerCase() == cleanId) {
          matchedUser = user;
          break;
        }
      }

      // Aceita login se senha for >= 4 caracteres ou demo
      if (matchedUser != null || (cleanId.isNotEmpty && password.length >= 4)) {
        final finalUser = matchedUser ??
            UserModel(
              id: 'usr_custom_${DateTime.now().millisecondsSinceEpoch}',
              nif: identifier.contains('@') ? '999999' : identifier,
              email: identifier.contains('@') ? identifier : '$identifier@empresa.com.br',
              name: identifier.contains('@') ? identifier.split('@').first : 'Colaborador NIF $identifier',
              role: 'Colaborador Registrado',
            );

        _currentUser = finalUser;
        await _storageService.saveCurrentUser(finalUser);
        await _storageService.setBiometricRemembered(true);
        _isBiometricRemembered = true;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Credenciais inválidas. Verifique seu NIF/E-mail e senha.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro no processo de login: $e';
      _setLoading(false);
      return false;
    }
  }

  // Autenticação por Biometria / Reconhecimento Facial
  Future<bool> loginWithBiometrics() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await _biometricService.authenticate(
        reason: 'Por favor, autentique com biometria ou reconhecimento facial para acessar o ponto.',
      );

      if (result['success'] == true) {
        // Recuperar o último usuário ou usar o primeiro de demonstração
        UserModel? user = await _storageService.getCurrentUser();
        user ??= demoUsers.first;

        _currentUser = user;
        await _storageService.saveCurrentUser(user);
        await _storageService.setBiometricRemembered(true);
        _isBiometricRemembered = true;

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'] ?? 'Falha na autenticação biométrica.';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao ler biometria: $e';
      _setLoading(false);
      return false;
    }
  }

  // Alternar rapidamente usuário para facilitar correção do professor
  Future<void> switchDemoUser(UserModel user) async {
    _currentUser = user;
    await _storageService.saveCurrentUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    _setLoading(true);
    await _firebaseService.signOut();
    await _storageService.clearCurrentUser();
    _currentUser = null;
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
