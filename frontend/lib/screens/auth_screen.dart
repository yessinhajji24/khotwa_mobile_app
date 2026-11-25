import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/toast.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const _levels = [
    'تلميذ بكالوريا 2026',
    'طالب مرحلة تحضيرية',
    'طالب هندسة',
    'طالب إجازة',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController(text: 'mohamed.benali@etudiant.tn');
  final _passCtrl = TextEditingController(text: '12345678');
  String _level = 'طالب هندسة';
  bool _signUp = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    appState.login(
      email: _emailCtrl.text.trim(),
      name: _signUp ? _nameCtrl.text.trim() : null,
      level: _signUp ? _level : null,
    );
    showToast('مرحباً بك في خطوة يا ${appState.firstName}!', success: true);
  }

  InputDecoration _deco(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 14),
        prefixIcon: Icon(icon, size: 18, color: AppColors.slate400),
        filled: true,
        fillColor: AppColors.slate50,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.celadon),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.imperial),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.imperial),
        ),
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.prussian)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x0D064E3B)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                                color: AppColors.prussian,
                                shape: BoxShape.circle),
                            child: const Icon(Icons.explore_outlined,
                                size: 28, color: Color(0xFF6EE7B7)),
                          ),
                          const SizedBox(height: 12),
                          const Text('خطوة',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.prussian)),
                          const SizedBox(height: 4),
                          const Text('رفيقك الذكي في المسار الجامعي التونسي',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.slate500)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (_signUp) ...[
                      _label('الاسم واللقب'),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration:
                            _deco('مثال: محمد بن علي', Icons.person_outline),
                      ),
                      const SizedBox(height: 16),
                      _label('المستوى الدراسي'),
                      DropdownButtonFormField<String>(
                        value: _level,
                        decoration: _deco('', Icons.school_outlined),
                        items: [
                          for (final l in _levels)
                            DropdownMenuItem(
                              value: l,
                              child: Text(l, style: const TextStyle(fontSize: 14)),
                            ),
                        ],
                        onChanged: (v) => setState(() => _level = v ?? _level),
                      ),
                      const SizedBox(height: 16),
                    ],

                    _label('البريد الإلكتروني'),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      decoration:
                          _deco('student@etudiant.tn', Icons.mail_outline),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 16),

                    _label('كلمة العبور'),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: true,
                      textDirection: TextDirection.ltr,
                      decoration: _deco('••••••••', Icons.lock_outline),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.celadon,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submit,
                        child: Text(
                          _signUp ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.slate100),
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            _signUp ? 'عندك حساب بالفعل؟' : 'ما عندكش حساب؟',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.slate500),
                          ),
                          TextButton(
                            onPressed: () => setState(() => _signUp = !_signUp),
                            child: Text(
                              _signUp ? 'تسجيل الدخول' : 'إنشاء حساب جديد',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.celadon),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}