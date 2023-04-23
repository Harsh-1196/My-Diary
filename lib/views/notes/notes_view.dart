// lec 29 -> 16:09
import 'package:flutter/material.dart';
import 'package:mydiary/services/auth/auth_service.dart';
import 'package:mydiary/services/crud/notes_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

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
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNoteRoute);
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
                  final showLogout = await showLogoutDialog(context);
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
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('waiting to get all notes...');
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

// logout popup menu
Future<bool> showLogoutDialog(BuildContext context) {
  // here showdialog can only return optional bool as the user can tap outside the box and then dialog cannot return its value
  // since user can tap outide thats why show dialog return optional bool and not compulsorily bool
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to Log Out?'),
        // actions are list of buttons which we would see after the heading text
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'))
        ],
      );
    },
    // since user can tap outide the box to cancel therefore we wrote here that either you can return us a value
    // or you can also return false anytime the value has not passed
  ).then((value) => value ?? false);
}
