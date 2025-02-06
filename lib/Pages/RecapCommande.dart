import 'package:flutter/material.dart';
import 'package:ap4_mobile/Data/Models/platsData.dart';

import '../Widgets/custom_app_bar.dart';
import '../Widgets/custom_bottom_nav_bar.dart';
import 'Commande.dart';

class RecapCommandeArguments {
  final List<platsData> plats;
  final Map<platsData, int> quantite;

  RecapCommandeArguments(this.plats, this.quantite);
}

class RecapCommandePage extends StatefulWidget {
  @override
  _RecapCommandePageState createState() => _RecapCommandePageState();
}

class _RecapCommandePageState extends State<RecapCommandePage> {
  late RecapCommandeArguments args;
  late Map<platsData, int> _orderQuantite;
  double total = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as RecapCommandeArguments;
      _orderQuantite = Map.from(args.quantite);
    _calculateTotal();
  }

  void _calculateTotal() {
    total = 0;
    _orderQuantite.forEach((plat, quantite) {
      total += plat.prix * quantite;
    });
  }

  void _updateQuantite(platsData plat, int delta) {
    setState(() {
      int newQuantite = (_orderQuantite[plat] ?? 0) + delta;
      if (newQuantite >= 0 && newQuantite <= plat.stock) {
        _orderQuantite[plat] = newQuantite;
        _calculateTotal();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newQuantite < 0
                ? 'La quantité ne peut pas être négative'
                : 'Stock insuffisant'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Récapitulatif de la commande'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _orderQuantite);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: args.plats.length,
              itemBuilder: (context, index) {
                final plat = args.plats[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Image du plat
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            plat.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        // Informations du plat
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plat.titre,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${plat.prix.toStringAsFixed(2)} €',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    color: Colors.red,
                                    onPressed: () => _updateQuantite(plat, -1),
                                  ),
                                  Text(
                                    '${_orderQuantite[plat]}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle),
                                    color: Colors.green,
                                    onPressed: () => _updateQuantite(plat, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Prix total pour ce plat
                        Text(
                          '${(plat.prix * _orderQuantite[plat]!).toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Total et bouton de validation
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${total.toStringAsFixed(2)} €',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/order',
                      arguments: CommandeArguments(_orderQuantite, total),
                    ) as Map<String, dynamic>?;

                    if (result != null) {
                      if (result['table_number'] != null) {
                        // La commande a été validée
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/dashboard',
                                (route) => false
                        );
                      } else {
                        // L'utilisateur est revenu en arrière
                        setState(() {
                          if (result['order_quantite'] != null) {
                            _orderQuantite = result['order_quantite'];
                            _calculateTotal();
                          }
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Finaliser la commande',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}