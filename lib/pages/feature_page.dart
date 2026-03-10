import 'package:flutter/material.dart';

class FeaturePage extends StatelessWidget {
  final String title;
  final String message;

  const FeaturePage({
    super.key,
    required this.title,
    this.message = 'Halaman ini masih dalam pengembangan.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(message)),
    );
  }
}
