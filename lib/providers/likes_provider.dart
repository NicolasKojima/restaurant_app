import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';

class LikesProvider extends ChangeNotifier {
  final List<Restaurant> _liked = [];

  List<Restaurant> get liked => List.unmodifiable(_liked);

  bool isLiked(Restaurant r) => _liked.any((x) => x.id == r.id);

  void like(Restaurant r) {
    if (!isLiked(r)) {
      _liked.add(r);
      notifyListeners();
    }
  }

  void unlike(Restaurant r) {
    _liked.removeWhere((x) => x.id == r.id);
    notifyListeners();
  }

  void clear() {
    if (_liked.isNotEmpty) {
      _liked.clear();
      notifyListeners();
    }
  }
}
