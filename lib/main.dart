import 'package:flutter/material.dart';
import 'package:mydiary/constants/routes.dart';
import 'package:mydiary/services/auth/auth_service.dart';
import 'package:mydiary/views/Verify_email_view.dart';
import 'package:mydiary/views/login_view.dart';
import 'package:mydiary/views/notes_view.dart';
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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // Here connectionstate.done means if firebase is successfully initialised and connected to the server
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
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
