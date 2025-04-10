import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tapp/core/navigation/routes.dart';

import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';

class ImagePreview extends StatelessWidget {
  final String url;
  final Radius bottomLeft;
  final Radius bottomRight;

  const ImagePreview({
    Key? key,
    required this.url,
    required this.bottomLeft,
    required this.bottomRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      ),
      child: GestureDetector(
        onTap: () {
          getIt<NavigationService>()
              .navigateTo(Routes.fullImageScreen, {'imageUrl': url});
        },
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          progressIndicatorBuilder: (context, url, progress) {
            return Container(
              color: Colors.transparent,
              width: 128,
              height: 128,
              child: Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                  valueColor: const AlwaysStoppedAnimation(Colors.grey),
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorWidget: (context, url, progress) {
            return Icon(
              Icons.broken_image,
              size: 48,
              color: Colors.grey[600],
            );
          },
        ),
      ),
    );
  }

// void _fullScreenImage(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierColor: Colors.red,
//     barrierDismissible: true,
//     useSafeArea: true,
//     builder: (context) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           elevation: 0,
//         ),
//         body: Container(
//           color: Colors.black,
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: PinchZoomImage(
//             image: Image.network(url, fit: BoxFit.cover),
//             zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
//             hideStatusBarWhileZooming: true,
//           ),
//         ),
//       );
//     },
//   );
// }
}
