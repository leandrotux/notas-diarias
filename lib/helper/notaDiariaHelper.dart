import 'package:flutter/material.dart';
import 'package:notas_diarias/model/NotasDiarias.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class notaDiariaHelper {
  static final String nomeTabela = "notas_diaria";

  static final notaDiariaHelper _diariaHelper = notaDiariaHelper._internal();

  Database? _db;

  factory notaDiariaHelper() {
    return _diariaHelper;
  }

  notaDiariaHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_notas.db");

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarNotasdiarias(NotasDiarias notas) async {
    var bancoDados = await db;

    int id = await bancoDados.insert(nomeTabela, notas.toMap());
    return id;
  }
}
