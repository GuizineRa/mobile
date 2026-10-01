import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/constants.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../providers/punch_provider.dart';
import 'punch_receipt_dialog.dart';

class PunchActionButton extends StatelessWidget {
  const PunchActionButton({super.key});

  void _showPunchModal(BuildContext context) {
    final punchProvider = Provider.of<PunchProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String selectedType = punchProvider.suggestedNextType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final isWithin = locationProvider.isWithinAllowedRadius;
            final user = authProvider.currentUser;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Confirmar Batida de Ponto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Selecione o tipo de registro e confirme com sua biometria',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 16),

                  // Seletor de Tipo
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildTypeChip(
                        type: AppConstants.punchTypeEntry,
                        selected: selectedType == AppConstants.punchTypeEntry,
                        onTap: () => setModalState(() => selectedType = AppConstants.punchTypeEntry),
                      ),
                      _buildTypeChip(
                        type: AppConstants.punchTypeLunchOut,
                        selected: selectedType == AppConstants.punchTypeLunchOut,
                        onTap: () => setModalState(() => selectedType = AppConstants.punchTypeLunchOut),
                      ),
                      _buildTypeChip(
                        type: AppConstants.punchTypeLunchIn,
                        selected: selectedType == AppConstants.punchTypeLunchIn,
                        onTap: () => setModalState(() => selectedType = AppConstants.punchTypeLunchIn),
                      ),
                      _buildTypeChip(
                        type: AppConstants.punchTypeExit,
                        selected: selectedType == AppConstants.punchTypeExit,
                        onTap: () => setModalState(() => selectedType = AppConstants.punchTypeExit),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Alerta de Localização
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isWithin ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isWithin ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isWithin ? Icons.check_circle : Icons.error_outline,
                          color: isWithin ? AppTheme.successColor : AppTheme.errorColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isWithin
                                ? 'Localização válida: a ${locationProvider.currentDistanceMeters.toStringAsFixed(1)}m da sede (máximo: ${AppConstants.maxAllowedDistanceMeters.toInt()}m).'
                                : 'Fora do raio permitido! Distância: ${locationProvider.currentDistanceMeters.toStringAsFixed(1)}m. Aproxime-se a até 100m da sede.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isWithin ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botão de Confirmação Biométrica
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint, size: 24),
                    label: const Text('Confirmar com Biometria / Facial'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWithin ? AppTheme.primaryColor : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: !isWithin || user == null
                        ? () {
                            if (!isWithin) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Registro bloqueado: você deve estar a até 100 metros do local de trabalho.'),
                                  backgroundColor: AppTheme.errorColor,
                                ),
                              );
                            }
                          }
                        : () async {
                            Navigator.pop(ctx);
                            final result = await punchProvider.registerPunch(
                              user: user,
                              type: selectedType,
                              latitude: locationProvider.currentPosition?.latitude ?? 0.0,
                              longitude: locationProvider.currentPosition?.longitude ?? 0.0,
                              distanceMeters: locationProvider.currentDistanceMeters,
                              isWithinAllowedRadius: isWithin,
                              forceBiometrics: true,
                            );

                            if (result.success && result.record != null) {
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => PunchReceiptDialog(record: result.record!),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.message),
                                    backgroundColor: AppTheme.errorColor,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            }
                          },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTypeChip({
    required String type,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(type),
      selected: selected,
      selectedColor: AppTheme.primaryLight.withOpacity(0.2),
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryColor : AppTheme.textSecondary,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 13,
      ),
      side: BorderSide(
        color: selected ? AppTheme.primaryColor : const Color(0xFFE2E8F0),
        width: selected ? 1.5 : 1,
      ),
      onSelected: (_) => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LocationProvider, PunchProvider, AuthProvider>(
      builder: (context, locationProvider, punchProvider, authProvider, child) {
        final isWithin = locationProvider.isWithinAllowedRadius;
        final isLoading = punchProvider.isLoading;
        final nextType = punchProvider.suggestedNextType;

        return Column(
          children: [
            InkWell(
              onTap: isLoading ? null : () => _showPunchModal(context),
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isWithin
                        ? [const Color(0xFF0D9488), const Color(0xFF10B981)]
                        : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isWithin ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.fingerprint, color: Colors.white, size: 50),
                            const SizedBox(height: 6),
                            const Text(
                              'REGISTRAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              nextType,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isWithin ? 'Pronto para registrar ponto' : 'Aproxime-se a até 100m do trabalho',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isWithin ? AppTheme.successColor : AppTheme.errorColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
