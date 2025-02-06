import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Data/Models/platsData.dart';
import '../../Data/Models/commandeData.dart';
import '../../Data/Models/messageData.dart';


class API {
  static const String baseUrl = 'http://ap4-api-zxkbl7-100a09-192-168-145-14.traefik.me/api';

  static Future login(email, password) {
    return http.post(Uri.parse("$baseUrl/employe/authentification"), body: {
      "email": email,
      "password": password,
    });
  }

  static Future<List<platsData>> getPlats() async {
    final response = await http.get(Uri.parse('$baseUrl/plats'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => platsData.fromJson(item)).toList();
    } else {
      throw Exception('Le chargement des plats à échoué.');
    }
  }

  static Future<int> ajouterCommande(CommandeData commande) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ajoutCommande'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(commande.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final int commandeId = data['IDCOMMANDE']; // Assurez-vous que la clé correspond à votre API
      return commandeId;
    } else {
      throw Exception('Échec de création de la commande: ${response.body}');
    }
  }



  static Future<List<MessageData>> getMessages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/messages'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => MessageData.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des messages');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  static Future<MessageData> sendMessage({
    required int idEmploye,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'IDEMPLOYE': idEmploye,
          'CONTENT': content,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        return MessageData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Échec de l\'envoi du message');
      }
    } catch (e) {

      throw Exception('Erreur de connexion: $e');
    }
  }
}