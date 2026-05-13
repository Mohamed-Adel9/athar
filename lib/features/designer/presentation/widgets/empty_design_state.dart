import 'package:flutter/material.dart';

class EmptyDesignState extends StatelessWidget {
  const EmptyDesignState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.design_services_rounded,
          size: 70,
          color: Colors.white.withOpacity(.2),
        ),
        const SizedBox(height: 18),
        Text(
          'Start Creating Your Design',
          style: TextStyle(
            color: Colors.white.withOpacity(.8),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
