import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _mainCategories = [
    {'icon': Icons.checkroom, 'name': 'ملابس رجالية', 'color': Colors.blue},
    {'icon': Icons.woman, 'name': 'ملابس نسائية', 'color': Colors.pink},
    {'icon': Icons.child_care, 'name': 'أطفال', 'color': Colors.orange},
    {'icon': Icons.watch, 'name': 'ساعات', 'color': Colors.purple},
    {'icon': Icons.phone_android, 'name': 'إلكترونيات', 'color': Colors.teal},
    {'icon': Icons.sports_soccer, 'name': 'رياضة', 'color': Colors.green},
    {'icon': Icons.face, 'name': 'تجميل', 'color': Colors.red},
    {'icon': Icons.chair, 'name': 'أثاث ومنزل', 'color': Colors.brown},
    {'icon': Icons.diamond, 'name': 'مجوهرات', 'color': Colors.amber},
    {'icon': Icons.luggage, 'name': 'حقائب', 'color': Colors.indigo},
  ];

  final List<List<Map<String, String>>> _subCategories = [
    // ملابس رجالية
    [
      {
        'name': 'قمصان',
        'image':
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=200',
      },
      {
        'name': 'بناطيل',
        'image':
            'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=200',
      },
      {
        'name': 'جاكيتات',
        'image':
            'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=200',
      },
      {
        'name': 'بدل رسمية',
        'image':
            'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=200',
      },
      {
        'name': 'ملابس رياضية',
        'image':
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200',
      },
      {
        'name': 'ملابس داخلية',
        'image':
            'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=200',
      },
    ],
    // ملابس نسائية
    [
      {
        'name': 'فساتين',
        'image':
            'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=200',
      },
      {
        'name': 'بلوزات',
        'image':
            'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=200',
      },
      {
        'name': 'تنانير',
        'image':
            'https://images.unsplash.com/photo-1583496661160-fb5886a0uj34?w=200',
      },
      {
        'name': 'عبايات',
        'image':
            'https://images.unsplash.com/photo-1590735213920-68192a487bc2?w=200',
      },
      {
        'name': 'ملابس نوم',
        'image':
            'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=200',
      },
    ],
    // أطفال
    [
      {
        'name': 'ملابس أولاد',
        'image':
            'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=200',
      },
      {
        'name': 'ملابس بنات',
        'image':
            'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=200',
      },
      {
        'name': 'ألعاب',
        'image':
            'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=200',
      },
      {
        'name': 'مستلزمات رضع',
        'image':
            'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=200',
      },
    ],
    // ساعات
    [
      {
        'name': 'ساعات رجالية',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=200',
      },
      {
        'name': 'ساعات نسائية',
        'image':
            'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=200',
      },
      {
        'name': 'ساعات ذكية',
        'image':
            'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200',
      },
    ],
    // إلكترونيات
    [
      {
        'name': 'هواتف',
        'image':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200',
      },
      {
        'name': 'لابتوب',
        'image':
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=200',
      },
      {
        'name': 'سماعات',
        'image':
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
      },
      {
        'name': 'شواحن',
        'image':
            'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=200',
      },
    ],
    // رياضة
    [
      {
        'name': 'ملابس رياضية',
        'image':
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=200',
      },
      {
        'name': 'أحذية رياضية',
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      },
      {
        'name': 'معدات',
        'image':
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200',
      },
    ],
    // تجميل
    [
      {
        'name': 'مكياج',
        'image':
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=200',
      },
      {
        'name': 'عناية بالبشرة',
        'image':
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=200',
      },
      {
        'name': 'عطور',
        'image':
            'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=200',
      },
    ],
    // أثاث ومنزل
    [
      {
        'name': 'غرف نوم',
        'image':
            'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=200',
      },
      {
        'name': 'غرف معيشة',
        'image':
            'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200',
      },
      {
        'name': 'مطبخ',
        'image':
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=200',
      },
    ],
    // مجوهرات
    [
      {
        'name': 'خواتم',
        'image':
            'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=200',
      },
      {
        'name': 'قلادات',
        'image':
            'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=200',
      },
      {
        'name': 'أساور',
        'image':
            'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=200',
      },
    ],
    // حقائب
    [
      {
        'name': 'حقائب يد',
        'image':
            'https://images.unsplash.com/photo-1560343090-f0409e92791a?w=200',
      },
      {
        'name': 'حقائب ظهر',
        'image':
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=200',
      },
      {
        'name': 'حقائب سفر',
        'image':
            'https://images.unsplash.com/photo-1565026057447-bc90a3dceb87?w=200',
      },
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Side - Main Categories
        Container(
          width: 90,
          color: Colors.grey.shade100,
          child: ListView.builder(
            itemCount: _mainCategories.length,
            itemBuilder: (_, i) {
              final cat = _mainCategories[i];
              final isSelected = _selectedIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border(
                      right: BorderSide(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        cat['icon'],
                        size: 24,
                        color: isSelected ? AppTheme.primaryColor : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cat['name'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Right Side - Sub Categories
        Expanded(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Header
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _mainCategories[_selectedIndex]['icon'],
                        color: _mainCategories[_selectedIndex]['color'],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _mainCategories[_selectedIndex]['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sub Categories Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: _subCategories[_selectedIndex].length,
                    itemBuilder: (_, i) {
                      final sub = _subCategories[_selectedIndex][i];
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(sub['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              sub['name']!,
                              style: const TextStyle(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
