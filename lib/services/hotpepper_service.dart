import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/restaurant.dart';

class HotPepperService {
  HotPepperService(this.apiKey);

  final String apiKey;

  // Direct API base (for mobile)
  static const _directBase =
      'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/';

  // Proxy base (for web) — your Cloudflare Worker
  static const _proxyBase =
      'https://hotpepper-proxy.restaurant-search.workers.dev/';

  String get _baseUrl => kIsWeb ? _proxyBase : _directBase;

  // Shibuya area code = Y030
  Future<List<Restaurant>> fetchShibuya({int count = 30}) async {
    final query = {
      'format': 'json',
      'middle_area': 'Y030',
      'count': '$count',
      'type': 'lite',
    };

    // Only pass API key if calling direct endpoint (mobile)
    if (!kIsWeb) {
      query['key'] = apiKey;
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: query);

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final data = jsonDecode(res.body);
    final shops = (data['results']?['shop'] as List?) ?? [];

    return shops.map<Restaurant>((s) {
      final id = s['id'] as String? ?? '';
      final nameJa = s['name'] as String? ?? '';
      final catchJa = s['catch'] as String? ?? (s['address'] as String? ?? '');

      final genre = (s['genre']?['name'] as String?) ?? '';
      final budget = (s['budget']?['name'] as String?) ?? '';
      final photoUrl = (s['photo']?['pc']?['l'] as String?) ?? '';

      return Restaurant(
        id: id,
        name: {'ja': nameJa, 'en': nameJa},
        description: {'ja': catchJa, 'en': catchJa},
        imageUrl: photoUrl.isNotEmpty ? photoUrl : null,
        genre: genre.isNotEmpty ? genre : null,
        budget: budget.isNotEmpty ? budget : null,
      );
    }).toList();
  }
}
