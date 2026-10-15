import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signin() async{
    try {
      //tenta a conexão com email e senha
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text);
    }on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falaha de Autenticação ${e.message}"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}