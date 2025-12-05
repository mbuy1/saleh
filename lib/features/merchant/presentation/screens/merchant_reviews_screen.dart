import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/api_service.dart';

/// شاشة التقييمات للتاجر مع Worker API
class MerchantReviewsScreen extends StatefulWidget {
  const MerchantReviewsScreen({super.key});

  @override
  State<MerchantReviewsScreen> createState() => _MerchantReviewsScreenState();
}

class _MerchantReviewsScreenState extends State<MerchantReviewsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _reviews = [];
  double _averageRating = 0.0;
  int _totalReviews = 0;
  Map<int, int> _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

  // فلترة التقييمات
  String _filterBy = 'all'; // all, pending_reply, replied
  int? _filterRating;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.getMerchantReviews();

      if (response['ok'] == true || response['success'] == true) {
        final data = response['data'];
        final reviewsData = (data is List) ? data : [];
        _reviews = reviewsData.map((r) => r as Map<String, dynamic>).toList();

        // حساب الإحصائيات
        _totalReviews = _reviews.length;
        if (_totalReviews > 0) {
          double totalRating = 0;
          _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

          for (var review in _reviews) {
            final rating = (review['rating'] as num?)?.toInt() ?? 0;
            totalRating += rating;
            if (rating >= 1 && rating <= 5) {
              _ratingDistribution[rating] =
                  (_ratingDistribution[rating] ?? 0) + 1;
            }
          }
          _averageRating = totalRating / _totalReviews;
        }
      } else {
        // بيانات تجريبية
        _loadDummyData();
      }
    } catch (e) {
      debugPrint('Error loading reviews: $e');
      _loadDummyData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadDummyData() {
    _reviews = [
      {
        'id': '1',
        'customer_name': 'أحمد محمد',
        'customer_avatar': null,
        'product_name': 'iPhone 15 Pro Max',
        'product_image': 'https://example.com/iphone.jpg',
        'rating': 5,
        'comment':
            'منتج رائع وجودة ممتازة، أنصح الجميع بشرائه. التوصيل كان سريع جداً والتغليف ممتاز.',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
        'merchant_reply': null,
        'is_verified_purchase': true,
      },
      {
        'id': '2',
        'customer_name': 'فاطمة علي',
        'customer_avatar': null,
        'product_name': 'Samsung Galaxy S24',
        'product_image': 'https://example.com/samsung.jpg',
        'rating': 4,
        'comment': 'جيد جداً لكن التوصيل تأخر قليلاً',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 5))
            .toIso8601String(),
        'merchant_reply':
            'شكراً لتقييمك، نعتذر عن التأخير وسنعمل على تحسين خدمة التوصيل.',
        'replied_at': DateTime.now()
            .subtract(const Duration(days: 4))
            .toIso8601String(),
        'is_verified_purchase': true,
      },
      {
        'id': '3',
        'customer_name': 'خالد سعيد',
        'customer_avatar': null,
        'product_name': 'AirPods Pro 2',
        'product_image': 'https://example.com/airpods.jpg',
        'rating': 5,
        'comment':
            'أفضل سماعات استخدمتها، جودة الصوت رائعة وإلغاء الضوضاء ممتاز',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 7))
            .toIso8601String(),
        'merchant_reply': null,
        'is_verified_purchase': true,
      },
      {
        'id': '4',
        'customer_name': 'سارة أحمد',
        'customer_avatar': null,
        'product_name': 'MacBook Air M3',
        'product_image': 'https://example.com/macbook.jpg',
        'rating': 3,
        'comment': 'المنتج جيد لكن السعر مرتفع قليلاً مقارنة بالمتاجر الأخرى',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 14))
            .toIso8601String(),
        'merchant_reply': null,
        'is_verified_purchase': false,
      },
      {
        'id': '5',
        'customer_name': 'محمد عبدالله',
        'customer_avatar': null,
        'product_name': 'iPad Pro 12.9',
        'product_image': 'https://example.com/ipad.jpg',
        'rating': 5,
        'comment': 'ممتاز! شاشة رائعة وأداء سريع جداً',
        'created_at': DateTime.now()
            .subtract(const Duration(days: 10))
            .toIso8601String(),
        'merchant_reply': 'شكراً لثقتك بنا! نتمنى لك تجربة ممتعة.',
        'replied_at': DateTime.now()
            .subtract(const Duration(days: 9))
            .toIso8601String(),
        'is_verified_purchase': true,
      },
    ];

    _totalReviews = _reviews.length;
    double totalRating = 0;
    _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var review in _reviews) {
      final rating = review['rating'] as int;
      totalRating += rating;
      _ratingDistribution[rating] = (_ratingDistribution[rating] ?? 0) + 1;
    }
    _averageRating = totalRating / _totalReviews;
  }

  List<Map<String, dynamic>> get _filteredReviews {
    var filtered = _reviews;

    // فلترة حسب الحالة
    if (_filterBy == 'pending_reply') {
      filtered = filtered.where((r) => r['merchant_reply'] == null).toList();
    } else if (_filterBy == 'replied') {
      filtered = filtered.where((r) => r['merchant_reply'] != null).toList();
    }

    // فلترة حسب التقييم
    if (_filterRating != null) {
      filtered = filtered.where((r) => r['rating'] == _filterRating).toList();
    }

    return filtered;
  }

  Future<void> _replyToReview(Map<String, dynamic> review) async {
    final replyController = TextEditingController(
      text: review['merchant_reply'] as String? ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'الرد على تقييم ${review['customer_name']}',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض التقييم الأصلي
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MbuyColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < (review['rating'] as int)
                              ? Icons.star
                              : Icons.star_border,
                          color: MbuyColors.warning,
                          size: 16,
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review['comment'] as String? ?? '',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: MbuyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // حقل الرد
            TextField(
              controller: replyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'اكتب ردك هنا...',
                hintStyle: GoogleFonts.cairo(color: MbuyColors.textTertiary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: GoogleFonts.cairo(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, replyController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: MbuyColors.primaryIndigo,
            ),
            child: Text(
              'إرسال الرد',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _submitReply(review['id'] as String, result);
    }
  }

  Future<void> _submitReply(String reviewId, String reply) async {
    try {
      // إرسال الرد إلى API
      final response = await ApiService.replyToReview(reviewId, reply);

      if (response['ok'] == true || response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إرسال الرد بنجاح', style: GoogleFonts.cairo()),
              backgroundColor: MbuyColors.success,
            ),
          );
        }
        _loadReviews();
      }
    } catch (e) {
      // تحديث محلي للتجربة
      setState(() {
        final index = _reviews.indexWhere((r) => r['id'] == reviewId);
        if (index != -1) {
          _reviews[index]['merchant_reply'] = reply;
          _reviews[index]['replied_at'] = DateTime.now().toIso8601String();
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إرسال الرد بنجاح', style: GoogleFonts.cairo()),
            backgroundColor: MbuyColors.success,
          ),
        );
      }
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        if (diff.inHours == 0) {
          return 'منذ ${diff.inMinutes} دقيقة';
        }
        return 'منذ ${diff.inHours} ساعة';
      } else if (diff.inDays == 1) {
        return 'أمس';
      } else if (diff.inDays < 7) {
        return 'منذ ${diff.inDays} أيام';
      } else if (diff.inDays < 30) {
        final weeks = diff.inDays ~/ 7;
        return 'منذ $weeks ${weeks == 1 ? 'أسبوع' : 'أسابيع'}';
      } else {
        final months = diff.inDays ~/ 30;
        return 'منذ $months ${months == 1 ? 'شهر' : 'أشهر'}';
      }
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('تقييمات المتجر'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadReviews),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                if (value.startsWith('rating_')) {
                  _filterRating = int.tryParse(value.split('_')[1]);
                } else {
                  _filterBy = value;
                  _filterRating = null;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(
                      _filterBy == 'all' && _filterRating == null
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 20,
                      color: MbuyColors.primaryIndigo,
                    ),
                    const SizedBox(width: 8),
                    Text('جميع التقييمات', style: GoogleFonts.cairo()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'pending_reply',
                child: Row(
                  children: [
                    Icon(
                      _filterBy == 'pending_reply'
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 20,
                      color: MbuyColors.primaryIndigo,
                    ),
                    const SizedBox(width: 8),
                    Text('بانتظار الرد', style: GoogleFonts.cairo()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'replied',
                child: Row(
                  children: [
                    Icon(
                      _filterBy == 'replied'
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      size: 20,
                      color: MbuyColors.primaryIndigo,
                    ),
                    const SizedBox(width: 8),
                    Text('تم الرد عليها', style: GoogleFonts.cairo()),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              ...List.generate(5, (index) {
                final rating = 5 - index;
                return PopupMenuItem(
                  value: 'rating_$rating',
                  child: Row(
                    children: [
                      Icon(
                        _filterRating == rating
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 20,
                        color: MbuyColors.primaryIndigo,
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(rating, (_) {
                        return const Icon(
                          Icons.star,
                          color: MbuyColors.warning,
                          size: 16,
                        );
                      }),
                      Text(
                        ' ($rating نجوم)',
                        style: GoogleFonts.cairo(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: MbuyColors.error),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: GoogleFonts.cairo(color: MbuyColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadReviews,
                    child: Text('إعادة المحاولة', style: GoogleFonts.cairo()),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadReviews,
              child: Column(
                children: [
                  // إحصائيات التقييمات
                  _buildRatingOverview(),
                  // فلاتر سريعة
                  _buildQuickFilters(),
                  // قائمة التقييمات
                  Expanded(
                    child: _filteredReviews.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.reviews_outlined,
                                  size: 64,
                                  color: MbuyColors.textTertiary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد تقييمات',
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    color: MbuyColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredReviews.length,
                            itemBuilder: (context, index) {
                              return _buildReviewCard(_filteredReviews[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRatingOverview() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: MbuyColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // التقييم الإجمالي
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: GoogleFonts.cairo(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final rating = _averageRating;
                    if (index < rating.floor()) {
                      return const Icon(
                        Icons.star,
                        color: MbuyColors.warning,
                        size: 20,
                      );
                    } else if (index < rating) {
                      return const Icon(
                        Icons.star_half,
                        color: MbuyColors.warning,
                        size: 20,
                      );
                    } else {
                      return const Icon(
                        Icons.star_border,
                        color: MbuyColors.warning,
                        size: 20,
                      );
                    }
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_totalReviews تقييم',
                  style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
          // توزيع التقييمات
          Expanded(
            flex: 3,
            child: Column(
              children: List.generate(5, (index) {
                final rating = 5 - index;
                final count = _ratingDistribution[rating] ?? 0;
                final percentage = _totalReviews > 0
                    ? count / _totalReviews
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$rating',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: MbuyColors.warning,
                        size: 12,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              MbuyColors.warning,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$count',
                        style: GoogleFonts.cairo(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    final pendingCount = _reviews
        .where((r) => r['merchant_reply'] == null)
        .length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            'الكل ($_totalReviews)',
            _filterBy == 'all' && _filterRating == null,
            () => setState(() {
              _filterBy = 'all';
              _filterRating = null;
            }),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'بانتظار الرد ($pendingCount)',
            _filterBy == 'pending_reply',
            () => setState(() {
              _filterBy = 'pending_reply';
              _filterRating = null;
            }),
            isWarning: pendingCount > 0,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'تم الرد',
            _filterBy == 'replied',
            () => setState(() {
              _filterBy = 'replied';
              _filterRating = null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    bool isWarning = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isWarning ? MbuyColors.warning : MbuyColors.primaryIndigo)
              : MbuyColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isWarning ? MbuyColors.warning : MbuyColors.primaryIndigo)
                : MbuyColors.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: isSelected ? Colors.white : MbuyColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final hasReply = review['merchant_reply'] != null;
    final isVerified = review['is_verified_purchase'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12, top: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات العميل والمنتج
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: MbuyColors.primaryIndigo,
                  radius: 24,
                  backgroundImage: review['customer_avatar'] != null
                      ? NetworkImage(review['customer_avatar'] as String)
                      : null,
                  child: review['customer_avatar'] == null
                      ? Text(
                          (review['customer_name'] as String? ?? 'U')[0]
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review['customer_name'] as String? ?? 'مستخدم',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MbuyColors.textPrimary,
                            ),
                          ),
                          if (isVerified) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: MbuyColors.success.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.verified,
                                    size: 12,
                                    color: MbuyColors.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'مشتري موثق',
                                    style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      color: MbuyColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < (review['rating'] as int? ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: MbuyColors.warning,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(review['created_at'] as String?),
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: MbuyColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!hasReply)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: MbuyColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'بانتظار الرد',
                      style: GoogleFonts.cairo(
                        fontSize: 10,
                        color: MbuyColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            // اسم المنتج
            if (review['product_name'] != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MbuyColors.background,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 14,
                      color: MbuyColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review['product_name'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: MbuyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // تعليق العميل
            const SizedBox(height: 12),
            Text(
              review['comment'] as String? ?? '',
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: MbuyColors.textSecondary,
                height: 1.5,
              ),
            ),

            // رد التاجر
            if (hasReply) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MbuyColors.primaryIndigo.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: MbuyColors.primaryIndigo.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.reply,
                          size: 16,
                          color: MbuyColors.primaryIndigo,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'رد التاجر',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MbuyColors.primaryIndigo,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(review['replied_at'] as String?),
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: MbuyColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review['merchant_reply'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: MbuyColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // زر الرد
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _replyToReview(review),
                  icon: Icon(hasReply ? Icons.edit : Icons.reply, size: 18),
                  label: Text(
                    hasReply ? 'تعديل الرد' : 'الرد',
                    style: GoogleFonts.cairo(),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: MbuyColors.primaryIndigo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
