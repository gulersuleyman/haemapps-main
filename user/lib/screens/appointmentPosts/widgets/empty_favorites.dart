import 'package:flutter/material.dart';

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Center(
      child: Text('Favoriler listeniz boş'),
    );
  }
}