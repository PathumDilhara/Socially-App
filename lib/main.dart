import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socially_app/views/responsive/mobile_layout.dart';
import 'package:socially_app/views/responsive/responsive_layout.dart';
import 'package:socially_app/views/responsive/web_layout.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),
    );
  }
}
