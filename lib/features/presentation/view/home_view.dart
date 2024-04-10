import 'package:chat_ai/common/widgets/k_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView(
            children: [],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
          child: Ktextfield(),
        )
      ],
    ));
  }
}
