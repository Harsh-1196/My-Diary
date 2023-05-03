import 'package:flutter/material.dart';
import 'package:mydiary/utilities/dialogs/generic_dialog.dart';

Future<bool> logoutDialog(BuildContext context) {
  return genericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout',
    optionsBuilder: () => {
      'Cancel': false,
      'Ok': true,
    },
  ).then((value) => value ?? false);
}
