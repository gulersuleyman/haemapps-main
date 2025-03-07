import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: Colors.white.withOpacity(0.1),
        ),
        child: const Icon(
          Icons.close,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
