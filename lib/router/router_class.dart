import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially_app/views/auth_view/registration_page.dart';
import 'package:socially_app/views/responsive/mobile_layout.dart';
import 'package:socially_app/views/responsive/responsive_layout.dart';
import 'package:socially_app/views/responsive/web_layout.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/register",
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
