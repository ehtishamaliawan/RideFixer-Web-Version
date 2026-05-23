import 'ebike_error_model.dart';
import 'ebike_errors_config.dart';

class EbikeErrorCatalog {
  static List<EbikeErrorInfo> all() {
    final items = ebikeErrorCodes.entries
        .map((e) => fromConfig(code: e.key, raw: e.value))
        .toList();
    items.sort((a, b) => a.code.compareTo(b.code));
    return items;
  }

  static EbikeErrorInfo? findByCode(String code) {
    final raw = ebikeErrorCodes[code.toUpperCase()];
    if (raw == null) return null;
    return fromConfig(code: code.toUpperCase(), raw: raw);
  }

  static EbikeErrorInfo fromConfig({required String code, required Map<String, dynamic> raw}) {
    final title = (raw['title'] as String?)?.trim().isNotEmpty == true
        ? (raw['title'] as String)
      : 'Error $code';
    final description = (raw['description'] as String?)?.trim().isNotEmpty == true
        ? (raw['description'] as String)
        : 'This code is not recognized for this bike/controller.';

    final sevStr = (raw['severity'] as String?)?.toLowerCase().trim();
    final severity = switch (sevStr) {
      'high' => EbikeSeverity.high,
      'medium' => EbikeSeverity.medium,
      _ => EbikeSeverity.low,
    };

    final steps = (raw['steps'] as List?)?.whereType<String>().toList() ?? const <String>[];

    // Rich fields: use configured values if present, otherwise derive safe defaults.
    final whatItMeans = (raw['whatItMeans'] as String?)?.trim().isNotEmpty == true
        ? (raw['whatItMeans'] as String)
        : description;

    final commonCauses = (raw['causes'] as List?)?.whereType<String>().toList() ??
        _defaultCausesFor(severity: severity);

    final commonSymptoms = (raw['symptoms'] as List?)?.whereType<String>().toList() ??
        _defaultSymptomsFor(severity: severity);

    final howToFix = (raw['fix'] as List?)?.whereType<String>().toList() ??
        (steps.isNotEmpty ? steps : _defaultFixFor(severity: severity));

    final rideability = (raw['rideability'] as String?)?.toLowerCase().trim();
    final rideabilityValue = switch (rideability) {
      'stop' => Rideability.stop,
      'caution' => Rideability.caution,
      'ok' => Rideability.ok,
      _ => _defaultRideabilityFor(severity: severity),
    };

    final urgency = (raw['urgency'] as String?)?.toLowerCase().trim();
    final urgencyValue = switch (urgency) {
      'immediate' => ServiceUrgency.immediate,
      'soon' => ServiceUrgency.soon,
      'info' => ServiceUrgency.info,
      _ => _defaultUrgencyFor(severity: severity),
    };

    final rideabilityGuidance = (raw['rideabilityGuidance'] as String?)?.trim().isNotEmpty == true
        ? (raw['rideabilityGuidance'] as String)
        : _defaultRideabilityGuidance(rideabilityValue);

    final urgencyGuidance = (raw['urgencyGuidance'] as String?)?.trim().isNotEmpty == true
        ? (raw['urgencyGuidance'] as String)
        : _defaultUrgencyGuidance(urgencyValue);

    final reference = (raw['source'] as String?)?.trim();

    final models = (raw['models'] as List?)?.whereType<String>().toList() ?? const <String>[];

    return EbikeErrorInfo(
      code: code,
      title: title,
      description: description,
      severity: severity,
      models: models,
      whatItMeans: whatItMeans,
      commonCauses: commonCauses,
      commonSymptoms: commonSymptoms,
      howToFix: howToFix,
      rideability: rideabilityValue,
      rideabilityGuidance: rideabilityGuidance,
      urgency: urgencyValue,
      urgencyGuidance: urgencyGuidance,
      reference: reference,
    );
  }

  static List<String> _defaultCausesFor({required EbikeSeverity severity}) {
    switch (severity) {
      case EbikeSeverity.high:
        return const [
          'Loose, damaged, or corroded power/communication connector',
          'Wiring short or pinched cable',
          'Faulty battery, controller, or motor electronics',
          'Water ingress or contamination in connectors',
        ];
      case EbikeSeverity.medium:
        return const [
          'Sensor misalignment or intermittent connector contact',
          'Overheating under load or poor ventilation',
          'Firmware/settings mismatch or calibration drift',
          'Accessory or module causing unstable readings',
        ];
      case EbikeSeverity.low:
        return const [
          'Minor sensor input issue (magnet alignment, switch stuck)',
          'Temporary communication hiccup',
          'Settings/configuration mismatch',
        ];
    }
  }

  static List<String> _defaultSymptomsFor({required EbikeSeverity severity}) {
    switch (severity) {
      case EbikeSeverity.high:
        return const [
          'Motor cuts out or refuses to assist',
          'Warning beeps and persistent error code',
          'Abnormal heat smell, noise, or vibration',
          'Battery or display resets unexpectedly',
        ];
      case EbikeSeverity.medium:
        return const [
          'Reduced assist power or intermittent assist',
          'Error appears during hills/acceleration',
          'Display shows unstable readings',
        ];
      case EbikeSeverity.low:
        return const [
          'Assist works but error appears briefly',
          'Some features disabled (e.g., throttle/regen)',
          'Minor warning without noticeable ride impact',
        ];
    }
  }

  static List<String> _defaultFixFor({required EbikeSeverity severity}) {
    switch (severity) {
      case EbikeSeverity.high:
        return const [
          'Stop riding and power the bike off',
          'Inspect connectors/wiring for damage or corrosion',
          'Let components cool and keep the bike dry',
          'If the error returns, get professional diagnostics',
        ];
      case EbikeSeverity.medium:
        return const [
          'Power cycle and re-test on flat ground',
          'Check sensor alignment and connector seating',
          'Reduce assist level and avoid heavy load',
          'If recurring, book service soon',
        ];
      case EbikeSeverity.low:
        return const [
          'Power cycle and re-test',
          'Check for stuck brake/throttle input and connector seating',
          'Review settings and calibrate if available',
        ];
    }
  }

  static Rideability _defaultRideabilityFor({required EbikeSeverity severity}) {
    switch (severity) {
      case EbikeSeverity.high:
        return Rideability.stop;
      case EbikeSeverity.medium:
        return Rideability.caution;
      case EbikeSeverity.low:
        return Rideability.ok;
    }
  }

  static ServiceUrgency _defaultUrgencyFor({required EbikeSeverity severity}) {
    switch (severity) {
      case EbikeSeverity.high:
        return ServiceUrgency.immediate;
      case EbikeSeverity.medium:
        return ServiceUrgency.soon;
      case EbikeSeverity.low:
        return ServiceUrgency.info;
    }
  }

  static String _defaultRideabilityGuidance(Rideability rideability) {
    switch (rideability) {
      case Rideability.stop:
        return 'Stop riding. Continuing can risk damage or safety.';
      case Rideability.caution:
        return 'You may be able to ride home gently. Avoid hills, high assist, and traffic risks.';
      case Rideability.ok:
        return 'Usually safe to ride, but monitor for changes and re-check if the code returns.';
    }
  }

  static String _defaultUrgencyGuidance(ServiceUrgency urgency) {
    switch (urgency) {
      case ServiceUrgency.immediate:
        return 'Get professional help as soon as possible. Avoid continued use.';
      case ServiceUrgency.soon:
        return 'Book service soon, especially if the error repeats.';
      case ServiceUrgency.info:
        return 'This is often non-critical. Monitor and service if it becomes frequent.';
    }
  }
}
