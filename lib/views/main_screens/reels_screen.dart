import 'package:flutter/material.dart';
import 'package:socially_app/utils/constants/colors.dart';

import '../../widgets/main/add_reel_widget.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  // Open bottom sheet
  void _openAddReelModel(BuildContext context) {
    // on tap out side do not close sheet ---> showBottomSheet
    // but showModalBottomSheet do
    showBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => AddReelWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainOrangeColor,
        onPressed: () => _openAddReelModel(context),
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text("Reels"),
      ),
    );
  }
}
