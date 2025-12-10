import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Merchant Home Screen
/// Overview of merchant's store and statistics
class MerchantHomeScreen extends ConsumerWidget {
  const MerchantHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('متجري')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.store, size: 100, color: Color(0xFFE53935)),
              const SizedBox(height: 24),
              Text(
                'معلومات المتجر',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              const Text(
                'هنا ستظهر معلومات المتجر والإحصائيات',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Text(
                '(سيتم ربطها بـ Worker لاحقاً)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
