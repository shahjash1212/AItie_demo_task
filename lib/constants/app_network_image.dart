import 'package:aitie_demo/constants/app_colors.dart';
import 'package:aitie_demo/constants/app_common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({super.key, required this.imageUrl, this.size = 50});

  final String imageUrl;
  final double size;

  bool get _isSvg => imageUrl.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: _isSvg ? _buildSvg() : _buildRaster(),
    );
  }

  Widget _buildSvg() {
    return SvgPicture.network(
      imageUrl,
      fit: BoxFit.cover,
      headers: const {'Accept': 'image/svg+xml'},
      allowDrawingOutsideViewBox: true,
      placeholderBuilder: (_) => const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: AppLoader(size: 2, color: AppColors.darkBackground),
        ),
      ),
      errorBuilder: (context, error, stackTrace) {
        debugPrint('SVG ERROR: $error');
        return _fallbackIcon();
      },
    );
  }

  Widget _buildRaster() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 24,
      ),
    );
  }
}
