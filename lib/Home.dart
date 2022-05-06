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

  _exibirTelaCadastro({NotasDiarias? anotacao}) {
    String textoSalvarAtualizar = "";
    String tituloDialog = "";

    if (anotacao == null) {
      _tituloController.text = "";
      _descricaoController.text = "";
      tituloDialog = "Adicionar anotação";
      textoSalvarAtualizar = "Salvar";
    } else {
      _tituloController.text = anotacao.titulo.toString();
      _descricaoController.text = anotacao.descricao.toString();
      tituloDialog = "Atualizar anotação";
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tituloDialog),
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
                _salvarAtualizarNotasDiarias(anotacaoSelecionada: anotacao);
                Navigator.pop(context);
              },
              child: Text(textoSalvarAtualizar),
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

  _removeNotasDiarias(int? id) async {
    await _db.removerNotasDiarias(id!);
    _recuperarAnotacoes();
  }

  _salvarAtualizarNotasDiarias({NotasDiarias? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    if (anotacaoSelecionada == null) {
      NotasDiarias nota =
          NotasDiarias(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarNotasdiarias(nota);
    } else {
      anotacaoSelecionada.titulo = titulo.toString();
      anotacaoSelecionada.descricao = descricao.toString();
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarNotasDiarias(anotacaoSelecionada);
    }

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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _exibirTelaCadastro(anotacao: item);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _removeNotasDiarias(item.id);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
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
