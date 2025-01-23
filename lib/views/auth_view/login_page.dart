import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially_app/services/auth/auth%20_services.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/custom_snackbar.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';
import 'package:socially_app/widgets/reusable/custom_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await AuthService().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
      );

      //show snackbar
      if (context.mounted) {
        customSnackBar(
          content: "User sign in successfully",
          color: mainOrangeColor,
          context: context,
        );
      }

      if (context.mounted) {
        GoRouter.of(context).go("/main");
      }
    } catch (err) {
      print(err.toString());
      //show snackbar
      if (context.mounted) {
        customSnackBar(
          content: "User sign in failed",
          color: Colors.redAccent,
          context: context,
        );
      }
    }
  }

  // Sign in with google
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
     await AuthService().signInWithGoogle();

      //show snackbar
      if (context.mounted) {
        customSnackBar(
          content: "User sign in successfully",
          color: mainOrangeColor,
          context: context,
        );
      }

      if (context.mounted) {
        GoRouter.of(context).go("/main");
      }
    } catch (err) {
      print(err.toString());
      if (context.mounted) {
        customSnackBar(
          content: "User sign in failed",
          color: Colors.redAccent,
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            Image.asset(
              "assets/logo.png",
              height: 68,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInputField(
                    controller: _emailController,
                    labelText: "email",
                    icon: Icons.email,
                    isObscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
                        return "Please enter valid your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomInputField(
                    controller: _passwordController,
                    labelText: "Password",
                    icon: Icons.lock,
                    isObscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        // firebase require this
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    text: "Log in",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await _signInWithEmailAndPassword(context);
                        _emailController.clear();
                        _passwordController.clear();
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Sign in with Google to access the app's features",
                    style: TextStyle(
                      fontSize: 14,
                      color: mainWhiteColor.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    text: "Sign in with Google",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () => _signInWithGoogle(context),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).go("/register");
                    },
                    child: Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(
                        color: mainWhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
