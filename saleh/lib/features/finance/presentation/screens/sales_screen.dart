import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../core/theme/app_theme.dart';

/// شاشة تقارير المبيعات
/// ملاحظة: مطلوب ربطها بالبيانات الحقيقية من API مستقبلاً
class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String _selectedPeriod = 'week';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundColorDark
          : AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header ثابت
            _buildHeader(context, isDark),
            // المحتوى القابل للتمرير
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // فلتر الوقت
                    _buildTimeFilter(isDark),
                    // بطاقات KPI
                    _buildKPICards(isDark),
                    // مخطط تحليل الإيرادات
                    _buildRevenueChart(isDark),
                    // المبيعات حسب الفئة والمنتجات الأكثر مبيعاً
                    _buildCategoryAndProducts(isDark),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // زر تصدير التقرير
      floatingActionButton: _buildExportButton(isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.backgroundColorDark.withValues(alpha: 0.9)
            : AppTheme.backgroundLight.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
                : AppTheme.textHintColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // زر الرجوع
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
                    : AppTheme.textHintColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: AppIcon(
                AppIcons.arrowBack,
                size: 24,
                color: isDark
                    ? AppTheme.textPrimaryColorDark
                    : AppTheme.textPrimaryColor,
              ),
            ),
          ),
          // العنوان
          Expanded(
            child: Text(
              'المبيعات',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppTheme.textPrimaryColorDark
                    : AppTheme.textPrimaryColor,
              ),
            ),
          ),
          // مساحة فارغة لموازنة زر الرجوع
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTimeFilter(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.surfaceDarkAccent
              : AppTheme.textHintColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildFilterOption('today', 'اليوم', isDark),
            _buildFilterOption('week', 'أسبوع', isDark),
            _buildFilterOption('month', 'شهر', isDark),
            _buildFilterOption('year', 'سنة', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String value, String label, bool isDark) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                      ? AppTheme.backgroundColorDark
                      : AppTheme.surfaceColor)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? (isDark ? AppTheme.primaryColor : AppTheme.textPrimaryColor)
                  : (isDark
                        ? AppTheme.textSecondaryColorDark
                        : AppTheme.textHintColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKPICards(bool isDark) {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildKPICard(
            isDark: isDark,
            icon: AppIcons.wallet,
            iconColor: isDark ? AppTheme.primaryColor : AppTheme.successColor,
            title: 'إجمالي المبيعات',
            value: '٥٤,٠٠٠',
            unit: 'ر.س',
            changePercent: 12,
            isPositive: true,
          ),
          const SizedBox(width: 16),
          _buildKPICard(
            isDark: isDark,
            icon: AppIcons.orders,
            iconColor: isDark ? Colors.blue[400]! : Colors.blue[500]!,
            title: 'عدد الطلبات',
            value: '١٤٥',
            unit: 'طلب',
            changePercent: 5,
            isPositive: true,
          ),
          const SizedBox(width: 16),
          _buildKPICard(
            isDark: isDark,
            icon: AppIcons.chart,
            iconColor: isDark ? Colors.purple[400]! : Colors.purple[500]!,
            title: 'متوسط السلة',
            value: '٣٧٠',
            unit: 'ر.س',
            changePercent: 2,
            isPositive: false,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildKPICard({
    required bool isDark,
    required String icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    required int changePercent,
    required bool isPositive,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDarkAccent : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : AppTheme.textHintColorDark,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.backgroundColorDark
                      : AppTheme.textHintColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppIcon(icon, size: 24, color: iconColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? (isDark
                            ? AppTheme.primaryColor.withValues(alpha: 0.1)
                            : AppTheme.successColor.withValues(alpha: 0.1))
                      : (isDark
                            ? Colors.red.withValues(alpha: 0.1)
                            : Colors.red[50]),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isPositive
                          ? (isDark
                                ? AppTheme.primaryColor
                                : AppTheme.successColor)
                          : (isDark ? Colors.red[400] : Colors.red[500]),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$changePercent%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPositive
                            ? (isDark
                                  ? AppTheme.primaryColor
                                  : AppTheme.successColor)
                            : (isDark ? Colors.red[400] : Colors.red[500]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppTheme.textSecondaryColorDark
                  : AppTheme.textHintColor,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.textPrimaryColorDark
                      : AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppTheme.textHintColorDark
                      : AppTheme.textHintColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDarkAccent : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
                : AppTheme.textHintColor.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تحليل الإيرادات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.textPrimaryColorDark
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الأداء خلال الـ ٧ أيام الماضية',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppTheme.textSecondaryColorDark
                            : AppTheme.textHintColor,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    color: isDark
                        ? AppTheme.textHintColorDark
                        : AppTheme.textHintColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // الرسم البياني
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _ChartPainter(isDark: isDark),
              ),
            ),
            const SizedBox(height: 16),
            // أيام الأسبوع
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDayLabel('السبت', isDark),
                _buildDayLabel('الأحد', isDark),
                _buildDayLabel('الاثنين', isDark),
                _buildDayLabel('الثلاثاء', isDark),
                _buildDayLabel('الأربعاء', isDark),
                _buildDayLabel('الخميس', isDark),
                _buildDayLabel('الجمعة', isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayLabel(String day, bool isDark) {
    return Text(
      day,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: isDark
            ? AppTheme.textSecondaryColorDark
            : AppTheme.textHintColor,
      ),
    );
  }

  Widget _buildCategoryAndProducts(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // المبيعات حسب الفئة
          _buildCategoryChart(isDark),
          const SizedBox(height: 16),
          // المنتجات الأكثر مبيعاً
          _buildTopProducts(isDark),
        ],
      ),
    );
  }

  Widget _buildCategoryChart(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDarkAccent : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
              : AppTheme.textHintColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المبيعات حسب الفئة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppTheme.textPrimaryColorDark
                  : AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // الدونت تشارت
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _DonutChartPainter(isDark: isDark),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '145',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppTheme.textPrimaryColorDark
                                : AppTheme.textPrimaryColor,
                          ),
                        ),
                        Text(
                          'طلب',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppTheme.textSecondaryColorDark
                                : AppTheme.textHintColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem(
                      'إلكترونيات',
                      '60%',
                      AppTheme.primaryColor,
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildLegendItem('أزياء', '25%', Colors.blue[500]!, isDark),
                    const SizedBox(height: 12),
                    _buildLegendItem(
                      'أخرى',
                      '15%',
                      Colors.yellow[600]!,
                      isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    String label,
    String percent,
    Color color,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppTheme.textSecondaryColorDark
                    : AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        Text(
          percent,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark
                ? AppTheme.textPrimaryColorDark
                : AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProducts(bool isDark) {
    return Column(
      children: [
        // العنوان
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المنتجات الأكثر مبيعاً',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppTheme.textPrimaryColorDark
                    : AppTheme.textPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'عرض الكل',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // قائمة المنتجات
        _buildProductItem(
          isDark: isDark,
          imageUrl: 'https://via.placeholder.com/56',
          name: 'حذاء رياضي نايكي أحمر',
          stock: 45,
          isLowStock: false,
          price: '٤٥٠ ر.س',
          sold: 24,
        ),
        const SizedBox(height: 12),
        _buildProductItem(
          isDark: isDark,
          imageUrl: 'https://via.placeholder.com/56',
          name: 'سماعات رأس لاسلكية',
          stock: 12,
          isLowStock: false,
          price: '٣٢٠ ر.س',
          sold: 18,
        ),
        const SizedBox(height: 12),
        _buildProductItem(
          isDark: isDark,
          imageUrl: 'https://via.placeholder.com/56',
          name: 'ساعة ذكية ألترا',
          stock: 8,
          isLowStock: true,
          price: '٩٩٩ ر.س',
          sold: 12,
        ),
      ],
    );
  }

  Widget _buildProductItem({
    required bool isDark,
    required String imageUrl,
    required String name,
    required int stock,
    required bool isLowStock,
    required String price,
    required int sold,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDarkAccent : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
              : AppTheme.textHintColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة المنتج
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
                  : AppTheme.textHintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image,
                  color: isDark
                      ? AppTheme.textHintColorDark
                      : AppTheme.textHintColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // معلومات المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppTheme.textPrimaryColorDark
                        : AppTheme.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isLowStock
                        ? (isDark
                              ? Colors.red[900]!.withValues(alpha: 0.2)
                              : Colors.red[100])
                        : (isDark
                              ? AppTheme.textHintColorDark.withValues(
                                  alpha: 0.2,
                                )
                              : AppTheme.textHintColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isLowStock ? 'منخفض: $stock' : 'المخزون: $stock',
                    style: TextStyle(
                      fontSize: 11,
                      color: isLowStock
                          ? (isDark ? Colors.red[400] : Colors.red[500])
                          : (isDark
                                ? AppTheme.textSecondaryColorDark
                                : AppTheme.textHintColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // السعر والمبيعات
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppTheme.textPrimaryColorDark
                      : AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$sold مبيعة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          // تصدير التقرير
        },
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        icon: const Icon(Icons.download, size: 24),
        label: const Text(
          'تصدير التقرير',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// رسام المخطط البياني
class _ChartPainter extends CustomPainter {
  final bool isDark;

  _ChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryColor.withValues(alpha: 0.25),
          AppTheme.primaryColor.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // رسم خطوط الشبكة
    for (int i = 0; i < 5; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // نقاط البيانات (نسبة من الارتفاع)
    final points = [0.76, 0.56, 0.56, 0.24, 0.24, 0.5, 0.2];

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height * points[i];

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        // منحنى ناعم
        final prevX = size.width * (i - 1) / (points.length - 1);
        final prevY = size.height * points[i - 1];
        final controlX1 = prevX + (x - prevX) / 2;
        final controlX2 = prevX + (x - prevX) / 2;
        path.cubicTo(controlX1, prevY, controlX2, y, x, y);
        fillPath.cubicTo(controlX1, prevY, controlX2, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // رسم نقطة التفاعل
    final dotPaint = Paint()
      ..color = isDark ? AppTheme.backgroundColorDark : AppTheme.surfaceColor
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final dotX = size.width * 3 / (points.length - 1);
    final dotY = size.height * points[3];

    canvas.drawCircle(Offset(dotX, dotY), 5, dotPaint);
    canvas.drawCircle(Offset(dotX, dotY), 5, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// رسام الدونت تشارت
class _DonutChartPainter extends CustomPainter {
  final bool isDark;

  _DonutChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 12.0;

    // خلفية الدائرة
    final bgPaint = Paint()
      ..color = isDark
          ? AppTheme.textHintColorDark.withValues(alpha: 0.2)
          : AppTheme.textHintColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    // قطاع الإلكترونيات (60%)
    final segment1Paint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90 درجة (البداية من الأعلى)
      3.7699, // 60% * 2π
      false,
      segment1Paint,
    );

    // قطاع الأزياء (25%)
    final segment2Paint = Paint()
      ..color = Colors.blue[500]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.1991, // بداية بعد 60%
      1.5708, // 25% * 2π
      false,
      segment2Paint,
    );

    // قطاع الأخرى (15%)
    final segment3Paint = Paint()
      ..color = Colors.yellow[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.7699, // بداية بعد 85%
      0.9425, // 15% * 2π
      false,
      segment3Paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
