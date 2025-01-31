import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially_app/services/auth/auth_services.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Sign out method
  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    if (context.mounted) {
      GoRouter.of(context).go("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(
          text: "Logout",
          width: MediaQuery.of(context).size.width,
          onPressed: () => _signOut(context),
        ),
      ),
    );
  }
}
