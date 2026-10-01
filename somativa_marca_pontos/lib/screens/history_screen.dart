import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/punch_provider.dart';
import '../widgets/punch_card_tile.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final punchProvider = Provider.of<PunchProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final records = punchProvider.records;
    final unsyncedCount = records.where((r) => !r.syncedWithFirebase).length;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await punchProvider.initialize(authProvider.currentUser?.id);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Resumo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetricColumn('Total de Batidas', '${records.length}'),
                    Container(height: 36, width: 1, color: Colors.white24),
                    _buildMetricColumn(
                      'Sincronizados',
                      '${records.length - unsyncedCount}',
                      color: AppTheme.successColor,
                    ),
                    Container(height: 36, width: 1, color: Colors.white24),
                    _buildMetricColumn(
                      'Pendentes',
                      '$unsyncedCount',
                      color: unsyncedCount > 0 ? AppTheme.warningColor : Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Botão de Sincronizar com Firebase se houver pendências
              if (unsyncedCount > 0 && authProvider.isFirebaseConnected)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: Text('Sincronizar $unsyncedCount registros com Firebase'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                    ),
                    onPressed: () async {
                      final count = await punchProvider.syncPendingWithFirebase();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$count registros enviados para o Cloud Firestore!'),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      }
                    },
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'HISTÓRICO COMPLETO',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${records.length} registros',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (records.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.history_toggle_off, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhum registro encontrado',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Os registros de ponto com comprovante biométrico e GPS aparecerão aqui.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    return PunchCardTile(record: records[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}
