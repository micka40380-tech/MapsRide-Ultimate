import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  // 1. Enregistre la position actuelle comme étant le "Domicile"
  static Future<void> setHomeLocation() async {
    // On demande la permission si nécessaire
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('home_lat', position.latitude);
    await prefs.setDouble('home_lon', position.longitude);
  }

  // 2. Vérifie si le joueur est dans un rayon de 100m de son domicile
  static Future<bool> isAtHome() async {
    final prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('home_lat');
    double? lon = prefs.getDouble('home_lon');

    // Si aucune position n'est enregistrée, on considère qu'il n'est pas chez lui
    if (lat == null || lon == null) return false;

    Position currentPos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    double distance = Geolocator.distanceBetween(
      currentPos.latitude, currentPos.longitude, lat, lon
    );

    return distance < 100; // 100 mètres de tolérance
  }
}