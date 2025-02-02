import 'package:flutter/material.dart';
import 'package:socially_app/models/reel_model.dart';
import 'package:socially_app/services/reels/reel_service.dart';
import 'package:socially_app/utils/constants/colors.dart';
import 'package:socially_app/widgets/main/reel_widget.dart';

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
      body: StreamBuilder(
        stream: ReelServices().getReels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: mainOrangeColor,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No reels available"),
            );
          }

          final List<ReelModel> reels = snapshot.data!.docs
              .map((doc) =>
                  ReelModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: reels.length,
            itemBuilder: (context, index) {
              return ReelWidget(reel: reels[index],);
            },
          );
        },
      ),
    );
  }
}
