import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:patinha/dao/anotacao_dao.dart';
import 'package:patinha/model/anotacao.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key, this.id});

  final String? id;

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // ---------------------------------------------------------------------//
  final TextEditingController _textoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _corPelagemController = TextEditingController();
  final TextEditingController _porteController = TextEditingController();
  bool _coleira = false;
  bool _docil = false;
  bool _desnutrindo = false;
  bool _machucado = false;
  // final TextEditingController _porteController = TextEditingController();

  XFile? _imagem;
  Anotacao? _anotacao;
  bool _carregando = false;
  final List<File> _imagens = List.empty(growable: true);
  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;

  Future<void> _abrirCalendario(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        _dataController.text = DateFormat("dd/MM/yyyy").format(data).toString();
      });
    }
  }

  //Verificar se o usuário informou que o animal contém coleira ou não e definir um valor para o _resultColeira

  _capturarFoto({bool camera = true}) async {
    XFile? temp;
    final ImagePicker picker = ImagePicker();

    if (camera) {
      temp = await picker.pickImage(source: ImageSource.camera);
    } else {
      temp = await picker.pickImage(source: ImageSource.gallery);
    }
    if (temp != null) {
      setState(() {
        _imagem = temp;
      });
    }
  }

  String _gerarNome() {
    final agora = DateTime.now();
    return agora.microsecondsSinceEpoch.toString();
  }

  Future<List<String>?> _salvarFoto(String id) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    // final FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference pastaFotos = pastaRaiz.child(id).child("fotos");
    Reference arquivo;

    List<String> temp = List.empty(growable: true);

    try {
      for (File foto in _imagens) {
        arquivo = pastaFotos.child("${_gerarNome()}.jpg");
        TaskSnapshot task = await arquivo.putFile(foto);
        String url = await task.ref.getDownloadURL();
        temp.add(url);
      }

      return temp;
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      print(e);
      return null;
    }
  }

  _salvarAnotacao({Anotacao? anotacao}) async {
    setState(() {
      _carregando = true;
    });

    final FirebaseAuth auth = FirebaseAuth.instance;

    String uID = auth.currentUser!.uid;
    final navigator = Navigator.of(context);
    String texto = _textoController.text;
    String cor = _corPelagemController.text;
    String porte = _porteController.text;
    List<String>? fotos = await _salvarFoto(uID);
    bool? desnutrido = _desnutrindo;   
    bool? coleira = _coleira;
    bool? machucado = _machucado;
    bool? docil = _docil;

    if (anotacao == null) {
      Anotacao anotacao = Anotacao(texto, fotos, cor, porte, desnutrido, coleira, machucado, docil);
      AnotacaoDAO().addAnotacao(anotacao, uID);
    } else {
      
    }

    setState(() {
      _carregando = false;
    });
    navigator.pop();
  }

  _adicionarFoto() {
    setState(() {
      _imagens.add(File(_imagem!.path));
    });
  }

  List<Widget> _carrossel() {
    List<Widget> imagens = List.empty(growable: true);
    for (File imagem in _imagens) {
      Padding temp = Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Image.file(
          imagem,
          fit: BoxFit.cover,
          width: 200,
        ),
      );
      imagens.add(temp);
    }
    return imagens;
  }

  @override
  void dispose() {
    _textoController.dispose();
    _corPelagemController.dispose();
    _porteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      //  _recuperarAnotacao(widget.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () => _salvarAnotacao(anotacao: _anotacao),
                icon: const Icon(Icons.save),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              top: 32,
              left: 32,
              right: 32,
              bottom: 64,
            ),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.blue[700]),
                      onPressed: () => _capturarFoto(),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.blue[700]),
                      onPressed: () => _capturarFoto(camera: false),
                      icon: const Icon(Icons.image),
                      label: const Text("Galeria"),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _imagem != null
                      ? Image.file(
                          File(_imagem!.path),
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(children: [
                    TextButton.icon(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.blue[700]),
                        onPressed: () => _adicionarFoto(),
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text("Adicionar foto")),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _carrossel(),
                        ),
                      ),
                    ),
                  ]),
                ),
                TextField(
                  controller: _textoController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Anotação",
                  ),
                ),
                TextField(
                  controller: _corPelagemController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: "cor"),
                ),
                TextField(
                  controller: _porteController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: "Porte"),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 28.0, left: 1.0, right: 20.0), // Ajusta a posição
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Cor de fundo
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      "O cachorro está desnutrido?",
                      style: TextStyle(
                        color: Colors.black, // Cor do texto
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _desnutrindo,
                    onChanged: (bool valor) {
                      setState(() {
                        _desnutrindo = valor;
                      });
                    },
                    activeColor: Colors.lightBlue, // Cor quando ativado
                    tileColor: Colors.black, // Cor do bloco do tile
                    controlAffinity: ListTileControlAffinity
                        .trailing, // Move o switch para o final
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 28.0, left: 1.0, right: 20.0), // Ajusta a posição
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Cor de fundo
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      "O cachorro parece docil?",
                      style: TextStyle(
                        color: Colors.black, // Cor do texto
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _docil,
                    onChanged: (bool valor) {
                      setState(() {
                        _docil = valor;
                      });
                    },
                    activeColor: Colors.blue, // Cor quando ativado
                    tileColor: Colors.black, // Cor do bloco do tile
                    controlAffinity: ListTileControlAffinity
                        .trailing, // Move o switch para o final
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 28.0, left: 1.0, right: 20.0), // Ajusta a posição
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Cor de fundo
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      "O cachorro está machucado?",
                      style: TextStyle(
                        color: Colors.black, // Cor do texto
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _machucado,
                    onChanged: (bool valor) {
                      setState(() {
                        _machucado = valor;
                      });
                    },
                    activeColor: Colors.blue, // Cor quando ativado
                    tileColor: Colors.black, // Cor do bloco do tile
                    controlAffinity: ListTileControlAffinity
                        .trailing, // Move o switch para o final
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 28.0, left: 1.0, right: 20.0), // Ajusta a posição

                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Cor de fundo
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      "O cachorro está com coleira?",
                      style: TextStyle(
                        color: Colors.black, // Cor do texto
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _coleira,
                    onChanged: (bool valor) {
                      setState(() {
                        _coleira = valor;
                      });
                    },
                    activeColor: Colors.blue, // Cor quando ativado
                    tileColor: Colors.black, // Cor do bloco do tile
                    controlAffinity: ListTileControlAffinity
                        .trailing, // Move o switch para o final
                  ),
                ),
              ]),
            ),
          ),
        ),
        if (_carregando)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if (_carregando)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
