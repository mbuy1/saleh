import 'package:flutter/material.dart';
import '../../../../shared/widgets/exports.dart';

/// قسم الكلمات المفتاحية للمنتج
class ProductKeywordsSection extends StatefulWidget {
  final List<String> keywords;
  final ValueChanged<List<String>> onKeywordsChanged;

  const ProductKeywordsSection({
    super.key,
    required this.keywords,
    required this.onKeywordsChanged,
  });

  @override
  State<ProductKeywordsSection> createState() => _ProductKeywordsSectionState();
}

class _ProductKeywordsSectionState extends State<ProductKeywordsSection> {
  final _keywordInputController = TextEditingController();

  @override
  void dispose() {
    _keywordInputController.dispose();
    super.dispose();
  }

  void _addKeyword(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isNotEmpty && !widget.keywords.contains(trimmed)) {
      final newKeywords = List<String>.from(widget.keywords)..add(trimmed);
      widget.onKeywordsChanged(newKeywords);
      _keywordInputController.clear();
    }
  }

  void _removeKeyword(String keyword) {
    final newKeywords = List<String>.from(widget.keywords)..remove(keyword);
    widget.onKeywordsChanged(newKeywords);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الكلمات المفتاحية (SEO)',
          style: TextStyle(
            fontSize: AppDimensions.fontBody,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dividerColor),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط الكلمات المفتاحية
              if (widget.keywords.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.keywords.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: TextStyle(fontSize: AppDimensions.fontLabel),
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeKeyword(tag),
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      deleteIconColor: AppTheme.primaryColor,
                      labelStyle: const TextStyle(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
              // حقل إضافة كلمة مفتاحية جديدة
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _keywordInputController,
                      decoration: InputDecoration(
                        hintText: 'أضف كلمة مفتاحية...',
                        hintStyle: TextStyle(fontSize: AppDimensions.fontBody),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: _addKeyword,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => _addKeyword(_keywordInputController.text),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'اضغط Enter أو + لإضافة كلمة مفتاحية',
          style: TextStyle(
            fontSize: AppDimensions.fontLabel,
            color: AppTheme.textHintColor,
          ),
        ),
      ],
    );
  }
}
