import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/constants.dart';
import '../models/punch_record_model.dart';
import 'punch_receipt_dialog.dart';

class PunchCardTile extends StatelessWidget {
  final PunchRecordModel record;

  const PunchCardTile({super.key, required this.record});

  Color _getTypeColor(String type) {
    switch (type) {
      case AppConstants.punchTypeEntry:
        return const Color(0xFF10B981); // Emerald
      case AppConstants.punchTypeLunchOut:
        return const Color(0xFFF59E0B); // Amber
      case AppConstants.punchTypeLunchIn:
        return const Color(0xFF3B82F6); // Blue
      case AppConstants.punchTypeExit:
        return const Color(0xFFEF4444); // Red
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case AppConstants.punchTypeEntry:
        return Icons.login;
      case AppConstants.punchTypeLunchOut:
        return Icons.restaurant;
      case AppConstants.punchTypeLunchIn:
        return Icons.coffee;
      case AppConstants.punchTypeExit:
        return Icons.logout;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(record.type);
    final icon = _getTypeIcon(record.type);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => PunchReceiptDialog(record: record),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícone do tipo de batida
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),

            // Informações principais
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        record.type,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (record.syncedWithFirebase)
                        const Icon(Icons.cloud_done, size: 14, color: AppTheme.successColor)
                      else
                        const Icon(Icons.cloud_off, size: 14, color: AppTheme.warningColor),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.fingerprint, size: 13, color: AppTheme.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        record.authMethod.contains('Biometria') ? 'Biometria' : 'NIF/Senha',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on, size: 13, color: AppTheme.textSecondary),
                      const SizedBox(width: 2),
                      Text(
                        '${record.distanceFromOffice.toStringAsFixed(0)}m',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Horário da Batida
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  record.formattedTime,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  record.formattedDate,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }
}
