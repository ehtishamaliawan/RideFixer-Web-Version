import 'dart:collection';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../features/ebike_errors/generic_models.dart';

class ModelScanCandidate {
  final String id;
  final String label;
  final int score;

  const ModelScanCandidate({required this.id, required this.label, required this.score});
}

class ModelScanResult {
  final String rawText;
  final List<ModelScanCandidate> candidates;

  const ModelScanResult({required this.rawText, required this.candidates});

  ModelScanCandidate? get best => candidates.isEmpty ? null : candidates.first;
}

class EbikeModelScanner {
  static String _dense(String s) => s.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

  static String _denseAlt(String s) {
    // Handle common OCR confusions.
    return _dense(s)
        .replaceAll('O', '0')
        .replaceAll('I', '1')
        .replaceAll('L', '1');
  }

  static List<String> _variantsForModel(GenericEbikeSubModel m) {
    final idDense = _dense(m.id);
    final nameDense = _dense(m.name);

    final variants = <String>{idDense, nameDense};

    // Useful partials.
    if (nameDense.contains('LCD3')) variants.add('LCD3');
    if (nameDense.contains('UKC1')) variants.add('UKC1');

    // Some IDs include hyphens in name only.
    if (idDense.startsWith('KT') && nameDense.contains('LCD3')) {
      variants.add('KTLCD3');
      variants.add('KTLCD');
    }

    return variants.where((v) => v.isNotEmpty).toList(growable: false);
  }

  /// Runs on-device OCR and tries to detect a known Generic display/controller model.
  ///
  /// Returns a ranked list of candidate model IDs from `genericEbikeSubModels`.
  static Future<ModelScanResult> scanGenericModelFromImagePath(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFilePath(imagePath);
      final recognized = await recognizer.processImage(input);
      final rawText = recognized.text;

      final dense = _dense(rawText);
      final denseAlt = _denseAlt(rawText);

      final scoresById = HashMap<String, int>();

      for (final model in genericEbikeSubModels) {
        if (model.id == 'other') continue;

        final variants = _variantsForModel(model);
        var bestScoreForModel = 0;

        for (final v in variants) {
          if (v.length < 2) continue;

          if (dense.contains(v)) {
            bestScoreForModel = bestScoreForModel < v.length * 10 ? v.length * 10 : bestScoreForModel;
          } else if (denseAlt.contains(v)) {
            bestScoreForModel = bestScoreForModel < v.length * 8 ? v.length * 8 : bestScoreForModel;
          }
        }

        if (bestScoreForModel > 0) {
          scoresById[model.id] = bestScoreForModel;
        }
      }

      final candidates = scoresById.entries
          .map((e) {
            final model = genericEbikeSubModels.firstWhere((m) => m.id == e.key);
            return ModelScanCandidate(id: e.key, label: model.name, score: e.value);
          })
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      // Keep it short; UI can still show manual list.
      final top = candidates.length > 5 ? candidates.sublist(0, 5) : candidates;

      return ModelScanResult(rawText: rawText, candidates: top);
    } finally {
      await recognizer.close();
    }
  }
}
