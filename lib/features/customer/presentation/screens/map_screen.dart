import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' show cos, sin, sqrt, asin;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/data/models.dart';
import '../../../../core/widgets/widgets.dart';
import 'store_details_screen.dart';

/// موديل المتجر مع المسافة
class StoreWithDistance {
  final Store store;
  final double distanceInKm;

  StoreWithDistance(this.store, this.distanceInKm);
}

/// دالة حساب المسافة بين نقطتين باستخدام Haversine formula
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // نصف قطر الأرض بالكيلومتر

  final double dLat = _toRadians(lat2 - lat1);
  final double dLon = _toRadians(lon2 - lon1);

  final double a =
      (sin(dLat / 2) * sin(dLat / 2)) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          (sin(dLon / 2) * sin(dLon / 2));

  final double c = 2 * asin(sqrt(a));
  return earthRadius * c;
}

double _toRadians(double degree) {
  return degree * 3.141592653589793 / 180;
}

/// قائمة المدن المتاحة
class City {
  final String name;
  final double latitude;
  final double longitude;

  const City(this.name, this.latitude, this.longitude);
}

final List<City> availableCities = [
  const City('الرياض', 24.7136, 46.6753),
  const City('جدة', 21.4858, 39.1925),
  const City('الدمام', 26.4207, 50.0888),
  const City('مكة المكرمة', 21.3891, 39.8579),
  const City('المدينة المنورة', 24.5247, 39.5692),
];

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  late List<StoreWithDistance> _storesWithDistance;
  late List<Marker> _markers;
  bool _isInitialized = false;

  // موقع المركز الحالي (موقع المستخدم أو المدينة المختارة)
  LatLng _currentCenter = const LatLng(24.7136, 46.6753); // الرياض افتراضياً
  String _selectedCityName = 'الرياض';

  // نصف قطر الدائرة بالكيلومتر
  final double _radiusInKm = 10.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadStoresWithDistance();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// تحميل المتاجر مع حساب المسافة من المركز الحالي
  void _loadStoresWithDistance() {
    try {
      final stores = DummyData.stores
          .where((s) => s.latitude != null && s.longitude != null)
          .toList();

      // حساب المسافة لكل متجر
      _storesWithDistance = stores.map((store) {
        final distance = calculateDistance(
          _currentCenter.latitude,
          _currentCenter.longitude,
          store.latitude!,
          store.longitude!,
        );
        return StoreWithDistance(store, distance);
      }).toList();

      // ترتيب المتاجر حسب المسافة (الأقرب أولاً)
      _storesWithDistance.sort(
        (a, b) => a.distanceInKm.compareTo(b.distanceInKm),
      );

      // بناء الـ markers
      _markers = _buildMarkers();
    } catch (e) {
      debugPrint('Error loading stores with distance: $e');
      _storesWithDistance = [];
      _markers = [];
    }
  }

  List<Marker> _buildMarkers() {
    return _storesWithDistance.map((storeWithDist) {
      try {
        final store = storeWithDist.store;
        return Marker(
          width: 240,
          height: 120, // زيادة الارتفاع لاستيعاب النص الكامل
          point: LatLng(store.latitude!, store.longitude!),
          child: GestureDetector(
            onTap: () => _onMarkerTap(storeWithDist),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Label - النص بارتفاع كافي
                Container(
                  width: 230,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12, // مساحة أكبر للنص
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: MbuyColors.borderLight,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    store.name,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: MbuyColors.textPrimary,
                      height: 1.4,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: store.isBoosted
                        ? MbuyColors.secondary
                        : MbuyColors.primaryIndigo,
                    border: Border.all(color: Colors.white, width: 3.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    store.isBoosted ? Icons.star_rounded : Icons.store_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        );
      } catch (e) {
        debugPrint('Error building marker: $e');
        return Marker(
          point: const LatLng(0, 0),
          child: const SizedBox.shrink(),
        );
      }
    }).toList();
  }

  void _onMarkerTap(StoreWithDistance storeWithDist) {
    if (!mounted) return;
    try {
      final store = storeWithDist.store;
      if (store.latitude != null && store.longitude != null) {
        _mapController.move(LatLng(store.latitude!, store.longitude!), 15.0);
      }
      _showStoreBottomSheet(storeWithDist);
    } catch (e) {
      debugPrint('Error on marker tap: $e');
    }
  }

  void _showStoreBottomSheet(StoreWithDistance storeWithDist) {
    final store = storeWithDist.store;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // اسم المتجر
            Row(
              children: [
                Expanded(
                  child: Text(
                    store.name,
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                ),
                if (store.isVerified)
                  const Icon(Icons.verified, color: Colors.blue, size: 28),
              ],
            ),
            const SizedBox(height: 12),
            // المسافة
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MbuyColors.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.directions_walk,
                    size: 20,
                    color: MbuyColors.primaryPurple,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${storeWithDist.distanceInKm.toStringAsFixed(1)} كم من موقعك',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MbuyColors.primaryPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // المدينة
            if (store.city != null)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.location_on,
                      size: 20,
                      color: MbuyColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    store.city!,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: MbuyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // الوصف
            Text(
              store.description,
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: MbuyColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // التقييم والمتابعين
            Row(
              children: [
                Icon(Icons.star_rounded, size: 24, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  store.rating.toString(),
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 24),
                Icon(
                  Icons.people_outline,
                  size: 22,
                  color: MbuyColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  '${store.followersCount} متابع',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // زر عرض المتجر
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: MbuyColors.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 4,
                  shadowColor: MbuyColors.primaryPurple.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'زيارة المتجر',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MbuyScaffold(
        useSafeArea: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'جاري تحميل الخريطة...',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: MbuyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MbuyScaffold(
      useSafeArea: false,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(24.7136, 46.6753),
              initialZoom: 13.0,
              minZoom: 8.0,
              maxZoom: 18.0,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              // CartoDB Positron (Light) Tiles - Google Maps style
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.muath.saleh',
                maxNativeZoom: 19,
                maxZoom: 19,
                tileSize: 256,
                keepBuffer: 2,
              ),

              // دائرة نصف القطر حول المركز الحالي
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _currentCenter,
                    radius: _radiusInKm * 1000,
                    useRadiusInMeter: true,
                    color: MbuyColors.primaryPurple.withValues(alpha: 0.05),
                    borderColor: MbuyColors.primaryPurple.withValues(
                      alpha: 0.2,
                    ),
                    borderStrokeWidth: 1,
                  ),
                ],
              ),

              // Marker للمركز الحالي
              MarkerLayer(
                markers: [
                  Marker(
                    width: 24,
                    height: 24,
                    point: _currentCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MbuyColors.primaryPurple,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Markers للمتاجر
              MarkerLayer(markers: _markers),
            ],
          ),

          // Header - Google Maps Style Search & Categories
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // شريط البحث مع أيقونة الحساب الشخصي
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'ابحث عن متجر أو مكان',
                              style: GoogleFonts.cairo(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // زر اختيار المدينة (عائم في الأسفل يمين)
          Positioned(
            bottom: 60,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showCitySelector,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_city,
                        color: MbuyColors.primaryPurple,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedCityName,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: MbuyColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Map Controls (Zoom, My Location)
          Positioned(
            left: 16,
            bottom: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MapControlButton(
                  icon: Icons.add,
                  onPressed: () {
                    if (!mounted) return;
                    try {
                      final zoom = _mapController.camera.zoom;
                      final center = _mapController.camera.center;
                      _mapController.move(center, zoom + 1);
                    } catch (_) {}
                  },
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.remove,
                  onPressed: () {
                    if (!mounted) return;
                    try {
                      final zoom = _mapController.camera.zoom;
                      final center = _mapController.camera.center;
                      _mapController.move(center, zoom - 1);
                    } catch (_) {}
                  },
                ),
                const SizedBox(height: 8),
                _MapControlButton(
                  icon: Icons.my_location,
                  onPressed: () {
                    if (!mounted) return;
                    try {
                      _mapController.move(const LatLng(24.7136, 46.6753), 13.0);
                    } catch (_) {}
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// عرض قائمة اختيار المدينة
  void _showCitySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            // العنوان
            Text(
              'اختر المدينة',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MbuyColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            // قائمة المدن
            ...availableCities.map(
              (city) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: city.name == _selectedCityName
                        ? MbuyColors.primaryGradient
                        : null,
                    color: city.name == _selectedCityName
                        ? null
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_city,
                    color: city.name == _selectedCityName
                        ? Colors.white
                        : Colors.grey[600],
                    size: 20,
                  ),
                ),
                title: Text(
                  city.name,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: city.name == _selectedCityName
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: city.name == _selectedCityName
                        ? MbuyColors.primaryPurple
                        : MbuyColors.textPrimary,
                  ),
                ),
                trailing: city.name == _selectedCityName
                    ? const Icon(
                        Icons.check_circle,
                        color: MbuyColors.primaryPurple,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _selectCity(city);
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// اختيار مدينة وتحديث الخريطة
  void _selectCity(City city) {
    if (!mounted) return;

    setState(() {
      _selectedCityName = city.name;
      _currentCenter = LatLng(city.latitude, city.longitude);

      // إعادة حساب المسافات بناءً على المركز الجديد
      _loadStoresWithDistance();
    });

    // تحريك الخريطة إلى المدينة المختارة
    try {
      _mapController.move(_currentCenter, 13.0);
    } catch (e) {
      debugPrint('Error moving map: $e');
    }
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _MapControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.black87, size: 20),
        ),
      ),
    );
  }
}
