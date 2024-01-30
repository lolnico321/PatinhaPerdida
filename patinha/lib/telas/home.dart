import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patinha/telas/Sobre.dart';
import 'package:patinha/telas/cadastro.dart';
import 'package:patinha/telas/login.dart';
import 'package:patinha/telas/principal.dart';
//import 'dart:io';
//import 'package:intl/date_symbol_data_local.dart'; 

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _telaAtual = 0;
  final auth = FirebaseAuth.instance;

  _verificarLogin() async {
    final navigator = Navigator.of(context);

    if (auth.currentUser != null) {
      print("Usuário logado!");
    } else {
      print("Usuário precisa estar logado para acesasr essa página");
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
    print(auth.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = const [Principal(), Cadastro(), Sobre(), Login()];
    return MaterialApp(
      theme: ThemeData.fallback(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Patinha Perdida",
            style: TextStyle(
              fontSize: 27.5,
              fontWeight: FontWeight.bold, // Adiciona negrito
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[700],
          actions: [
            IconButton(
                onPressed: () async {
                  await auth.signOut();
                  print(auth.currentUser);
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(pageBuilder: (BuildContext context,
                          Animation animation, Animation secondaryAnimation) {
                        return Login();
                      }, transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return new SlideTransition(
                          position: new Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      }),
                      (Route route) => false);
                },
                icon: Icon(Icons.exit_to_app),
                
                ),
          ],
        ),
        body: telas[_telaAtual],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _telaAtual,
          onTap: (tela) {
            setState(() {
              _telaAtual = tela;
            });
          },
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.blue[700],
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white70, //quandp tda um toque na tela
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.blue[700],
              icon: Icon(Icons.home),
              label: "principal",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.blue[700],
              icon: Icon(Icons.add_box),
              label: "Cadastro",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.blue[700],
              icon: Icon(Icons.search),
              label: "Historia",
            ),
             BottomNavigationBarItem(
              backgroundColor: Colors.blue[700],
              icon: Icon(Icons.person),
              label: "Login",
            ),
          ],
        ),
        
      ),
    ); 
  }
}
