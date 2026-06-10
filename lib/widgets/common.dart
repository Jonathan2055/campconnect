import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/helpers.dart';

/// Maps a category string to an accent colour so tags stay consistent app-wide.
Color categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'competition':
      return AppColors.green;
    case 'opportunity':
    case 'leadership':
      return AppColors.purple;
    case 'event':
    case 'tech':
      return AppColors.blue;
    case 'internship':
      return AppColors.teal;
    case 'workshop':
    case 'design':
      return AppColors.pink;
    case 'startup':
    case 'pitch':
      return AppColors.emerald;
    default:
      return AppColors.emerald;
  }
}

/// Initials-in-a-circle avatar. Avoids broken network images in the demo.
class Avatar extends StatelessWidget {
  final String name;
  final Color color;
  final double size;
  const Avatar(
      {super.key, required this.name, required this.color, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.4),
      ),
      alignment: Alignment.center,
      child: Text(
        initialsFrom(name),
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold, fontSize: size * 0.34),
      ),
    );
  }
}

/// Gradient "cover image" placeholder with a centred icon.
class GradientCover extends StatelessWidget {
  final List<Color> colors;
  final double height;
  final double? width;
  final IconData icon;
  final BorderRadius? radius;
  const GradientCover({
    super.key,
    required this.colors,
    this.height = 150,
    this.width,
    this.icon = Icons.event,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: radius ?? BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(icon,
            color: Colors.white.withValues(alpha: 0.85), size: height * 0.32),
      ),
    );
  }
}

class PillTag extends StatelessWidget {
  final String label;
  final Color color;
  const PillTag({super.key, required this.label, this.color = AppColors.purple});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('See all',
                style: TextStyle(
                    color: AppColors.emerald, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  const GoldButton(
      {super.key, required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emerald,
          foregroundColor: AppColors.onEmerald,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class OutlineButton2 extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  const OutlineButton2(
      {super.key,
      required this.label,
      required this.onTap,
      this.color = AppColors.emerald});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child: Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      ),
    );
  }
}

/// Two-option pill switch reused by Communities and My RSVPs screens.
class SegmentedToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool leftSelected;
  final ValueChanged<bool> onChanged; // true = left selected
  const SegmentedToggle({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.leftSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _seg(leftLabel, leftSelected, () => onChanged(true)),
          _seg(rightLabel, !leftSelected, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _seg(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.emerald : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? AppColors.onEmerald : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Friendly empty-state used wherever a list can be empty.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
