import 'package:flutter/foundation.dart';

@immutable
class GenericEbikeSubModel {
  final String id;
  final String name;
  final String description;

  const GenericEbikeSubModel({
    required this.id,
    required this.name,
    required this.description,
  });
}

/// Generic/Chinese e-bike displays/controllers vary a lot.
/// These sub-models help users pick the closest match.
///
/// Note: IDs are persisted/compared in code; keep them stable.
const List<GenericEbikeSubModel> genericEbikeSubModels = [
  GenericEbikeSubModel(
    id: 'sw900',
    name: 'SW900',
    description: 'Common LCD display used on many Chinese controllers.',
  ),
  GenericEbikeSubModel(
    id: 'gd01',
    name: 'GD01',
    description: 'Common generic display family.',
  ),
  GenericEbikeSubModel(
    id: 'gd02',
    name: 'GD02',
    description: 'Common generic display family.',
  ),
  GenericEbikeSubModel(
    id: 's866',
    name: 'S866',
    description: 'Common LCD display (often with 36V/48V hubs).',
  ),
  GenericEbikeSubModel(
    id: 's830',
    name: 'S830',
    description: 'Compact display often bundled with hub kits.',
  ),
  GenericEbikeSubModel(
    id: 'kt-lcd3',
    name: 'KT LCD3',
    description: 'Kunteng/KT controller + LCD3 style displays.',
  ),
  GenericEbikeSubModel(
    id: 'ukc1',
    name: 'UKC1 / UKC-1',
    description: 'Very common basic LCD used with many kits.',
  ),
  GenericEbikeSubModel(
    id: 'm5',
    name: 'M5',
    description: 'Widely used display (M5 / similar variants).',
  ),
  // Always keep Other at the end.
  GenericEbikeSubModel(
    id: 'other',
    name: 'Other / Not sure',
    description: 'Not sure which model? Show all generic codes.',
  ),
];
