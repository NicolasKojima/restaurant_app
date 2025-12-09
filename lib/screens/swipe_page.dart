import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'dart:math';

import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import '../providers/likes_provider.dart';
import '../services/hotpepper_service.dart';
import '../l10n/generated/app_localizations.dart';


class RestaurantSwipePage extends StatefulWidget {
  const RestaurantSwipePage({Key? key}) : super(key: key);

  @override
  State<RestaurantSwipePage> createState() => _RestaurantSwipePageState();
}

class _RestaurantSwipePageState extends State<RestaurantSwipePage> {
  final _controller = CardSwiperController();

  late final HotPepperService _hp;
  bool _loading = true;
  String _error = '';
  List<Restaurant> _restaurants = [];

  @override
  void initState() {
    super.initState();

    // Load HotPepper API key (for mobile)
    const defineKey = String.fromEnvironment('HOTPEPPER_API_KEY');
    final envKey = dotenv.env['HOTPEPPER_API_KEY'] ?? '';
    final apiKey = defineKey.isNotEmpty ? defineKey : envKey;

    _hp = HotPepperService(apiKey);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final data = await _hp.fetchShibuya(count: 40);
      setState(() {
        _restaurants = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _showFloatingHeart() {
  final overlay = Overlay.of(context);
  if (overlay == null) return;

  final random = Random();
  final horizontalOffset = (random.nextDouble() * 60) - 30; // ±30 px sideways

  final heart = OverlayEntry(
    builder: (context) {
      return Positioned.fill(
        child: IgnorePointer(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 900),
            builder: (context, value, child) {
              final yOffset = 100 * value; // goes up
              return Opacity(
                opacity: 1.0 - value,
                child: Transform.translate(
                  offset: Offset(horizontalOffset, -yOffset),
                  child: Transform.scale(
                    scale: 1.0 + (0.4 * value),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                      size: 100,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  overlay.insert(heart);
  Future.delayed(const Duration(milliseconds: 900), heart.remove);
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = EdgeInsets.symmetric(
      horizontal: size.width * 0.05,
      vertical: size.height * 0.08,
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.discoverRestaurants)),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('Failed to load: $_error'),
                    ),
                  )
                : _restaurants.isEmpty
                    ? Center(child: Text(AppLocalizations.of(context)!.noRestaurantsFound))
                    : Stack(
                        children: [
                          CardSwiper(
                            controller: _controller,
                            cardsCount: _restaurants.length,
                            padding: padding,
                            numberOfCardsDisplayed: 1,
                            allowedSwipeDirection:
                                const AllowedSwipeDirection.only(
                              left: true,
                              right: true,
                            ),
                            cardBuilder: (context, index, _, __) {
                              final r = _restaurants[index];
                              return RestaurantCard(restaurant: r);
                            },
                            onSwipe: (prevIndex, _, direction) {
                              final r = _restaurants[prevIndex];
                              final likes =
                                  context.read<LikesProvider>();

                              if (direction == CardSwiperDirection.right) {
                                likes.like(r);
                                _showFloatingHeart(); // ❤️ animation
                              } else if (direction ==
                                  CardSwiperDirection.left) {
                                likes.unlike(r);
                              }
                              return true;
                            },
                            onEnd: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('No more restaurants to show.')),
                              );
                            },
                          ),
                          // “Powered by” footer
                          Positioned(
                            bottom: 8,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.poweredBy,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: size.width * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
      bottomNavigationBar: _loading || _restaurants.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: size.height * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _swipeButton(
                      label: AppLocalizations.of(context)!.nope,
                      icon: Icons.close,
                      color: Colors.grey.shade400,
                      onTap: () =>
                          _controller.swipe(CardSwiperDirection.left),
                      size: size,
                    ),
                    _swipeButton(
                      label: AppLocalizations.of(context)!.like,
                      icon: Icons.favorite,
                      color: Colors.pinkAccent,
                      onTap: () =>
                          _controller.swipe(CardSwiperDirection.right),
                      size: size,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _swipeButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required Size size,
  }) {
    final btnSize = size.width * 0.12;
    return SizedBox(
      width: btnSize * 1.5,
      height: btnSize,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnSize * 0.5),
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: btnSize * 0.5),
        label: Text(
          label,
          style: TextStyle(fontSize: btnSize * 0.25),
        ),
      ),
    );
  }
}
