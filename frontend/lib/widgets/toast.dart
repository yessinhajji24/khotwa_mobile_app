import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Attach this key to MaterialApp.scaffoldMessengerKey (done in main.dart).
final messengerKey = GlobalKey<ScaffoldMessengerState>();

void showToast(String message, {bool success = false}) {
  final messenger = messengerKey.currentState;
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
        ),
        backgroundColor: success ? AppColors.emerald : AppColors.prussian,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 90), // sits above bottom nav
        duration: const Duration(milliseconds: 2600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}