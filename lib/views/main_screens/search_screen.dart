import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially_app/models/user_model.dart';
import 'package:socially_app/services/users/user_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

  Future<void> _fetchAllUsers() async {
    try {
      final List<UserModel> users = await UserService().getAllUsers();
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
      });
    } catch (err) {
      print("Error fetching users $err");
    }
  }

  // search users
  void _searchUsers(String query) {
    setState(() {
      _filteredUsers = _allUsers
          .where(
            (user) => user.name.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  // navigate to single user page
  void _navigateToSingleUserPage(UserModel user) {
    GoRouter.of(context).push("/singleUser", extra: user);
  }

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorderStyle = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Search users"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                border: inputBorderStyle,
                focusedBorder: inputBorderStyle,
                enabledBorder: inputBorderStyle,
                filled: true,
                hintText: "Search",
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                ),
              ),
              onChanged: _searchUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.imageUrl.isNotEmpty
                        ? NetworkImage(user.imageUrl)
                        : AssetImage("assets/logo.png") as ImageProvider,
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.jobTitle),
                  onTap: () => _navigateToSingleUserPage(user),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
