import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final size = MediaQuery.sizeOf(context);

    final width = (size.width * 0.9).clamp(320.0, 720.0);
    final height = (size.height * 0.75).clamp(360.0, 900.0);

    // Decide which image URL to use
    String? imageUrl = restaurant.imageUrl;
    if (kIsWeb && imageUrl != null) {
      // Wrap in Cloudflare Worker proxy
      imageUrl =
          'https://hotpepper-proxy.restaurant-search.workers.dev/image?url=${Uri.encodeComponent(imageUrl)}';
    }

    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey.shade200),
                )
              else
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFEF3C7), Color(0xFFFFEDD5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              // Gradient overlay for text readability
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
              // Info box at bottom
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.getLocalizedName(locale),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    if (restaurant.genre != null && restaurant.genre!.isNotEmpty)
                      Text(
                        restaurant.genre!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    if (restaurant.budget != null && restaurant.budget!.isNotEmpty)
                      Text(
                        restaurant.budget!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      restaurant.getLocalizedDescription(locale),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
