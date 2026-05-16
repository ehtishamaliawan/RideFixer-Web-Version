import 'package:flutter/foundation.dart';

@immutable
class EbikeSettingInfo {
  final String code; // e.g. P01
  final String title;
  final String summary;
  final String whatItDoes;
  final List<String> values;
  final List<String> notes;
  final List<String> models; // lowercased IDs, e.g. sw900

  const EbikeSettingInfo({
    required this.code,
    required this.title,
    required this.summary,
    required this.whatItDoes,
    required this.values,
    required this.notes,
    required this.models,
  });
}
