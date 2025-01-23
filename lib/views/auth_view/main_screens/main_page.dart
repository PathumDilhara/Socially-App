import 'package:flutter/material.dart';
import 'package:socially_app/services/auth/auth%20_services.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            AuthService().signOut();
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
