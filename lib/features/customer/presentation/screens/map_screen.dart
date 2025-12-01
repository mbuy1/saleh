import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/dummy_data.dart';
import '../../../../core/data/models.dart';
import '../../../../shared/widgets/profile_button.dart';
import 'store_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  late final List<Store> _stores;
  late final List<Marker> _markers;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _stores = _loadStores();
    _markers = _buildMarkers();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  List<Store> _loadStores() {
    try {
      return DummyData.stores
          .where((s) => s.latitude != null && s.longitude != null)
          .toList();
    } catch (e) {
      debugPrint('Error loading stores: $e');
      return [];
    }
  }

  List<Marker> _buildMarkers() {
    return _stores.map((store) {
      try {
        return Marker(
          width: 50,
          height: 50,
          point: LatLng(store.latitude!, store.longitude!),
          child: GestureDetector(
            onTap: () => _onMarkerTap(store),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: store.isBoosted
                    ? MbuyColors.primaryPurple
                    : MbuyColors.primaryBlue,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.store, color: Colors.white, size: 24),
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

  void _onMarkerTap(Store store) {
    if (!mounted) return;
    try {
      if (store.latitude != null && store.longitude != null) {
        _mapController.move(LatLng(store.latitude!, store.longitude!), 15.0);
      }
      _showStoreBottomSheet(store);
    } catch (e) {
      debugPrint('Error on marker tap: $e');
    }
  }

  void _showStoreBottomSheet(Store store) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // اسم المتجر
            Row(
              children: [
                Expanded(
                  child: Text(
                    store.name,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: MbuyColors.textPrimary,
                    ),
                  ),
                ),
                if (store.isVerified)
                  const Icon(Icons.verified, color: Colors.blue, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            // المدينة
            if (store.city != null)
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: MbuyColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    store.city!,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: MbuyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            // الوصف
            Text(
              store.description,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: MbuyColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            // التقييم والمتابعين
            Row(
              children: [
                Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  store.rating.toString(),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 18, color: MbuyColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${store.followersCount} متابع',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: MbuyColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'عرض المتجر',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
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

    return Scaffold(
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
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.muath.saleh',
                maxNativeZoom: 19,
                maxZoom: 19,
                tileSize: 256,
                keepBuffer: 2,
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          // Header في الأعلى - العنوان وإيقونة الحساب
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // العنوان على اليسار
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'الخريطة',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MbuyColors.textPrimary,
                        ),
                      ),
                    ),
                    // إيقونة الحساب الشخصي على اليمين
                    const ProfileButton(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 100,
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
