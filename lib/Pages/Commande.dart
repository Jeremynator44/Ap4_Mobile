import 'package:flutter/material.dart';
import 'package:ap4_mobile/Data/Models/platsData.dart';

class CommandeArguments {
  final Map<platsData, int> orderQuantite;
  final double total;

  CommandeArguments(this.orderQuantite, this.total);
}

class CommandePage extends StatefulWidget {
  @override
  _CommandePageState createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  late CommandeArguments args;
  final _formKey = GlobalKey<FormState>();
  final _tableController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as CommandeArguments;
  }

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finaliser la commande'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {
              'order_quantite': args.orderQuantite,
              'total': args.total,
            });
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Récapitulatif de la commande',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: args.orderQuantite.entries
                      .where((entry) => entry.value > 0)
                      .map((entry) => ListTile(
                    leading: Image.network(
                      entry.key.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(entry.key.titre),
                    subtitle: Text(
                        '${entry.key.prix.toStringAsFixed(2)} € x ${entry.value}'),
                    trailing: Text(
                      '${(entry.key.prix * entry.value).toStringAsFixed(2)} €',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
                      .toList(),
                ),
              ),
              TextFormField(
                controller: _tableController,
                decoration: InputDecoration(
                  labelText: 'Numéro de table',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez entrer un numéro valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${args.total.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final orderResult = {
                        'table_number': int.parse(_tableController.text),
                        'order_quantite': args.orderQuantite,
                        'total': args.total,
                      };
                      Navigator.pop(context, orderResult);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Confirmer la commande',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}