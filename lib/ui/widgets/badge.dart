import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final int value;

  const CustomBadge({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Visibility(
      visible: value > 0,
      child: Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: theme.colorScheme.primary, shape: BoxShape.circle),
        child: Text(
          value.toString(),
          style: theme.textTheme.labelLarge!.copyWith(
            color: theme.colorScheme.onPrimary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
