import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSqLite {
  Future<Database>openConnection() async {
    final databasePath =
        await getDatabasesPath(); //string aonde ele vai guardar o banco
    final databaseFinalPath =
        join(databasePath, 'SQLITE_EXEMPLE'); //String concatenada
    return await openDatabase(databaseFinalPath, version: 3,
        //ao abrir a conexão com o banco de dados esse método é executado
        onConfigure: (db) async {
      await db.execute('PRAGMA foreing_keys= ON');
    },
        //se ele estiver abrindo o app pela primeira vez, esse método seŕa executado
        onCreate: (Database db, int version) {
      print('On Create');
      final batch = db.batch();
      batch.execute('''
        create table teste(
            id Integer primary key autoincrement,
            nome varchar(200)
      )
      ''');
      batch.execute('''
        create table produto(
            id Integer primary key autoincrement,
            nome varchar(200)
      )
      ''');
      batch.execute('''
        create table categoria(
            id Integer primary key autoincrement,
            nome varchar(200)
      )
      ''');
      batch.commit();
    },
        //será chamado sempre que houver uma alteração  no version(incremetal)
        onUpgrade: (Database db, int oldVersion, int version) {
      print('On Upgrade');
      final batch = db.batch();
      //se a versão old for igual a 1 ele executa
      if (oldVersion == 1) {
        batch.execute('''
        create table produto(
            id Integer primary key autoincrement,
            nome varchar(200)
      )
      ''');
        batch.execute('''
        create table categoria(
            id Integer primary key autoincrement,
            nome varchar(200)
      )
      ''');
      }
      if (oldVersion == 2) {
        batch.execute('''
        create table categoria(
            id Integer primary key autoincrement,
            nome varchar(200)
      )
      ''');
      }
      batch.commit();
    },
        //será chamado sempre que houver uma alteração no version(decremental)
        onDowngrade: (Database db, int oldVersion,
            int version) {}); //abrir uma conexão,e dizer aonde ele vai guardar o banco
  }
}
