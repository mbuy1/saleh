import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_form_state.dart';
import '../../../../../../shared/widgets/exports.dart';

/// حقول المنتج الرقمي
class DigitalProductFields extends StatelessWidget {
  final TextEditingController fileUrlController;
  final TextEditingController downloadLimitController;
  final String selectedFileType;
  final Function(String) onFileTypeChanged;

  const DigitalProductFields({
    super.key,
    required this.fileUrlController,
    required this.downloadLimitController,
    required this.selectedFileType,
    required this.onFileTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cloud_download,
                    color: productTypes[ProductType.digital]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات المنتج الرقمي',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // رابط الملف
              TextFormField(
                controller: fileUrlController,
                decoration: InputDecoration(
                  labelText: 'رابط الملف *',
                  hintText: 'https://example.com/file.pdf',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.url,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 12),

              // نوع الملف وحد التحميل
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedFileType,
                      decoration: InputDecoration(
                        labelText: 'نوع الملف',
                        prefixIcon: const Icon(Icons.insert_drive_file),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                        DropdownMenuItem(value: 'zip', child: Text('ZIP')),
                        DropdownMenuItem(value: 'video', child: Text('فيديو')),
                        DropdownMenuItem(value: 'audio', child: Text('صوت')),
                        DropdownMenuItem(
                          value: 'ebook',
                          child: Text('كتاب إلكتروني'),
                        ),
                        DropdownMenuItem(
                          value: 'software',
                          child: Text('برنامج'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('أخرى')),
                      ],
                      onChanged: (value) => onFileTypeChanged(value ?? 'pdf'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: downloadLimitController,
                      decoration: InputDecoration(
                        labelText: 'حد التحميل',
                        hintText: 'مثل: 5',
                        prefixIcon: const Icon(Icons.download),
                        suffixText: 'مرة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '💡 اترك حد التحميل فارغاً للسماح بتحميلات غير محدودة',
                style: TextStyle(
                  fontSize: AppDimensions.fontCaption,
                  color: AppTheme.textHintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }
}

/// حقول الخدمات
class ServiceFields extends StatelessWidget {
  final TextEditingController durationController;
  final TextEditingController deliveryTimeController;
  final TextEditingController revisionsController;

  const ServiceFields({
    super.key,
    required this.durationController,
    required this.deliveryTimeController,
    required this.revisionsController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.handyman,
                    color: productTypes[ProductType.service]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الخدمة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // مدة الخدمة ووقت التسليم
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: durationController,
                      decoration: InputDecoration(
                        labelText: 'مدة الخدمة',
                        hintText: 'مثل: ساعة',
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: deliveryTimeController,
                      decoration: InputDecoration(
                        labelText: 'وقت التسليم',
                        hintText: 'مثل: 3 أيام',
                        prefixIcon: const Icon(Icons.schedule),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // عدد التعديلات
              TextFormField(
                controller: revisionsController,
                decoration: InputDecoration(
                  labelText: 'عدد التعديلات المسموحة',
                  hintText: 'مثل: 3',
                  prefixIcon: const Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }
}

/// حقول الأكل والمشروبات
class FoodFields extends StatelessWidget {
  final TextEditingController caloriesController;
  final TextEditingController ingredientsController;
  final TextEditingController prepTimeController;
  final List<String> selectedAllergens;
  final Function(String) onAddAllergen;
  final Function(String) onRemoveAllergen;

  const FoodFields({
    super.key,
    required this.caloriesController,
    required this.ingredientsController,
    required this.prepTimeController,
    required this.selectedAllergens,
    required this.onAddAllergen,
    required this.onRemoveAllergen,
  });

  static const List<String> _commonAllergens = [
    'قمح/جلوتين',
    'بيض',
    'حليب/لاكتوز',
    'مكسرات',
    'فول سوداني',
    'صويا',
    'سمك',
    'محار',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant,
                    color: productTypes[ProductType.foodAndBeverage]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الأكل والمشروبات',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // وقت التحضير والسعرات
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: prepTimeController,
                      decoration: InputDecoration(
                        labelText: 'وقت التحضير',
                        hintText: 'مثل: 30 دقيقة',
                        prefixIcon: const Icon(Icons.timer),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: caloriesController,
                      decoration: InputDecoration(
                        labelText: 'السعرات الحرارية',
                        hintText: 'مثل: 250',
                        prefixIcon: const Icon(Icons.local_fire_department),
                        suffixText: 'سعرة',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // المكونات
              TextFormField(
                controller: ingredientsController,
                decoration: InputDecoration(
                  labelText: 'المكونات',
                  hintText: 'اذكر المكونات الرئيسية',
                  prefixIcon: const Icon(Icons.list_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              // المسببات للحساسية
              const Text(
                'مسببات الحساسية:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _commonAllergens.map((allergen) {
                  final isSelected = selectedAllergens.contains(allergen);
                  return FilterChip(
                    label: Text(allergen),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        onAddAllergen(allergen);
                      } else {
                        onRemoveAllergen(allergen);
                      }
                    },
                    selectedColor: Colors.orange.withValues(alpha: 0.2),
                    checkmarkColor: Colors.orange,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }
}

/// حقول الاشتراكات
class SubscriptionFields extends StatelessWidget {
  final String billingCycle;
  final TextEditingController trialDaysController;
  final List<String> features;
  final Function(String) onBillingCycleChanged;
  final Function(String) onAddFeature;
  final Function(String) onRemoveFeature;

  const SubscriptionFields({
    super.key,
    required this.billingCycle,
    required this.trialDaysController,
    required this.features,
    required this.onBillingCycleChanged,
    required this.onAddFeature,
    required this.onRemoveFeature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.autorenew,
                    color: productTypes[ProductType.subscription]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الاشتراك',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // دورة الفوترة
              DropdownButtonFormField<String>(
                initialValue: billingCycle,
                decoration: InputDecoration(
                  labelText: 'دورة الفوترة',
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'weekly', child: Text('أسبوعي')),
                  DropdownMenuItem(value: 'monthly', child: Text('شهري')),
                  DropdownMenuItem(value: 'quarterly', child: Text('ربع سنوي')),
                  DropdownMenuItem(value: 'yearly', child: Text('سنوي')),
                ],
                onChanged: (value) => onBillingCycleChanged(value ?? 'monthly'),
              ),
              const SizedBox(height: 12),

              // فترة التجربة
              TextFormField(
                controller: trialDaysController,
                decoration: InputDecoration(
                  labelText: 'فترة التجربة المجانية',
                  hintText: 'مثل: 7',
                  prefixIcon: const Icon(Icons.card_giftcard),
                  suffixText: 'يوم',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 12),

              // مميزات الاشتراك
              const Text(
                'مميزات الاشتراك:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: features.map((feature) {
                  return Chip(
                    label: Text(feature),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => onRemoveFeature(feature),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }
}

/// حقول التذاكر والحجوزات
class TicketFields extends StatelessWidget {
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final TextEditingController locationController;
  final TextEditingController seatsController;
  final Function(DateTime?) onDateChanged;
  final Function(TimeOfDay?) onTimeChanged;

  const TicketFields({
    super.key,
    required this.eventDate,
    required this.eventTime,
    required this.locationController,
    required this.seatsController,
    required this.onDateChanged,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number,
                    color: productTypes[ProductType.ticket]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'معلومات الفعالية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // التاريخ والوقت
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: eventDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        onDateChanged(date);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'تاريخ الفعالية *',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                          ),
                        ),
                        child: Text(
                          eventDate != null
                              ? '${eventDate!.day}/${eventDate!.month}/${eventDate!.year}'
                              : 'اختر التاريخ',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: eventTime ?? TimeOfDay.now(),
                        );
                        onTimeChanged(time);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'الوقت',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusM,
                            ),
                          ),
                        ),
                        child: Text(
                          eventTime != null
                              ? '${eventTime!.hour}:${eventTime!.minute.toString().padLeft(2, '0')}'
                              : 'اختر الوقت',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // الموقع
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'الموقع',
                  hintText: 'مثل: الرياض - مركز الملك عبدالعزيز',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // عدد المقاعد
              TextFormField(
                controller: seatsController,
                decoration: InputDecoration(
                  labelText: 'عدد المقاعد المتاحة',
                  hintText: 'مثل: 100',
                  prefixIcon: const Icon(Icons.event_seat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }
}

/// حقول المنتجات القابلة للتخصيص
class CustomizableFields extends StatelessWidget {
  final List<Map<String, dynamic>> customizationOptions;
  final bool previewEnabled;
  final VoidCallback onAddOption;
  final Function(int) onRemoveOption;
  final Function(bool) onPreviewChanged;

  const CustomizableFields({
    super.key,
    required this.customizationOptions,
    required this.previewEnabled,
    required this.onAddOption,
    required this.onRemoveOption,
    required this.onPreviewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MbuyCard(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune,
                    color: productTypes[ProductType.customizable]!.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'خيارات التخصيص',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // خيارات التخصيص
              if (customizationOptions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.slate100,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: const Center(
                    child: Text(
                      'لم تتم إضافة خيارات تخصيص بعد',
                      style: TextStyle(color: AppTheme.textSecondaryColor),
                    ),
                  ),
                )
              else
                ...customizationOptions.asMap().entries.map((entry) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        _getOptionIcon(
                          entry.value['type'] as String? ?? 'text',
                        ),
                        color: AppTheme.primaryColor,
                      ),
                      title: Text(entry.value['name'] as String? ?? ''),
                      subtitle: Text(entry.value['type'] as String? ?? 'text'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onRemoveOption(entry.key),
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 12),

              // زر إضافة خيار
              OutlinedButton.icon(
                onPressed: onAddOption,
                icon: const Icon(Icons.add),
                label: const Text('إضافة خيار تخصيص'),
              ),

              const SizedBox(height: 16),

              // تفعيل المعاينة
              SwitchListTile(
                title: const Text('تفعيل المعاينة المباشرة'),
                subtitle: const Text('يمكن للعميل رؤية التخصيصات مباشرة'),
                value: previewEnabled,
                onChanged: onPreviewChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacing16),
      ],
    );
  }

  IconData _getOptionIcon(String type) {
    switch (type) {
      case 'text':
        return Icons.text_fields;
      case 'color':
        return Icons.palette;
      case 'image':
        return Icons.image;
      case 'size':
        return Icons.straighten;
      case 'dropdown':
        return Icons.arrow_drop_down_circle;
      default:
        return Icons.tune;
    }
  }
}
