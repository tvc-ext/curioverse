import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/child_profile.dart';

class OpenKnowledgeItem {
  const OpenKnowledgeItem({
    required this.title,
    required this.summary,
    required this.sourceUrl,
    this.imageUrl,
    this.credit = 'Wikipedia · CC BY-SA',
  });

  final String title;
  final String summary;
  final String sourceUrl;
  final String? imageUrl;
  final String credit;

  Map<String, Object?> toJson() => {
        'title': title,
        'summary': summary,
        'sourceUrl': sourceUrl,
        'imageUrl': imageUrl,
        'credit': credit,
      };

  factory OpenKnowledgeItem.fromJson(Map<String, Object?> json) =>
      OpenKnowledgeItem(
        title: json['title']! as String,
        summary: json['summary']! as String,
        sourceUrl: json['sourceUrl']! as String,
        imageUrl: json['imageUrl'] as String?,
        credit: json['credit']! as String,
      );
}

abstract interface class OpenKnowledgeSource {
  Future<List<OpenKnowledgeItem>> load(AgeBand ageBand);
}

class OpenKnowledgeService implements OpenKnowledgeSource {
  OpenKnowledgeService({
    required this.preferences,
    http.Client? client,
  }) : client = client ?? http.Client();

  static const _cacheKey = 'open_knowledge.cache.v1';
  static const _userAgent =
      'CurioVerse/0.1 (educational app; https://github.com/tvc-ext/curioverse)';

  final SharedPreferences preferences;
  final http.Client client;

  static const _titlesByAge = {
    AgeBand.explorer6to8: ['Moon', 'Dinosaur', 'Ocean', 'Rainbow'],
    AgeBand.adventurer9to11: [
      'Moon',
      'Solar System',
      'Artificial intelligence',
      'Dinosaur fossil',
      'Octopus',
      'Volcano',
    ],
    AgeBand.creator12to14: [
      'Moon',
      'Solar System',
      'Artificial intelligence',
      'Machine learning',
      'Marine ecosystem',
      'Quantum mechanics',
      'Space exploration',
      'Renewable energy',
    ],
  };

  @override
  Future<List<OpenKnowledgeItem>> load(AgeBand ageBand) async {
    try {
      final wikipediaItems = await Future.wait(
        _titlesByAge[ageBand]!.map(_fetchWikipediaSummary),
      );
      List<OpenKnowledgeItem> nasaItems;
      try {
        nasaItems = await _fetchNasaImages(
          ageBand == AgeBand.explorer6to8 ? 'Moon' : 'space exploration',
        );
      } catch (_) {
        nasaItems = const [];
      }
      final items = [...nasaItems, ...wikipediaItems];
      await preferences.setString(
        '$_cacheKey.${ageBand.name}',
        jsonEncode(items.map((item) => item.toJson()).toList()),
      );
      return items;
    } catch (_) {
      final cached = preferences.getString('$_cacheKey.${ageBand.name}');
      if (cached == null) return const [];
      final values = jsonDecode(cached) as List<Object?>;
      return values
          .cast<Map<String, Object?>>()
          .map(OpenKnowledgeItem.fromJson)
          .toList();
    }
  }

  Future<List<OpenKnowledgeItem>> _fetchNasaImages(String query) async {
    final uri = Uri.https(
      'images-api.nasa.gov',
      '/search',
      {'q': query, 'media_type': 'image', 'page_size': '6'},
    );
    final response = await client.get(uri);
    if (response.statusCode != 200) {
      throw StateError('NASA request failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, Object?>;
    final collection = json['collection']! as Map<String, Object?>;
    final items = collection['items']! as List<Object?>;

    return items.take(6).map((value) {
      final item = value! as Map<String, Object?>;
      final data = (item['data']! as List<Object?>).first!
          as Map<String, Object?>;
      final links = item['links'] as List<Object?>?;
      final imageUrl = links == null || links.isEmpty
          ? null
          : (links.first! as Map<String, Object?>)['href'] as String?;
      final nasaId = data['nasa_id']! as String;
      final description = (data['description'] as String?) ??
          'Explore this image from NASA’s public library.';

      return OpenKnowledgeItem(
        title: data['title']! as String,
        summary: description,
        sourceUrl: 'https://images.nasa.gov/details-$nasaId',
        imageUrl: imageUrl,
        credit: 'NASA Image and Video Library',
      );
    }).toList();
  }

  Future<OpenKnowledgeItem> _fetchWikipediaSummary(String title) async {
    final encoded = Uri.encodeComponent(title.replaceAll(' ', '_'));
    final uri = Uri.parse(
      'https://en.wikipedia.org/api/rest_v1/page/summary/$encoded',
    );
    final response = await client.get(
      uri,
      headers: {'Api-User-Agent': _userAgent},
    );
    if (response.statusCode != 200) {
      throw StateError('Open knowledge request failed: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, Object?>;
    final contentUrls = json['content_urls'] as Map<String, Object?>?;
    final desktop = contentUrls?['desktop'] as Map<String, Object?>?;
    final thumbnail = json['thumbnail'] as Map<String, Object?>?;

    return OpenKnowledgeItem(
      title: json['title']! as String,
      summary: json['extract']! as String,
      sourceUrl: (desktop?['page'] as String?) ??
          'https://en.wikipedia.org/wiki/$encoded',
      imageUrl: thumbnail?['source'] as String?,
    );
  }
}

class MemoryOpenKnowledgeSource implements OpenKnowledgeSource {
  const MemoryOpenKnowledgeSource([this.items = const []]);

  final List<OpenKnowledgeItem> items;

  @override
  Future<List<OpenKnowledgeItem>> load(AgeBand ageBand) async => items;
}
