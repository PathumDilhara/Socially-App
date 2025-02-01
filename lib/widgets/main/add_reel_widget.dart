import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially_app/models/user_model.dart';
import 'package:socially_app/services/reels/reel_service.dart';
import 'package:socially_app/services/reels/reel_storage_service.dart';
import 'package:socially_app/services/users/user_services.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';
import 'package:socially_app/widgets/reusable/custom_snackbar.dart';

class AddReelWidget extends StatefulWidget {
  const AddReelWidget({super.key});

  @override
  State<AddReelWidget> createState() => _AddReelWidgetState();
}

class _AddReelWidgetState extends State<AddReelWidget> {
  final TextEditingController _captionController = TextEditingController();

  File? _videoFile;
  bool _isUploading = false;

  // Pick a video from gallery
  Future<void> _pickVideo() async {
    final picker = ImagePicker();

    final pickedVideoFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideoFile != null) {
      setState(() {
        _videoFile = File(pickedVideoFile.path);
      });
    }
  }

  // upload video
  void _submitReel() async {
    if (_videoFile != null && _captionController.text.isNotEmpty) {
      try {
        // loading
        setState(() {
          _isUploading = true;
        });

        // don't allow web users to create reel
        if (kIsWeb) {
          return;
        }

        // upload video to cloud storage
        final String videoUrl = await ReelStorageService().uploadVideo(
            videoFile: _videoFile!,
            userId: FirebaseAuth.instance.currentUser!.uid);

        // get userDetails
        final UserModel? userData = await UserService()
            .getUserDetailsById(userId: FirebaseAuth.instance.currentUser!.uid);
        // Create reelDetails Map to pass to save
        final Map<String, dynamic> reelDetails = {
          "caption": _captionController.text,
          "videoUrl": videoUrl,
          "userId": FirebaseAuth.instance.currentUser!.uid,
          "userName": userData?.name,
          "profileImageUrl": userData?.imageUrl,
        };

        await ReelServices().saveReel(reelDetails);

        if (mounted) {
          Navigator.of(context).pop();
          customSnackBar(
              content: "Reel uploaded",
              color: mainOrangeColor,
              context: context);
        }
      } catch (err) {
        print("#################### Error uploading reel $err");
        if (mounted) {
          customSnackBar(
              content: "Failed to upload reel",
              color: mainOrangeColor,
              context: context);
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
    final inputBoarderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: Divider.createBorderSide(context),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  border: inputBoarderStyle,
                  focusedBorder: inputBoarderStyle,
                  enabledBorder: inputBoarderStyle,
                  labelText: "Caption",
                ),
              ),
              SizedBox(
                height: 16,
              ),
              _videoFile != null
                  ? Text(
                      "Video file path : ${_videoFile!.path}",
                      style: TextStyle(
                        color: mainWhiteColor.withValues(alpha: 0.5),
                      ),
                    )
                  : Text(
                      "No video file selected",
                      style: TextStyle(
                        color: mainWhiteColor.withValues(alpha: 0.5),
                      ),
                    ),
              SizedBox(
                height: 16,
              ),
              CustomButton(
                text: "Select Video",
                width: double.infinity,
                onPressed: () {
                  _pickVideo();
                },
              ),
              SizedBox(
                height: 16,
              ),
              CustomButton(
                text: kIsWeb
                    ? "Web not supported"
                    : _isUploading
                        ? "Uploading..."
                        : "Upload Reel",
                width: double.infinity,
                onPressed: _submitReel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
