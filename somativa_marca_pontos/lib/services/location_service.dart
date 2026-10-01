import 'package:geolocator/geolocator.dart';
import '../config/constants.dart';

class LocationService {
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização foi negada pelo usuário.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permissão de localização negada permanentemente. Por favor, habilite nas configurações do aparelho.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  bool isWithinPerimeter({
    required double currentLatitude,
    required double currentLongitude,
    required double officeLatitude,
    required double officeLongitude,
    double maxRadiusMeters = AppConstants.maxAllowedDistanceMeters,
  }) {
    final distance = calculateDistance(
      startLatitude: currentLatitude,
      startLongitude: currentLongitude,
      endLatitude: officeLatitude,
      endLongitude: officeLongitude,
    );
    return distance <= maxRadiusMeters;
  }
}
