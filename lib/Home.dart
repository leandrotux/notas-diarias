import 'package:flutter/material.dart';
import 'package:notas_diarias/helper/notaDiariaHelper.dart';
import 'package:notas_diarias/model/NotasDiarias.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  var _db = notaDiariaHelper();

  List<NotasDiarias> _anotacoes = List.empty();

  _exibirTelaCadastro() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar anotação"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Titulo",
                  hintText: "Digite título...",
                ),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintText: "Digite a descrição....",
                ),
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: () {
                _salvarNotasDiarias();
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<NotasDiarias> listaTemporaria = List.empty(growable: true);

    for (var item in anotacoesRecuperadas) {
      NotasDiarias anotacao = NotasDiarias.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });

    listaTemporaria = List.empty();
  }

  _salvarNotasDiarias() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    NotasDiarias nota =
        NotasDiarias(titulo, descricao, DateTime.now().toString());

    int resultado = await _db.salvarNotasdiarias(nota);
    print("Salvar nota: " + resultado.toString());

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");
    var formatador = DateFormat.yMd("pt_BR");
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _anotacoes.length,
                itemBuilder: (context, index) {
                  final item = _anotacoes[index];

                  return Card(
                    child: ListTile(
                      title: Text("${item.titulo}"),
                      subtitle: Text(
                          "${_formatarData(item.data.toString())} - ${item.descricao}"),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
