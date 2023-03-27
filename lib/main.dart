import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mydiary/constants/routes.dart';
import 'package:mydiary/views/Verify_email_view.dart';
import 'package:mydiary/views/login_view.dart';
import 'firebase_options.dart';
import 'views/Register_View.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
      routes: {
        // routes are basically screens and pages
        // here we are basically assigning a name to each screen so that we can navigate to each screen using navigator
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // Here connectionstate.done means if firebase is successfully initialised and connected to the server
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return const NotesView();
                } else {
                  // if user is not verified
                  return const VerifyEmailView();
                }
              } else {
                // user has not logged in
                return const LoginView();
              }
            // firebase connection is incomplete
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

// Notes view

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes'), actions: [
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
                  await FirebaseAuth.instance.signOut();
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
      ]),
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
