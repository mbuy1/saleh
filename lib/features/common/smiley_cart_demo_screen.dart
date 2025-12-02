import 'package:flutter/material.dart';
import '../../shared/widgets/smiley_cart_icon.dart';
import '../../shared/widgets/smiley_cart_logo.dart';
import '../../shared/widgets/animated_smiley_cart_icon.dart';

/// مثال توضيحي كامل لاستخدام Smiley Cart Icons
///
/// هذا الملف يوضح جميع الطرق المختلفة لاستخدام الأيقونات
class SmileyCartDemoScreen extends StatefulWidget {
  const SmileyCartDemoScreen({super.key});

  @override
  State<SmileyCartDemoScreen> createState() => _SmileyCartDemoScreenState();
}

class _SmileyCartDemoScreenState extends State<SmileyCartDemoScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smiley Cart - أمثلة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ========================
            // الشعار الكبير
            // ========================
            _buildSection(
              'الشعار الكبير (Logo)',
              const Center(child: SmileyCartLogo(size: 150, withShadow: true)),
            ),

            const SizedBox(height: 32),

            // ========================
            // الأيقونات الثابتة
            // ========================
            _buildSection(
              'الأيقونات الثابتة (Static Icons)',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Column(
                    children: [
                      SmileyCartIcon(size: 24),
                      SizedBox(height: 8),
                      Text('24px', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      SmileyCartIcon(size: 40),
                      SizedBox(height: 8),
                      Text('40px', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      SmileyCartIcon(size: 64, isActive: true),
                      SizedBox(height: 8),
                      Text('64px (Active)', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ========================
            // الأيقونات المتحركة
            // ========================
            _buildSection(
              'الأيقونات المتحركة (Animated Icons)',
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedSmileyCartIcon(
                    size: 40,
                    isActive: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  AnimatedSmileyCartIcon(
                    size: 40,
                    isActive: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  AnimatedSmileyCartIcon(
                    size: 40,
                    isActive: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Center(
              child: Text(
                'اضغط على الأيقونات لرؤية الرسوم المتحركة',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ),

            const SizedBox(height: 32),

            // ========================
            // مثال Navigation Bar
            // ========================
            _buildSection(
              'مثال Navigation Bar',
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildBottomNavExample(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildBottomNavExample() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      items: [
        BottomNavigationBarItem(
          icon: AnimatedSmileyCartIcon(size: 28, isActive: _selectedIndex == 0),
          label: 'الرئيسية',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'المنتجات',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'الطلبات',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'الحساب',
        ),
      ],
    );
  }
}
