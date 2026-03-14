import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDbiKpKXlljzrYZz-Tsics_RQQG2QKbg-w",
      appId: "1:720445313397:web:095adb40eaef547785833c",
      messagingSenderId: "720445313397",
      projectId: "monprojetfirebasedemo-332e9",
      authDomain: "monprojetfirebasedemo-332e9.firebaseapp.com",
      storageBucket: "monprojetfirebasedemo-332e9.firebasestorage.app",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Gestion Emploi du Temps",

      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      home: LoginScreen(),
    );

  }
}