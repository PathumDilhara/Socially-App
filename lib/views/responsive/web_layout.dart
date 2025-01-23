import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/views/auth_view/login_page.dart';

import '../main_page.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: mainOrangeColor,
            ),
          );
        } else if(snapshot.hasData){
          return MainPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
