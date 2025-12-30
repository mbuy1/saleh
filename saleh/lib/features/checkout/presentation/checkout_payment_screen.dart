import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/checkout_service.dart';

/// شاشة الدفع - تعرض صفحة الدفع من البوابة
class CheckoutPaymentScreen extends ConsumerStatefulWidget {
  final String merchantId;
  final String orderId;
  final int amount; // بالهللة
  final String? description;
  final CustomerInfo? customer;

  const CheckoutPaymentScreen({
    super.key,
    required this.merchantId,
    required this.orderId,
    required this.amount,
    this.description,
    this.customer,
  });

  @override
  ConsumerState<CheckoutPaymentScreen> createState() =>
      _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends ConsumerState<CheckoutPaymentScreen> {
  bool _isLoading = true;
  String? _error;
  CheckoutPaymentResult? _payment;
  CheckoutPaymentStatus? _status;
  bool _isCheckingStatus = false;

  @override
  void initState() {
    super.initState();
    _createPayment();
  }

  Future<void> _createPayment() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ref.read(checkoutServiceProvider);
      final payment = await service.createPayment(
        merchantId: widget.merchantId,
        orderId: widget.orderId,
        amount: widget.amount,
        description: widget.description,
        customer: widget.customer,
      );

      setState(() {
        _payment = payment;
        _isLoading = false;
      });

      // فتح صفحة الدفع تلقائياً
      await _openPaymentPage();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openPaymentPage() async {
    if (_payment == null) return;

    final uri = Uri.parse(_payment!.paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      // بعد الرجوع، تحقق من الحالة
      _startCheckingStatus();
    } else {
      setState(() {
        _error = 'لا يمكن فتح صفحة الدفع';
      });
    }
  }

  void _startCheckingStatus() {
    if (_isCheckingStatus) return;
    setState(() => _isCheckingStatus = true);

    // التحقق كل 3 ثواني
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return false;

      try {
        final service = ref.read(checkoutServiceProvider);
        final status = await service.getPaymentStatus(_payment!.transactionId);

        setState(() => _status = status);

        // إذا تم الدفع أو فشل، توقف عن التحقق
        if (status.isPaid || status.isFailed || status.isCancelled) {
          setState(() => _isCheckingStatus = false);
          return false;
        }

        return true; // استمر في التحقق
      } catch (_) {
        return true; // استمر في التحقق عند الخطأ
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الدفع'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(_status),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جاري تجهيز صفحة الدفع...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text('حدث خطأ', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                _error!.replaceAll('Exception: ', ''),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _createPayment,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_status != null) {
      return _buildStatusView();
    }

    return _buildPaymentView();
  }

  Widget _buildPaymentView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payment, size: 64, color: Theme.of(context).primaryColor),
          const SizedBox(height: 24),
          Text(
            'المبلغ المطلوب',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${(widget.amount / 100).toStringAsFixed(2)} ر.س',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 32),
          if (_isCheckingStatus) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('جاري انتظار إتمام الدفع...'),
          ] else ...[
            ElevatedButton.icon(
              onPressed: _openPaymentPage,
              icon: const Icon(Icons.open_in_new),
              label: const Text('فتح صفحة الدفع'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('إلغاء'),
          ),
          const SizedBox(height: 32),
          Text(
            'بوابة الدفع: ${_payment?.gateway ?? 'غير محدد'}',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusView() {
    final status = _status!;

    IconData icon;
    Color color;
    String title;
    String subtitle;

    if (status.isPaid) {
      icon = Icons.check_circle;
      color = Colors.green;
      title = 'تم الدفع بنجاح!';
      subtitle = 'شكراً لك، تم إتمام عملية الدفع';
    } else if (status.isFailed) {
      icon = Icons.cancel;
      color = Colors.red;
      title = 'فشلت عملية الدفع';
      subtitle = 'يرجى المحاولة مرة أخرى';
    } else if (status.isCancelled) {
      icon = Icons.cancel_outlined;
      color = Colors.orange;
      title = 'تم إلغاء العملية';
      subtitle = 'تم إلغاء عملية الدفع';
    } else {
      icon = Icons.hourglass_empty;
      color = Colors.blue;
      title = 'قيد المعالجة';
      subtitle = 'جاري معالجة الدفعة...';
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: color),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Text(
            'المبلغ: ${(status.amount / 100).toStringAsFixed(2)} ر.س',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),
          if (status.isPaid) ...[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(status),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('متابعة'),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (status.isFailed || status.isCancelled)
                  ElevatedButton(
                    onPressed: _createPayment,
                    child: const Text('إعادة المحاولة'),
                  ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(status),
                  child: const Text('إغلاق'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// دالة مساعدة لفتح شاشة الدفع
Future<CheckoutPaymentStatus?> openCheckoutPayment(
  BuildContext context, {
  required String merchantId,
  required String orderId,
  required int amount,
  String? description,
  CustomerInfo? customer,
}) async {
  return await Navigator.of(context).push<CheckoutPaymentStatus>(
    MaterialPageRoute(
      builder: (context) => CheckoutPaymentScreen(
        merchantId: merchantId,
        orderId: orderId,
        amount: amount,
        description: description,
        customer: customer,
      ),
    ),
  );
}
