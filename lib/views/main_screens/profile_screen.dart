import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially_app/models/user_model.dart';
import 'package:socially_app/services/auth/auth_services.dart';
import 'package:socially_app/services/feeds/feed_services.dart';
import 'package:socially_app/services/users/user_services.dart';
import 'package:socially_app/widgets/reusable/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel?> _userFuture;
  late Future<Map<String, int>> _userStatsFuture;
  bool _isLoading = true;
  bool _hasError = false;
  late String _currentUserId;
  late UserService _userService;
  late FeedServices _feedServices;

  @override
  void initState() {
    super.initState();
    _userService = UserService();
    _feedServices = FeedServices();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _userFuture = _fetchUserDetails();
    _userStatsFuture = _fetchUserStats();
  }

  Future<UserModel?> _fetchUserDetails() async {
    try {
      final userId = _currentUserId;
      final user = await _userService.getUserDetailsById(userId: userId);

      setState(() {
        _isLoading = false;
        if (user == null) {
          _hasError = true;
        }
      });
      return user;
    } catch (error) {
      print('Error fetching user details: $error');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return null;
    }
  }

  Future<Map<String, int>> _fetchUserStats() async {
    try {
      final userId = AuthService().getCurrentUser()?.uid ?? '';
      final postsCount = await _feedServices.getUserPostsCount(userId);
      final followersCount = await _userService.getUserFollowersCount(userId);
      final followingCount = await _userService.getUserFollowingCount(userId);

      return {
        'posts': postsCount,
        'followers': followersCount,
        'following': followingCount,
      };
    } catch (error) {
      print('Error fetching user stats: $error');
      return {'posts': 0, 'followers': 0, 'following': 0};
    }
  }

  // Sign out method
  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    if (context.mounted) {
      GoRouter.of(context).go("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_hasError) {
            return const Center(child: Text('Error loading profile'));
          }
          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundImage: user.imageUrl.isNotEmpty
                    ? NetworkImage(user.imageUrl)
                    : const AssetImage('assets/logo.png') as ImageProvider,
              ),
              const SizedBox(height: 16),
              // User Name
              Text(
                user.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // User Bio
              Text(
                user.jobTitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Stats (Posts, Followers, Following)
              FutureBuilder<Map<String, int>>(
                future: _userStatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading stats'));
                  }
                  final stats = snapshot.data;

                  if (stats == null) {
                    return const Center(child: Text('Stats not available'));
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatColumn('Posts', stats['posts'].toString()),
                      _buildStatColumn(
                          'Followers', stats['followers'].toString()),
                      _buildStatColumn(
                          'Following', stats['following'].toString()),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),
              // Follow Button (conditional visibility)
              if (user.userId != _currentUserId)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FutureBuilder<bool>(
                    future: _userService.isFollowing(
                        currentUserId: _currentUserId,
                        userToCheckId: user.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Error checking follow status');
                      }
                      final isFollowing = snapshot.data ?? false;
                      return CustomButton(
                        onPressed: () {
                          // TODO: Implement follow/unfollow functionality
                        },
                        width: MediaQuery.of(context).size.width,
                        text: isFollowing ? 'Unfollow' : 'Follow',
                      );
                    },
                  ),
                ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomButton(
                  onPressed: () => _signOut(context),
                  width: MediaQuery.of(context).size.width,
                  text: 'Logout',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build stats column
  Widget _buildStatColumn(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
