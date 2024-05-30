import 'package:a2chat/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:a2chat/chatapp.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const A2ChatApp());
}
