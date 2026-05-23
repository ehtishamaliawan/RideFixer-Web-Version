import 'ebike_setting_model.dart';

class SettingsCatalog {
  static List<EbikeSettingInfo> getSettingsByBrand(String brand) {
    final brandLower = brand.toLowerCase();
    final Object settings;

    switch (brandLower) {
      case 'generic':
        settings = _genericSettings;
        break;
      case 'bosch':
        settings = _boschSettings;
        break;
      case 'shimano':
        settings = _shimanoSettings;
        break;
      case 'yamaha':
        settings = _yamahaSettings;
        break;
      case 'bafang':
        settings = _bafangSettings;
        break;
      case 'brose':
        settings = _broseSettings;
        break;
      default:
        return [];
    }

    final items = switch (settings) {
      final List list => list
          .whereType<Map<String, dynamic>>()
          .map((raw) {
            final code = (raw['code'] as String?)?.trim() ?? '';
            return _fromConfig(code: code, raw: raw);
          })
          .where((e) => e.code.isNotEmpty)
          .toList(),
      final Map<String, Map<String, dynamic>> map => map.entries.map((e) => _fromConfig(code: e.key, raw: e.value)).toList(),
      _ => <EbikeSettingInfo>[],
    };
    items.sort((a, b) => a.code.compareTo(b.code));
    return items;
  }

  static EbikeSettingInfo? findByCodeAndBrand(String code, String brand, {String? modelId}) {
    final items = getSettingsByBrand(brand);
    final normalizedCode = code.trim().toUpperCase();
    final normalizedModel = modelId?.trim().toLowerCase();
    try {
      final matches = items.where((e) => e.code.toUpperCase() == normalizedCode).toList(growable: false);
      if (matches.isEmpty) return null;

      if (normalizedModel != null && normalizedModel.isNotEmpty) {
        try {
          return matches.firstWhere((e) => e.models.contains(normalizedModel));
        } catch (_) {
          // fall through
        }

        try {
          return matches.firstWhere((e) => e.models.isEmpty);
        } catch (_) {
          // fall through
        }
      }

      return matches.first;
    } catch (_) {
      return null;
    }
  }

