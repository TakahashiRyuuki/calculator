import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'main.dart';
import 'package:decimal/decimal.dart';

class DataBase {
  Future<void> DataBaseInsert(formula, answer) async {
    var settings = new ConnectionSettings(
        host: (dotenv.env['DB_HOST']).toString(),
        port: int.parse(dotenv.get('DB_PORT')),
        user: (dotenv.env['DB_USERNAME']).toString(),
        password: (dotenv.env['DB_PASSWORD']).toString(),
        db: (dotenv.env['DB_DATABASE']).toString());
    var conn = await MySqlConnection.connect(settings);

    var result = await conn.query(
        'insert into calculator (formula,answer) values (?,?)',
        [formula, answer]);
    await conn.close();
  }

  Future<void> DataBaseDelete(int dl) async {
    String dlTarget = "";
    dlTarget = numberList[dl];
    var settings = new ConnectionSettings(
        host: (dotenv.env['DB_HOST']).toString(),
        port: int.parse(dotenv.get('DB_PORT')),
        user: (dotenv.env['DB_USERNAME']).toString(),
        password: (dotenv.env['DB_PASSWORD']).toString(),
        db: (dotenv.env['DB_DATABASE']).toString());
    var conn = await MySqlConnection.connect(settings);

    var result = await conn.query(
        'DELETE FROM `calculator` WHERE `calculator`.`number` = (?)',
        [dlTarget]);

    await conn.close();
  }

  Future DataBaseReceiving() async {
    var settings = new ConnectionSettings(
        host: (dotenv.env['DB_HOST']).toString(),
        port: int.parse(dotenv.get('DB_PORT')),
        user: (dotenv.env['DB_USERNAME']).toString(),
        password: (dotenv.env['DB_PASSWORD']).toString(),
        db: (dotenv.env['DB_DATABASE']).toString());
    var conn = await MySqlConnection.connect(settings);

    var result = await conn.query('select * from calculator');

    numberList.clear();
    formulaList.clear();
    resultList.clear();

    for (var row in result) {
      print('No: ${row[0]} 式: ${row[1]}答:${row[2]}');
      numberList.add('${row[0]}');
      formulaList.add('${row[1]}');
      resultList.add('${row[2]}');
    }
  }

  Future<void> allDataBaseDelete() async {
    var settings = new ConnectionSettings(
        host: (dotenv.env['DB_HOST']).toString(),
        port: int.parse(dotenv.get('DB_PORT')),
        user: (dotenv.env['DB_USERNAME']).toString(),
        password: (dotenv.env['DB_PASSWORD']).toString(),
        db: (dotenv.env['DB_DATABASE']).toString());
    var conn = await MySqlConnection.connect(settings);

    var result = await conn.query('TRUNCATE TABLE `calculator`');

    await conn.close();
  }
}
