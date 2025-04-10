import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? url;
  final Color backgroundColor;
  final String? fallbackText;
  final double fallbackTextSize;
  final double radius;

  const CustomCircleAvatar({
    Key? key,
    this.url = '',
    this.backgroundColor = const Color(0xff7257b3),
    this.fallbackText = 'user',
    this.fallbackTextSize = 14,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {      
      return CircleLetter(
        backgroundColor: backgroundColor,
        fallbackText: fallbackText == null ? 'user' : fallbackText!.isEmpty ? 'user' : fallbackText!,
        fallbackTextSize: fallbackTextSize,
        radius: radius,
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => Center(
          child: Text(
            (fallbackText?? "C").substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: fallbackTextSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleLetter extends StatelessWidget {
  final String fallbackText;
  final double fallbackTextSize;
  final double radius;
  final Color backgroundColor;

  const CircleLetter(
      {Key? key,
      required this.fallbackText,
      required this.fallbackTextSize,
      required this.radius,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          fallbackText.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: fallbackTextSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
