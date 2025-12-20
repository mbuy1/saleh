import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../../shared/widgets/exports.dart';

/// قسم الوسائط في نموذج إضافة المنتج
class ProductMediaSection extends StatelessWidget {
  final List<XFile> selectedImages;
  final XFile? selectedVideo;
  final List<String> mediaUrls;
  final int mainImageIndex;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;
  final Function(int) onRemoveImage;
  final VoidCallback onRemoveVideo;
  final Function(int) onRemoveMediaUrl;
  final Function(String) onAddMediaUrl;
  final Function(int) onSetMainImage;

  const ProductMediaSection({
    super.key,
    required this.selectedImages,
    required this.selectedVideo,
    required this.mediaUrls,
    required this.mainImageIndex,
    required this.onPickImages,
    required this.onPickVideo,
    required this.onRemoveImage,
    required this.onRemoveVideo,
    required this.onRemoveMediaUrl,
    required this.onAddMediaUrl,
    required this.onSetMainImage,
  });

  @override
  Widget build(BuildContext context) {
    return MbuyCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildSubtitle(),
          const SizedBox(height: 16),
          _buildMediaArea(context),
          const SizedBox(height: 16),
          _buildActionButtons(),
          const SizedBox(height: 16),
          _buildMediaUrlInput(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.addPhoto,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            AppTheme.primaryColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'الوسائط (صور وفيديو)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'أضف صور وفيديو للمنتج (4 صور كحد أقصى)',
      style: TextStyle(
        fontSize: AppDimensions.fontCaption,
        color: AppTheme.textSecondaryColor,
      ),
    );
  }

  Widget _buildMediaArea(BuildContext context) {
    return GestureDetector(
      onTap: onPickImages,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          border: Border.all(
            color: AppTheme.dividerColor,
            style: BorderStyle.solid,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child:
            selectedImages.isEmpty && selectedVideo == null && mediaUrls.isEmpty
            ? _buildEmptyState()
            : _buildMediaPreview(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIcons.uploadCloud,
          width: 48,
          height: 48,
          colorFilter: const ColorFilter.mode(
            AppTheme.textHintColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'اضغط لاختيار الصور',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'PNG, JPG, WEBP حتى 5MB',
          style: TextStyle(
            fontSize: AppDimensions.fontCaption,
            color: AppTheme.textHintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPreview() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // عرض الصور المختارة
            ...selectedImages.asMap().entries.map((entry) {
              final isMain = entry.key == mainImageIndex;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () => onSetMainImage(entry.key),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isMain
                              ? Border.all(
                                  color: AppTheme.primaryColor,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(entry.value.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isMain)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'رئيسية',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onRemoveImage(entry.key),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            // عرض الفيديو المختار
            if (selectedVideo != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.videocam,
                          size: 40,
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onRemoveVideo,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // عرض روابط الوسائط
            ...mediaUrls.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.dividerColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          entry.value,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.link,
                                size: 32,
                                color: AppTheme.textHintColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => onRemoveMediaUrl(entry.key),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            // زر إضافة المزيد
            if (selectedImages.length < 4)
              GestureDetector(
                onTap: onPickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border.all(color: AppTheme.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 32,
                        color: AppTheme.textHintColor,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'إضافة',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: selectedImages.length < 4 ? onPickImages : null,
            icon: const Icon(Icons.photo_library, size: 18),
            label: const Text('صورة'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: selectedVideo == null ? onPickVideo : null,
            icon: const Icon(Icons.videocam, size: 18),
            label: const Text('فيديو'),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaUrlInput(BuildContext context) {
    final controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'رابط صورة خارجية',
              hintText: 'https://example.com/image.jpg',
              prefixIcon: const Icon(Icons.link),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onAddMediaUrl(controller.text);
              controller.clear();
            }
          },
          icon: const Icon(Icons.add_circle, color: AppTheme.primaryColor),
        ),
      ],
    );
  }
}
