import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDbHelper {
  late Database database;

  openDatabaseFile() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'user.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE User (username TEXT PRIMARY KEY, password TEXT)",
        );
      },
    );
  }

  addUser({required String username, required String password}) async {
    await openDatabaseFile();
    await database.rawInsert(
      "INSERT INTO User (username,password) VALUES ('$username','$password')",
    );
    await database.close();
  }

  checkIfUserExists({required String username}) async {
    await openDatabaseFile();
    List<Map<String, dynamic>> result = await database.rawQuery(
      "SELECT * FROM User WHERE username = '$username'",
    );
    await database.close();
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  signInUser({required String username, required String password}) async {
    await openDatabaseFile();
    List<Map<String, dynamic>> result = await database.rawQuery(
      "SELECT * FROM User WHERE username = '$username' AND password ='$password'",
    );

    await database.close();
    return result.isNotEmpty;
  }
}
