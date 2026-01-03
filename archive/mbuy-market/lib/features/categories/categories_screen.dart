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
    {'icon': Icons.favorite, 'name': 'لأجلك', 'color': Colors.red},
    {'icon': Icons.star, 'name': 'متميز', 'color': Colors.amber},
    {'icon': Icons.local_offer, 'name': 'عروض', 'color': Colors.green},
    {'icon': Icons.phone_android, 'name': 'الجوالات', 'color': Colors.blue},
    {'icon': Icons.devices, 'name': 'الإلكترونيات', 'color': Colors.teal},
    {'icon': Icons.home, 'name': 'المنزل والحديقة', 'color': Colors.brown},
    {'icon': Icons.face, 'name': 'الجمال', 'color': Colors.pink},
    {'icon': Icons.checkroom, 'name': 'ملابس', 'color': Colors.purple},
    {'icon': Icons.luggage, 'name': 'الأمتعة', 'color': Colors.indigo},
    {'icon': Icons.watch, 'name': 'النظارات والساعات', 'color': Colors.orange},
    {
      'icon': Icons.directions_walk,
      'name': 'الأحذية',
      'color': Colors.blueGrey,
    },
    {
      'icon': Icons.directions_car,
      'name': 'زينة السيارات',
      'color': Colors.grey,
    },
    {'icon': Icons.school, 'name': 'اللوازم المدرسية', 'color': Colors.cyan},
    {
      'icon': Icons.computer,
      'name': 'الكمبيوتر والألعاب',
      'color': Colors.deepPurple,
    },
    {'icon': Icons.kitchen, 'name': 'الأجهزة الصغيرة', 'color': Colors.lime},
    {
      'icon': Icons.child_care,
      'name': 'لوازم البيبي',
      'color': Colors.lightBlue,
    },
    {'icon': Icons.terrain, 'name': 'الكشتة والرحلات', 'color': Colors.green},
    {'icon': Icons.spa, 'name': 'العطور', 'color': Colors.deepOrange},
    {'icon': Icons.menu_book, 'name': 'الكتب', 'color': Colors.brown},
    {'icon': Icons.inventory, 'name': 'المواد الخام', 'color': Colors.blueGrey},
    {
      'icon': Icons.card_giftcard,
      'name': 'الهدايا والحرف',
      'color': Colors.pinkAccent,
    },
  ];

  final List<List<Map<String, String>>> _subCategories = [
    // لأجلك
    [
      {
        'name': 'منتجات مقترحة',
        'image':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200',
      },
      {
        'name': 'شوهد مؤخراً',
        'image':
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=200',
      },
      {
        'name': 'المفضلة',
        'image':
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=200',
      },
    ],
    // متميز
    [
      {
        'name': 'الأكثر مبيعاً',
        'image':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200',
      },
      {
        'name': 'جديد',
        'image':
            'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=200',
      },
      {
        'name': 'حصري',
        'image':
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=200',
      },
    ],
    // عروض
    [
      {
        'name': 'تخفيضات اليوم',
        'image':
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=200',
      },
      {
        'name': 'كوبونات',
        'image':
            'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=200',
      },
      {
        'name': 'فلاش سيل',
        'image':
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200',
      },
    ],
    // الجوالات والاكسسوارات
    [
      {
        'name': 'آيفون',
        'image':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200',
      },
      {
        'name': 'سامسونج',
        'image':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200',
      },
      {
        'name': 'هواوي',
        'image':
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200',
      },
      {
        'name': 'كفرات',
        'image':
            'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?w=200',
      },
      {
        'name': 'شواحن',
        'image':
            'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=200',
      },
      {
        'name': 'سماعات',
        'image':
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
      },
    ],
    // الإلكترونيات
    [
      {
        'name': 'تلفزيونات',
        'image':
            'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=200',
      },
      {
        'name': 'لابتوب',
        'image':
            'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=200',
      },
      {
        'name': 'تابلت',
        'image':
            'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=200',
      },
      {
        'name': 'كاميرات',
        'image':
            'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=200',
      },
    ],
    // المنزل والحديقة
    [
      {
        'name': 'أثاث',
        'image':
            'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=200',
      },
      {
        'name': 'ديكور',
        'image':
            'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=200',
      },
      {
        'name': 'مطبخ',
        'image':
            'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=200',
      },
      {
        'name': 'حديقة',
        'image':
            'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=200',
      },
    ],
    // الجمال
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
        'name': 'عناية بالشعر',
        'image':
            'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=200',
      },
      {
        'name': 'أظافر',
        'image':
            'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=200',
      },
    ],
    // ملابس واكسسوارات
    [
      {
        'name': 'رجالي',
        'image':
            'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=200',
      },
      {
        'name': 'نسائي',
        'image':
            'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=200',
      },
      {
        'name': 'إكسسوارات',
        'image':
            'https://images.unsplash.com/photo-1611923134239-b9be5816e23e?w=200',
      },
    ],
    // الأمتعة والحقائب
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
    // النظارات والساعات
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
        'name': 'نظارات شمسية',
        'image':
            'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=200',
      },
      {
        'name': 'نظارات طبية',
        'image':
            'https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=200',
      },
    ],
    // الأحذية
    [
      {
        'name': 'أحذية رجالية',
        'image':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      },
      {
        'name': 'أحذية نسائية',
        'image':
            'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=200',
      },
      {
        'name': 'أحذية رياضية',
        'image':
            'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=200',
      },
    ],
    // زينة وقطع السيارات
    [
      {
        'name': 'إكسسوارات داخلية',
        'image':
            'https://images.unsplash.com/photo-1489824904134-891ab64532f1?w=200',
      },
      {
        'name': 'إكسسوارات خارجية',
        'image':
            'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=200',
      },
      {
        'name': 'قطع غيار',
        'image':
            'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=200',
      },
    ],
    // اللوازم المدرسية والمكتبية
    [
      {
        'name': 'أدوات مكتبية',
        'image':
            'https://images.unsplash.com/photo-1456735190827-d1262f71b8a3?w=200',
      },
      {
        'name': 'حقائب مدرسية',
        'image':
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=200',
      },
      {
        'name': 'دفاتر وأقلام',
        'image':
            'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?w=200',
      },
    ],
    // الكمبيوتر وألعاب الفيديو
    [
      {
        'name': 'بلايستيشن',
        'image':
            'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=200',
      },
      {
        'name': 'إكسبوكس',
        'image':
            'https://images.unsplash.com/photo-1612801799890-4ba4760b6590?w=200',
      },
      {
        'name': 'ألعاب PC',
        'image':
            'https://images.unsplash.com/photo-1542549237432-a176cb9d5586?w=200',
      },
      {
        'name': 'إكسسوارات قيمنق',
        'image':
            'https://images.unsplash.com/photo-1593305841991-05c297ba4575?w=200',
      },
    ],
    // الأجهزة الصغيرة
    [
      {
        'name': 'خلاطات',
        'image':
            'https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=200',
      },
      {
        'name': 'مكانس',
        'image':
            'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=200',
      },
      {
        'name': 'مكاوي',
        'image':
            'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=200',
      },
    ],
    // لوازم البيبي
    [
      {
        'name': 'ملابس أطفال',
        'image':
            'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?w=200',
      },
      {
        'name': 'عربات',
        'image':
            'https://images.unsplash.com/photo-1591088398332-8a7791972843?w=200',
      },
      {
        'name': 'ألعاب',
        'image':
            'https://images.unsplash.com/photo-1558060370-d644479cb6f7?w=200',
      },
      {
        'name': 'حفاضات',
        'image':
            'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=200',
      },
    ],
    // الكشتة والرحلات
    [
      {
        'name': 'خيام',
        'image':
            'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=200',
      },
      {
        'name': 'أدوات تخييم',
        'image':
            'https://images.unsplash.com/photo-1510312305653-8ed496efae75?w=200',
      },
      {
        'name': 'شوايات',
        'image':
            'https://images.unsplash.com/photo-1529262225327-aa43defd2d3f?w=200',
      },
    ],
    // العطور
    [
      {
        'name': 'عطور رجالية',
        'image':
            'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=200',
      },
      {
        'name': 'عطور نسائية',
        'image':
            'https://images.unsplash.com/photo-1541643600914-78b084683601?w=200',
      },
      {
        'name': 'عود وبخور',
        'image':
            'https://images.unsplash.com/photo-1594035910387-fea47794261f?w=200',
      },
    ],
    // الكتب
    [
      {
        'name': 'كتب عربية',
        'image':
            'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=200',
      },
      {
        'name': 'كتب إنجليزية',
        'image':
            'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200',
      },
      {
        'name': 'كتب أطفال',
        'image':
            'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=200',
      },
    ],
    // المواد الخام
    [
      {
        'name': 'أقمشة',
        'image':
            'https://images.unsplash.com/photo-1558171813-4c088753af8f?w=200',
      },
      {
        'name': 'خيوط',
        'image':
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200',
      },
      {
        'name': 'أدوات خياطة',
        'image':
            'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=200',
      },
    ],
    // الهدايا والحرف
    [
      {
        'name': 'هدايا',
        'image':
            'https://images.unsplash.com/photo-1513885535751-8b9238bd345a?w=200',
      },
      {
        'name': 'تغليف',
        'image':
            'https://images.unsplash.com/photo-1512909006721-3d6018887383?w=200',
      },
      {
        'name': 'حرف يدوية',
        'image':
            'https://images.unsplash.com/photo-1452860606245-08befc0ff44b?w=200',
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
