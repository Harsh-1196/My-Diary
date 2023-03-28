// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mydiary/constants/routes.dart';
import 'package:mydiary/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Column(
        children: [
          const Text(
            "Press the below button to verify your email address",
            textAlign: TextAlign.right,
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Go to login view'),
          )
        ],
      ),
    );
  }
}
