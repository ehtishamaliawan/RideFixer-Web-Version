class Reminder {
  final int? id;
  final int bikeId;
  final String title;
  final double dueDistance; // Distance at which reminder triggers
  final DateTime? dueDate; // Date at which reminder triggers
  final bool isCompleted;
  final String? imagePath;

  Reminder({
    this.id,
    required this.bikeId,
    required this.title,
    required this.dueDistance,
    this.dueDate,
    this.isCompleted = false,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bikeId': bikeId,
      'title': title,
      'dueDistance': dueDistance,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'imagePath': imagePath,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      bikeId: map['bikeId'],
      title: map['title'],
      dueDistance: map['dueDistance'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'] == 1,
      imagePath: map['imagePath'],
    );
  }
  Reminder copyWith({
    int? id,
    int? bikeId,
    String? title,
    double? dueDistance,
    DateTime? dueDate,
    bool? isCompleted,
    String? imagePath,
  }) {
    return Reminder(
      id: id ?? this.id,
      bikeId: bikeId ?? this.bikeId,
      title: title ?? this.title,
      dueDistance: dueDistance ?? this.dueDistance,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
