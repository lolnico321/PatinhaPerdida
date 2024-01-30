import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:patinha/dao/anotacao_dao.dart';
import '../model/anotacao.dart';
import 'cadastro.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _HomeState();
}

class _HomeState extends State<Principal> {
  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;

  _removerAnotacao(String id) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    String uID = auth.currentUser!.uid;

    Anotacao anotacao = await AnotacaoDAO().getAnotacao(uID, id);

    for (String url in anotacao.fotos!) {
      storage.refFromURL(url).delete();
    }

    AnotacaoDAO().removerAnotacao(uID, id);
  }

  List<Widget> _carrossel(List<dynamic> fotos) {
    List<Widget> imagens = List.empty(growable: true);
    for (String imagem in fotos) {
      Padding temp = Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Image.network(
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection("anotacoes").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Erro ao recuperar os dados!",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> documentos = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    Anotacao anotacao =
                        Anotacao.fromFirestore(documentos[index]);
                    return Card(
                      child: Column(
                        children: [
                          anotacao.fotos != null
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _carrossel(anotacao.fotos!),
                                  ),
                                )
                              : Container(),
                          ListTile(
                            
                            title: Text(anotacao.texto!, ),
                            
                            // subtitle: Text(_formatarData(anotacao.data!)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            Cadastro(id: anotacao.id!),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 16),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    _removerAnotacao(anotacao.id!);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[700],
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Cadastro(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
