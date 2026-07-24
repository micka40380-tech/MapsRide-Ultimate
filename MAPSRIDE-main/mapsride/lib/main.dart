import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main_navigation.dart'; // Importation de la navigation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialisation de la DB dès le lancement avec capture d'erreur
    await DatabaseHelper.instance.database;
    runApp(const MyApp());
  } catch (e, stackTrace) {
    // Si la base de données ou le démarrage plante, l'app l'affiche direct en rouge sur le téléphone !
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red[900],
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  "ERREUR AU LANCEMENT :\n\n$e\n\n$stackTrace",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maps Ride',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainNavigation(), // Point d'entrée modifié vers la navigation
    );
  }
}
