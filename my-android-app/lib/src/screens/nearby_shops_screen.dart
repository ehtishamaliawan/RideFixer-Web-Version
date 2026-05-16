import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/app_back_button.dart';
import '../widgets/location_disclosure_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../services/places_service.dart';

class NearbyShopsScreen extends StatefulWidget {
  const NearbyShopsScreen({super.key});

  @override
  State<NearbyShopsScreen> createState() => _NearbyShopsScreenState();
}

class _NearbyShopsScreenState extends State<NearbyShopsScreen> {
  final PlacesService _placesService = PlacesService();
  List<Place> _shops = [];
  bool _isLoading = true;
  String? _errorMessage;
  Position? _currentPosition;
  bool _didAutoOpenMaps = false;

  @override
  void initState() {
    super.initState();
    // Show Google Play-compliant disclosure before requesting location.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final accepted = await showLocationDisclosure(context, forRideTracking: false);
      if (!accepted) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Location access is needed to find nearby shops.';
          });
        }
        return;
      }
      _fetchShops();
    });
  }

  Future<void> _fetchShops() async {
    try {
      final position = await _placesService.getCurrentLocation();
      if (position != null) {
        setState(() => _currentPosition = position);
        final shops = await _placesService.getNearbyBikeShops(
          position.latitude,
          position.longitude,
        );

        // Filter out entries without coordinates and sort by nearest distance
        final validShops = shops
            .where((s) => s.lat != 0.0 || s.lon != 0.0)
            .toList();
        validShops.sort((a, b) {
          final da = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            a.lat,
            a.lon,
          );
          final db = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            b.lat,
            b.lon,
          );
          return da.compareTo(db);
        });

        if (mounted) {
          setState(() {
            _shops = validShops;
            _isLoading = false;
          });
        }

        // If the API returns nothing (Overpass can be flaky), fall back to Maps.
        if (mounted && validShops.isEmpty) {
          setState(() {
            _errorMessage =
                'We couldn\'t load nearby shops right now. Google Maps search will open instead.';
          });
          _autoOpenMapsSearchOnce();
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage =
                'Location is unavailable. Google Maps search will open instead.';
            _isLoading = false;
          });
          _autoOpenMapsSearchOnce();
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('NearbyShops: failed to fetch shops: $e');
      if (mounted) {
        setState(() {
          _errorMessage =
              'We\'re having trouble loading nearby shops right now. Google Maps search will open instead.';
          _isLoading = false;
        });
        _autoOpenMapsSearchOnce();
      }
    }
  }

  Future<void> _retry() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _shops = [];
      _currentPosition = null;
      _didAutoOpenMaps = false;
    });
    await _fetchShops();
  }

  void _autoOpenMapsSearchOnce() {
    if (_didAutoOpenMaps) return;
    _didAutoOpenMaps = true;

    // Post-frame to avoid launching URLs during build/layout.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await _openMapsSearch();
      } catch (_) {
        // If the device can't launch Maps/URL, we just keep the in-app message.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        final router = GoRouter.of(context);
        if (router.canPop()) {
          router.pop();
          return;
        }
        router.go('/home');
      },
      child: Scaffold(
        extendBodyBehindAppBar: true, // Allow gradient to go behind AppBar
        appBar: AppBar(
          title: const Text(
            'Nearby Shops',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          leading: AppBackButton(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
          // Fixed Gradient Header Background
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: AppTheme.headerGradient(context),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: AppTheme.softShadow,
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 100), // Spacing for AppBar
              // "Open in Maps" generic button header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // Glass pill
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openMapsSearch,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.map, color: Colors.white),
                            const SizedBox(width: 8),
                            const Flexible(
                              child: Text(
                                'Open in Maps: bike shops near me',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        child: _buildFallbackPanel(context, message: _errorMessage!),
                      )
                    : _shops.isEmpty
                    ? const Center(child: Text('No bike shops found nearby.'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount: _shops.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final shop = _shops[index];
                          return _buildShopCard(context, shop);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildFallbackPanel(BuildContext context, {required String message}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.map_outlined, size: 36, color: colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openMapsSearch,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Google Maps'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primaryColor,
                side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard(BuildContext context, Place shop) {
    // Calculate distance if verify location available
    String distanceString = 'Unknown distance';
    if (_currentPosition != null) {
      final distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        shop.lat,
        shop.lon,
      );
      if (distanceInMeters < 1000) {
        distanceString = '${distanceInMeters.round()} m';
      } else {
        distanceString = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
      }
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shop.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.address ?? 'Address unknown',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      distanceString,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _openShopInMaps(shop),
              icon: const Icon(Icons.directions),
              label: const Text('Get Directions'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMapsSearch() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/bike+shops+near+me',
    );
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _openShopInMaps(Place shop) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${shop.lat},${shop.lon}',
    );
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
