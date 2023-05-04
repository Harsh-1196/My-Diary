import 'package:flutter/material.dart';
import 'package:mydiary/services/crud/notes_service.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallBack onDelete;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final shouldDelete = await deleteDialog(context);
                if (shouldDelete) {
                  onDelete(note);
                }
              },
            ));
      },
    );
  }
}
