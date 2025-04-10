import 'package:flutter/material.dart';

class BottomItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function()? onTap;
  final bool active;

  const BottomItem({
    Key? key,
    required this.icon,
    required this.color,
    required this.active,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        height: 48,
        onPressed: onTap,
        splashColor: color,
        color: active ? color.withOpacity(0.1) : Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
        child: Icon(
          icon,
          color: active ? color : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
