import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';

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
      _videoFile = File(pickedVideoFile.path);
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
                text: "Upload Reel",
                width: double.infinity,
                onPressed: () {
                  // TODO
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
