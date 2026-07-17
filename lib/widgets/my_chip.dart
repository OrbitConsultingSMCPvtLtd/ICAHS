import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  const MyChip({super.key, required this.label, this.color, this.textColor});

  final Widget label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color ?? const Color.fromARGB(45, 1, 255, 9),
      ),
      child: Center(child: label),
    );
  }
}
