import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newflashchtapp/utilities/constant.dart';
import 'package:shimmer/shimmer.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    Key? key,
    required this.imageUrl,
    this.size = 55,
  }) : super(key: key);

  final String imageUrl;

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, _) {
          return SizedBox(
            width: size,
            height: size,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              child: Container(color: Colors.grey),
            ),
          );
        },
        errorWidget: (context, _, __) {
          return CachedNetworkImage(imageUrl: defaultImage);
        },
      ),
    );
  }
}
