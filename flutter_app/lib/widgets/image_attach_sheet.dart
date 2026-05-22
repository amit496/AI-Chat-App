import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/constants/brand_config.dart';
import '../core/theme/app_theme.dart';

/// Attach menu: gallery or camera (theme-aware).
Future<File?> showImageAttachSheet(BuildContext context) async {
  final isDark = AppTheme.isDark(context);
  final bg = isDark ? BrandConfig.darkSurface : BrandConfig.lightBg;
  final text = AppTheme.textPrimary(context);
  final muted = AppTheme.textMuted(context);
  final border = isDark ? BrandConfig.darkBorder : BrandConfig.lightBorder;

  return showModalBottomSheet<File?>(
    context: context,
    backgroundColor: bg,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Attach a photo to your message',
                style: TextStyle(fontSize: 14, color: muted),
              ),
              const SizedBox(height: 16),
              _AttachOption(
                icon: Icons.photo_library_outlined,
                title: 'Choose from gallery',
                subtitle: 'Pick an existing photo',
                textColor: text,
                mutedColor: muted,
                borderColor: border,
                tileBg: isDark ? BrandConfig.darkBg : BrandConfig.lightSurface,
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 75,
                    maxWidth: 1920,
                  );
                  if (ctx.mounted) Navigator.pop(ctx, picked != null ? File(picked.path) : null);
                },
              ),
              const SizedBox(height: 10),
              _AttachOption(
                icon: Icons.photo_camera_outlined,
                title: 'Take a photo',
                subtitle: 'Use your camera',
                textColor: text,
                mutedColor: muted,
                borderColor: border,
                tileBg: isDark ? BrandConfig.darkBg : BrandConfig.lightSurface,
                onTap: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 75,
                    maxWidth: 1920,
                  );
                  if (ctx.mounted) Navigator.pop(ctx, picked != null ? File(picked.path) : null);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _AttachOption extends StatelessWidget {
  const _AttachOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
    required this.tileBg,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;
  final Color tileBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tileBg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: BrandConfig.accent, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: mutedColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: mutedColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
