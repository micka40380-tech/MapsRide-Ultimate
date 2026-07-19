import 'package:flutter/material.dart';
import 'location_service.dart';
import 'database_helper.dart';

class GarageView extends StatefulWidget {
  const GarageView({super.key});

  @override
  State<GarageView> createState() => _GarageViewState();
}

class _GarageViewState extends State<GarageView> {
  bool _isAtHome = false;
  List<Map<String, dynamic>> _items = [];

  double _posX = 100;
  double _posY = 100;
  double _rotation = 0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    bool atHome = await LocationService.isAtHome();
    if (atHome) {
      final items = await DatabaseHelper.instance.getItems();
      setState(() => _items = items);
    }
    setState(() => _isAtHome = atHome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mode Aménagement")),
      body: _isAtHome
          ? Stack(
              children: [
                // Affichage des objets existants
                ..._items.map((item) => Positioned(
                      left: (item['x'] as num).toDouble(),
                      top: (item['y'] as num).toDouble(),
                      child: Transform.scale(
                        scale: (item['scale'] as num).toDouble(),
                        child: Transform.rotate(
                          angle: (item['rotation'] as num).toDouble() * (3.14 / 180),
                          child: const Icon(Icons.chair, size: 50),
                        ),
                      ),
                    )).toList(),
                // Panneau de contrôle
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.white70,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: const Icon(Icons.arrow_upward), onPressed: () => setState(() => _posY -= 10)),
                            IconButton(icon: const Icon(Icons.arrow_downward), onPressed: () => setState(() => _posY += 10)),
                            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _posX -= 10)),
                            IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => setState(() => _posX += 10)),
                          ],
                        ),
                        Slider(value: _rotation, min: 0, max: 360, onChanged: (v) => setState(() => _rotation = v)),
                        const Text("Taille de l'objet :"),
                        Slider(value: _scale, min: 0.5, max: 2.0, onChanged: (v) => setState(() => _scale = v)),
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseHelper.instance.insertItem('Canapé', 'Installé', _posX, _posY, _rotation, _scale);
                            _loadData();
                          },
                          child: const Text("Sauvegarder l'objet"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: Text("Tu n'es pas dans ton garage.")),
    );
  }
}