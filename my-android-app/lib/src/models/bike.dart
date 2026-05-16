class Bike {
  final int? id;
  final String name;
  final String brand;
  final String model;
  final String type; // New field
  final String? imagePath;
  final double totalDistance;

  // Alias for totalDistance to match UI code
  int get mileage => totalDistance.round();

  Bike({
    this.id,
    required this.name,
    this.brand = '', // Default to empty
    this.model = '', // Default to empty
    this.type = 'Bike', // Default type
    this.imagePath,
    this.totalDistance = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'type': type,
      'imagePath': imagePath,
      'totalDistance': totalDistance,
      // Note: 'type' is not persisted in DB currently to avoid migration issues
    };
  }

  factory Bike.fromMap(Map<String, dynamic> map) {
    final rawType = (map['type'] ?? 'Bike').toString();
    final normalizedType = rawType.trim().toLowerCase();
    final resolvedType = (normalizedType == 'motorbike' || normalizedType == 'motorcycle')
        ? 'Bike'
        : rawType;
    return Bike(
      id: map['id'],
      name: map['name'],
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      type: resolvedType,
      imagePath: map['imagePath'],
      totalDistance: map['totalDistance'] ?? 0.0,
    );
  }

  Bike copyWith({
    int? id,
    String? name,
    String? brand,
    String? model,
    String? type,
    String? imagePath,
    double? totalDistance,
  }) {
    return Bike(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }
}
