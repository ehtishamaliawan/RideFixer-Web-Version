// Parts configuration per bike type.
//
// Intervals researched from published manufacturer service manuals and
// widely-used industry references:
//  - Park Tool Big Blue Book of Bicycle Repair (BBB-4) maintenance schedule
//  - Shimano Dealer's Manual (chain check every 500 km; 0.75% elongation)
//  - Shimano STEPS E8000 service intervals (motor bolts 1,000 km, sensors 1,000 km)
//  - Bosch eBike System owner's guide (chain ~1,000–2,000 km; battery ~500 cycles)
//  - Fox Racing Shox service intervals (lower leg 125 hrs; full 500 hrs)
//  - RockShox service intervals (lower leg 50 hrs; damper 200 hrs)
//  - SRAM/Shimano brake manuals (bleed annually; rotor min thickness 1.5 mm)
//  - Schwalbe tire longevity data (Marathon Plus 8,000–12,000 km; Energizer Plus 5,000–8,000 km)
//  - Continental tire lifespan guide (GP5000: 4,000–6,000 km)
//
// E-bike wearable intervals are shorter because of:
//  - Higher total weight (~25–30 kg vs 8–12 kg)
//  - Higher sustained speeds and motor torque on the drivetrain
//  - Greater braking forces required
//
// All values are editable defaults — users can adjust the interval when
// they add a bike or reset a reminder.

