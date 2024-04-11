import 'package:chat_ai/core/toast_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KToast extends StatelessWidget {
  final ToastVariant variant;
  final String message;

  const KToast({
    required this.variant,
    required this.message,
    super.key,
  });

  Color getColor(ToastVariant variant) {
    switch (variant) {
      case ToastVariant.success:
        return Colors.green;
      case ToastVariant.error:
        return Colors.red;
      case ToastVariant.warning:
        return Colors.orange;
      case ToastVariant.info:
        return Colors.blueAccent;
    }
  }

  IconData getIcon(ToastVariant variant) {
    switch (variant) {
      case ToastVariant.success:
        return Icons.check_circle;

      case ToastVariant.error:
        return Icons.cancel;

      case ToastVariant.warning:
        return Icons.warning;

      case ToastVariant.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: getColor(variant),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            spreadRadius: 2,
            color: getColor(variant).withOpacity(0.25),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(getIcon(variant), color: Colors.white),
          SizedBox(
            height: 16.h,
          ),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
