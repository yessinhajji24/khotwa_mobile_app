import 'package:flutter/material.dart';
import '../data/static_data.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class NewsTab extends StatefulWidget {
  NewsTab({super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  String _category = 'all';

  @override
  Widget build(BuildContext context) {
    final filtered = _category == 'all'
        ? newsItems
        : newsItems.where((n) => n.category == _category).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('أخبار الطلبة 📰',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.prussian)),
          const SizedBox(height: 16),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in newsFilters) ...[
                  _chip(f.$1, f.$2),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          for (final n in filtered) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: cardBox(
                  border: n.urgent
                      ? const Color(0x80E63946)
                      : AppColors.slate100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Pill(
                        n.urgent ? '❗ ${n.badge}' : n.badge,
                        bg: n.urgent ? AppColors.red50 : AppColors.blue50,
                        fg: n.urgent ? AppColors.imperial : AppColors.celadon,
                      ),
                      Text(n.date,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.slate400)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(n.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.prussian)),
                  const SizedBox(height: 4),
                  Text(n.summary,
                      style: const TextStyle(
                          fontSize: 12, height: 1.6, color: AppColors.slate600)),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _chip(String key, String label) {
    final selected = _category == key;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => setState(() => _category = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.celadon : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
              color: selected ? AppColors.celadon : AppColors.slate200),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.slate600)),
      ),
    );
  }
}