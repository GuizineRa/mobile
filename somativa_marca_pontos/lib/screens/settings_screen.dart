import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../providers/punch_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final punchProvider = Provider.of<PunchProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Diagnóstico de Recursos de Hardware
            _buildSectionHeader('RECURSOS DE HARDWARE E SENSORES', Icons.hardware),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildHardwareRow(
                      icon: Icons.fingerprint,
                      title: 'Biometria / Reconhecimento Facial',
                      subtitle: authProvider.isBiometricSupported
                          ? 'Sensor biométrico detectado e ativo'
                          : 'Hardware não detectado / Modo emulação',
                      isAvailable: authProvider.isBiometricSupported,
                    ),
                    const Divider(height: 20),
                    _buildHardwareRow(
                      icon: Icons.gps_fixed,
                      title: 'Módulo de Geolocalização (GPS)',
                      subtitle: locationProvider.currentPosition != null
                          ? 'GPS ativo (Precisão: ±${locationProvider.currentPosition!.accuracy.toStringAsFixed(1)}m)'
                          : 'Aguardando sinal de satélite / permissão',
                      isAvailable: locationProvider.currentPosition != null,
                    ),
                    const Divider(height: 20),
                    _buildHardwareRow(
                      icon: Icons.cloud_sync,
                      title: 'Integração Firebase (Cloud Backend)',
                      subtitle: authProvider.isFirebaseConnected
                          ? 'Firebase Auth & Cloud Firestore conectados'
                          : 'Modo local ativo com fallback automático',
                      isAvailable: authProvider.isFirebaseConnected,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Parâmetros de Geolocalização Corporativa
            _buildSectionHeader('PARÂMETROS DO LOCAL DE TRABALHO', Icons.business),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sede Atual:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Raio: ${locationProvider.workLocation.maxRadiusMeters.toInt()}m',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      locationProvider.workLocation.name,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Lat: ${locationProvider.workLocation.latitude.toStringAsFixed(6)} | Lon: ${locationProvider.workLocation.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Ferramentas para Avaliação do Professor:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.my_location, size: 16),
                          label: const Text('Definir Aqui como Sede'),
                          onPressed: () {
                            locationProvider.setOfficeToCurrentLocation();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sede redefinida para sua posição atual! Raio de 100m ativo.'),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          },
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.replay, size: 16),
                          label: const Text('Restaurar Sede Padrão'),
                          onPressed: () {
                            locationProvider.resetToDefaultLocation();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sede restaurada para Av. Paulista.'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Alternar Usuário de Teste
            _buildSectionHeader('PERFIL DO COLABORADOR', Icons.person_outline),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.currentUser?.name ?? 'Não identificado',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Cargo: ${authProvider.currentUser?.role ?? "Colaborador"} | NIF: ${authProvider.currentUser?.nif ?? "------"}',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    Text(
                      'E-mail: ${authProvider.currentUser?.email ?? "------"}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Alternar para outro perfil demonstrativo:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: AuthProvider.demoUsers.map((user) {
                        final isSelected = authProvider.currentUser?.id == user.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(user.name.split(' ').first),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                authProvider.switchDemoUser(user);
                                punchProvider.initialize(user.id);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Ações do Sistema
            _buildSectionHeader('DADOS E ARMAZENAMENTO', Icons.storage),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.delete_sweep_outlined, color: AppTheme.errorColor),
                    title: const Text('Limpar Histórico Local'),
                    subtitle: const Text('Remove todas as batidas armazenadas no dispositivo'),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Limpar Dados?'),
                          content: const Text('Deseja realmente apagar todos os registros de ponto gravados?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Limpar'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await punchProvider.clearAll();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Histórico reiniciado com sucesso!')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                '${AppConstants.appName} v${AppConstants.appVersion}\nAvaliação Somativa em Flutter - Recursos de Hardware',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHardwareRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isAvailable,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isAvailable ? AppTheme.successColor : Colors.grey).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isAvailable ? AppTheme.successColor : Colors.grey, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ],
          ),
        ),
        Icon(
          isAvailable ? Icons.check_circle : Icons.warning_amber_rounded,
          color: isAvailable ? AppTheme.successColor : Colors.orange,
          size: 20,
        ),
      ],
    );
  }
}
