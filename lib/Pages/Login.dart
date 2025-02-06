import 'dart:convert';
import 'package:flutter/material.dart';
import '../Data/Models/loginData.dart';
import '../Data/Services/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  loginData? data;
  bool loading = false;
  bool isSecret = true;

  String email = '';
  String password = '';

  final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z0-3]$");
  final RegExp passwordRegex = RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$");

  final _formKey = GlobalKey<FormState>();

  _getData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    // Limiter le temps du loader à 10 secondes pour éviter les erreurs de connexion
    Future.delayed(Duration(seconds: 10)).then((value) {
      if (loading) {
        setState(() {
          loading = false;
        });
        _showErrorDialog('Une erreur de connection est survenue. Veuillez réessayer.');
      }
    });

    API.login(email, password).then((response) {
      data = loginData.fromJson(json.decode(response.body));
      setState(() {
        loading = false;
        Navigator.pushNamed(context, '/dashboard');
      });
    }).catchError((error) {
      setState(() {
        if (loading) {
          loading = false;
          _showErrorDialog(
              "L'email ou le mot de passe est incorrect. Veuillez réessayer.");
        }
      });
    });
    //print('\x1B[94m' + data.toString() + '\x1B[0m');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  void onToggleSecret() {
    setState(() {
      isSecret = !isSecret;
    });
  }

  String? onEmailRegex(String? value) {
    if (value == null || value.isEmpty || !emailRegex.hasMatch(value)) {
      return 'Entrez une adresse e-mail valide';
    }
    return null;
  }

  String? onPasswordRegex(String? value) {
    if (value == null || value.isEmpty || !passwordRegex.hasMatch(value)) {
      return 'Entrez un mot de passe valide (8 caractères minimum dont au moins une majuscule, minuscule, chiffre, caractère spécial.)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                Text(
                  'Se Connecter',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 70),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: onEmailRegex,
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          hintText: 'Ex: john.doe@gmail.com',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: isSecret,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: onPasswordRegex,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(isSecret ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              onToggleSecret();
                            },
                          ),
                          labelText: 'Mot de Passe',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _formKey.currentState?.validate() == true ? _getData : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text('Valider',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                  },
                  child: Text('Vous avez oublié votre mot de passe ?'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}