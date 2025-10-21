import 'package:flutter/material.dart';

class Restaurant {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final String? imageUrl;
  final String? genre;
  final String? budget;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.genre,
    this.budget,
  });

  String getLocalizedName(Locale locale) {
    return name[locale.languageCode] ?? name['en'] ?? name.values.first;
  }

  String getLocalizedDescription(Locale locale) {
    return description[locale.languageCode] ??
        description['en'] ??
        description.values.first;
  }

  @override
  bool operator ==(Object other) => other is Restaurant && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
