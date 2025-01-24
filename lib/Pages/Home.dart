import 'package:flutter/material.dart';
import '../Widgets/custom_app_bar.dart'; // Importer la Custom AppBar


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Page d\'Accueil'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue à la page d\'accueil !',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20), // Espacement entre les widgets
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: Text('Aller aux Paramètres'),
            ),
            SizedBox(height: 10), // Espacement
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Voir le Profil'),
            ),
          ],
        ),
      ),
    );
  }
}