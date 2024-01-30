import 'package:flutter/material.dart';
import 'package:patinha/telas/cadastro_usuario.dart';
import 'package:patinha/telas/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  String? _erro;

  final auth = FirebaseAuth.instance;

  _login() async {
    final navigator = Navigator.of(context);
    try {
      final credencial = await auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );

      if (auth.currentUser != null) {
        print("Usuário logado!");
      } else {
        print("Usuário não logado!");
      }
      print(auth.currentUser);

      if (credencial.user != null) {
        navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        )); //ele manda pra outra tela, e destroi a tela atual
      }
    } on FirebaseAuthException catch (e) {
      //s segundo mostra somente o erro do firebase como logi e senhas
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'INVALID_LOGIN_CREDENTIALS') {
        setState(() {
          _erro = "Senha ou e mail incorretos";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _verificarLogin() async {
    final User? usuario = auth.currentUser;

    if (usuario != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  //para puxar outras telas - ABAS
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
       
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: Image.asset("imagens/logo.png"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: _emailController,
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text, // define o tipo de teclado
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    // Cor do texto do rótulo
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: _senhaController,
                  keyboardType: TextInputType.text, // define o tipo de teclado
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Senha",
                   
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(_erro ?? "",
                    style: const TextStyle(color: Colors.red, fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _login(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons
                              .account_box), // Adiciona um ícone (substitua pelo ícone desejado)
                          const SizedBox(
                              width:
                                  8), // Adiciona um espaçamento entre o ícone e o texto
                          Text(
                            "Entrar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
        

                  //padding botão cadastre-se
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20, 
                      ), // Ajuste o espaçamento à esquerda
                      child: ElevatedButton(
                        
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CadastroUsuario()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons
                                .account_circle), // Adiciona um ícone (substitua pelo ícone desejado)
                            const SizedBox(
                                width:
                                    8), // Adiciona um espaçamento entre o ícone e o texto
                            Text(
                              "Cadastre - se",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
