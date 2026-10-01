import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/punch_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: '102030');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleCredentialsLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final punchProvider = Provider.of<PunchProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final success = await authProvider.loginWithCredentials(
      identifier: _identifierController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      if (authProvider.currentUser != null) {
        await punchProvider.initialize(authProvider.currentUser!.id);
      }
      if (!mounted) return;
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Falha na autenticação.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _handleBiometricLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final punchProvider = Provider.of<PunchProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final success = await authProvider.loginWithBiometrics();

    if (!mounted) return;

    if (success) {
      if (authProvider.currentUser != null) {
        await punchProvider.initialize(authProvider.currentUser!.id);
      }
      if (!mounted) return;
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Não foi possível validar biometria.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _fillDemoUser(UserModel user) {
    setState(() {
      _identifierController.text = user.nif;
      _passwordController.text = '123456';
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo e Cabeçalho Corporativo
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PontoGeo Bio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sistema Integrado de Ponto Eletrônico',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Campo NIF ou E-mail
                  TextFormField(
                    controller: _identifierController,
                    decoration: const InputDecoration(
                      labelText: 'NIF ou E-mail Corporativo',
                      hintText: 'Ex: 102030 ou usuario@empresa.com',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Informe seu NIF ou e-mail corporativo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Campo Senha
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Senha de Acesso',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().length < 4) {
                        return 'A senha deve possuir pelo menos 4 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Botão Entrar com Senha
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleCredentialsLogin,
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Entrar com Senha'),
                  ),

                  const SizedBox(height: 16),

                  // Divisor com "OU"
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OU',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Botão de Autenticação Biométrica / Facial
                  OutlinedButton.icon(
                    icon: const Icon(Icons.fingerprint, size: 24, color: AppTheme.accentColor),
                    label: const Text(
                      'Acessar com Biometria / Facial',
                      style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.accentColor, width: 1.5),
                    ),
                    onPressed: authProvider.isLoading ? null : _handleBiometricLogin,
                  ),

                  const SizedBox(height: 28),

                  // Atalhos de Demonstração para Avaliação
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.science_outlined, size: 16, color: AppTheme.primaryColor),
                            SizedBox(width: 6),
                            Text(
                              'Preenchimento Rápido (Avaliação):',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: AuthProvider.demoUsers.map((user) {
                            return ActionChip(
                              avatar: const Icon(Icons.person, size: 14),
                              label: Text('${user.name} (${user.nif})', style: const TextStyle(fontSize: 11)),
                              backgroundColor: Colors.white,
                              onPressed: () => _fillDemoUser(user),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
