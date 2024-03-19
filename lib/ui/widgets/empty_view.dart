import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final Widget message;
  final Widget? callToAtion;
  final Widget image;

  const EmptyView({
    super.key,
    required this.message,
    this.callToAtion,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image,
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: message,
        ),
        const SizedBox(height: 4),
        if (callToAtion != null) callToAtion!,
      ],
    );
  }
}
