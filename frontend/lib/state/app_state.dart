import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single global instance used across the app.
final appState = AppState();

class AppState extends ChangeNotifier {
  static const _storageKey = 'khotwa_app_state_v1';

  bool isLoggedIn = false;
  String name = 'محمد بن علي';
  String email = 'mohamed.benali@etudiant.tn';
  String level = 'طالب هندسة';
  int points = 120;
  final Set<int> readArticles = {};
  final Map<String, Set<int>> checkedPapers = {};

  String get firstName {
    final first = name.trim().split(' ').first;
    return first.isEmpty ? 'صديقي' : first;
  }

  String get initial => firstName.substring(0, 1);

  int get totalChecked =>
      checkedPapers.values.fold(0, (sum, s) => sum + s.length);

  // ---------- persistence ----------
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) return;
      final m = jsonDecode(raw) as Map<String, dynamic>;
      isLoggedIn = m['isLoggedIn'] as bool? ?? false;
      name = m['name'] as String? ?? name;
      email = m['email'] as String? ?? email;
      level = m['level'] as String? ?? level;
      points = m['points'] as int? ?? points;
      readArticles
        ..clear()
        ..addAll(((m['readArticles'] as List?) ?? []).cast<int>());
      checkedPapers.clear();
      ((m['checkedPapers'] as Map?) ?? {}).forEach((k, v) {
        checkedPapers[k as String] = (v as List).cast<int>().toSet();
      });
    } catch (_) {
      // corrupted data -> keep defaults
    }
  }

  Future<void> _commit() async {
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        jsonEncode({
          'isLoggedIn': isLoggedIn,
          'name': name,
          'email': email,
          'level': level,
          'points': points,
          'readArticles': readArticles.toList(),
          'checkedPapers':
              checkedPapers.map((k, v) => MapEntry(k, v.toList())),
        }),
      );
    } catch (e) {
      debugPrint('Failed to save state: $e');
    }
  }

  // ---------- auth ----------
  void login({required String email, String? name, String? level}) {
    if (name != null && name.isNotEmpty) {
      this.name = name;
      if (level != null) this.level = level;
    }
    if (email.isNotEmpty) this.email = email;
    isLoggedIn = true;
    _commit();
  }

  void logout() {
    isLoggedIn = false;
    _commit();
  }

  // ---------- points / articles / papers ----------
  void addPoints(int n) {
    points += n;
    _commit();
  }

  /// Returns true if the article was newly marked as read (+15 pts).
  bool markArticleRead(int id) {
    if (readArticles.contains(id)) return false;
    readArticles.add(id);
    points += 15;
    _commit();
    return true;
  }

  /// Returns true if the item became checked (+5 pts), false if unchecked (-5 pts).
  bool togglePaperItem(String paperId, int index) {
    final set = checkedPapers.putIfAbsent(paperId, () => <int>{});
    final added = set.add(index);
    if (added) {
      points += 5;
    } else {
      set.remove(index);
      points = points >= 5 ? points - 5 : 0;
    }
    _commit();
    return added;
  }
}