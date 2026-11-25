import 'package:flutter/material.dart';

class NewsItem {
  final int id;
  final String category;
  final String badge;
  final bool urgent;
  final String date;
  final String title;
  final String summary;

  const NewsItem({
    required this.id,
    required this.category,
    required this.badge,
    required this.urgent,
    required this.date,
    required this.title,
    required this.summary,
  });
}

class ArticleSection {
  final String h;
  final String p;
  const ArticleSection(this.h, this.p);
}

class Article {
  final int id;
  final String emoji;
  final String tag;
  final String title;
  final String summary;
  final List<ArticleSection> sections;

  const Article({
    required this.id,
    required this.emoji,
    required this.tag,
    required this.title,
    required this.summary,
    required this.sections,
  });
}

class Paper {
  final String id;
  final IconData icon;
  final String title;
  final String cost;
  final String center;
  final String wait;
  final String portalUrl;
  final String portalLabel;
  final List<String> items;

  const Paper({
    required this.id,
    required this.icon,
    required this.title,
    required this.cost,
    required this.center,
    required this.wait,
    required this.portalUrl,
    required this.portalLabel,
    required this.items,
  });
}