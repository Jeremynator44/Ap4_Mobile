import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Ap4 Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyConnexionPage(title: 'L\'Ancre de Breizh'),
    );
  }
}

class MyConnexionPage extends StatefulWidget {
  const MyConnexionPage({super.key, required this.title});


  final String title;

  @override
  State<MyConnexionPage> createState() => _MyConnexionPageState();
}

class _MyConnexionPageState extends State<MyConnexionPage> {

  void start() {
    setState(() {
      print('bang bang bang');
    });
  }

  void Validation() {
    setState(() {
      // Appel de l'API

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 35),
              child: Text("Connexion",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),

            const Padding(padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  hintText: 'Entrez une adresse mail',
                  labelText: 'Email *',
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.key),
                  border: OutlineInputBorder(),
                  hintText: 'Entrez un mot de passe',
                  labelText: 'Mot de Passe *',
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: ElevatedButton(
                  onPressed: Validation,
                  child: const Text("Valider")
              ),
            ),
          ],
        ),
      ),
    );
  }
}
