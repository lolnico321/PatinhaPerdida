import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:patinha/telas/principal.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({super.key});

  @override
  State<CadastroUsuario> createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  @override
  final  auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  void _cadastrar() async {
    String email = _emailController.text;
    String senha = _senhaController.text;
    final navigator = Navigator.of(context);

    try {
      UserCredential usuario = await auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (usuario != null) {
        print("Usuário criado com sucesso");
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Principal(),
          ),
        );
      }
    } catch (e) {
      print("Erro ao cadastrar usuário: $e");
      // Lide com o erro, exiba uma mensagem ou realize outra ação conforme necessário
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Usuário"),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: TextField(
                  controller: _senhaController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Senha",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: _cadastrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lime[700],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Cadastrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
