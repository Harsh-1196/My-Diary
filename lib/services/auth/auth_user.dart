import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);
  // factory keyword helps us to implement the properties of another class like 'extends'
  // Here we import the "User" property from firebase and use it to check if our email is verified or not
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
  // here all we did is copied the firebase data into "AuthUser" class
}
