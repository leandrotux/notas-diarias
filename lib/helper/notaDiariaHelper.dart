import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class notaDiariaHelper {
  static final notaDiariaHelper _diariaHelper = notaDiariaHelper._internal();

  Database? _db;

  factory notaDiariaHelper() {
    return _diariaHelper;
  }

  notaDiariaHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {}
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE notas_diaria (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_notas.db");

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }
}
