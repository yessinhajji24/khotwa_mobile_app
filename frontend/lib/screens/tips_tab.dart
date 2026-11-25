import 'package:flutter/material.dart';
import '../data/static_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/toast.dart';

class TipsTab extends StatefulWidget {
  const TipsTab({super.key, this.initialArticleId});

  /// Set when the user taps "tip of the week" on the home tab.
  final int? initialArticleId;

  @override
  State<TipsTab> createState() => _TipsTabState();
}

class _TipsTabState extends State<TipsTab> {
  int? _openId;

  @override
  void initState() {
    super.initState();
    _openId = widget.initialArticleId;
  }

  @override
  Widget build(BuildContext context) {
    final art =
        _openId == null ? null : articles.firstWhere((a) => a.id == _openId);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: art == null ? _list() : _detail(art),
    );
  }

  // ---------- list ----------
  Widget _list() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('نصائح وحياة الطالب ✨',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.prussian)),
        const SizedBox(height: 2),
        Text.rich(
          const TextSpan(
            style: TextStyle(fontSize: 12, color: AppColors.slate500),
            children: [
              TextSpan(text: 'اقرأ المقالات واربح '),
              TextSpan(
                  text: '+15 نقطة',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.amber)),
              TextSpan(text: ' لكل مقال!'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final a in articles) ...[
          _card(a),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _card(Article a) {
    final isRead = appState.readArticles.contains(a.id);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _openId = a.id),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: cardBox(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Pill(a.tag,
                    bg: AppColors.blue50,
                    fg: AppColors.celadon,
                    size: 10,
                    radius: 6),
                isRead
                    ? const Pill('تمت القراءة ✓',
                        bg: AppColors.emerald50, fg: AppColors.emerald)
                    : const Pill('غير مقروء',
                        bg: AppColors.slate100, fg: AppColors.slate400),
              ],
            ),
            const SizedBox(height: 8),
            Text(a.title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    color: AppColors.prussian)),
            const SizedBox(height: 6),
            Text(a.summary,
                style: const TextStyle(
                    fontSize: 12, height: 1.6, color: AppColors.slate500)),
          ],
        ),
      ),
    );
  }

  // ---------- detail ----------
  Widget _detail(Article a) {
    final isRead = appState.readArticles.contains(a.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackPill(label: 'رجوع للقائمة', onTap: () => setState(() => _openId = null)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: cardBox(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isRead
                  ? const Pill('تمت القراءة ✓',
                      bg: AppColors.emerald50, fg: AppColors.emerald, size: 12)
                  : Pill(a.tag,
                      bg: AppColors.blue50, fg: AppColors.celadon, size: 12),
              const SizedBox(height: 8),
              Text(a.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      color: AppColors.prussian)),
              const SizedBox(height: 16),
              for (final s in a.sections) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0x99EAF3EF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x0D064E3B)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.h,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.prussian)),
                      const SizedBox(height: 4),
                      Text(s.p,
                          style: const TextStyle(
                              fontSize: 12,
                              height: 1.7,
                              color: AppColors.slate700)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: isRead
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.emerald50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x4D10B981)),
                  ),
                  child: const Text('تمت قراءة هذا المقال مسبقاً ✓',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.emerald)),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (appState.markArticleRead(a.id)) {
                      showToast('ممتاز! ربحت +15 نقطة لقراءة المقال ⭐️',
                          success: true);
                    }
                    setState(() => _openId = null);
                  },
                  child: const Text('✅ تحديد كمقروء (+15 نقطة)',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
        ),
      ],
    );
  }
}