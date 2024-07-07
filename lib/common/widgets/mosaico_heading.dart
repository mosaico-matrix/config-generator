import 'package:flutter/material.dart';

class MosaicoHeading extends StatelessWidget {

  final String text;
  const MosaicoHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white));
  }
}
