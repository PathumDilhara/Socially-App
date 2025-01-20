import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';
import 'package:socially_app/widgets/reusable/custom_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  File? _imageFile; // to store image for temporarily

  Future<void> _imagePicker(ImageSource source) async {
    final _picker = ImagePicker();
    final _pickedImage = await _picker.pickImage(source: source);
    if (_pickedImage != null) {
      setState(() {
        _imageFile = File(_pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    Center(
                      child: Stack(
                        children: [
                          _imageFile != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: FileImage(_imageFile!),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: NetworkImage(
                                      "https://i.sstatic.net/l60Hf.png"),
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: () {
                                _imagePicker(ImageSource.gallery);
                              },
                              icon: Icon(
                                Icons.add_a_photo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    // Name
                    CustomInputField(
                      controller: _nameController,
                      labelText: "Name",
                      icon: Icons.person,
                      isObscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    // Email
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

                    // Job title
                    CustomInputField(
                      controller: _jobTitleController,
                      labelText: "Job Title",
                      icon: Icons.work,
                      isObscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your job title";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    // Password
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
                      height: 16,
                    ),

                    // Confirm Password
                    CustomInputField(
                      controller: _confirmPasswordController,
                      labelText: "Confirm Password",
                      icon: Icons.lock,
                      isObscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != _passwordController.text) {
                          return "Password doesn't match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    // Sign in button
                    CustomButton(
                      text: "Sign Up",
                      width: MediaQuery.of(context).size.width,
                      onPressed: () {
                        // TODO : register logic
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).go("/login");
                      },
                      child: Text(
                        "Already have an account? log in",
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
      ),
    );
  }
}
