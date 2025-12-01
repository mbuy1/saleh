import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

/// شريط بحث محسّن بنمط Alibaba مع أيقونات إضافية
class EnhancedSearchBar extends StatefulWidget {
  final List<String> placeholders;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onImageSearch;
  final bool showVoiceSearch;
  final bool showImageSearch;

  const EnhancedSearchBar({
    super.key,
    this.placeholders = const ['ابحث عن منتجات...'],
    this.controller,
    this.onChanged,
    this.onVoiceSearch,
    this.onImageSearch,
    this.showVoiceSearch = true,
    this.showImageSearch = true,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  int _currentPlaceholderIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.placeholders.length > 1) {
      _startPlaceholderRotation();
    }
  }

  void _startPlaceholderRotation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentPlaceholderIndex =
              (_currentPlaceholderIndex + 1) % widget.placeholders.length;
        });
        _startPlaceholderRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة البحث على اليسار
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.search,
              color: MbuyColors.textSecondary,
              size: 22,
            ),
          ),
          // حقل البحث
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: MbuyColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.placeholders[_currentPlaceholderIndex],
                hintStyle: GoogleFonts.cairo(
                  fontSize: 14,
                  color: MbuyColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
            ),
          ),
          // أيقونة البحث بالصورة
          if (widget.showImageSearch)
            IconButton(
              icon: const Icon(
                Icons.photo_camera_outlined,
                color: MbuyColors.textSecondary,
                size: 22,
              ),
              onPressed:
                  widget.onImageSearch ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('قريباً: البحث بالصورة')),
                    );
                  },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40),
            ),
          // أيقونة البحث الصوتي
          if (widget.showVoiceSearch)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: const Icon(
                  Icons.mic_outlined,
                  color: MbuyColors.primaryPurple,
                  size: 22,
                ),
                onPressed:
                    widget.onVoiceSearch ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('قريباً: البحث الصوتي')),
                      );
                    },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40),
              ),
            ),
        ],
      ),
    );
  }
}
