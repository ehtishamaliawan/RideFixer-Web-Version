class ServiceLog {
  final int? id;
  final int bikeId;
  final String title; // "Brake Pads"
  final DateTime date;
  final double cost;
  final String? notes;

  ServiceLog({
    this.id,
    required this.bikeId,
    required this.title,
    required this.date,
    required this.cost,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bikeId': bikeId,
      'title': title,
      'date': date.toIso8601String(),
      'cost': cost,
      'notes': notes,
    };
  }

  factory ServiceLog.fromMap(Map<String, dynamic> map) {
    return ServiceLog(
      id: map['id'],
      bikeId: map['bikeId'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      cost: map['cost'] ?? 0.0,
      notes: map['notes'],
    );
  }
}