  static EbikeSettingInfo _fromConfig({required String code, required Map<String, dynamic> raw}) {
    final title = (raw['title'] as String?)?.trim() ?? 'Setting $code';
    final summary = (raw['summary'] as String?)?.trim() ?? '';
    final whatItDoes = (raw['whatItDoes'] as String?)?.trim() ?? summary;

    final values = (raw['values'] as List?)?.whereType<String>().toList() ?? const <String>[];
    final notes = (raw['notes'] as List?)?.whereType<String>().toList() ?? const <String>[];

    final rawModels = raw['models'];
    final models = switch (rawModels) {
      final String single => [single],
      final List list => list.whereType<String>().toList(),
      _ => const <String>[],
    }
        .map((e) => e.toLowerCase().trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    return EbikeSettingInfo(
      code: code,
      title: title,
      summary: summary,
      whatItDoes: whatItDoes,
      values: values,
      notes: notes,
      models: models,
    );
  }
}

/// Generic/Chinese display settings vary by display/controller firmware.
///
/// Important: P01–P14 menus are NOT universal across all generic displays.
/// To keep data correct, we only apply entries to specific display families where
/// the P-code structure and meanings are verified.
const List<String> _sw900FamilyModels = [
  'sw900',
  'gd01',
  'gd02',
];

const List<String> _s866M5FamilyModels = [
  's866',
  'm5',
];

const List<String> _s830FamilyModels = [
  's830',
];

const List<String> _ktLcd3Models = [
  'kt-lcd3',
];

const List<Map<String, dynamic>> _genericSettings = [
  // SW900-family (P01–P14)
  {
    'code': 'P01',
    'title': 'Display brightness',
    'summary': 'Adjusts the screen backlight brightness.',
    'whatItDoes': 'Changes how bright the screen appears. Higher brightness is easier to read in sunlight but may use slightly more power.',
    'models': _sw900FamilyModels,
    'values': [
      '1 = dim',
      '2 = medium',
      '3 = bright (sunny days)',
    ],
    'notes': [
      'If your screen becomes hard to read outside, increase brightness.',
    ],
  },
  {
    'code': 'P02',
    'title': 'Speed unit (km/h or mph)',
    'summary': 'Selects kilometres per hour or miles per hour.',
    'whatItDoes': 'Changes the speed unit shown on the display. For correct speed, make sure wheel size is set correctly (P06).',
    'models': _sw900FamilyModels,
    'values': [
      '0 = km/h',
      '1 = mph',
    ],
    'notes': [
      'After changing P02, verify your wheel size (P06) so the speed reading stays accurate.',
    ],
  },
  {
    'code': 'P03',
    'title': 'Battery voltage setting',
    'summary': 'Sets the battery/motor voltage class (e.g. 24V/36V/48V).',
    'whatItDoes': 'Tells the display/controller what voltage system you have. A wrong setting can cause incorrect battery readings or cut-outs.',
    'models': _sw900FamilyModels,
    'values': [
      '24V',
      '36V',
      '48V (common default)',
      'Note: many SW900 units can operate up to 72V depending on controller/firmware.',
    ],
    'notes': [
      'Match this to your actual battery voltage (label on battery or spec sheet).',
    ],
  },
  {
    'code': 'P04',
    'title': 'Display sleep timer',
    'summary': 'Turns the system off after a period of inactivity.',
    'whatItDoes': 'If there is no operation for the configured time, the display/controller may shut down. Riding activity typically resets the timer.',
    'models': _sw900FamilyModels,
    'values': [
      '0–60 minutes',
      '0 = never sleep',
      '60 = sleep after 60 minutes of no-operation',
    ],
    'notes': [
      'Set a small value if you often forget to power off after stopping.',
    ],
  },
  {
    'code': 'P05',
    'title': 'PAS levels (assist steps)',
    'summary': 'Chooses how many pedal-assist levels are available.',
    'whatItDoes': 'Controls whether the display offers fewer (1–3) or more (1–5) assist levels.',
    'models': _sw900FamilyModels,
    'values': [
      '0 = 1–3 PAS levels',
      '1 = 1–5 PAS levels',
    ],
    'notes': [
      'More PAS levels can make it easier to fine-tune assistance to your pedaling effort.',
    ],
  },
  {
    'code': 'P06',
    'title': 'Wheel size',
    'summary': 'Sets wheel diameter so speed and distance read correctly.',
    'whatItDoes': 'The display uses wheel size to compute speed and distance. Incorrect wheel size causes incorrect speed readings and odometer/trip values.',
    'models': _sw900FamilyModels,
    'values': [
      'Set the wheel size in inches (varies by firmware; often 10–30+).',
    ],
    'notes': [
      'Common sizes: 20", 24", 26", 27.5", 28", 29".',
    ],
  },
  {
    'code': 'P07',
    'title': 'Speed measuring magnet (factory calibration)',
    'summary': 'Calibration value related to speed sensing and cutoff behavior.',
    'whatItDoes': 'This is commonly factory calibrated and affects how the controller interprets speed feedback and speed limiting.',
    'models': _sw900FamilyModels,
    'values': [
      'Factory calibrated (value varies).',
    ],
    'notes': [
      'Recommended: do not change unless a qualified bike shop advises a specific value.',
      'Changing this incorrectly can cause inaccurate speed limiting or assist behavior.',
    ],
  },
  {
    'code': 'P08',
    'title': 'Speed limit',
    'summary': 'Sets the maximum assisted speed (where supported).',
    'whatItDoes': 'Defines the speed at which the controller reduces or stops assistance, depending on local regulations and controller behavior.',
    'models': _sw900FamilyModels,
    'values': [
      'Set a speed limit that matches your local e-bike regulations.',
    ],
    'notes': [
      'Some controllers ignore display-set limits; verify behavior in a safe area.',
    ],
  },
  {
    'code': 'P09',
    'title': 'Zero / non-zero start (throttle behavior)',
    'summary': 'Controls whether throttle can start from standstill.',
    'whatItDoes': 'A non-zero start often introduces a small delay (about 1 second) or requires the bike to be moving before throttle engages.',
    'models': _sw900FamilyModels,
    'values': [
      '0 = zero start (throttle can start from standstill, if allowed by controller)',
      '1 = non-zero start (throttle delayed / requires movement)',
    ],
    'notes': [
      'Non-zero start can be a safety feature to reduce accidental launches.',
    ],
  },
  {
    'code': 'P10',
    'title': 'Drive mode (PAS/throttle)',
    'summary': 'Chooses PAS-only, throttle-only, or both.',
    'whatItDoes': 'Selects how the system delivers power: pedal assist, throttle, or a combination.',
    'models': _sw900FamilyModels,
    'values': [
      '0 = PAS only',
      '1 = throttle only',
      '2 = PAS + throttle',
    ],
    'notes': [
      'Local regulations may restrict throttle use. Configure accordingly.',
    ],
  },
  {
    'code': 'P11',
    'title': 'PAS sensitivity',
    'summary': 'Adjusts how strongly the system responds to pedaling.',
    'whatItDoes': 'Higher sensitivity settings can reduce battery usage by ramping assistance more gently (depending on controller).',
    'models': _sw900FamilyModels,
    'values': [
      '1–24 (where supported)',
      'Higher values often mean gentler/less aggressive assistance response.',
    ],
    'notes': [
      'If the bike feels too jumpy when you start pedaling, try increasing the sensitivity value.',
    ],
  },
  {
    'code': 'P12',
    'title': 'PAS start strength',
    'summary': 'How strongly assist starts when you begin pedaling.',
    'whatItDoes': 'Controls initial assist power at pedaling start. Too high can feel abrupt; too low can feel sluggish.',
    'models': _sw900FamilyModels,
    'values': [
      '0 = low start strength',
      '5 = maximum start strength',
    ],
    'notes': [
      'If you experience harsh kick-on, reduce start strength.',
    ],
  },
  {
    'code': 'P13',
    'title': 'PAS magnet type',
    'summary': 'PAS magnet disc type/count (e.g. 5/8/12).',
    'whatItDoes': 'Matches the PAS sensor configuration to the magnet disc. A mismatch can cause unreliable assist engagement.',
    'models': _sw900FamilyModels,
    'values': [
      '5 / 8 / 12 (typical options)',
    ],
    'notes': [
      'Usually factory matched to your PAS sensor; change only if you have replaced the PAS disc/sensor and know the correct value.',
    ],
  },
  {
    'code': 'P14',
    'title': 'Controller current limit (A)',
    'summary': 'Sets the controller current limit (often factory-set).',
    'whatItDoes': 'Limits peak current draw (and therefore power). Incorrect values can stress the battery/controller or reduce performance unexpectedly.',
    'models': _sw900FamilyModels,
    'values': [
      'Common range: 1–20A (varies by controller)',
    ],
    'notes': [
      'Recommended: do not increase beyond the controller/battery rating.',
      'If you are unsure, leave at the manufacturer value or ask a trusted bike shop.',
    ],
  },

  // S830 family (P00–P17)
  {
    'code': 'P00',
    'title': 'Factory reset (optional)',
    'summary': 'Resets display settings to factory defaults (use with caution).',
    'whatItDoes': 'Restores factory defaults. This may reset wheel size, units, speed limit and other parameters.',
    'models': _s830FamilyModels,
    'notes': [
      'Use only if you understand the consequences or if instructed by the bike/controller vendor.',
      'After a reset, re-check wheel size (P06), units (P02) and speed limit (P08).',
    ],
  },
  {
    'code': 'P01',
    'title': 'Backlight brightness',
    'summary': 'Screen brightness level. 1 = darkest, 3 = brightest.',
    'whatItDoes': 'Adjusts the LCD backlight brightness for readability.',
    'models': _s830FamilyModels,
    'values': [
      '1 = darkest',
      '2 = medium',
      '3 = brightest',
    ],
  },
  {
    'code': 'P02',
    'title': 'System unit (km or mile)',
    'summary': 'Select metric or imperial units.',
    'whatItDoes': 'Changes the units used for speed/distance on the display.',
    'models': _s830FamilyModels,
    'values': [
      '0 = km (metric)',
      '1 = mile (imperial)',
    ],
  },
  {
    'code': 'P03',
    'title': 'System voltage',
    'summary': 'Voltage class: 24V/36V/48V/60V/72V.',
    'whatItDoes': 'Configures the voltage class used by the display/controller for correct battery behavior.',
    'models': _s830FamilyModels,
    'values': [
      '24V',
      '36V',
      '48V',
      '60V',
      '72V',
    ],
    'notes': [
      'Set this to match your actual battery voltage class.',
      'If unsure, check the battery label/spec sheet before changing.',
    ],
  },
  {
    'code': 'P04',
    'title': 'Auto-off time (minutes)',
    'summary': 'Turns off after inactivity. 0 = never.',
    'whatItDoes': 'Automatically powers off after the selected time interval with no operation.',
    'models': _s830FamilyModels,
    'values': [
      '0 = never',
      'Other values = auto-off interval in minutes',
    ],
  },
  {
    'code': 'P05',
    'title': 'Pedal assist level mode',
    'summary': 'Choose assist level count and whether Level 0 is shown.',
    'whatItDoes': 'Controls the number of PAS levels available (3/5/9) and whether a Level 0 is included.',
    'models': _s830FamilyModels,
    'values': [
      '0–3 level mode',
      '1–3 level mode (no Level 0)',
      '0–5 level mode',
      '1–5 level mode (no Level 0)',
      '0–9 level mode',
      '1–9 level mode (no Level 0)',
    ],
  },
  {
    'code': 'P06',
    'title': 'Wheel size',
    'summary': 'Wheel diameter in inches (step 0.1).',
    'whatItDoes': 'Used to compute speed and distance. Incorrect values cause inaccurate readings.',
    'models': _s830FamilyModels,
    'values': [
      'Unit: inch',
      'Increment: 0.1',
    ],
    'notes': [
      'If speed/distance looks wrong, verify the wheel size is correct for your tire/wheel combo.',
    ],
  },
  {
    'code': 'P07',
    'title': 'Motor magnets number (speed gauge)',
    'summary': 'Speed sensor magnets count (technical). Range: 1–100.',
    'whatItDoes': 'Affects how the display computes speed from the motor/sensor feedback.',
    'models': _s830FamilyModels,
    'values': [
      'Range: 1–100',
    ],
    'notes': [
      'Change only if you know the correct value for your motor/sensor setup.',
    ],
  },
  {
    'code': 'P08',
    'title': 'Speed limit',
    'summary': 'Speed limit range: 0–100 km/h (controller/communication dependent).',
    'whatItDoes': 'Sets the maximum assisted speed (where supported). The max speed is kept constant at the set value.',
    'models': _s830FamilyModels,
    'values': [
      'Range: 0–100 km/h',
      'Error value: ±1 km/h',
    ],
    'notes': [
      'Values are measured in metric (km/h).',
      'If the system unit is set to mph, the displayed speed converts, but the speed limit value shown may not convert accordingly (manual note).',
    ],
  },
  {
    'code': 'P09',
    'title': 'Direct start / kick-to-start',
    'summary': 'Throttle start behavior.',
    'whatItDoes': 'Controls whether throttle can start the bike directly or requires a kick-to-start action.',
    'models': _s830FamilyModels,
    'values': [
      '0 = Direct start (throttle-on-demand)',
      '1 = Kick-to-start',
    ],
  },
  {
    'code': 'P10',
    'title': 'Drive mode setting',
    'summary': 'Choose PAS-only, throttle-only, or both (with direct-start note).',
    'whatItDoes': 'Selects how power is delivered: pedal assist, throttle, or a combination.',
    'models': _s830FamilyModels,
    'values': [
      '0 = Pedal assist (PAS level decides motor power; throttle does not work)',
      '1 = Electric drive (throttle only; PAS does not work)',
      '2 = PAS + electric drive (electric drive does not work in direct-start status)',
    ],
  },
  {
    'code': 'P11',
    'title': 'Pedal assist sensitivity',
    'summary': 'PAS sensitivity. Range: 1–24.',
    'whatItDoes': 'Adjusts how sensitive the assist engagement is to pedaling (manual-dependent).',
    'models': _s830FamilyModels,
    'values': [
      'Range: 1–24',
    ],
  },
  {
    'code': 'P12',
    'title': 'Pedal assist starting intensity',
    'summary': 'PAS starting intensity. Range: 0–5.',
    'whatItDoes': 'Controls how strongly assist starts when pedaling begins.',
    'models': _s830FamilyModels,
    'values': [
      'Range: 0–5',
    ],
  },
  {
    'code': 'P13',
    'title': 'PAS sensor magnets number',
    'summary': 'Magnet count in PAS sensor disc: 5/8/12.',
    'whatItDoes': 'Matches the PAS sensor configuration to the magnet disc.',
    'models': _s830FamilyModels,
    'values': [
      '5 magnets',
      '8 magnets',
      '12 magnets',
    ],
  },
  {
    'code': 'P14',
    'title': 'Current limit value (A)',
    'summary': 'Controller current limit. Default: 12A. Range: 1–20A.',
    'whatItDoes': 'Limits peak current draw (affects peak power).',
    'models': _s830FamilyModels,
    'values': [
      'Default: 12A',
      'Range: 1–20A',
    ],
    'notes': [
      'Do not increase beyond controller/battery ratings.',
    ],
  },
  {
    'code': 'P15',
    'title': 'Display low voltage value',
    'summary': 'Low voltage threshold (technical).',
    'whatItDoes': 'Defines a low-voltage threshold used by the display/controller system.',
    'models': _s830FamilyModels,
    'notes': [
      'Change only if instructed by your controller/vendor manual.',
    ],
  },
  {
    'code': 'P16',
    'title': 'ODO clearance',
    'summary': 'Clears ODO value via a long-press action.',
    'whatItDoes': 'Press and hold the Up key for 5 seconds and the ODO value will be cleared.',
    'models': _s830FamilyModels,
    'values': [
      'Hold UP for 5s to clear ODO',
    ],
  },
  {
    'code': 'P17',
    'title': 'Cruise',
    'summary': 'Cruise function enable/disable.',
    'whatItDoes': 'Toggles the cruise function (if supported by the controller/firmware).',
    'models': _s830FamilyModels,
    'values': [
      '0 = cruise deactivated',
      '1 = cruise activated',
    ],
  },

  // KT-LCD3 (P1–P5, C1–C14)
  {
    'code': 'P1',
    'title': 'Motor characteristic parameter',
    'summary': 'P1 = motor gear reduction ratio × number of rotor magnet pieces (rounded).',
    'whatItDoes': 'Defines a motor characteristic used by the controller/display for speed/assist calculations.',
    'models': _ktLcd3Models,
    'values': [
      'Range: 1–255',
      'Set as: gear reduction ratio × rotor magnet count (round if needed)',
    ],
    'notes': [
      'If unsure, keep the existing value or follow your KT controller/motor documentation.',
      'No button operation for 1 minute exits and saves.',
    ],
  },
  {
    'code': 'P2',
    'title': 'Wheel speed pulse signal',
    'summary': 'Pulse signals per wheel revolution.',
    'whatItDoes': 'If your wheel generates 1 pulse per revolution, set P2=1; if 6 pulses, set P2=6. If not configured, P2 can be 0.',
    'models': _ktLcd3Models,
    'values': [
      'Range: 0–6',
      '0 = not configured',
      '1 = 1 pulse / revolution',
      '6 = 6 pulses / revolution',
    ],
    'notes': [
      'Manual note: if P2=0 on a built-in clutch motor, speed display can be inaccurate when the internal rotor stops or is slower than the outer rotor.',
      'No button operation for 1 minute exits and saves.',
    ],
  },
  {
    'code': 'P3',
    'title': 'Power assist control mode',
    'summary': '0 = speed control; 1 = imitation torque control (gear 5 behavior).',
    'whatItDoes': 'Selects the power assist control mode supported by your controller.',
    'models': _ktLcd3Models,
    'values': [
      '0 = speed control mode (gear 5)',
      '1 = imitation torque control mode (gear 5)',
    ],
    'notes': [
      'Set according to the distributed function of the controller (manual note).',
    ],
  },
  {
    'code': 'P4',
    'title': 'Handlebar startup (throttle start)',
    'summary': '0 = zero startup; 1 = non-zero startup.',
    'whatItDoes': 'Controls whether throttle can start the motor directly (zero-start) or only after pedal assist starts (non-zero).',
    'models': _ktLcd3Models,
    'values': [
      '0 = zero startup (throttle can start directly)',
      '1 = non-zero startup (throttle effective only after foot power assist starts)',
    ],
  },
  {
    'code': 'P5',
    'title': 'Power monitoring',
    'summary': '0 = real-time voltage; other = smart power mode (battery-dependent).',
    'whatItDoes': 'Selects how the display estimates battery capacity: direct voltage-based or a battery-characteristic-based smart mode.',
    'models': _ktLcd3Models,
    'values': [
      'Range: 0–40',
      '0 = real-time voltage mode',
      'Smart power mode: value depends on battery characteristics',
      'Typical: 24V lithium often 4–11; 36V lithium often 5–15 (manual note)',
    ],
    'notes': [
      'After finishing P5, you can enter C parameters by holding UP + DOWN for ~2s within 1 minute (manual note).',
    ],
  },

  {
    'code': 'C1',
    'title': 'PAS sensor select',
    'summary': 'Selects the power-assist sensor type/parameters. Range: 0–7.',
    'whatItDoes': 'Configures PAS sensor behavior (start sensitivity varies by sensor type).',
    'models': _ktLcd3Models,
    'values': [
      'Range: 0–7',
    ],
    'notes': [
      'KT manuals provide a detailed table mapping C1 values to specific Kunteng sensor types and start sensitivity. Use the value recommended for your exact sensor.',
    ],
  },
  {
    'code': 'C2',
    'title': 'Motor phase classification coding',
    'summary': 'Identification parameter for sine wave drive motor phases. Default: 0. Range: 0–7.',
    'whatItDoes': 'Used to match the controller to different motor phase configurations (manual-dependent).',
    'models': _ktLcd3Models,
    'values': [
      'Range: 0–7',
      '0 = ordinary phase (default)',
    ],
  },
  {
    'code': 'C3',
    'title': 'Assist level initialization',
    'summary': 'Sets which assist level is active at startup. Factory default: 8.',
    'whatItDoes': 'Controls which power-assist ratio gear is selected after power-on.',
    'models': _ktLcd3Models,
    'values': [
      '0–5 = always start in gear 0–5',
      '6 & 7 = reserved',
      '8 = restore last gear at shutdown (default)',
    ],
  },
  {
    'code': 'C4',
    'title': 'Handlebar function',
    'summary': 'Throttle behavior by mode. Range: 0–4.',
    'whatItDoes': 'Defines throttle speed limit behavior depending on whether P4 is zero-start or non-zero-start.',
    'models': _ktLcd3Models,
    'values': [
      '0 = throttle follows P4 (zero-start vs non-zero-start)',
      '1 = zero-start: throttle limited to 6 km/h; non-zero-start: 6 km/h before PAS, full speed after PAS',
      '2 = throttle limited to a specified speed (value configurable; default 20)',
      '3 = zero-start: gear 0 effective; non-zero-start: like (1) plus returns to 6 km/h when PAS stops',
      '4 = throttle gears distinguished according to display meter (manual-dependent)',
    ],
    'notes': [
      'When C4=2, a “specified speed limit value of handlebar” is set (default 20).',
      'When C4=4, you set the % for first gear speed (default 50%); other gears divide equally (manual note).',
    ],
  },
  {
    'code': 'C5',
    'title': 'Controller maximum current adjustment',
    'summary': 'Tiny adjustment of limit current value. Default: 10. Range: 0–10.',
    'whatItDoes': 'Scales the controller maximum operating current using preset ratios (manual table).',
    'models': _ktLcd3Models,
    'values': [
      '0 = three level slow start / maximum current value',
      '1 = two level slow start / maximum current value',
      '2 = one level slow start / maximum current value',
      '3 = max current ÷ 2.00',
      '4 = max current ÷ 1.50',
      '5 = max current ÷ 1.33',
      '6 = max current ÷ 1.25',
      '7 = max current ÷ 1.20',
      '8 = max current ÷ 1.15',
      '9 = max current ÷ 1.10',
      '10 = max current (default)',
    ],
  },
  {
    'code': 'C6',
    'title': 'Backlight brightness adjustment',
    'summary': 'Backlight brightness. Default: 3. Range: 1–5.',
    'whatItDoes': 'Adjusts screen backlight brightness in finer steps.',
    'models': _ktLcd3Models,
    'values': [
      '1 = dimmest',
      '2 = darker',
      '3 = standard (default)',
      '4 = brighter',
      '5 = brightest',
    ],
  },
  {
    'code': 'C7',
    'title': 'Cruise function',
    'summary': '0 = off, 1 = on.',
    'whatItDoes': 'Enables or disables cruise (if supported by controller/firmware).',
    'models': _ktLcd3Models,
    'values': [
      '0 = off',
      '1 = on',
    ],
  },
  {
    'code': 'C8',
    'title': 'Motor temperature display',
    'summary': '0 = off, 1 = on (requires motor temperature sensor).',
    'whatItDoes': 'Shows motor operating temperature if a temperature sensor is installed and wired.',
    'models': _ktLcd3Models,
    'values': [
      '0 = function off',
      '1 = function on',
    ],
    'notes': [
      'Requires installing a temperature sensor in the motor and outputting a detection signal (manual note).',
    ],
  },
  {
    'code': 'C9',
    'title': 'Startup password',
    'summary': '0 = off, 1 = on (then set a 000–999 password). Default: 0.',
    'whatItDoes': 'Enables a power-on password prompt. When enabled, you configure a 3-digit password.',
    'models': _ktLcd3Models,
    'values': [
      '0 = function off',
      '1 = function on',
      'Password range: 000–999',
    ],
    'notes': [
      'Manual note: if you forget your password, parameters can only be copied from a data source meter before decoding.',
    ],
  },
  {
    'code': 'C10',
    'title': 'Automatically restore factory setting',
    'summary': 'n = off, y = on. Default: n.',
    'whatItDoes': 'If set to y and confirmed, restores default settings and exits settings mode (manual behavior).',
    'models': _ktLcd3Models,
    'values': [
      'n = off',
      'y = on (restore defaults)',
    ],
  },
  {
    'code': 'C11',
    'title': 'Meter attribute selection',
    'summary': 'Communication protocol / data source mode. Range: 0–2.',
    'whatItDoes': 'Selects protocol compatibility and whether the meter acts as a data source for parameter copying.',
    'models': _ktLcd3Models,
    'values': [
      '0 = LCD3 new protocol (compatible with LCD1/LCD2)',
      '1 = LCD1/LCD2 old protocol (not compatible with LCD3)',
      '2 = data source for copying parameters (manual note)',
    ],
    'notes': [
      'Manual note: C9 password and C11 attributes cannot be copied.',
      'LCD3 can only copy parameters to the same meter model.',
    ],
  },
  {
    'code': 'C12',
    'title': 'Controller minimum voltage adjustment',
    'summary': 'Tiny adjustment of low-voltage cutoff. Default: 4. Range: 0–7.',
    'whatItDoes': 'Adjusts the controller minimum operating voltage threshold by preset offsets.',
    'models': _ktLcd3Models,
    'values': [
      '0 = default − 2V',
      '1 = default − 1.5V',
      '2 = default − 1V',
      '3 = default − 0.5V',
      '4 = default (24V:20V, 36V:30V, 48V:40V) [manual table]',
      '5 = default + 0.5V',
      '6 = default + 1V',
      '7 = default + 1.5V',
    ],
  },
  {
    'code': 'C13',
    'title': 'ABS braking / energy recovery',
    'summary': 'Braking strength and energy recovery efficiency. Default: 0. Range: 0–5.',
    'whatItDoes': 'Configures braking intensity levels and energy recovery behavior (manual-dependent).',
    'models': _ktLcd3Models,
    'values': [
      '0 = none / none',
      '1 = class 1 braking strength / best recovery efficiency',
      '2 = class 2 braking strength / general recovery efficiency',
      '3 = class 3 braking strength / weaker recovery efficiency',
      '4 = class 4 braking strength / poor recovery efficiency',
      '5 = class 5 braking strength / bad recovery efficiency',
    ],
    'notes': [
      'Manual recommendation: C13=1; choose other values with caution.',
      'Higher braking intensity increases damage risk to the motor shaft (manual warning).',
    ],
  },
  {
    'code': 'C14',
    'title': 'Power-assist tuning',
    'summary': 'Assist strength tuning. Default: 2. Range: 1–3.',
    'whatItDoes': 'Tunes assist strength for intelligent pedal motor behavior.',
    'models': _ktLcd3Models,
    'values': [
      '1 = weak assist strength',
      '2 = general assist strength (default)',
      '3 = stronger assist strength',
    ],
    'notes': [
      'Manual note: valid for assist gears 1–4 and only when P3=1.',
    ],
  },

  // S866 / M5 family (P01–P20)
  {
    'code': 'P01',
    'title': 'Screen backlight (brightness)',
    'summary': '3 levels of screen brightness. Default: 002.',
    'whatItDoes': 'Adjusts the LCD backlight brightness for readability.',
    'models': _s866M5FamilyModels,
    'values': [
      '1 = low',
      '2 = medium (default)',
      '3 = high',
    ],
  },
  {
    'code': 'P02',
    'title': 'Distance units',
    'summary': 'Choose kilometres (KM) or miles (MILE). Default: 001.',
    'whatItDoes': 'Changes the units used for speed/distance on the display.',
    'models': _s866M5FamilyModels,
    'values': [
      '0 = KM',
      '1 = MILE',
    ],
  },
  {
    'code': 'P03',
    'title': 'Motor voltage (do not change)',
    'summary': 'Sets motor voltage class (48V or 52V). Default: 048 or 052 (depends on bike).',
    'whatItDoes': 'Configures the voltage class used by the motor/controller system.',
    'models': _s866M5FamilyModels,
    'values': [
      '48 = 48V system',
      '52 = 52V system',
    ],
    'notes': [
      'Do not change unless you are sure of your system voltage.',
      'Wrong values can cause incorrect behavior and may damage the motor/controller.',
    ],
  },
  {
    'code': 'P04',
    'title': 'Sleep time (minutes)',
    'summary': 'Auto sleep after inactivity. Default: 010.',
    'whatItDoes': 'If there is no operation for the configured time, the display will auto-sleep and exit settings mode.',
    'models': _s866M5FamilyModels,
    'values': [
      '0 = no sleep',
      '1–60 minutes',
    ],
  },
  {
    'code': 'P05',
    'title': 'PAS gear (assist levels)',
    'summary': 'Pedal assist level range. Default: 005.',
    'whatItDoes': 'Sets the pedal assist level range available on the display.',
    'models': _s866M5FamilyModels,
    'values': [
      '0–5 (levels)',
    ],
  },
  {
    'code': 'P06',
    'title': 'Tire size (do not change)',
    'summary': 'Used to compute speed/distance. Default often: 28.0 or 29.0 (varies by bike).',
    'whatItDoes': 'The display uses tire size to compute speed and distance traveled.',
    'models': _s866M5FamilyModels,
    'values': [
      'Typical values: 28.0 or 29.0',
      'Folding bike: 23',
      'Notes from manuals: E8/E9 = 29.0; EB7/EB7Pro/G7/EB9 = 28.0; GT2.0 = 22.8 or 23',
    ],
    'notes': [
      'Do not change unless you are correcting an incorrect speed reading and you know the exact correct value for your setup.',
      'Wrong tire size causes inaccurate speed and distance.',
    ],
  },
  {
    'code': 'P07',
    'title': 'Speed test magnetic steel (calibration)',
    'summary': 'Factory calibration. Default: 001.',
    'whatItDoes': 'A calibration value related to speed measurement.',
    'models': _s866M5FamilyModels,
    'notes': [
      'Non-professionals should not change this.',
      'Changing this value can display incorrect speed on the LCD.',
    ],
  },
  {
    'code': 'P08',
    'title': 'Speed limit',
    'summary': 'Sets maximum operating speed. Default: 100.',
    'whatItDoes': 'Defines the maximum operating speed of the vehicle (e.g., set 25 to limit to ~25 km/h).',
    'models': _s866M5FamilyModels,
    'values': [
      'Range typically 0–50 km/h (manual-dependent)',
      'Max value allowed is 55; anything above may not be recognized',
      'Error tolerance noted as ±3 km/h (manual-dependent)',
    ],
    'notes': [
      'Follow local e-bike regulations.',
      'Some controllers may ignore display-set limits; verify in a safe area.',
    ],
  },
  {
    'code': 'P09',
    'title': 'Throttle zero start',
    'summary': 'Controls whether throttle is active from standstill. Default: 000.',
    'whatItDoes': 'Determines whether throttle works immediately on power-on or only after pedaling/movement.',
    'models': _s866M5FamilyModels,
    'values': [
      '0 = throttle active when power is on',
      '1 = throttle active only after a few pedaling',
    ],
  },
  {
    'code': 'P10',
    'title': 'Mode toggle (PAS/throttle)',
    'summary': 'Selects how PAS and throttle work together. Default: 002.',
    'whatItDoes': 'Controls whether PAS is enabled, throttle is enabled, and when throttle is allowed to activate.',
    'models': _s866M5FamilyModels,
    'values': [
      '0 = PAS active, throttle inactive',
      '1 = throttle active only when already moving',
      '2 = both PAS and throttle active',
    ],
  },
  {
    'code': 'P11',
    'title': 'PAS start strength',
    'summary': 'Assist start strength (1–5). Default: 003.',
    'whatItDoes': 'Controls how strongly assist starts when pedaling begins.',
    'models': _s866M5FamilyModels,
    'values': [
      '1 = weakest start',
      '5 = strongest start',
    ],
  },
  {
    'code': 'P12',
    'title': 'PAS sensitivity',
    'summary': 'Pedal sensor sensitivity. Default: 005.',
    'whatItDoes': 'Higher numbers typically require more crank rotations for the motor to turn on; lower numbers require fewer rotations.',
    'models': _s866M5FamilyModels,
    'notes': [
      'If assist comes on too easily, try increasing the value.',
      'If assist feels delayed, try lowering the value.',
    ],
  },
  {
    'code': 'P13',
    'title': 'PAS magnetic type',
    'summary': 'Factory/technical setting. Default: 012.',
    'whatItDoes': 'A technical PAS sensor configuration value (manual-dependent).',
    'models': _s866M5FamilyModels,
    'notes': [
      'Non-professionals should not change this.',
    ],
  },
  {
    'code': 'P14',
    'title': 'Controller current limit',
    'summary': 'Controller current limit (technical). Default: 12.',
    'whatItDoes': 'Limits controller current draw (affects peak power).',
    'models': _s866M5FamilyModels,
    'notes': [
      'Non-professionals should not change this.',
      'Increasing current beyond ratings can stress battery/controller.',
    ],
  },
  {
    'code': 'P15',
    'title': 'Controller undervoltage value',
    'summary': 'Low-voltage cutoff threshold (technical). Default: 40.0.',
    'whatItDoes': 'Defines an undervoltage threshold used by the controller/display system.',
    'models': _s866M5FamilyModels,
    'notes': [
      'Non-professionals should not change this.',
    ],
  },
  {
    'code': 'P16',
    'title': 'ODO resetting',
    'summary': 'Reset total trip mileage. Default: 00000.',
    'whatItDoes': 'Allows resetting the total trip mileage via a long-press action.',
    'models': _s866M5FamilyModels,
    'values': [
      'Press the UP arrow button for 5 seconds to reset the total trip mileage.',
    ],
  },
  {
    'code': 'P17',
    'title': 'Cruiser setting',
    'summary': 'Function development (do not change). Default: 000.',
    'whatItDoes': 'Reserved / function development per manual.',
    'models': _s866M5FamilyModels,
    'notes': [
      'Function development, do not change.',
    ],
  },
  {
    'code': 'P18',
    'title': 'Display speed scale adjustment',
    'summary': 'Function development (do not change). Default: 100.',
    'whatItDoes': 'Reserved / function development per manual.',
    'models': _s866M5FamilyModels,
    'notes': [
      'Function development, do not change.',
    ],
  },
  {
    'code': 'P19',
    'title': '0 gear enable bit',
    'summary': 'Function development (do not change). Default: 000.',
    'whatItDoes': 'Reserved / function development per manual.',
    'models': _s866M5FamilyModels,
    'notes': [
      'Function development, do not change.',
    ],
  },
  {
    'code': 'P20',
    'title': 'Protocol',
    'summary': 'Function development (do not change). Default: 000.',
    'whatItDoes': 'Reserved / protocol selection per manual (function development).',
    'models': _s866M5FamilyModels,
    'notes': [
      'Function development, do not change.',
    ],
  },
];


// Brand systems typically don't use generic P-codes. We only list verified, safe guidance.
const Map<String, Map<String, dynamic>> _boschSettings = {
  'BOSCH-APP': {
    'title': 'Bosch settings (official app)',
    'summary': 'Most user-adjustable settings are managed through Bosch apps.',
    'whatItDoes': 'Bosch systems typically do not expose generic P01–Pxx menus. Depending on your system generation and display, settings are adjusted in the official Bosch app or by a dealer.',
    'values': [
      'Bosch eBike Flow (Smart System) — modes, display layout, updates (varies by model)',
      'Bosch eBike Connect — settings and ride data (varies by model)',
    ],
    'notes': [
      'If you are unsure which system you have, check your display model and the Bosch app compatibility list.',
    ],
  },
};

const Map<String, Map<String, dynamic>> _shimanoSettings = {
  'SHIMANO-ETUBE': {
    'title': 'Shimano settings (E-Tube Project)',
    'summary': 'Shimano STEPS settings are commonly adjusted via E-Tube Project.',
    'whatItDoes': 'Shimano systems do not use generic P01–Pxx settings. Assist behavior, switch assignments, and firmware updates are typically managed using the Shimano E-Tube Project app (where supported).',
    'values': [
      'Assist tuning (Eco/Trail/Boost) where supported',
      'Switch/display configuration where supported',
      'Firmware updates where supported',
    ],
    'notes': [
      'Availability depends on your exact motor/display and region.',
    ],
  },
};

const Map<String, Map<String, dynamic>> _yamahaSettings = {
  'YAMAHA-MODES': {
    'title': 'Yamaha assist modes',
    'summary': 'Yamaha systems are configured via the OEM display/app or dealer tools.',
    'whatItDoes': 'Yamaha drive units generally do not use generic P01–Pxx menus. What you can change depends on the bike brand, display, and system generation (some settings may require dealer access).',
    'values': [
      'Assist mode selection and behavior (varies by model)',
      'Display preferences (varies by model)',
    ],
    'notes': [
      'Check your bike brand’s manual for the supported settings for your specific display.',
    ],
  },
};

const Map<String, Map<String, dynamic>> _bafangSettings = {
  'BAFANG-PROGRAM': {
    'title': 'Bafang programming (where supported)',
    'summary': 'Some Bafang systems can be configured with dedicated tools.',
    'whatItDoes': 'Bafang mid-drive kits (and some controllers) can support parameter changes using a programming cable/app/tool, depending on the exact controller/display/firmware. These are not universal P01–Pxx settings.',
    'values': [
      'Speed limit (where supported)',
      'Current limit / power limits (where supported)',
      'PAS behavior (where supported)',
    ],
    'notes': [
      'Changing programming values can damage components or make the bike unsafe if done incorrectly; use manufacturer specs or a trusted bike shop.',
    ],
  },
};

const Map<String, Map<String, dynamic>> _broseSettings = {
  'BROSE-OEM': {
    'title': 'Brose settings (bike/OEM dependent)',
    'summary': 'Brose settings are typically controlled by the bike manufacturer’s integration.',
    'whatItDoes': 'Brose motors are usually integrated by bike brands with their own display/app behavior. Settings and diagnostics often depend on the OEM app or dealer tools rather than a universal P01–Pxx menu.',
    'values': [
      'Assist modes and profiles (varies by bike brand)',
      'Firmware updates (dealer/OEM dependent)',
    ],
    'notes': [
      'Check your bike brand’s support pages for the correct app/tools for your model.',
    ],
  },
};
