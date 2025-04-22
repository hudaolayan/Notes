import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notes/db/notes_db_helper.dart';
import 'package:notes/models/note_model.dart';
import 'package:notes/view/add_note_screen.dart';
import 'package:notes/view/sign_in_screen.dart';
import 'package:notes/view/update_note_screen.dart';
import 'package:notes/widgets/list_item_note_widget.dart';

import '../utils/const_values.dart';
import '../utils/shared_preferences_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<NoteModel> notes = [];
  NotesDbHelper notesDbHelper = NotesDbHelper();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    notes = await notesDbHelper.getNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.app_name),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body:
          notes.isEmpty
              ? Center(
                child: Text(AppLocalizations.of(context)!.empty_notes_list),
              )
              : Padding(
                padding: EdgeInsets.all(20),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListItemNoteWidget(
                      noteModel: notes[index],
                      onEditPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    UpdateNoteScreen(note: notes[index]),
                          ),
                        );
                        getData();
                      },
                      onDeletePressed: () {
                        deleteNote(notes[index]);
                      },
                    );
                  },
                  itemCount: notes.length,
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
          getData();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  deleteNote(NoteModel note) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.delete),
          title: Text(AppLocalizations.of(context)!.delete_note_title),
          content: Text(note.title),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)!.delete),
              onPressed: () async {
                await notesDbHelper.deleteNote(id: note.id);
                Navigator.pop(context);
                getData();
              },
            ),
          ],
        );
      },
    );
  }

  signOut() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.logout),
          title: Text(AppLocalizations.of(context)!.sign_out_title),
          content: Text(AppLocalizations.of(context)!.sign_out_description),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            MaterialButton(
              child: Text(AppLocalizations.of(context)!.sign_out),
              onPressed: () async {
                await SharedPreferencesHelper().savePrefBool(
                  key: ConstValues.isLoggedIn,
                  value: false,
                );
                SharedPreferencesHelper().remove(key: ConstValues.username);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
