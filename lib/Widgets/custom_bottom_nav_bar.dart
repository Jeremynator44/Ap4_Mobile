// bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import '../Pages/Dashboard.dart';
import '../Data/Models/platsData.dart';
import '../Pages/RecapCommande.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: "Plats",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: "Message",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          // Naviguez vers la page Dashboard
          Navigator.pushNamed(
            context,
            '/dashboard'
          );
        }
        if (index == 1) {
        // Naviguez vers la page Profile
          Navigator.pushNamed(
            context,
            '/message'
          );
        }
        if (index == 2) {
          // Naviguez vers la page Profile
          Navigator.pushNamed(
              context,
              '/profile'
          );
        }
      }
    );
  }
}