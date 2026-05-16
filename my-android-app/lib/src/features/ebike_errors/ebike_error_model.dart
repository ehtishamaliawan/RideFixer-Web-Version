import 'package:flutter/material.dart';

enum EbikeSeverity { low, medium, high }

enum Rideability { ok, caution, stop }

enum ServiceUrgency { info, soon, immediate }

class EbikeErrorInfo {
  final String code;
  final String title;
  final String description;
  final EbikeSeverity severity;

  /// Optional filtering tags (primarily used by Generic/Chinese catalogs).
  /// Example values: 'sw900', 'gd01', 'gd02'.
  ///
  /// If empty, the code is treated as applicable to all models.
  final List<String> models;

  // Rich guidance
  final String whatItMeans;
  final List<String> commonCauses;
  final List<String> commonSymptoms;
  final List<String> howToFix;
  final Rideability rideability;
  final String rideabilityGuidance;
  final ServiceUrgency urgency;
  final String urgencyGuidance;

  // Optional reference text
  final String? reference;

  const EbikeErrorInfo({
    required this.code,
    required this.title,
    required this.description,
    required this.severity,
    this.models = const [],
    required this.whatItMeans,
    required this.commonCauses,
    required this.commonSymptoms,
    required this.howToFix,
    required this.rideability,
    required this.rideabilityGuidance,
    required this.urgency,
    required this.urgencyGuidance,
    this.reference,
  });

  Color severityColor() {
    switch (severity) {
      case EbikeSeverity.high:
        return Colors.red.shade600;
      case EbikeSeverity.medium:
        return Colors.orange.shade600;
      case EbikeSeverity.low:
        return Colors.green.shade600;
    }
  }

  IconData severityIcon() {
    switch (severity) {
      case EbikeSeverity.high:
        return Icons.error_outline;
      case EbikeSeverity.medium:
        return Icons.warning_amber_outlined;
      case EbikeSeverity.low:
        return Icons.info_outline;
    }
  }

  Color rideabilityColor() {
    switch (rideability) {
      case Rideability.stop:
        return Colors.red.shade600;
      case Rideability.caution:
        return Colors.orange.shade600;
      case Rideability.ok:
        return Colors.green.shade600;
    }
  }

  IconData rideabilityIcon() {
    switch (rideability) {
      case Rideability.stop:
        return Icons.block;
      case Rideability.caution:
        return Icons.report_problem_outlined;
      case Rideability.ok:
        return Icons.check_circle_outline;
    }
  }

  String rideabilityLabel() {
    switch (rideability) {
      case Rideability.stop:
        return 'Do not ride';
      case Rideability.caution:
        return 'Ride with caution';
      case Rideability.ok:
        return 'Safe to ride';
    }
  }

  String urgencyLabel() {
    switch (urgency) {
      case ServiceUrgency.immediate:
        return 'Go to a shop now';
      case ServiceUrgency.soon:
        return 'Service soon';
      case ServiceUrgency.info:
        return 'Monitor';
    }
  }

  Color urgencyColor() {
    switch (urgency) {
      case ServiceUrgency.immediate:
        return Colors.red.shade600;
      case ServiceUrgency.soon:
        return Colors.orange.shade700;
      case ServiceUrgency.info:
        return Colors.blueGrey;
    }
  }

  IconData urgencyIcon() {
    switch (urgency) {
      case ServiceUrgency.immediate:
        return Icons.local_hospital_outlined;
      case ServiceUrgency.soon:
        return Icons.schedule;
      case ServiceUrgency.info:
        return Icons.info_outline;
    }
  }
}
