import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:patinha/telas/home.dart';

Future<void> main() async {
  const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyAqz-LnI-5SxoVjatHOZsTBrOgAkeWWts0", 
    appId: "1:210595286844:android:47769d3381b55d097c1839", 
    messagingSenderId: "210595286844",
    projectId: "conexao-5c740",
    storageBucket: "conexao-5c740.appspot.com");

    const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBrRlGzwIY105yuBFKNZhhU3wV4NTy9e94", 
    appId: "1:210595286844:ios:c769cbb53dc6c75f7c1839", 
    messagingSenderId: "210595286844",
    projectId: "conexao-5c740",
    storageBucket: "conexao-5c740.appspot.com" );

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: Platform.isAndroid ? android : ios);

    runApp(const MaterialApp(
    localizationsDelegates: [ //para dizer para o Material, ele vai puxar esses dados. esses sao os basicoa para ela funcionar
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate, 
      GlobalCupertinoLocalizations.delegate 
    ],
  supportedLocales: [
    Locale("pt"),
  ],
  home: Home(),
  debugShowCheckedModeBanner: false,
  ),);

}

