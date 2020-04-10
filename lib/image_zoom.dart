import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageZoomPage extends StatelessWidget {
  final String imageLink;
  final String imageTitle;
  ImageZoomPage(this.imageLink, this.imageTitle);
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(imageTitle),
      ),
      body: MatrixGestureDetector(
        onMatrixUpdate: (m, tm, sm, rm) {
          notifier.value = m;
        },
        child: AnimatedBuilder(
          animation: notifier,
          builder: (ctx, child) {
            return Transform(
              transform: notifier.value,
              child: Container(
                    padding: EdgeInsets.all(32),
                    alignment: Alignment(0, -0.5),
                    child: CachedNetworkImage(
                      imageUrl: imageLink,
                    )
                  ),
            );
          },
        ),
      ),
    );
  }
}