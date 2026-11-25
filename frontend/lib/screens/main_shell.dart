import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/sheets.dart';
import 'home_tab.dart';
import 'news_tab.dart';
import 'profile_tab.dart';
import 'resources_tab.dart';
import 'tips_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  int? _pendingArticleId; // used by "tip of the week" on the home tab
  bool _notifDot = true;

  void _go(int i, {int? articleId}) {
    setState(() {
      _index = i;
      _pendingArticleId = articleId;
    });
  }

  void _openNotifications() {
    setState(() => _notifDot = false);
    showNotificationsSheet(context);
  }

  Widget _body() {
    switch (_index) {
      case 0:
        return HomeTab(
          onStartQuiz: () => showQuizSheet(context),
          onGoNews: () => _go(1),
          onGoTips: () => _go(2),
          onOpenArticle: (id) => _go(2, articleId: id),
        );
      case 1:
        return NewsTab();
      case 2:
        return TipsTab(
          key: ValueKey('tips-$_pendingArticleId'),
          initialArticleId: _pendingArticleId,
        );
      case 3:
        return ResourcesTab();
      default:
        return ProfileTab(
          onOpenNotifications: _openNotifications,
          onOpenQuiz: () => showQuizSheet(context),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild whenever points / read articles / checked papers change.
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => Scaffold(
        backgroundColor: AppColors.mintBg,
        body: Column(
          children: [
            _header(),
            Expanded(child: _body()),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.slate200)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 15,
                  offset: Offset(0, -4)),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: _go,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: AppColors.celadon,
            unselectedItemColor: AppColors.slate400,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined), label: 'أخبار'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb_outline), label: 'نصائح'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.folder_open_outlined), label: 'الوثائق'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'حسابي'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.slate200)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: AppColors.prussian, shape: BoxShape.circle),
                child: const Icon(Icons.explore_outlined,
                    size: 18, color: Color(0xFF6EE7B7)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('خطوة',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            color: AppColors.prussian)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 12, color: AppColors.amber),
                        const SizedBox(width: 4),
                        Text('${appState.points} نقطة',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.amber)),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                customBorder: const CircleBorder(),
                onTap: _openNotifications,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: AppColors.mintBg, shape: BoxShape.circle),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.notifications_none,
                          size: 22, color: AppColors.prussian),
                      if (_notifDot)
                        Positioned(
                          top: 9,
                          right: 10,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppColors.imperial,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}