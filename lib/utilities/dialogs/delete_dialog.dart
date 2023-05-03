import 'package:flutter/material.dart';
import 'package:mydiary/utilities/dialogs/generic_dialog.dart';

Future<bool> deleteDialog(BuildContext context) {
  return genericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to delete this item',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
