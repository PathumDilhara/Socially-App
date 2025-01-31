import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially_app/services/auth/feeds/feed_services.dart';
import 'package:socially_app/services/users/user_services.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/utils/functions/moods.dart';
import 'package:socially_app/widgets/reusable/custom_snackbar.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';
import 'package:socially_app/widgets/reusable/custom_input.dart';

import '../../models/user_model.dart';

class CreateNewScreen extends StatefulWidget {
  const CreateNewScreen({super.key});

  @override
  State<CreateNewScreen> createState() => _CreateNewScreenState();
}

class _CreateNewScreenState extends State<CreateNewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _captionController = TextEditingController();
  File? _imageFile;
  Mood _selectedMode = Mood.happy;
  bool _isUploading = false;

  // pick image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  // Handle form submission
  void _submitPost() async {
    if (_formKey.currentState?.validate() ?? false) {
      print("################################## ");

      try {
        setState(() {
          _isUploading = true;
        });

        // Check if the platform is mobile
        if (kIsWeb) {
          return;
        }

        final String postCaption = _captionController.text;
        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // fetch user details from firestore
          final UserModel? userData =
              await UserService().getUserDetailsById(userId: user.uid);
          print("###################################user data $userData");

          if (userData != null) {
            // Create new post obj with user details
            final postDetails = {
              "postCaption": postCaption,
              "mood": _selectedMode.name,
              "userId": userData.userId,
              "userName": userData.name,
              "profileImage": userData.imageUrl,
              "postImage": _imageFile,
            };

            // Save the post}
            await FeedServices().savePost(postDetails);
            print("############################# created");

            if (mounted) {
              customSnackBar(
                content: "Post created",
                color: mainOrangeColor,
                context: context,
              );
            }
          }
        }
      } catch (err) {
        print("############################# Error : ${err.toString()}");
        if (mounted) {
          customSnackBar(
            content: "Post created failed",
            color: Colors.redAccent,
            context: context,
          );
        }
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(
                  controller: _captionController,
                  labelText: "Caption",
                  icon: Icons.text_fields,
                  isObscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a caption";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                DropdownButton<Mood>(
                  value: _selectedMode,
                  items: Mood.values.map((Mood mood) {
                    return DropdownMenuItem(
                      value: mood,
                      child: Text("${mood.name} ${mood.emoji}"),
                    );
                  }).toList(),
                  onChanged: (Mood? newMode) {
                    setState(() {
                      _selectedMode = newMode ?? _selectedMode;
                    });
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: kIsWeb
                            ? Image.network(_imageFile!.path)
                            : Image.file(_imageFile!),
                      )
                    : Text("No image selected"),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: "Use Camera",
                      width: MediaQuery.of(context).size.width * 0.43,
                      onPressed: () => _pickImage(
                        ImageSource.camera,
                      ),
                    ),
                    CustomButton(
                      text: "Use Gallery",
                      width: MediaQuery.of(context).size.width * 0.43,
                      onPressed: () => _pickImage(
                        ImageSource.gallery,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                CustomButton(
                  text: kIsWeb
                      ? "Not Supported yet"
                      : _isUploading
                          ? "Uploading"
                          : "Create Post",
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    _submitPost();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
