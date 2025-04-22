import 'package:flutter/material.dart';
import 'package:notes/models/note_model.dart';

class ListItemNoteWidget extends StatelessWidget {
  final NoteModel noteModel;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const ListItemNoteWidget({
    super.key,
    required this.noteModel,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(noteModel.title,style: TextStyle(fontWeight: FontWeight.bold),),
        Text(noteModel.description),
        Row( mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                onEditPressed();
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                onDeletePressed();
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
  }
}
