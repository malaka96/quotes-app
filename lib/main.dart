import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quotes_app/firebase_options.dart';
import 'package:quotes_app/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true
      ),
      home: HomePage(),
    );
  }
}
