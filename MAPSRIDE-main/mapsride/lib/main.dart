import 'package:flutter/material.dart';
import 'database_helper.dart'; 
import 'main_navigation.dart'; // Importation de la navigation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialisation de la DB dès le lancement
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
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