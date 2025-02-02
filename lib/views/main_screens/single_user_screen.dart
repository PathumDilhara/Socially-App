import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially_app/models/user_model.dart';
import 'package:socially_app/services/feeds/feed_services.dart';
import 'package:socially_app/services/users/user_services.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';
import 'package:socially_app/widgets/reusable/custom_snackbar.dart';

class SingleUserScreen extends StatefulWidget {
  final UserModel user;
  const SingleUserScreen({super.key, required this.user});

  @override
  State<SingleUserScreen> createState() => _SingleUserScreenState();
}

class _SingleUserScreenState extends State<SingleUserScreen> {
  late Future<List<String>> _userPosts;
  late Future<bool> _isFollowing;
  late UserService _userService;
  late String _currentUseId;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _currentUseId = FirebaseAuth.instance.currentUser!.uid;
    _userPosts =
        FeedServices().getAllUsersPostImages(userId: widget.user.userId);
    _isFollowing = _userService.isFollowing(
        currentUserId: _currentUseId, userToCheckId: widget.user.userId);
  }

  // Follow & Unfollow Users
  Future<void> _toggleFollow() async {
    try {
      final isFollowing = await _isFollowing;
      if (isFollowing) {
        await _userService.unfollowUser(
          currentUserId: _currentUseId,
          userToUnfollowId: widget.user.userId,
        );
        setState(() {
          _isFollowing = Future.value(false);
        });
        if(mounted) {
          customSnackBar(
              content: "User unfollowed",
              color: mainOrangeColor,
              context: context);
        }
      } else {
        await _userService.followUser(
          currentUserId: _currentUseId,
          userToFollowId: widget.user.userId,
        );

        setState(() {
          _isFollowing = Future.value(true);
        });

        if(mounted) {
          customSnackBar(
              content: "User followed",
              color: mainOrangeColor,
              context: context);
        }
      }
    } catch (err) {
      print("############### Error toggling $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.imageUrl),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.user.jobTitle,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: mainWhiteColor.withValues(alpha: 0.5)),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            if (widget.user.userId != _currentUseId)
              FutureBuilder<bool>(
                future: _isFollowing,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: mainOrangeColor,
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error checking follow status");
                  } else if (!snapshot.hasData) {
                    return Container();
                  }

                  final isFollowing = snapshot.data!;
                  return CustomButton(
                    text: isFollowing ? "UnFollow" : "Follow",
                    width: double.infinity,
                    onPressed: _toggleFollow,
                  );
                },
              ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _userPosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: mainOrangeColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error loading posts");
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No post available");
                  }

                  final postImages = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: postImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        postImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
