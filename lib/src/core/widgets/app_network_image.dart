import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/network/image_url_resolver.dart';

class const AppNetworkImage({
  required final String imagePath,
  final BoxFit fit = BoxFit.cover,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return const _FallbackImage();
    }
    return Image.network(
      ImageUrlResolver.resolve(imagePath),
      fit: fit,
      errorBuilder: (_, _, _) => const _FallbackImage(),
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const ColoredBox(
              color: Color(0xFFFFEFCC),
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

class const _FallbackImage() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: 64,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
