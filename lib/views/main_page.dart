import 'package:flutter/material.dart';
import 'package:socially_app/views/main_screens/create_new_screen.dart';
import 'package:socially_app/views/main_screens/feed_screen.dart';
import 'package:socially_app/views/main_screens/profile_screen.dart';
import 'package:socially_app/views/main_screens/reels_screen.dart';
import 'package:socially_app/views/main_screens/search_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    FeedScreen(),
    SearchScreen(),
    CreateNewScreen(),
    ReelsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: "Search",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_card_outlined,
            ),
            label: "Create",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.video_library,
            ),
            label: "Reels",
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
          print(_currentIndex);
        },
      ),
    );
  }
}
