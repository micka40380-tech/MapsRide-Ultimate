import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialisation de la DB dès le lancement avec capture d'erreur
    await DatabaseHelper.instance.database;
    runApp(const MyApp());
  } catch (e, stackTrace) {
    // Affiche l'erreur exacte et sa trace en rouge vif sur le téléphone en cas de crash
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
      home: const MainNavigation(),
    );
  }
}
