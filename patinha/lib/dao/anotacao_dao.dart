import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patinha/model/anotacao.dart';

class AnotacaoDAO {
  final CollectionReference colecao =
      FirebaseFirestore.instance.collection("anotacoes");

  Future<void> addAnotacao(Anotacao anotacao, String doc) {
    return colecao.add(anotacao.toFirestore());
  }

  Future<List<Anotacao>> getAnotacoes(String doc) async {
    final QuerySnapshot resultado =
        await colecao.get();

    final List<DocumentSnapshot> lista = resultado.docs;

    return lista.map((DocumentSnapshot documento) {
      return Anotacao.fromFirestore(documento);
    }).toList();
  }

  Future<Anotacao> getAnotacao(String doc, String anotacao) async {
    final DocumentSnapshot documento =
        await colecao.doc(anotacao).get();
    return Anotacao.fromFirestore(documento);
  }

  Future<void> removerAnotacao(String doc, String anotacao) {
    return colecao.doc(doc).collection("anotacao").doc(anotacao).delete();
  }
}
