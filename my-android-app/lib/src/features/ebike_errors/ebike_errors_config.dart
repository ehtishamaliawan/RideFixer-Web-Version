// E-Bike error codes configuration.
// Add or edit codes and steps as OEMs / controllers vary by model.
const Map<String, Map<String, dynamic>> ebikeErrorCodes = {
  'E01': {
    'title': 'Battery Communication Fault',
    'severity': 'high',
    'description': 'Controller cannot communicate reliably with the battery management system (BMS).',
    'whatItMeans': 'Your controller is not receiving stable data from the battery/BMS, so it may limit or disable assist to protect the system.',
    'causes': [
      'Battery not fully seated or connector pins contaminated',
      'Damaged harness between battery cradle and controller',
      'BMS protective shutdown or firmware mismatch',
      'Water ingress/corrosion in high-current connectors',
    ],
    'symptoms': [
      'Motor assist cuts out or never engages',
      'Display shows battery bars jumping or resets',
      'Error appears after bumps/vibration (intermittent contact)',
    ],
    'rideability': 'stop',
    'rideabilityGuidance': 'Avoid riding. If assist cuts out unexpectedly it can be unsafe, and repeated attempts can worsen connector damage.',
    'urgency': 'immediate',
    'urgencyGuidance': 'If cleaning/reseating doesn\'t fix it, you likely need dealer diagnostics (battery cradle, BMS, or controller).',
    'steps': [
      'Power cycle the bike (turn off, wait 10s, turn on).',
      'Check battery connector seating and cleanliness.',
      'Ensure battery firmware is up to date (OEM tool).',
      'If persists, contact dealer — battery module diagnosis required.',
    ],
    'source': 'Generic BMS/Controller guidance',
  },
  'E02': {
    'title': 'Motor Overcurrent / Overload',
    'severity': 'high',
    'description': 'Motor draws excessive current — could be heavy load, binding, or wiring short.',
    'whatItMeans': 'The controller detected current draw beyond safe limits and may shut down assist to prevent damage to wiring and power electronics.',
    'causes': [
      'Riding at high assist on steep climbs or starting in a high gear',
      'Wheel/drivetrain binding (brake rub, debris, bent rotor)',
      'Damaged motor phase wiring or connector short',
      'Internal motor fault (windings) or controller failure',
    ],
    'symptoms': [
      'Assist cuts out under load (hills/acceleration)',
      'Motor feels jerky or makes unusual noises',
      'Error returns immediately when you apply power',
    ],
    'rideability': 'stop',
    'rideabilityGuidance': 'Stop using assist. You can pedal unassisted if the bike rolls freely; do not keep forcing power through the motor.',
    'urgency': 'immediate',
    'urgencyGuidance': 'If the bike binds or wiring looks damaged, get it checked before riding again.',
    'steps': [
      'Stop riding and check for debris caught in the wheel or drivetrain.',
      'Inspect motor connectors and wiring for damage or corrosion.',
      'Lower pedal assist level and test on flat ground.',
      'If error repeats, have motor tested at a service center.',
    ],
    'source': 'Motor controller diagnostics',
  },
  'E03': {
    'title': 'Torque/Speed Sensor Fault',
    'severity': 'medium',
    'description': 'Pedal-assist sensors report invalid or no values.',
    'whatItMeans': 'The bike can\'t reliably read pedal force or wheel speed, so assist may become weak, delayed, or disabled for safety.',
    'causes': [
      'Sensor magnet misalignment (speed sensor)',
      'Loose sensor connector or damaged cable near the crank/wheel',
      'Calibration drift after service or firmware update',
    ],
    'symptoms': [
      'Assist feels delayed or inconsistent',
      'Speed reads 0 while moving (speed sensor issue)',
      'Assist works only at certain pedal cadence',
    ],
    'rideability': 'caution',
    'rideabilityGuidance': 'You can usually ride home carefully. Expect reduced or inconsistent assist and avoid busy traffic/hills.',
    'urgency': 'soon',
    'urgencyGuidance': 'Service soon if it repeats—sensor faults can leave you without assist unexpectedly.',
    'steps': [
      'Check sensor magnet alignment (if applicable) and secure mounting.',
      'Inspect connectors at the sensor and controller.',
      'Try re-calibrating or re-booting the display/controller.',
      'Replace sensor if intermittent readings continue.',
    ],
    'source': 'OEM sensor troubleshooting',
  },
  'E04': {
    'title': 'Controller Overtemperature',
    'severity': 'medium',
    'description': 'Controller temperature exceeded safe threshold temporarily.',
    'whatItMeans': 'The controller is too hot to operate safely. Assist may be reduced or cut off until the temperature drops.',
    'causes': [
      'Long climbs or high assist in hot weather',
      'Poor airflow around the controller area',
      'Dragging brake or drivetrain load increasing current draw',
    ],
    'symptoms': [
      'Assist fades gradually then stops',
      'Error appears after sustained climbs',
      'Controller area feels very warm to the touch',
    ],
    'rideability': 'caution',
    'rideabilityGuidance': 'You can usually ride home by reducing assist and load. Stop and cool down if the error returns.',
    'urgency': 'soon',
    'urgencyGuidance': 'If it happens frequently in normal riding, get it checked for airflow or electrical issues.',
    'steps': [
      'Stop and allow the bike to cool down (avoid heavy loads).',
      'Inspect for blocked airflow or damaged heatsink.',
      'Avoid high-load climbs until diagnosis.',
    ],
    'source': 'Controller thermal protection',
  },
  'E05': {
    'title': 'Throttle Not Responding',
    'severity': 'low',
    'description': 'Throttle reports no input or unstable values.',
    'whatItMeans': 'The throttle signal is missing or out of range. Many bikes disable throttle for safety when the signal is unstable.',
    'causes': [
      'Loose throttle connector',
      'Damaged throttle cable or water ingress',
      'Brake cut-off sensor stuck (disables throttle)',
    ],
    'symptoms': [
      'Throttle does nothing or feels intermittent',
      'Assist works but throttle is disabled',
      'Error appears when turning handlebars (cable strain)',
    ],
    'rideability': 'ok',
    'rideabilityGuidance': 'Usually safe to ride using pedal assist only. Avoid relying on throttle until fixed.',
    'urgency': 'info',
    'urgencyGuidance': 'Fix at your convenience unless it disables assist or appears with other errors.',
    'steps': [
      'Check throttle wiring and connector seating.',
      'Try cleaning throttle pivot and check for binding.',
      'Test with a different throttle if available.',
    ],
    'source': 'Throttle and user interface troubleshooting',
  },
  // Additional common/placeholder codes up to E30. Replace with OEM specifics as needed.
  'E06': {
    'title': 'Hall Sensor Failure',
    'severity': 'high',
    'description': 'Incorrect or missing hall sensor signals from the motor.',
    'steps': [
      'Inspect motor connector and wiring to the controller.',
      'Check for moisture or corrosion at the connector.',
      'If available, run motor bench test at a service centre.',
    ],
    'source': 'Motor diagnostics',
  },
  'E07': {
    'title': 'Display Communication Error',
    'severity': 'low',
    'description': 'Console/display cannot communicate with the controller.',
    'steps': [
      'Power cycle the bike and display.',
      'Inspect display ribbon/connector for damage.',
      'Try re-connecting or swapping a known-good display.',
    ],
  },
  'E08': {
    'title': 'Low Battery Voltage',
    'severity': 'medium',
    'description': 'Pack voltage below operational threshold or sudden drop detected.',
    'steps': [
      'Check battery state-of-charge and charge fully.',
      'Inspect for poor battery contact or loose wiring.',
      'If repeated, have battery tested for cell imbalance.',
    ],
  },
  'E09': {
    'title': 'Overvoltage Event',
    'severity': 'high',
    'description': 'Controller detected voltage above safe limit.',
    'steps': [
      'Power down immediately and avoid charging until inspected.',
      'Check charger and battery for faults.',
      'Contact service — overvoltage can damage electronics.',
    ],
  },
  'E10': {
    'title': 'Brake Sensor Trigger Fault',
    'severity': 'low',
    'description': 'Brake cut-off sensor stuck or reporting incorrectly.',
    'steps': [
      'Inspect brake lever sensor and wiring.',
      'Clean contacts and check for mechanical binding.',
      'Replace switch if intermittent.',
    ],
  },
  'E11': {
    'title': 'Speedometer Mismatch',
    'severity': 'low',
    'description': 'Speed readings differ significantly from expected values.',
    'steps': [
      'Check wheel magnet and sensor alignment.',
      'Verify wheel circumference setting in display.',
    ],
  },
  'E12': {
    'title': 'Controller EEPROM Error',
    'severity': 'medium',
    'description': 'Controller memory read/write or configuration corruption.',
    'steps': [
      'Try a soft reset of the controller (power cycle).',
      'If available, re-flash controller firmware with OEM tools.',
    ],
  },
  'E13': {
    'title': 'CAN Bus / External Module Error',
    'severity': 'medium',
    'description': 'Communication issue with external modules over CAN/serial.',
    'steps': [
      'Inspect CAN/serial wiring and connectors.',
      'Check for recent module changes or aftermarket devices.',
    ],
  },
  'E14': {
    'title': 'Regenerative Braking Fault',
    'severity': 'low',
    'description': 'Regeneration subsystem reporting an error.',
    'steps': [
      'Confirm braking hardware is functioning normally.',
      'Check firmware/settings for regen limits.',
    ],
  },
  'E15': {
    'title': 'Battery Temperature Sensor Fault',
    'severity': 'high',
    'description': 'Battery temperature sensing out of range or disconnected.',
    'steps': [
      'Inspect temperature sensor lead and connector.',
      'Avoid charging or heavy use until resolved.',
    ],
  },
  'E16': {
    'title': 'Connector Short Circuit',
    'severity': 'high',
    'description': 'Detected short in power/charger connector area.',
    'steps': [
      'Power down immediately and inspect connectors for damage.',
      'Do not attempt to charge until cleared by a technician.',
    ],
  },
  'E17': {
    'title': 'Faulty Charger Detection',
    'severity': 'medium',
    'description': 'Charger presence/handshake not detected correctly.',
    'steps': [
      'Try a different known-good charger.',
      'Inspect charging port for debris or damage.',
    ],
  },
  'E18': {
    'title': 'Motor Phase Imbalance',
    'severity': 'high',
    'description': 'Phase currents differ unexpectedly indicating wiring or motor fault.',
    'steps': [
      'Inspect motor phase wires for damage.',
      'If present, remove wheel and bench-test the motor.',
    ],
  },
  'E19': {
    'title': 'Controller Ground Fault',
    'severity': 'high',
    'description': 'Unusual current paths or grounding detected.',
    'steps': [
      'Inspect frame and mounting points for contact with wiring.',
      'Stop using the bike and seek professional inspection.',
    ],
  },
  'E20': {
    'title': 'Firmware Version Mismatch',
    'severity': 'low',
    'description': 'Controller and display versions incompatible or deprecated.',
    'steps': [
      'Check for firmware updates for display and controller.',
      'Follow OEM upgrade instructions carefully.',
    ],
  },
  'E21': {
    'title': 'Pedal Assist Calibration Error',
    'severity': 'low',
    'description': 'Calibration parameters out of expected range.',
    'steps': [
      'Run pedal-assist calibration from the display menu if available.',
      'If not, consult the service manual.',
    ],
  },
  'E22': {
    'title': 'USB Debug Interface Active',
    'severity': 'low',
    'description': 'Controller in programming/debug mode — normal for service only.',
    'steps': [
      'Exit debug mode via OEM tool or power-cycle the system.',
      'Avoid using the bike in this state for safety.',
    ],
  },
  'E23': {
    'title': 'Low Torque Output',
    'severity': 'medium',
    'description': 'Controller limiting torque due to a safety condition or sensor fault.',
    'steps': [
      'Check torque sensor, PAS settings and wiring.',
      'Inspect battery voltage under load.',
    ],
  },
  'E24': {
    'title': 'High Idle Current',
    'severity': 'medium',
    'description': 'Controller draws unexpected current while idle.',
    'steps': [
      'Inspect accessories and lights for shorted circuits.',
      'Monitor current draw with diagnostic tools.',
    ],
  },
  'E25': {
    'title': 'Water Ingress Detected',
    'severity': 'high',
    'description': 'Moisture detected in controller or battery leading to faults.',
    'steps': [
      'Dry components thoroughly and inspect for corrosion.',
      'Do not ride until system is checked by service.',
    ],
  },
  'E26': {
    'title': 'Faulty External Sensor',
    'severity': 'low',
    'description': 'Third-party or optional sensor reports invalid data.',
    'steps': [
      'Disconnect optional sensors and test core system.',
      'Replace or recalibrate the external sensor.',
    ],
  },
  'E27': {
    'title': 'ABS / Traction Control Fault',
    'severity': 'medium',
    'description': 'Advanced stability system reports an internal error.',
    'steps': [
      'Restart the system and check wheel sensors.',
      'If persistent, inspect ABS module wiring.',
    ],
  },
  'E28': {
    'title': 'Drive Mode Selection Error',
    'severity': 'low',
    'description': 'Requested drive mode cannot be engaged.',
    'steps': [
      'Cycle through drive modes and confirm settings.',
      'Reset to defaults if necessary.',
    ],
  },
  'E29': {
    'title': 'Persistent Fault Flag',
    'severity': 'medium',
    'description': 'Controller reports a stored persistent fault requiring clear and check.',
    'steps': [
      'Use OEM diagnostic tool to read and clear fault logs.',
      'Investigate any logged faults before clearing.',
    ],
  },
};
