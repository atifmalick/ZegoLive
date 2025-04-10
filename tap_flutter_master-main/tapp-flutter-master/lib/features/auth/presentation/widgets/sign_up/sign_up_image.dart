import 'package:flutter/material.dart';

class SignUpImage extends StatelessWidget {
  const SignUpImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 20,
      ),
      child: Image.asset(
        'assets/register.png',
        height: MediaQuery.of(context).size.height * 0.3,
      ),
    );
  }
}
