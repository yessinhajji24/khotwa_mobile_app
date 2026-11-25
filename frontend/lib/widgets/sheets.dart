import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import 'common.dart';

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.celadon, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.prussian)),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                          color: AppColors.slate100, shape: BoxShape.circle),
                      child: const Icon(Icons.close,
                          size: 18, color: AppColors.slate500),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, color: AppColors.slate100),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Notifications
// ------------------------------------------------------------
Future<void> showNotificationsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SheetFrame(
      icon: Icons.notifications_none,
      title: 'الإشعارات',
      child: SingleChildScrollView(
        child: Column(
          children: [
            _notif(
              bg: AppColors.red50,
              border: const Color(0x33E63946),
              labelColor: AppColors.imperial,
              label: 'تذكير عاجل',
              when: 'اليوم',
              text: 'تسكير تسجيل المبيت الجامعي OOUS يقترب. تأكد من إيداع ملفك.',
            ),
            const SizedBox(height: 12),
            _notif(
              bg: AppColors.mintBg,
              border: const Color(0x0D064E3B),
              labelColor: AppColors.celadon,
              label: 'المنحة الجامعية',
              when: 'أمس',
              text: 'آخر أجل لإيداع ملف المنحة في OOUN هو 31 ديسمبر.',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _notif({
  required Color bg,
  required Color border,
  required Color labelColor,
  required String label,
  required String when,
  required String text,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: labelColor)),
            Text(when,
                style:
                    const TextStyle(fontSize: 10, color: AppColors.slate400)),
          ],
        ),
        const SizedBox(height: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 12, height: 1.6, color: AppColors.prussian)),
      ],
    ),
  );
}

// ------------------------------------------------------------
// Orientation quiz
// ------------------------------------------------------------
Future<void> showQuizSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _QuizSheet(),
  );
}

class _QuizSheet extends StatefulWidget {
  const _QuizSheet();

  @override
  State<_QuizSheet> createState() => _QuizSheetState();
}

class _QuizSheetState extends State<_QuizSheet> {
  String? _result;

  static const _options = [
    ('💻 البرمجة، التكنولوجيا وحل المشاكل التقنية',
        'الهندسة والإعلامية (INSAT / ENSI / Prépa)'),
    ('🩺 العلوم البيولوجية ومساعدة الناس',
        'العلوم الطبية والصحية (الطب / الصيدلة)'),
    ('📊 ريادة الأعمال، المالية والتسويق', 'الاقتصاد والتصرف (IHEC / ISG)'),
  ];

  void _finish(String recommendation) {
    appState.addPoints(10);
    setState(() => _result = recommendation);
  }

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      icon: Icons.explore,
      title: 'اختبار التوجيه السريع',
      child: SingleChildScrollView(
        child: _result == null ? _question() : _answer(),
      ),
    );
  }

  Widget _question() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('شنوّا أكثر مجال يشدّ انتباهك في القراية؟',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.slate600)),
        const SizedBox(height: 12),
        for (final o in _options) ...[
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _finish(o.$2),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.slate200),
              ),
              child: Text(o.$1,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.prussian)),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _answer() {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.emerald50, shape: BoxShape.circle),
          child: const Text('🎯', style: TextStyle(fontSize: 22)),
        ),
        const SizedBox(height: 12),
        const Text('المسار المقترح ليك:',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.prussian)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
              color: AppColors.blue50, borderRadius: BorderRadius.circular(12)),
          child: Text(_result!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.celadon)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.prussian,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت، شكراً! (+10 نقاط)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}