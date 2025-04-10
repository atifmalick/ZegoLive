import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

class PostFullScreenImage extends StatelessWidget {
  const PostFullScreenImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (ModalRoute.of(context)!.settings.arguments as Map)['imageUrl'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Center(
        child: PinchZoomImage(
          image: Image.network(imageUrl, fit: BoxFit.cover),
          zoomedBackgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
          hideStatusBarWhileZooming: true,
        ),
      ),
    );
  }
}
