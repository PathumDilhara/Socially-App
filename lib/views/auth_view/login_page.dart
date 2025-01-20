import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';
import 'package:socially_app/widgets/reusable/custom_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                    onPressed: () {
                      // TODO : Log in method
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
                    onPressed: () {
                      // TODO : Google log in
                    },
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
