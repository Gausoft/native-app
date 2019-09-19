import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final firebaseUser = await firebaseAuth.currentUser();
  runApp(MyApp(isSignedIn: firebaseUser != null));
}
