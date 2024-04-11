// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_ai/features/presentation/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Ktextfield extends StatelessWidget {
  final HomeBloc homeBloc;

  final TextEditingController? controller;
  final void Function()? onTap;

  const Ktextfield({
    super.key,
    this.controller,
    this.onTap,
    required this.homeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: homeBloc.isTextGenerating
              ? LottieBuilder.asset(
                  "assets/loading.json",
                  height: 50.h,
                )
              : Container(
                  margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(CupertinoIcons.up_arrow),
                ),
        ),
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
