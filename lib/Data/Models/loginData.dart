/// Modèle de données pour l'authentification (récupération des données de l'utilisateur).
class loginData {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String mdp;

  loginData({required this.id, required this.email, required this.firstName, required this.lastName, required this.mdp});

  factory loginData.fromJson(Map<String, dynamic> json) {
    return loginData(
      id: json['IDEMPLOYE'],
      lastName: json['NOM'],
      firstName: json['PRENOM'],
      email: json['MAIL'],
      mdp: json['MDP'],
    );
  }
}