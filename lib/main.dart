import 'package:flutter/material.dart';
import 'pages/Dashboard.dart';
import 'pages/Login.dart';
import 'pages/Home.dart';
import 'pages/Settings.dart';
import 'pages/Profile.dart';
import 'pages/RecapCommande.dart';
import 'pages/Commande.dart';
import 'pages/Message.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ap4 Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => ProfilePage(),
        '/recapOrder': (context) => RecapCommandePage(),
        '/order': (context) => CommandePage(),
        '/message': (context) => MessagesScreen(),
      },
    );
  }
}
