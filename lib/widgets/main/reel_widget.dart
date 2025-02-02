import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially_app/models/reel_model.dart';
import 'package:socially_app/services/reels/reel_service.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/main/video_player_widget.dart';

class ReelWidget extends StatelessWidget {
  final ReelModel reel;
  const ReelWidget({
    super.key,
    required this.reel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: reelBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(reel.profileImageUrl),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  reel.userName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              reel.caption,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayerWidget(videoUrl: reel.videoUrl),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_outline_rounded),
                ),
                Spacer(),
                if (reel.userId == FirebaseAuth.instance.currentUser!.uid)
                  IconButton(
                    onPressed: () => ReelServices().deleteReel(reel: reel),
                    icon: Icon(Icons.delete),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
