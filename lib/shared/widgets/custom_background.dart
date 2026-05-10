import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget? top;
  final Widget body;
  final Widget? bottom;
  final Widget? floatingActionButton;
  const CustomBackground({
    super.key,
    this.top,
    required this.body,
    this.bottom,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),

        // المحتوى الرئيسي
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              ?top,
              Expanded(child: body),
            ],
          ),
          bottomNavigationBar: bottom,
          floatingActionButton: floatingActionButton,
        ),
      ],
    );
  }
}
