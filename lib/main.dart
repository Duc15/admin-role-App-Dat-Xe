import 'package:admin_uber_web_panel/dashboard/side_navigation_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBoJ4lOLPcSjxLf3l1k5u4Q_QDJ6B1avyY",
          authDomain: "app-dat-xe-38f38.firebaseapp.com",
          databaseURL: "https://app-dat-xe-38f38-default-rtdb.firebaseio.com",
          projectId: "app-dat-xe-38f38",
          storageBucket: "app-dat-xe-38f38.appspot.com",
          messagingSenderId: "299269538562",
          appId: "1:299269538562:web:745315d56b13a35d24381b"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SideNavigationDrawer(),
    );
  }
}
// run = flutter run -d chrome --web-renderer html
