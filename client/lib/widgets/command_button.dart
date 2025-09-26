import 'package:flutter/material.dart';

class CommandButton extends StatelessWidget {
  final String label;
  final MaterialColor color; // pass only MaterialColor
  final bool enabled;
  final VoidCallback onPressed;

  const CommandButton({
    super.key,
    required this.label,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final background = enabled ? color.shade400 : Colors.grey.shade200;
    final borderColor = enabled ? color.shade600 : Colors.grey.shade400;
    final textColor = enabled ? Colors.white : Colors.grey.shade600;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: textColor,
        elevation: enabled ? 2 : 0,
        shadowColor: enabled ? Colors.black12 : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        minimumSize: const Size(88, 38),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: enabled ? onPressed : null,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
