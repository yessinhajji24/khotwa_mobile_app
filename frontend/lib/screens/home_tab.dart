import 'package:flutter/material.dart';
import '../data/static_data.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/toast.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.onStartQuiz,
    required this.onGoNews,
    required this.onGoTips,
    required this.onOpenArticle,
  });

  final VoidCallback onStartQuiz;
  final VoidCallback onGoNews;
  final VoidCallback onGoTips;
  final void Function(int articleId) onOpenArticle;

  @override
  Widget build(BuildContext context) {
    final tip = articles.first;

    final paths = <(IconData, Color, Color, String, String, String)>[
      (
        Icons.workspace_premium_outlined,
        AppColors.blue50,
        AppColors.celadon,
        'بكالوريا 2026',
        'حساب السكور والتوجيه',
        'مسار بكالوريا 2026: رزنامة التوجيه والسكور قريباً!'
      ),
      (
        Icons.functions,
        AppColors.amber50,
        AppColors.amber,
        'مرحلة تحضيرية',
        'MP / PC / PT / BG',
        'مسار المرحلة التحضيرية: دليل المناظرة الوطنية جاهز!'
      ),
      (
        Icons.laptop_mac,
        AppColors.emerald50,
        AppColors.emerald,
        'إجازة وهندسة',
        'مشاريع التخرج والمنح',
        'مسار الإجازة والهندسة: فرص التربصات والماجستير'
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Hero ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  AppColors.prussian,
                  Color(0xFF254570),
                  AppColors.celadon
                ],
              ),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 8,
                    offset: Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('أهلاً بك يا ${appState.firstName} 👋',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
                const SizedBox(height: 8),
                const Text('اكتشف مسارك من غير توتر',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        color: Colors.white)),
                const SizedBox(height: 4),
                const Text(
                    'أجب على 3 أسئلة سريعة باش نعاونوك تختار الشعبة والجامعة الأنسب لطموحك.',
                    style: TextStyle(
                        fontSize: 12, height: 1.6, color: Color(0xFFDBEAFE))),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: onStartQuiz,
                  icon: const Icon(Icons.auto_fix_high,
                      size: 16, color: AppColors.celadon),
                  label: const Text('ابدأ اختبار التوجيه السريع',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.prussian,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ---------- Study paths ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('مساراتك الدراسية',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.prussian)),
              Text('اسحب للمزيد ←',
                  style: TextStyle(fontSize: 11, color: AppColors.slate500)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 124,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: paths.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final p = paths[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => showToast(p.$6),
                  child: Container(
                    width: 145,
                    padding: const EdgeInsets.all(14),
                    decoration: cardBox(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconBox(p.$1, bg: p.$2, fg: p.$3),
                        const SizedBox(height: 10),
                        Text(p.$4,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.prussian)),
                        const SizedBox(height: 2),
                        Text(p.$5,
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.slate500)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // ---------- Urgent news ----------
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onGoNews,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: cardBox(border: const Color(0xCCE63946), borderWidth: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppColors.red50,
                            borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircleAvatar(
                                radius: 4, backgroundColor: AppColors.imperial),
                            SizedBox(width: 6),
                            Text('عاجل - المبيتات',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.imperial)),
                          ],
                        ),
                      ),
                      const Text('منذ ساعتين',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.slate400)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('تسكير تسجيل المبيت الجامعي OOUS',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.prussian)),
                  const SizedBox(height: 4),
                  const Text(
                      'آخر أجل لتقديم مطالب السكن الجامعي وتجديدها عبر موقع ديوان الخدمات الجامعية للجنوب والشمال والوسط.',
                      style: TextStyle(
                          fontSize: 12, height: 1.6, color: AppColors.slate600)),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text('اقرأ التفاصيل',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.imperial)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 16, color: AppColors.imperial),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ---------- Tip of the week ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('نصيحة الأسبوع 💡',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.prussian)),
              TextButton(
                onPressed: onGoTips,
                child: const Text('كل النصائح',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.celadon)),
              ),
            ],
          ),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onOpenArticle(tip.id),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: cardBox(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.emerald50,
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(tip.emoji, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Pill(tip.tag,
                            bg: AppColors.blue50,
                            fg: AppColors.celadon,
                            size: 10,
                            radius: 6),
                        const SizedBox(height: 4),
                        const Text('كيفاش ما تصرفش مصروف شهر كامل في جمعة وحدة؟',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                color: AppColors.prussian)),
                        const SizedBox(height: 4),
                        const Text(
                            'نصائح عملية بالتونسي باش تسيطر على مصروفك وتعيش مرتاح لنهاية الشهر.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: AppColors.slate500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}