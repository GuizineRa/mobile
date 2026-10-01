import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricHardwareAvailable() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> hasFaceOrFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

  Future<Map<String, dynamic>> authenticate({
    required String reason,
    bool biometricOnly = false,
  }) async {
    try {
      final bool isAvailable = await isBiometricHardwareAvailable();
      if (!isAvailable) {
        return {
          'success': false,
          'error': 'Hardware biométrico não disponível ou não configurado no dispositivo.',
          'code': 'NO_HARDWARE',
        };
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: biometricOnly,
        persistAcrossBackgrounding: true,
      );

      return {
        'success': didAuthenticate,
        'error': didAuthenticate ? null : 'Autenticação biométrica cancelada ou não reconhecida.',
        'code': didAuthenticate ? 'SUCCESS' : 'USER_CANCEL',
      };
    } on LocalAuthException catch (e) {
      return {
        'success': false,
        'error': 'Erro na autenticação biométrica: ${e.description ?? e.code.name}',
        'code': e.code.name,
      };
    } on PlatformException catch (e) {
      return {
        'success': false,
        'error': 'Erro de plataforma biométrica: ${e.message ?? e.code}',
        'code': e.code,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Falha inesperada no leitor biométrico: $e',
        'code': 'UNKNOWN',
      };
    }
  }

  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (_) {}
  }
}
