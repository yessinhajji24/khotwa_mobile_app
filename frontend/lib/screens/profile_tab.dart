import 'package:flutter/material.dart';
import '../data/static_data.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/toast.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.onOpenNotifications,
    required this.onOpenQuiz,
  });

  final VoidCallback onOpenNotifications;
  final VoidCallback onOpenQuiz;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          // ---------- User card ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: cardBox(),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [AppColors.prussian, AppColors.celadon],
                    ),
                    border: Border.all(color: AppColors.mintBg, width: 4),
                  ),
                  child: Text(appState.initial,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
                const SizedBox(height: 12),
                Text(appState.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.prussian)),
                const SizedBox(height: 2),
                Text(appState.level,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate500)),
                const SizedBox(height: 2),
                Text(appState.email,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.slate400)),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.amber50,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0x66F59E0B)),
                  ),
                  child: Text('نقاطك: ${appState.points} ⭐️',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFB45309))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ---------- Stats ----------
          Row(
            children: [
              Expanded(
                child: _stat(
                  '${appState.readArticles.length}/${articles.length}',
                  'مقالات مقروءة',
                  AppColors.emerald,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stat(
                  '${appState.totalChecked}',
                  'وثائق جاهزة',
                  AppColors.celadon,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ---------- Settings ----------
          Container(
            decoration: cardBox(),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _menuRow(Icons.tune, AppColors.blue50, AppColors.celadon,
                    'إعدادات التوجيه', onOpenQuiz),
                const Divider(height: 1, color: AppColors.slate100),
                _menuRow(Icons.notifications_none, AppColors.amber50,
                    AppColors.amber, 'الإشعارات', onOpenNotifications),
                const Divider(height: 1, color: AppColors.slate100),
                _menuRow(
                  Icons.help_outline,
                  AppColors.emerald50,
                  AppColors.emerald,
                  'المساعدة',
                  () => showToast(
                      'فريق دعم خطوة متاح عبر البريد: support@khotwa.tn'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ---------- Logout ----------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.imperial,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                appState.logout();
                showToast('تم تسجيل الخروج بنجاح');
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('تسجيل الخروج',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardBox(),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
        ],
      ),
    );
  }

  Widget _menuRow(
    IconData icon,
    Color bg,
    Color fg,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            IconBox(icon, bg: bg, fg: fg, size: 32, iconSize: 16, radius: 8),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.prussian)),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.slate400),
          ],
        ),
      ),
    );
  }
}