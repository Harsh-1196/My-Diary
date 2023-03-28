import 'package:flutter/material.dart';
import 'package:mydiary/constants/routes.dart';
import 'package:mydiary/services/auth/auth_exception.dart';
import 'package:mydiary/services/auth/auth_service.dart';
import '../utilities/error_dialog.dart';

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
              AuthService.firebase().sendEmailVerification();
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                if (!mounted) return;
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                if (!mounted) return;
                await showErrorDialog(
                  context,
                  'weak password',
                );
              } on EmailAlreadyInUseAuthException {
                if (!mounted) return;
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on InvalidEmailAuthException {
                if (!mounted) return;
                await showErrorDialog(
                  context,
                  'invalid email address',
                );
              } on GenericAuthException {
                if (!mounted) return;
                await showErrorDialog(
                  context,
                  'Failed to register',
                );
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
