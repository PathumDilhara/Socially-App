import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socially_app/models/post_model.dart';
import 'package:socially_app/services/auth/feeds/feed_services.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/utils/functions/moods.dart';
import 'package:socially_app/widgets/reusable/custom_snackbar.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String currentUserId;

  const PostWidget({
    super.key,
    required this.postModel,
    required this.onEdit,
    required this.onDelete,
    required this.currentUserId,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isLiked = false;

  // Check if the user has liked the post
  Future<void> _checkIfUserLiked() async {
    final bool hasLiked = await FeedServices().hasUserLikedPost(
      postId: widget.postModel.postId,
      userId: widget.currentUserId,
    );
    print("############################### ${widget.currentUserId} , $hasLiked");
    if (mounted) {
      setState(() {
        _isLiked = hasLiked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkIfUserLiked();
  }

  // Method to like and dis like a post
  void _likeOrDisLikePost() async {
    try {
      if (_isLiked) {
        await FeedServices().disLikePost(
          postId: widget.postModel.postId,
          userId: widget.currentUserId,
        );

        setState(() {
          _isLiked = false;
        });

        if (mounted) {
          customSnackBar(
            content: "Post unliked",
            color: mainOrangeColor,
            context: context,
          );
        }
      } else {
        await FeedServices().likePost(
          postId: widget.postModel.postId,
          userId: widget.currentUserId,
        );

        setState(() {
          _isLiked = true;
        });

        if (mounted) {
          customSnackBar(
              content: "Post liked", color: mainOrangeColor, context: context);
        }
      }
    } catch (err) {
      print("###################################${err.toString()}");
      if (mounted) {
        customSnackBar(
            content: "Failed to liked or unlike", color: Colors.redAccent, context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // date formatter intl
    final formattedDate =
        DateFormat("dd/MM/yyyy HH:mm").format(widget.postModel.dateOfPublish);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: webBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  widget.postModel.profileImage.isEmpty
                      ? "https://i.sstatic.net/l60Hf.png"
                      : widget.postModel.profileImage,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.postModel.userName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                        fontSize: 10,
                        color: mainWhiteColor.withValues(alpha: 0.4)),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
              color: mainPurpleColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "Feeling ${widget.postModel.mood.name}${widget.postModel.mood.emoji}",
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.postModel.postCaption,
            style: TextStyle(
              color: mainWhiteColor.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.postModel.profileImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.postModel.postURL,
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: mainOrangeColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    color: Colors.red,
                  );
                },
              ),
            ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _likeOrDisLikePost,
                    icon: Icon(
                     _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? mainOrangeColor : mainWhiteColor,
                    ),
                  ),
                  Text("${widget.postModel.noOfLikes} likes"),
                ],
              ),
              if (widget.postModel.userId == widget.currentUserId)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildDialogOptions(
                                context: context,
                                icon: Icons.edit,
                                text: "Edit",
                                onTap: () {},
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  color: mainWhiteColor.withValues(alpha: 0.5),
                                ),
                              ),
                              _buildDialogOptions(
                                context: context,
                                icon: Icons.delete,
                                text: "Delete",
                                onTap: () {
                                  widget.onDelete();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDialogOptions(
      {required BuildContext context,
      required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 12,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mainWhiteColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
