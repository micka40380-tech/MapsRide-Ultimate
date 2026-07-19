import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'database_helper.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  int _monArgent = 0;
  int _niveau = 1;
  int _xp = 0;
  final int _chargeBatterie = 75; // Valeur fixe pour le visuel
  bool _isBoosting = false;
  Timer? _timerBoost;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initialiserApp();
  }

  Future<void> _initialiserApp() async {
    await _chargerSolde();
    await _chargerCommercesSurCarte();
  }

  Future<void> _chargerSolde() async {
    int argent = await DatabaseHelper.instance.getArgent();
    setState(() => _monArgent = argent);
  }

  Future<void> _chargerCommercesSurCarte() async {
    final db = await DatabaseHelper.instance.database;
    final commerces = await db.query('commerces');
    setState(() {
      _markers = commerces.map((c) => Marker(
            markerId: MarkerId(c['id'].toString()),
            position: LatLng(c['latitude'] as double, c['longitude'] as double),
            infoWindow: InfoWindow(title: c['nom_lieu'] as String),
          )).toSet();
    });
  }

  void _toggleBoost() {
    if (_isBoosting) return;
    setState(() => _isBoosting = true);
    _timerBoost = Timer(const Duration(seconds: 15), () {
      if (mounted) setState(() => _isBoosting = false);
    });
  }

  void _ouvrirInventaire() {
    showModalBottomSheet(context: context, builder: (context) => Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: const Center(child: Text("Inventaire : Urban Glide Standard")),
    ));
  }

  @override
  void dispose() {
    _timerBoost?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(47.190, 2.450), zoom: 15),
            markers: _markers,
          ),
          
          // HUD HAUT
          Positioned(
            top: 40, left: 20, right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Text("Niveau: $_niveau | 🪙 $_monArgent €", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                LinearProgressIndicator(value: _xp / 100, backgroundColor: Colors.white24),
              ]),
            ),
          ),

          // COCKPIT IMMERSIF (BAS)
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 280,
              decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Image du guidon
                        Image.asset('assets/images/urban_glide.jpg', fit: BoxFit.contain),
                        
                        // Compteur superposé
                        Positioned(
                          top: 140, // Ajuste cette valeur si le texte n'est pas pile sur l'écran
                          child: Column(
                            children: [
                              Text(
                                _isBoosting ? "45" : "25",
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _isBoosting ? Colors.greenAccent : Colors.white),
                              ),
                              Text("⚡ $_chargeBatterie%", style: const TextStyle(fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Boutons d'action
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(onPressed: _toggleBoost, child: Text(_isBoosting ? "BOOST!" : "BOOST")),
                        ElevatedButton(onPressed: _ouvrirInventaire, child: const Text("INV")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}