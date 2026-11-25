import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/auth_screen.dart';
import 'screens/main_shell.dart';
import 'state/app_state.dart';
import 'theme/app_colors.dart';
import 'widgets/toast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load(); // restore saved login / points / progress
  runApp(const KhotwaApp());
}

class KhotwaApp extends StatelessWidget {
  const KhotwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'خطوة (Khotwa)',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.mintBg,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.celadon),
        textTheme: GoogleFonts.tajawalTextTheme().apply(
          bodyColor: AppColors.prussian,
          displayColor: AppColors.prussian,
        ),
      ),
      // Force right-to-left layout for the whole app (Arabic UI).
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: ListenableBuilder(
        listenable: appState,
        builder: (context, _) =>
            appState.isLoggedIn ? const MainShell() : const AuthScreen(),
      ),
    );
  }
}