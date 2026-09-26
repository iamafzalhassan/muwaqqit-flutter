import 'package:geolocator/geolocator.dart';

typedef LatLng = ({double lat, double lng});

class LocationService {
  static const LatLng fallback = (lat: 6.9271, lng: 79.8612);

  const LocationService();

  Future<LatLng> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return fallback;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return fallback;
      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      return (lat: position.latitude, lng: position.longitude);
    } catch (_) {
      return fallback;
    }
  }
}
