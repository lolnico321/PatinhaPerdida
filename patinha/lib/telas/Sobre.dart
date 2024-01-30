import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: Container(
        color: Colors.white, // Cor de fundo azul
        padding: EdgeInsets.all(16.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           
            Text(
              'A cada dia, mais e mais animais são abandonados nas ruas de nossas cidades.',
              style: TextStyle(
                
                color: Colors.black, // Cor do texto branco
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                
              ),
            ),
            SizedBox(height: 18.0),
            Text(
              'Eles estão assustados, famintos e, muitas vezes, feridos. Mas juntos, podemos fazer a diferença.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Ao baixar e usar nosso aplicativo PatinhaPerdida, você pode ajudar a mapear a localização desses animais, fornecer informações vitais sobre sua condição e, finalmente, ajudar a resgatá-los.',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Cada animal merece um lar seguro, comida e amor.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Junte-se a nós na missão de resgatar animais abandonados. Seu apoio pode salvar uma vida.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Projeto criado por: Daniel, Vinicius e Artur.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16.0),
            Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.black,
              size: 48.0,
              
            ),
          ],
        ),
      ),
    );
  }
}
