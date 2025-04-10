import 'package:flutter/material.dart';

class SignInImage extends StatelessWidget {
  const SignInImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Image.asset(
        'assets/hello2.png',
        height: MediaQuery.of(context).size.height * 0.35,
      ),
    );
  }
}
