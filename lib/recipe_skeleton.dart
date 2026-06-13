import 'package:flutter/material.dart';

class RecipeSkeleton extends StatelessWidget {
  const RecipeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, i) {
        return Container(
          margin: const EdgeInsets.all(10),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }
}