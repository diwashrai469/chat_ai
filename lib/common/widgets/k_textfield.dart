import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ktextfield extends StatelessWidget {
  const Ktextfield({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: Container(
            margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(CupertinoIcons.up_arrow)),
        hintText: "  Enter your promt...",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade600)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade600)),
      ),
    );
  }
}
