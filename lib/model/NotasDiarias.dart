class NotasDiarias {
  int? id;
  String? titulo;
  String? descricao;
  String? data;

  NotasDiarias(this.titulo, this.descricao, this.data);

  NotasDiarias.fromMap(Map map) {
    this.id = map["id"];
    this.titulo = map["titulo"];
    this.descricao = map["descricao"];
    this.data = map["data"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "titulo": titulo,
      "descricao": descricao,
      "data": data,
    };

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}
