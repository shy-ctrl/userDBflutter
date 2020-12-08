import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Usuario {
  String nombre;
  String direccion;
  int numero;
  Usuario() {
    this.nombre = "";
    this.direccion = "";
    this.numero = 0;
  }

  setNombre(String name) {
    this.nombre = name;
  }

  setDireccion(String dir) {
    this.direccion = dir;
  }

  setNumero(int number) {
    this.numero = number;
  }

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "direccion": direccion,
      "numero": numero,
    };
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    nombre = map['nombre'];
    direccion = map['direccion'];
    numero = map['numero'];
  }
}

class UsuarioDB {
  Database _db;

  initDB() async {
    _db = await openDatabase('db_user.db', version: 1,
        onCreate: (Database db, int version) {
      db.execute(
          'CREATE TABLE usuario(id INTEGER PRIMARY KEY, nombre TEXT NOT NULL, direccion TEXT, numero INTEGER)');
    });
  }

  insert(Usuario usuario) async {
    _db.insert("usuario", usuario.toMap());
  }

  deleteUserByNumber(int number) {
    _db.rawDelete("DELETE FROM usuario WHERE numero=${number}");
  }

  deleteUserByName(String name) {
    _db.rawDelete("DELETE FROM usuario WHERE nombre=name");
  }

  deleteUserByDir(String dir) {
    _db.rawDelete("DELETE FROM usuario WHERE direccion=dir");
  }

  Future<List<Usuario>> getAllusuarios() async {
    List<Map<String, dynamic>> results = await _db.query("usuario");
    print("Long: ${results.length}");
    return results.map((map) => Usuario.fromMap(map)).toList();
  }
}
