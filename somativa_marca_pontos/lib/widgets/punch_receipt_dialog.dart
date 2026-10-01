import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/punch_record_model.dart';

class PunchReceiptDialog extends StatelessWidget {
  final PunchRecordModel record;

  const PunchReceiptDialog({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícone de Sucesso
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.successColor,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'COMPROVANTE DE PONTO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Registro homologado com sucesso',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary.withOpacity(0.9)),
              ),

              const SizedBox(height: 16),
              const Divider(thickness: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 12),

              // Dados do Recibo
              _buildReceiptRow('Colaborador:', record.userName),
              _buildReceiptRow('NIF:', record.userNif),
              _buildReceiptRow('Tipo de Batida:', record.type, isHighlight: true),
              _buildReceiptRow('Data:', record.formattedDate),
              _buildReceiptRow('Horário:', record.formattedTime, isHighlight: true),
              _buildReceiptRow('Autenticação:', record.authMethod),
              _buildReceiptRow(
                'Distância da Sede:',
                '${record.distanceFromOffice.toStringAsFixed(1)} metros',
              ),
              _buildReceiptRow(
                'Geolocalização:',
                '${record.latitude.toStringAsFixed(4)}, ${record.longitude.toStringAsFixed(4)}',
              ),

              const SizedBox(height: 12),
              const Divider(thickness: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 12),

              // Código de Verificação e Status do Firebase
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CÓDIGO DE AUTENTICIDADE',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.receiptCode,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        fontFamily: 'monospace',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          record.syncedWithFirebase ? Icons.cloud_done : Icons.cloud_off,
                          size: 14,
                          color: record.syncedWithFirebase ? AppTheme.successColor : AppTheme.warningColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          record.syncedWithFirebase ? 'Sincronizado com Firebase' : 'Armazenado localmente',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: record.syncedWithFirebase ? AppTheme.successColor : AppTheme.warningColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Botão de Fechar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Concluir'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
                color: isHighlight ? AppTheme.primaryLight : AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
