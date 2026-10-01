import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'config/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/location_provider.dart';
import 'providers/punch_provider.dart';
import 'screens/splash_screen.dart';
import 'services/biometric_service.dart';
import 'services/firebase_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa a formatação para o padrão pt_BR
  try {
    await initializeDateFormatting('pt_BR', null);
  } catch (e) {
    debugPrint('Aviso na formatação de data pt_BR: $e');
  }

  // Inst instanciação dos serviços fundamentais
  final storageService = StorageService();
  final biometricService = BiometricService();
  final locationService = LocationService();
  final firebaseService = FirebaseService();

  // Inicialização segura do Firebase (com suporte a fallback offline/local)
  try {
    await firebaseService.initialize();
  } catch (e) {
    debugPrint('Firebase operando em modo local resiliente: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            storageService: storageService,
            biometricService: biometricService,
            firebaseService: firebaseService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(
            locationService: locationService,
            storageService: storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PunchProvider(
            storageService: storageService,
            biometricService: biometricService,
            firebaseService: firebaseService,
          ),
        ),
      ],
      child: const PontoGeoApp(),
    ),
  );
}

class PontoGeoApp extends StatelessWidget {
  const PontoGeoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
