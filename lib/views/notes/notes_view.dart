// lec 32 -> 12:49
import 'package:flutter/material.dart';
import 'package:mydiary/services/auth/auth_service.dart';
import 'package:mydiary/services/crud/notes_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';
import 'notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // here we didnt add ! sign after email
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () {
              // here we used pushNamed and not pudhNamedAndRemoveUntill as we need to display this new note on top of our home screen and not by removing it
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          //here, popup menu button requires a list as input thereofre we created an enum named MenuAction which contains logout
          PopupMenuButton<MenuAction>(
            // basically when we select the three dots then popupmenu's item is being shown
            onSelected: (value) async {
              // since we have to wait for the user to do something inside popup menu item and hence,
              // we need to wait for the user to complete action and need to show the popup menu item
              switch (value) {
                // now when the user selects the "logout" button then return show logout dialog
                case MenuAction.logout:
                  final showLogout = await logoutDialog(context);
                  if (showLogout) {
                    await AuthService.firebase().logOut();
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                // remember -> value is what programmer see in terminal and child is what the user see
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // if user exists return the streams of all notes from our database
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotesListView(
                          notes: allNotes,
                          onDelete: (note) async {
                            await _notesService.deleteNote(id: note.id);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
