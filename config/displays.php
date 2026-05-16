<?php

return [
  'sw900' => [
    'name' => 'SW900 Display',
    'family' => 'Generic Chinese LCD Display',
    'summary' => 'SW900 is a very common e-bike LCD display used with many generic Chinese controllers, conversion kits and delivery e-bikes.',
    'keywords' => ['SW900 P settings', 'SW900 error codes', 'SW900 speed limit', 'SW900 voltage setting'],
    'settings' => ['p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11','p12','p13','p14','p15','p16'],
    'errors' => ['e01','e02','e03','e05','e06','e07','e08','e09','e10','e11','e21','e22','e24','e25','e30'],
    'notes' => ['Most SW900 menus depend on controller firmware.', 'P08 and P14 are high-risk settings because they affect speed and current.', 'Always match P03 voltage and P06 wheel size to the actual bike.'],
  ],
  's866' => [
    'name' => 'S866 Display',
    'family' => 'Generic Chinese LCD Display',
    'summary' => 'S866 is widely used on budget e-bikes and conversion kits. It often exposes P-settings for wheel size, voltage, speed limit and PAS behaviour.',
    'keywords' => ['S866 P settings', 'S866 error codes', 'S866 P08', 'S866 P14'],
    'settings' => ['p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11','p12','p13','p14','p15','p16'],
    'errors' => ['e01','e02','e03','e05','e06','e07','e08','e09','e10','e11','e21','e22','e24','e25','e30'],
    'notes' => ['S866 parameter labels can vary by seller.', 'Wrong P03 voltage can make the battery indicator inaccurate.', 'Wrong P06 wheel size causes wrong speed readings.'],
  ],
  'kt-lcd3' => [
    'name' => 'KT-LCD3 Display',
    'family' => 'KT Controller Display',
    'summary' => 'KT-LCD3 is popular with KT controllers and has a deeper C/P parameter system for PAS, current, speed and controller behaviour.',
    'keywords' => ['KT LCD3 settings', 'KT controller P settings', 'KT LCD3 error codes'],
    'settings' => ['p01','p02','p03','p04','p05','p06','p07','p08','p09','p10','p11','p12','p13','p14','p15'],
    'errors' => ['e03','e05','e06','e07','e08','e09','e21','e22','e30'],
    'notes' => ['KT displays may use both P and C parameter groups.', 'Current and PAS settings should match controller and battery ratings.'],
  ],
  'kd21c' => [
    'name' => 'KD21C Display',
    'family' => 'Compact E-Bike LCD Display',
    'summary' => 'KD21C-style displays are common on compact e-bikes and conversion kits. Settings vary by controller but usually include wheel size, voltage and speed limit.',
    'keywords' => ['KD21C settings', 'KD21C error codes', 'KD21C speed limit'],
    'settings' => ['p01','p03','p06','p08','p09','p10','p11','p12','p14','p15'],
    'errors' => ['e01','e02','e06','e07','e21','e22','e30'],
    'notes' => ['Menu names can differ between suppliers.', 'Use the controller label and display connector type for confirmation.'],
  ],
  'm5' => [
    'name' => 'M5 / M6 Display',
    'family' => 'Generic Compact Display',
    'summary' => 'M5 and M6 displays appear on many generic e-bikes. They commonly share Chinese controller error-code patterns.',
    'keywords' => ['M5 display error codes', 'M6 display P settings', 'generic ebike display errors'],
    'settings' => ['p01','p03','p06','p08','p10','p11','p12','p14','p15'],
    'errors' => ['e01','e02','e06','e07','e08','e21','e22','e30'],
    'notes' => ['If the display shows E07 or E30, check motor/controller wiring first.', 'Settings are controller-dependent.'],
  ],
];
