import 'package:flutter/material.dart';
import '../Widgets/custom_app_bar.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Page des Paramètres'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue à la page des paramètres !',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20), // Espacement entre les widgets
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Text('Aller au Profil'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retour à la page précédente
              },
              child: Text('Revenir à la Page Précédente'),
            ),
          ],
        ),
      ),
    );
  }
}
