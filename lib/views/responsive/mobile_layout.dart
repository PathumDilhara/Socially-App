import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/views/auth_view/login_page.dart';

import '../main_screens/main_page.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         return Center(
            child: CircularProgressIndicator(
              color: mainOrangeColor,
            ),
          );
        }

        // Since we use <User> if snapshot is empty it means data/user is there
        else if (snapshot.hasData) {
          return MainPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
