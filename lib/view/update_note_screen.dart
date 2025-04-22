import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notes/models/note_model.dart';

import '../db/notes_db_helper.dart';

class UpdateNoteScreen extends StatelessWidget {
  final NoteModel note;
  NotesDbHelper notesDbHelper = NotesDbHelper();
  bool showErrorTitle = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  UpdateNoteScreen({super.key, required this.note}) {
    titleController.text = note.title;
    descriptionController.text = note.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.edit_note)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText:
                      showErrorTitle
                          ? AppLocalizations.of(context)!.error_note_title
                          : null,
                  prefixIcon: Icon(Icons.title),
                  label: Text(AppLocalizations.of(context)!.note_title),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.text_fields),
                  label: Text(AppLocalizations.of(context)!.note_description),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      showErrorTitle = true;
                    } else {
                      showErrorTitle = false;
                      await notesDbHelper.updateNote(
                        id: note.id,
                        title: titleController.text,
                        description: descriptionController.text,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
