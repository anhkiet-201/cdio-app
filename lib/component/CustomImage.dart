import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class CDImage extends StatelessWidget {
  const CDImage(
      {super.key,
      required this.url,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.radius = 0,
      this.onError,
      this.placeholder});

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final Function? onError;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        // placeholder: (_, __) =>
        //     placeholder ??
        //     Skeletonizer(
        //       enabled: false,
        //       child: Container(
        //         width: width,
        //         height: height,
        //         color: Colors.black,
        //       ),
        //     ),
        errorListener: (_) => onError?.call(),
        errorWidget: (_, __, ___) => Container(
          constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Center(
              child: Icon(Iconsax.info_circle,
                  size: width == null || height == null
                      ? 12
                      : (max(width ?? 0, height ?? 0) / 100) * 24)),
        ),
      ),
    );
  }
}
