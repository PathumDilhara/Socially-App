import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially_app/models/user_model.dart';
import 'package:socially_app/views/auth_view/login_page.dart';
import 'package:socially_app/views/auth_view/registration_page.dart';
import 'package:socially_app/views/main_screens/single_user_screen.dart';
import 'package:socially_app/views/responsive/mobile_layout.dart';
import 'package:socially_app/views/responsive/responsive_layout.dart';
import 'package:socially_app/views/responsive/web_layout.dart';

import '../views/main_page.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) => errorPage(),
    routes: [
      // initial route
      GoRoute(
        name: "nav_layout",
        path: "/",
        builder: (context, state) => ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ),

      // Register page
      GoRoute(
        name: "register",
        path: "/register",
        builder: (context, state) => RegistrationPage(),
      ),

      // Login page
      GoRoute(
        name: "login",
        path: "/login",
        builder: (context, state) => LoginPage(),
      ),

      // main page
      GoRoute(
        name: "main",
        path: "/main",
        builder: (context, state) => MainPage(),
      ),

      // single user page
      GoRoute(
        name: "singleUser",
        path: "/singleUser",
        builder: (context, state) {
          final UserModel user = state.extra as UserModel;
          return SingleUserScreen(user: user,);
        },
      ),
    ],
  );
}

MaterialPage errorPage() {
  return MaterialPage(
    child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text("Error Page not found"),
          ),
          ElevatedButton(
            onPressed: () {
              RouterClass().router.go("/");
            },
            child: Text("Home"),
          )
        ],
      ),
    ),
  );
}