const Map<String, List<Map<String, dynamic>>> partsConfig = {
  // ──────────────────────────────────────────────────────────────────────
  // Regular bicycles (road, gravel, MTB, hybrid)
  // ──────────────────────────────────────────────────────────────────────
  'Bike': [
    // ── Drivetrain ──
    {
      'title': 'Chain Lubrication',
      'distance': 200.0,
      'months': 1,
      'distanceRange': [100, 500],
      'monthsRange': [1, 2],
      'note':
          'Apply lube after every wet/muddy ride or every 150–300 km in dry conditions. Wipe excess to avoid attracting grit.',
      'source': 'Park Tool BBB-4 / Shimano Dealer\'s Manual',
    },
    {
      'title': 'Chain Wear / Replace',
      'distance': 3000.0,
      'months': 12,
      'distanceRange': [2000, 5000],
      'monthsRange': [6, 24],
      'note':
          'Use a chain checker tool (Park Tool CC-2); replace at 0.5% stretch for 11/12-speed, 0.75% for 9/10-speed. Road chains tend to last longer than MTB chains.',
      'source': 'Park Tool / Shimano Dealer\'s Manual',
    },
    {
      'title': 'Drivetrain Cleaning (chain, cassette, chainrings)',
      'distance': 400.0,
      'months': 1,
      'distanceRange': [200, 1000],
      'monthsRange': [1, 3],
      'note':
          'Degrease and scrub chain, cassette and chainrings. Cleaning extends component life and improves shifting.',
      'source': 'Park Tool / Shimano',
    },
    {
      'title': 'Cassette / Freehub Replace',
      'distance': 8000.0,
      'months': 24,
      'distanceRange': [4000, 15000],
      'monthsRange': [12, 48],
      'note':
          'A cassette typically outlasts 2–3 chains. Replace when teeth become hooked or the chain skips under load. 12-speed cassettes wear faster than 9/10.',
      'source': 'Shimano / SRAM / Park Tool',
    },
    {
      'title': 'Derailleur Pulleys & Shift Check',
      'distance': 3000.0,
      'months': 6,
      'distanceRange': [1500, 6000],
      'monthsRange': [3, 12],
      'note':
          'Inspect jockey wheel teeth for wear and derailleur hanger alignment. Adjust limit screws and cable tension if shifting is sluggish.',
      'source': 'Shimano / Park Tool',
    },
    {
      'title': 'Bottom Bracket Service',
      'distance': 6000.0,
      'months': 24,
      'distanceRange': [3000, 10000],
      'monthsRange': [12, 36],
      'note':
          'Check for play and creaking when pedalling. Shimano Hollowtech II / SRAM DUB sealed units last 5,000–10,000 km; press-fit BBs may need service sooner.',
      'source': 'Park Tool / Shimano / SRAM',
    },
    {
      'title': 'Cables & Housing (inspect/replace)',
      'distance': 3200.0,
      'months': 12,
      'distanceRange': [2000, 6000],
      'monthsRange': [6, 24],
      'note':
          'Replace frayed or sticky cables. Inspect housing for kinks, cracks or water ingress. Not applicable if bike uses full electronic shifting (Di2/AXS).',
      'source': 'Park Tool BBB-4',
    },

    // ── Brakes ──
    {
      'title': 'Brake Pads (inspect/replace)',
      'distance': 1500.0,
      'months': 6,
      'distanceRange': [500, 3000],
      'monthsRange': [3, 12],
      'note':
          'Disc brake: organic pads last ~500–1,500 km, metallic ~1,000–2,500 km. Rim brake: ~2,000–5,000 km. Replace when pad material is below the wear line.',
      'source': 'Shimano / SRAM brake manuals / Park Tool',
    },
    {
      'title': 'Brake Bleed (hydraulic)',
      'distance': 3000.0,
      'months': 12,
      'distanceRange': [1500, 6000],
      'monthsRange': [6, 24],
      'note':
          'Bleed annually or when lever feels spongy. Shimano uses mineral oil; SRAM uses DOT fluid (hygroscopic — absorbs moisture over time).',
      'source': 'Shimano / SRAM / Magura service manuals',
    },
    {
      'title': 'Brake Rotors / Disc Inspection',
      'distance': 3000.0,
      'months': 12,
      'distanceRange': [1500, 8000],
      'monthsRange': [6, 24],
      'note':
          'Measure rotor thickness with calipers. Shimano min: 1.5 mm (new 1.8 mm). Replace if warped or below minimum. Clean with isopropyl alcohol.',
      'source': 'Shimano / SRAM rotor specifications',
    },

    // ── Wheels ──
    {
      'title': 'Tire Visual Check & Pressure',
      'distance': 500.0,
      'months': 1,
      'distanceRange': [200, 1000],
      'monthsRange': [1, 3],
      'note':
          'Inspect tread, sidewalls and bead for cuts, bulges or embedded debris. Check pressure before every ride (road 80–120 psi; MTB 25–35 psi; gravel 35–55 psi).',
      'source': 'Park Tool / REI expert advice',
    },
    {
      'title': 'Tire Replacement',
      'distance': 5000.0,
      'months': 24,
      'distanceRange': [2500, 12000],
      'monthsRange': [12, 48],
      'note':
          'Depends heavily on compound: Continental GP5000 ~4,000–6,000 km; Schwalbe Marathon Plus ~8,000–12,000 km; MTB tires ~3,000–5,000 km.',
      'source': 'Continental / Schwalbe published longevity data',
    },
    {
      'title': 'Wheel Truing / Spoke Check',
      'distance': 2000.0,
      'months': 12,
      'distanceRange': [1000, 5000],
      'monthsRange': [6, 24],
      'note':
          'Check spoke tension by squeezing pairs. True the rim if lateral wobble exceeds ~1 mm. Machine-built wheels may need an early re-tension at 500 km.',
      'source': 'Park Tool BBB-4',
    },
    {
      'title': 'Hub Service / Bearing Check',
      'distance': 6000.0,
      'months': 24,
      'distanceRange': [3000, 10000],
      'monthsRange': [12, 36],
      'note':
          'Check for play by rocking the wheel side-to-side. Sealed cartridge bearings last 5,000–10,000 km; cup-and-cone hubs need grease every 3,000–5,000 km.',
      'source': 'Park Tool / hub manufacturer guidance',
    },

    // ── Suspension (if equipped) ──
    {
      'title': 'Suspension Lower-Leg Service',
      'distance': 2500.0,
      'months': 6,
      'distanceRange': [750, 5000],
      'monthsRange': [3, 12],
      'note':
          'Wipe stanchions, replace wiper seals, change lower-leg oil. Fox recommends every 125 hours; RockShox every 50 hours. At ~15 km/h average that is ~750–1,875 km.',
      'source': 'Fox / RockShox published service intervals',
    },
    {
      'title': 'Suspension Full Service (damper & air spring)',
      'distance': 8000.0,
      'months': 12,
      'distanceRange': [3000, 12000],
      'monthsRange': [6, 24],
      'note':
          'Full damper and air-spring rebuild. Fox recommends every 500 hours; RockShox every 200 hours. Professional service typically required.',
      'source': 'Fox / RockShox published service intervals',
    },

    // ── Steering & Cockpit ──
    {
      'title': 'Headset Service / Bearings',
      'distance': 6000.0,
      'months': 24,
      'distanceRange': [3000, 10000],
      'monthsRange': [12, 36],
      'note':
          'Check for play by squeezing the front brake and rocking the bike. Sealed cartridge headset bearings typically last 5,000–10,000 km.',
      'source': 'Park Tool BBB-4',
    },
    {
      'title': 'Seatpost & Stem Bolt Torque Check',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Verify bolts are torqued to spec (typically 4–6 Nm for carbon, 6–8 Nm for alloy). Use a torque wrench — over-tightening carbon can cause failure.',
      'source': 'Manufacturer torque specs / Park Tool',
    },

    // ── Misc ──
    {
      'title': 'Quick Release / Thru-Axle Torque Check',
      'distance': 0.0,
      'months': 3,
      'monthsRange': [1, 6],
      'note':
          'Verify secure closure after wheel removal or long rides. Thru-axles typically 12–16 Nm.',
      'source': 'Park Tool / frame manufacturer specs',
    },
    {
      'title': 'Pedals / Cleats (inspect)',
      'distance': 0.0,
      'months': 12,
      'monthsRange': [6, 24],
      'note':
          'Check pedal bearings for play and cleat bolts for looseness. Replace cleats when float becomes excessive (Shimano SPD-SL ~5,000–10,000 km).',
      'source': 'Shimano / Look / Crankbrothers',
    },
    {
      'title': 'Lights & Reflectors (inspect)',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Verify all lights function, check battery charge, and ensure reflectors are undamaged.',
      'source': 'Safety best practice',
    },
    {
      'title': 'Frame & Fastener Inspection',
      'distance': 0.0,
      'months': 12,
      'monthsRange': [6, 24],
      'note':
          'Inspect frame for cracks, dents or paint bubbles (possible corrosion). Check bottle cage, rack and accessory bolts.',
      'source': 'Manufacturer safety guidance',
    },
  ],

  // ──────────────────────────────────────────────────────────────────────
  // Electric bikes (pedal-assist / throttle)
  // ──────────────────────────────────────────────────────────────────────
  'E-Bike': [
    // ── Drivetrain (shorter intervals due to motor torque & weight) ──
    {
      'title': 'Chain Lubrication',
      'distance': 150.0,
      'months': 1,
      'distanceRange': [80, 400],
      'monthsRange': [1, 2],
      'note':
          'Motor torque accelerates chain wear; lubricate more often than a regular bike, especially after wet or salty conditions.',
      'source': 'Bosch eBike owner\'s guide / Shimano STEPS manual',
    },
    {
      'title': 'Chain Wear / Replace',
      'distance': 1500.0,
      'months': 6,
      'distanceRange': [1000, 3000],
      'monthsRange': [3, 12],
      'note':
          'E-bike chains wear ~1.5–2× faster than regular bike chains due to constant motor torque. Bosch recommends checking every 1,000 km. Use a chain checker at 0.5% for 11/12-speed.',
      'source': 'Bosch eBike guide / Shimano STEPS service manual',
    },
    {
      'title': 'Drivetrain Cleaning',
      'distance': 300.0,
      'months': 1,
      'distanceRange': [150, 800],
      'monthsRange': [1, 3],
      'note':
          'Degrease chain, cassette and chainring. A clean drivetrain can add hundreds of km to chain life.',
      'source': 'Bosch maintenance tips / Park Tool',
    },
    {
      'title': 'Cassette / Chainring Inspection',
      'distance': 4500.0,
      'months': 12,
      'distanceRange': [2500, 10000],
      'monthsRange': [6, 24],
      'note':
          'Higher motor torque wears chainring teeth faster. Replace when teeth appear hooked or chain skips under pedal pressure.',
      'source': 'Shimano STEPS / SRAM / Bosch',
    },
    {
      'title': 'Cables & Housing (inspect/replace)',
      'distance': 2500.0,
      'months': 12,
      'distanceRange': [1500, 5000],
      'monthsRange': [6, 24],
      'note':
          'Check routing near motor and battery where cables often rub. Replace frayed or corroded cables.',
      'source': 'Park Tool / e-bike manufacturer guidance',
    },

    // ── Brakes (heavier bike + higher speed = faster wear) ──
    {
      'title': 'Brake Pads (inspect/replace)',
      'distance': 800.0,
      'months': 3,
      'distanceRange': [300, 2000],
      'monthsRange': [2, 8],
      'note':
          'E-bikes are 10–20 kg heavier and ride faster, increasing braking force and pad wear by roughly 2×. Check pad thickness every few hundred km.',
      'source': 'Shimano / Magura / Tektro e-bike brake guidelines',
    },
    {
      'title': 'Brake Bleed (hydraulic)',
      'distance': 2000.0,
      'months': 12,
      'distanceRange': [1000, 4000],
      'monthsRange': [6, 18],
      'note':
          'Heavier braking generates more heat, which degrades brake fluid faster. Bleed annually or when the lever feels spongy.',
      'source': 'Shimano / SRAM / Magura service manuals',
    },
    {
      'title': 'Brake Rotors / Disc Inspection',
      'distance': 2000.0,
      'months': 6,
      'distanceRange': [1000, 5000],
      'monthsRange': [3, 12],
      'note':
          'Rotors on e-bikes wear faster than regular bikes. Measure thickness with calipers; Shimano minimum is 1.5 mm.',
      'source': 'Shimano rotor specs / e-bike brake guidelines',
    },

    // ── Wheels & Tires ──
    {
      'title': 'Tire Visual Check & Pressure',
      'distance': 300.0,
      'months': 1,
      'distanceRange': [150, 800],
      'monthsRange': [1, 3],
      'note':
          'E-bike tires carry more load; inspect for cuts, embedded debris and sidewall damage. Check pressure before each ride (typical e-bike: 40–65 psi).',
      'source': 'Schwalbe / Continental e-bike tire guides',
    },
    {
      'title': 'Tire Replacement',
      'distance': 4000.0,
      'months': 18,
      'distanceRange': [2000, 8000],
      'monthsRange': [12, 36],
      'note':
          'Use e-bike rated tires (ECE-R75 rated). Schwalbe Energizer Plus lasts ~5,000–8,000 km; softer compounds wear faster. Rear tire wears ~2× faster than front due to motor drive.',
      'source': 'Schwalbe / Continental published data',
    },
    {
      'title': 'Wheel Truing / Spoke Tension Check',
      'distance': 1500.0,
      'months': 6,
      'distanceRange': [800, 3000],
      'monthsRange': [3, 12],
      'note':
          'Higher weight and motor torque stress spokes more. Hub-motor wheels are especially prone to spoke loosening. Re-tension earlier than on a regular bike.',
      'source': 'Park Tool / e-bike wheel builder guidance',
    },

    // ── Frame & Structure ──
    {
      'title': 'Frame & Fastener Inspection',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Pay special attention to motor mount points, battery rail, rear rack mounts and welds near the BB. Vibration from motor can loosen bolts.',
      'source': 'E-bike manufacturer safety guidance',
    },

    // ── E-bike Electrical Components ──
    {
      'title': 'Battery Health Check (range & capacity)',
      'distance': 0.0,
      'months': 3,
      'monthsRange': [1, 6],
      'note':
          'Track your range over time — a noticeable drop signals ageing cells. Most lithium batteries last ~500–1,000 full charge cycles (roughly 25,000–50,000 km). Store between 30–80% charge if unused for weeks.',
      'source': 'Bosch / Shimano STEPS battery care guides',
    },
    {
      'title': 'Battery Contacts / Mount Cleaning',
      'distance': 0.0,
      'months': 3,
      'monthsRange': [1, 6],
      'note':
          'Remove battery, inspect contact pins for corrosion or debris, and clean with a dry cloth. Ensure the battery seats firmly with no rattle.',
      'source': 'Bosch / Shimano STEPS maintenance guides',
    },
    {
      'title': 'Charger & Charge Port Inspection',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Check charger cable for fraying, bent connector pins, and the charge port cover seal. Never charge with a wet port.',
      'source': 'Bosch / e-bike manufacturer guidance',
    },
    {
      'title': 'Wiring & Connectors (visual check)',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Inspect wiring harness for chafing, loose connectors and moisture ingress. Wiggle connectors gently to check for intermittent faults.',
      'source': 'Shimano STEPS / Bosch dealer manuals',
    },
    {
      'title': 'Motor Mount & Hardware Torque Check',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Mid-drive: check motor mounting bolts (typically 40–50 Nm). Hub-motor: check axle nut / torque arm. Shimano STEPS recommends every 1,000 km.',
      'source': 'Shimano STEPS Dealer\'s Manual / Bosch installation guide',
    },
    {
      'title': 'Sensors Check (speed / cadence / torque)',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Verify assist engages smoothly and the speedometer reads correctly. Check magnet/sensor gap (~1.5 mm typical for Shimano STEPS speed sensor).',
      'source': 'Shimano STEPS manual / Bosch dealer guide',
    },
    {
      'title': 'Brake Cutoff Sensors',
      'distance': 0.0,
      'months': 6,
      'monthsRange': [3, 12],
      'note':
          'Squeeze each brake lever and confirm the motor cuts power instantly. A failing cutoff sensor is a serious safety issue.',
      'source': 'E-bike safety standards / manufacturer guidance',
    },
    {
      'title': 'Controller / Display Firmware Update',
      'distance': 0.0,
      'months': 12,
      'monthsRange': [6, 24],
      'note':
          'Check for firmware updates via the manufacturer\'s app (Bosch eBike Flow, Shimano E-Tube, etc.). Updates may fix bugs or improve motor tuning.',
      'source': 'Bosch / Shimano / Specialized / manufacturer apps',
    },
  ],
};
