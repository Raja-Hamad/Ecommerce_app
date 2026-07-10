import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, required this.url, this.fit = BoxFit.cover, this.borderRadius});

  final String url;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, _) => Shimmer.fromColors(
        baseColor: AppColors.border,
        highlightColor: AppColors.scaffold,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, _, _) => Container(
        color: AppColors.primaryLight,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.primary),
      ),
    );
    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
