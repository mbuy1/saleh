import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../shared/widgets/store_card_compact.dart';
import 'store_details_screen.dart';

/// شاشة جميع المتاجر
class AllStoresScreen extends StatefulWidget {
  const AllStoresScreen({super.key});

  @override
  State<AllStoresScreen> createState() => _AllStoresScreenState();
}

class _AllStoresScreenState extends State<AllStoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MbuyColors.background,
      appBar: AppBar(
        title: const Text('جميع المتاجر'),
        backgroundColor: MbuyColors.cardBackground,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DummyData.stores.length,
        itemBuilder: (context, index) {
          final store = DummyData.stores[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StoreCardCompact(
              store: store,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreDetailsScreen(
                      storeId: store.id,
                      storeName: store.name,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

