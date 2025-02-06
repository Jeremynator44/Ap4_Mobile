/// Modèle de données pour l'ajout de commande.
class CommandeData {
  final int numTable;
  static const int ETAT_INITIAL = 1;

  CommandeData({
    required this.numTable,
  });

  Map<String, dynamic> toJson() {
    return {
      'NUMTABLE': numTable,
      'IDETAT': ETAT_INITIAL,
      'IDFACTURE': null,
      'IDEMPLOYE': 504,
      'DATE_COMMANDE': DateTime.now().toIso8601String(),
    };
  }
}
