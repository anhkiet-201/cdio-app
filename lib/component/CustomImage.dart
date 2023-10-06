import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skeletons/skeletons.dart';


class CDImage extends StatelessWidget {
  const CDImage(
      {super.key,
      required this.url,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.radius = 0,
      this.onError,
      this.placeholder,
      this.background = Colors.white});

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final Function? onError;
  final Widget? placeholder;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        imageUrl: url ?? '',
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) =>
            placeholder ??
            SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: width,
                height: height,
                borderRadius: BorderRadius.circular(radius)
              ),
            ),
        errorListener: (_) => onError?.call(),
        errorWidget: (_, __, ___) => Container(
          constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
          decoration: BoxDecoration(
              color: background,
              borderRadius: const BorderRadius.all(Radius.circular(15))),
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
