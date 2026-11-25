import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// White rounded card with a thin border (the `bg-white rounded-2xl shadow-sm border` look).
BoxDecoration cardBox({
  Color border = AppColors.slate100,
  double borderWidth = 1,
}) =>
    BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border, width: borderWidth),
      boxShadow: const [
        BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1)),
      ],
    );

class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    required this.bg,
    required this.fg,
    this.size = 11,
    this.radius = 999,
  });

  final String text;
  final Color bg;
  final Color fg;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius)),
      child: Text(
        text,
        style: TextStyle(fontSize: size, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

class IconBox extends StatelessWidget {
  const IconBox(
    this.icon, {
    super.key,
    required this.bg,
    required this.fg,
    this.size = 36,
    this.iconSize = 18,
    this.radius = 12,
  });

  final IconData icon;
  final Color bg;
  final Color fg;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius)),
      child: Icon(icon, size: iconSize, color: fg),
    );
  }
}

/// "رجوع للقائمة" button used by the detail views.
class BackPill extends StatelessWidget {
  const BackPill({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, size: 16, color: AppColors.prussian),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.prussian)),
            ],
          ),
        ),
      ),
    );
  }
}