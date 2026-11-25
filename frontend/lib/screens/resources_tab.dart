import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/static_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/toast.dart';

class ResourcesTab extends StatefulWidget {
  ResourcesTab({super.key});

  @override
  State<ResourcesTab> createState() => _ResourcesTabState();
}

class _ResourcesTabState extends State<ResourcesTab> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    final paper =
        _openId == null ? null : papers.firstWhere((p) => p.id == _openId);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: paper == null ? _list() : _detail(paper),
    );
  }

  // ---------- list ----------
  Widget _list() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ملفاتك والوثائق الإدارية 📂',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.prussian)),
        const SizedBox(height: 2),
        const Text('حضّر أوراقك خطوة بخطوة وتابع تقدمك تلقائياً.',
            style: TextStyle(fontSize: 12, color: AppColors.slate500)),
        const SizedBox(height: 16),
        for (final p in papers) ...[
          _paperCard(p),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _paperCard(Paper p) {
    final count = appState.checkedPapers[p.id]?.length ?? 0;
    final total = p.items.length;
    final complete = count == total;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _openId = p.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: cardBox(),
        child: Column(
          children: [
            Row(
              children: [
                IconBox(p.icon,
                    bg: complete ? AppColors.emerald50 : AppColors.blue50,
                    fg: complete ? AppColors.emerald : AppColors.celadon,
                    size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.title,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.prussian)),
                      Text(p.center,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.slate500)),
                    ],
                  ),
                ),
                Pill('$count/$total',
                    bg: complete ? AppColors.emerald50 : AppColors.mintBg,
                    fg: complete ? AppColors.emerald : AppColors.prussian,
                    size: 12,
                    radius: 8),
              ],
            ),
            const SizedBox(height: 12),
            _progress(count / total, height: 8),
          ],
        ),
      ),
    );
  }

  Widget _progress(double value, {required double height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: AppColors.slate100,
        valueColor: const AlwaysStoppedAnimation(AppColors.emerald),
      ),
    );
  }

  // ---------- detail ----------
  Widget _detail(Paper p) {
    final checked = appState.checkedPapers[p.id] ?? <int>{};
    final total = p.items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackPill(label: 'رجوع للوثائق', onTap: () => setState(() => _openId = null)),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: cardBox(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(p.title,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.prussian)),
                  ),
                  Pill('${checked.length}/$total',
                      bg: AppColors.mintBg,
                      fg: AppColors.prussian,
                      size: 12,
                      radius: 8),
                ],
              ),
              const SizedBox(height: 12),

              // meta grid
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.slate50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.slate100),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _meta('المكان:', p.center)),
                        Expanded(child: _meta('المعاليم:', p.cost)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppColors.slate200),
                    const SizedBox(height: 8),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'المدة التقريبية: ',
                            style: TextStyle(
                                fontSize: 10, color: AppColors.slate400)),
                        TextSpan(
                            text: p.wait,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.celadon)),
                      ])),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _progress(checked.length / total, height: 10),
              const SizedBox(height: 20),

              const Text('الوثائق المطلوبة (اضغط للتحديد):',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate500)),
              const SizedBox(height: 12),

              for (var i = 0; i < total; i++) ...[
                _checkItem(p, i, checked.contains(i)),
                const SizedBox(height: 10),
              ],

              const SizedBox(height: 10),
              const Divider(color: AppColors.slate100),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.mintBg,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _openPortal(p.portalUrl),
                  icon: const Icon(Icons.open_in_new,
                      size: 16, color: AppColors.celadon),
                  label: Text('زيارة ${p.portalLabel}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.prussian)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _meta(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppColors.slate400)),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.prussian)),
        ],
      );

  Widget _checkItem(Paper p, int index, bool isChecked) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        final added = appState.togglePaperItem(p.id, index);
        if (added) showToast('تم حفظ الوثيقة (+5 نقاط) ✓', success: true);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isChecked ? const Color(0x66ECFDF5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isChecked ? const Color(0x4D10B981) : AppColors.slate200),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.emerald : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: isChecked ? AppColors.emerald : AppColors.slate300,
                    width: 2),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                p.items[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: isChecked ? AppColors.slate400 : AppColors.prussian,
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPortal(String url) async {
    final ok = await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication);
    if (!ok) showToast('تعذّر فتح الرابط');
  }
}