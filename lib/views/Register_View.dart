import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:mydiary/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register View'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter Your Email Here'),
          ),
          TextField(
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: 'Enter Your Password Here'),
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              final email = _email
                  .text; //we take the email and password text from controller
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  devtools.log('email already in use');
                } else if (e.code == 'weak-password') {
                  devtools.log('weak password');
                } else if (e.code == 'invalid-email') {
                  devtools.log('invalid email');
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              // login button inside register view
              onPressed: () {
                // Navigar helps in going to a particular screen using named routes we defined inside main file
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Not Login yet? Login here!'))
        ],
      ),
    );
  }
}
