// Arquivo de configuração padrão do Firebase para Flutter
// Caso configure seu projeto no Firebase Console com o comando:
// `flutterfire configure`
// Este arquivo será substituído automaticamente pelas credenciais da sua conta.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions não configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderWebKeyForEvaluation123',
    appId: '1:100000000000:web:demo1234567890',
    messagingSenderId: '100000000000',
    projectId: 'somativa-marca-pontos',
    authDomain: 'somativa-marca-pontos.firebaseapp.com',
    storageBucket: 'somativa-marca-pontos.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderAndroidKeyForEvaluation12',
    appId: '1:100000000000:android:demo1234567890',
    messagingSenderId: '100000000000',
    projectId: 'somativa-marca-pontos',
    storageBucket: 'somativa-marca-pontos.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoPlaceholderIosKeyForEvaluation1234',
    appId: '1:100000000000:ios:demo1234567890',
    messagingSenderId: '100000000000',
    projectId: 'somativa-marca-pontos',
    storageBucket: 'somativa-marca-pontos.appspot.com',
    iosBundleId: 'com.example.somativaMarcaPontos',
  );
}
