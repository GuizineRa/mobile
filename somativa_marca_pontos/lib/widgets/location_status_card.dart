import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/constants.dart';
import '../providers/location_provider.dart';

class LocationStatusCard extends StatelessWidget {
  const LocationStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final isWithin = locationProvider.isWithinAllowedRadius;
        final distance = locationProvider.currentDistanceMeters;
        final isLoading = locationProvider.isLoading;
        final position = locationProvider.currentPosition;
        final workLocation = locationProvider.workLocation;

        final Color statusColor = isWithin ? AppTheme.successColor : AppTheme.errorColor;
        final String statusTitle = isWithin
            ? 'DENTRO DO PERÍMETRO PERMITIDO'
            : 'FORA DO PERÍMETRO PERMITIDO';
        final String statusSubtitle = isWithin
            ? 'Você está a ${distance.toStringAsFixed(1)}m da sede (Limite: ${AppConstants.maxAllowedDistanceMeters.toInt()}m)'
            : 'Distância atual: ${distance.toStringAsFixed(1)}m (Excede o limite de ${AppConstants.maxAllowedDistanceMeters.toInt()}m)';

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: statusColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho de Status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWithin ? Icons.location_on : Icons.location_off,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            statusTitle,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            statusSubtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh, color: AppTheme.primaryLight),
                        tooltip: 'Atualizar Localização',
                        onPressed: () => locationProvider.refreshLocation(),
                      ),
                  ],
                ),

                const Divider(height: 24),

                // Informações Técnicas de Geolocalização
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sede Cadastrada:',
                            style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            workLocation.name,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Raio: ${AppConstants.maxAllowedDistanceMeters.toInt()}m',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                    ),
                  ],
                ),

                if (position != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Coordenadas GPS: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontFamily: 'monospace'),
                  ),
                ],

                const SizedBox(height: 12),

                // Barra de Ações Rápidas para Avaliação do Professor
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tune, size: 16, color: AppTheme.primaryColor),
                      const SizedBox(width: 6),
                      const Text(
                        'Modo Teste:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.my_location, size: 14),
                        label: const Text('Aqui é a Sede', style: TextStyle(fontSize: 11)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          locationProvider.setOfficeToCurrentLocation();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sede redefinida para sua localização atual (Raio de 100m ativo)!'),
                              backgroundColor: AppTheme.successColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.not_listed_location_outlined, size: 14),
                        label: const Text('Simular Fora', style: TextStyle(fontSize: 11)),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.errorColor,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          locationProvider.simulateOutOfRange();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Simulando localização fora do raio de 100m (para testar bloqueio).'),
                              backgroundColor: AppTheme.errorColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
