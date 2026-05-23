import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Place {
  final String name;
  final double lat;
  final double lon;
  final String? address;

  Place({
    required this.name,
    required this.lat,
    required this.lon,
    this.address,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final tags = json['tags'] ?? {};
    double? lat;
    double? lon;

    // Handle different geometry formats from Overpass (node vs way/relation center)
    if (json['lat'] != null && json['lon'] != null) {
      lat = (json['lat'] as num).toDouble();
      lon = (json['lon'] as num).toDouble();
    } else if (json['center'] != null) {
      lat = (json['center']['lat'] as num).toDouble();
      lon = (json['center']['lon'] as num).toDouble();
    }

    // Fallback or skip (though factory must return, so we provide default 0.0 or filter later)
    // Ideally this factory should be nullable but for now we safeguard values.
    return Place(
      name: tags['name'] ?? 'Unknown Shop',
      lat: lat ?? 0.0,
      lon: lon ?? 0.0,
      address: tags['addr:street'] != null
          ? '${tags['addr:street']} ${tags['addr:housenumber'] ?? ''}'
          : null,
    );
  }
}

class PlacesService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Place>> getNearbyBikeShops(double lat, double lon) async {
    // 1. Check Internet Connection
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }

    // Overpass API query for bicycle shops around the location (radius 5000m)
    final query =
        '''
      [out:json][timeout:25];
      (
        node["shop"="bicycle"](around:5000, $lat, $lon);
        way["shop"="bicycle"](around:5000, $lat, $lon);
        relation["shop"="bicycle"](around:5000, $lat, $lon);
      );
      out center;
    ''';

    final url = Uri.parse('https://overpass-api.de/api/interpreter');
    try {
      final response = await http.post(url, body: {'data': query});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List;
        return elements.map((e) => Place.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load shops (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching shops: $e');
      rethrow; // Let the UI handle the specific error (Connectivity, Server, etc)
    }
  }
}
