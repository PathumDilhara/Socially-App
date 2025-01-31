import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially_app/models/post_model.dart';
import 'package:socially_app/services/auth/feeds/feed_services.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/main/post_widget.dart';
import 'package:socially_app/widgets/reusable/custom_snackbar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  // Handle post delete
  Future<void> _deletePost({
    required String postId,
    required String postUrl,
    required BuildContext context,
  }) async {
    try {
      await FeedServices().deletePost(postId: postId, postUrl: postUrl);
      customSnackBar(
        content: "Post deleted",
        color: mainOrangeColor,
        context: context,
      );
    } catch (err) {
      print("####################### Error deleting post $err");
      customSnackBar(
        content: "Error deleting post",
        color: Colors.redAccent,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FeedServices().getPostStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: mainOrangeColor,
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Failed to fetch posts"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No posts available"),
            );
          }

          final List<PostModel> posts = snapshot.data!;

          // Easy, lazy loading is default enabled
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Column(
                children: [
                  PostWidget(
                    postModel: post,
                    onEdit: () {},
                    onDelete: () async {
                      await _deletePost(
                          postId: post.postId,
                          postUrl: post.postURL,
                          context: context);
                    },
                    currentUserId: FirebaseAuth.instance.currentUser?.uid ?? "",
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
