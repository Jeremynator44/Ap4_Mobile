import 'package:ap4_mobile/Data/Models/platsData.dart';
import 'package:ap4_mobile/Data/Services/api.dart';
import 'package:flutter/material.dart';
import '../Widgets/custom_app_bar.dart'; // Importer la Custom AppBar
import '../Widgets/custom_bottom_nav_bar.dart';
import 'RecapCommande.dart'; // Importer la Custom Nav Bar

class DashboardPage extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  late Future<List<platsData>> _plats;
  Map<int, List<platsData>> _platsParCategorie = {};
  int _selectedCategoryId = 0;
  Map<platsData, int> _orderQuantite = {};


  @override
  void initState() {
    super.initState();
    _plats = API.getPlats().then((plats) {
      _platsParCategorie = groupPlatsParCategorie(plats);
      for (var plat in plats) {
        _orderQuantite[plat] = 0;
      }
      return plats;
    });
  }

  Map<int, List<platsData>> groupPlatsParCategorie(List<platsData> plats) {
    Map<int, List<platsData>> result = {
      0: [], // All
      1: [], // Entrées
      2: [], // Plats
      3: [], // Desserts
      4: [], // Boissons
    };
    for (var plat in plats) {
      result[plat.idCategorie]!.add(plat);
    }
    return result;
  }

  void _incrementQuantite(platsData plat) {
    if (_orderQuantite[plat]! < plat.stock) {
      setState(() {
        _orderQuantite[plat] = (_orderQuantite[plat] ?? 0) + 1;
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stock insuffisant'),
        ),
      );
    }
  }

  void _decrementQuantite(platsData plat) {
    if (_orderQuantite[plat] != null && _orderQuantite[plat]! > 0) {
      setState(() {
        _orderQuantite[plat] = (_orderQuantite[plat]! - 1);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('La quantité ne peut pas être négative'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des plats'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedCategoryId = newValue ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Catégorie',
                    ),
                    items: [
                      DropdownMenuItem(value: 0, child: Text('Tous'),),
                      DropdownMenuItem(value: 1, child: Text('Entrées'),),
                      DropdownMenuItem(value: 2, child: Text('Plats'),),
                      DropdownMenuItem(value: 4, child: Text('Desserts'),),
                      DropdownMenuItem(value: 3, child: Text('Boissons'),),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    List<platsData> orderedPlats = _orderQuantite.entries
                        .where((entry) => entry.value > 0)
                        .map((entry) => entry.key)
                        .toList();
                    final result = await Navigator.pushNamed(
                      context,
                      '/recapOrder',
                      arguments: RecapCommandeArguments(orderedPlats, _orderQuantite),
                    ) as Map<platsData, int>?;

                    if (result != null) {
                      setState(() {
                        _orderQuantite = result;  // Mise à jour des quantités au retour
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    minimumSize: Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ],
            )
          ),
          Expanded(
            child: FutureBuilder<List<platsData>>(
              future: _plats,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<platsData> plats = _selectedCategoryId == 0
                      ? snapshot.data!
                      : _platsParCategorie[_selectedCategoryId]!;
                  return GridView.builder(
                    padding: EdgeInsets.all(2.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    itemCount: plats.length,
                    itemBuilder: (context, index) {
                      final plat = plats[index];
                      return Card(
                        elevation: 4.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  child: Image.network(
                                    plat.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plat.titre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${plat.prix.toStringAsFixed(2)} €',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Stock: ${plat.stock}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          _decrementQuantite(plat);
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${_orderQuantite[plat] ?? 0}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          _incrementQuantite(plat);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur de chargement des plats.'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(), // Ajout du CustomBottomNavigationBar
    );
  }
}
