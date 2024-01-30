import 'package:cloud_firestore/cloud_firestore.dart';

class Anotacao {
  String? id;
  String? texto;//
  List<dynamic>? fotos;
  String? corPelagem; 
  String? porte;/////
  bool? coleira;//
  bool? machucado;//
  bool? desnutrido;//
  bool? docil;//

  

  Anotacao(this.texto,this.fotos, this.corPelagem, this.porte, this.coleira, this.machucado, this.desnutrido, this.docil);

  Map<String, dynamic> toFirestore() {
    return {
      "texto": texto,
      "fotos": fotos,
      "coleira": coleira,
      "cor": corPelagem,
      "porte": porte,
      "machucado": machucado,
      "desnutrido": desnutrido,
      "docil": docil,
    };
  }

  Anotacao.fromJson(String id, Map<String, dynamic> json)
      : id = id,
        texto = json["texto"],
        fotos = json["fotos"],
        coleira = json["coleira"],
        corPelagem = json["corPelagem"],
        porte = json["porte"],
        machucado = json["machucado"],
        desnutrido = json["desnutrido"],
        docil = json["docil"];

  factory Anotacao.fromFirestore(DocumentSnapshot doc) {
    final dados = doc.data()! as Map<String, dynamic>;
    return Anotacao.fromJson(doc.id, dados);
  }
}
