import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Modèle de données pour la récupération des plats (récupération des données des plats).
class platsData {
  final int id;
  final int idCategorie;
  final String titre;
  final String description;
  final double prix;
  final int stock;
  final String image;

  platsData({required this.id, required this.idCategorie, required this.titre, required this.description, required this.prix, required this.stock, required this.image});

  factory platsData.fromJson(Map<String, dynamic> json) {
    return platsData(
      id: json['IDPRODUIT'],
      idCategorie: json['IDCATEGORIE'],
      titre: json['TITRE'],
      description: json['DESCRIPTION'],
      prix: (json['PRIXHT']).toDouble(),
      stock: json['STOCK'],
      image: json['URLPHOTO'],
    );

  }
}