import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/likes_provider.dart';
import '../models/restaurant.dart';
import '../l10n/generated/app_localizations.dart';

class LikedPage extends StatefulWidget {
  const LikedPage({Key? key}) : super(key: key);

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  String? selectedGenre;

  @override
  Widget build(BuildContext context) {
    final likes = context.watch<LikesProvider>().liked;
    final size = MediaQuery.of(context).size;
    final locale = Localizations.localeOf(context);

    // Collect genres from liked restaurants
    final genres = likes
        .map((r) => r.genre ?? '')
        .where((g) => g.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    // Filtered list by selected genre
    final filtered = selectedGenre == null
        ? likes
        : likes.where((r) => r.genre == selectedGenre).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.likedRestaurants),
        actions: [
          if (selectedGenre != null)
            IconButton(
              onPressed: () => setState(() => selectedGenre = null),
              icon: const Icon(Icons.clear),
              tooltip: 'Clear filter',
            ),
        ],
      ),
      body: likes.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noLikedRestaurants))
        : Column(
            children: [
              if (genres.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.015,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: genres.map((genre) {
                        final selected = genre == selectedGenre;
                        return Padding(
                          padding:
                              EdgeInsets.only(right: size.width * 0.02),
                          child: ChoiceChip(
                            label: Text(
                              genre,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                            selected: selected,
                            selectedColor: Colors.orange,
                            backgroundColor: Colors.grey.shade200,
                            onSelected: (_) => setState(() {
                              selectedGenre = selected ? null : genre;
                            }),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width > 800
                          ? 3
                          : size.width > 500
                              ? 2
                              : 1,
                      crossAxisSpacing: size.width * 0.03,
                      mainAxisSpacing: size.height * 0.02,
                      childAspectRatio: 4 / 3,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final r = filtered[i];
                      return _RestaurantGridCard(
                          restaurant: r, locale: locale);
                    },
                  ),
                ),
              ),
            ],
          ),

    );
  }
}

class _RestaurantGridCard extends StatelessWidget {
  final Restaurant restaurant;
  final Locale locale;

  const _RestaurantGridCard({
    Key? key,
    required this.restaurant,
    required this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final radius = size.width * 0.04;

    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (restaurant.imageUrl != null)
              Image.network(
                restaurant.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              )
            else
              Container(color: Colors.orange.shade50),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.getLocalizedName(locale),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (restaurant.genre != null)
                    Text(
                      restaurant.genre!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  if (restaurant.budget != null)
                    Text(
                      restaurant.budget!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (restaurant.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(restaurant.imageUrl!),
                  ),
                const SizedBox(height: 16),
                Text(
                  restaurant.getLocalizedName(locale),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (restaurant.genre != null)
                  Text('${AppLocalizations.of(context)!.genre}: ${restaurant.genre!}'),
                if (restaurant.budget != null)
                  Text('${AppLocalizations.of(context)!.budget}: ${restaurant.budget!}'),
                const SizedBox(height: 12),
                Text(
                  restaurant.getLocalizedDescription(locale),
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
