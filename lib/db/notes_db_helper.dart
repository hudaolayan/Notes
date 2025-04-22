import 'package:notes/utils/const_values.dart';
import 'package:notes/utils/shared_preferences_helper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note_model.dart';

class NotesDbHelper {
  late Database database;
  late String username = SharedPreferencesHelper().getPrefString(
    key: ConstValues.username,
    defaultValue: "",
  );
  List<NoteModel> notes = [];

  openDatabaseFile() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE Notes (id INTEGER PRIMARY KEY,username TEXT, title TEXT, description TEXT)",
        );
      },
    );
  }

  addNote({required String title, required String description}) async {
    await openDatabaseFile();
    await database.rawInsert(
      "INSERT INTO Notes (title,description,username) VALUES ('$title','$description','$username')",
    );
    await database.close();
  }

  updateNote({
    required int id,
    required String title,
    required String description,
  }) async {
    await openDatabaseFile();
    await database.rawUpdate(
      "UPDATE Notes Set title='$title', description= '$description' WHERE id= $id",
    );
    await database.close();
    getNotes();
  }

  deleteNote({required int id}) async {
    await openDatabaseFile();
    await database.rawDelete("DELETE FROM Notes WHERE id= $id");
    await database.close();
    getNotes();
  }

  getNotes() async {
    await openDatabaseFile();
    List<Map<String, dynamic>> maps = await database.rawQuery(
      "SELECT * FROM Notes",
    );
    notes.clear();
    for (var element in maps) {
      notes.add(
        NoteModel(
          id: element['id'],
          title: element['title'],
          description: element['description'],
        ),
      );
    }
    await database.close();
    return notes;
  }
}
