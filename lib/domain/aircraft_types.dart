class AircraftType {
  final String id;
  final String label;
  final String manufacturer;
  final String family;
  final int typicalSeats;
  final int rangeKm;
  final int engines;
  final String engineMount;
  final String spotterTip;

  const AircraftType({
    required this.id,
    required this.label,
    required this.manufacturer,
    required this.family,
    required this.typicalSeats,
    required this.rangeKm,
    required this.engines,
    required this.engineMount,
    required this.spotterTip,
  });
}

class AircraftCatalog {
  static const List<AircraftType> all = [
    AircraftType(
      id: 'a320',
      label: 'A320',
      manufacturer: 'Airbus',
      family: 'A320 family',
      typicalSeats: 165,
      rangeKm: 6300,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Rounded nose and a tall, straight fin. Compared with the A321 the fuselage is noticeably shorter; sharklet wingtips mark the neo variants.',
    ),
    AircraftType(
      id: 'a321',
      label: 'A321',
      manufacturer: 'Airbus',
      family: 'A320 family',
      typicalSeats: 200,
      rangeKm: 7400,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'A stretched A320 with extra overwing exits. The long, slim tube and four pairs of doors are the giveaway versus the shorter A320.',
    ),
    AircraftType(
      id: 'a330',
      label: 'A330',
      manufacturer: 'Airbus',
      family: 'A330 widebody',
      typicalSeats: 280,
      rangeKm: 11750,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Twin-aisle with two large engines and a curved wing. The shorter -200 sits higher on its gear; the -300 is the longer common version.',
    ),
    AircraftType(
      id: 'b737',
      label: '737-700',
      manufacturer: 'Boeing',
      family: '737 NG',
      typicalSeats: 140,
      rangeKm: 6000,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Pointed nose and flattened engine intakes (hamster-pouch). The -700 is the short NG body, often with blended winglets.',
    ),
    AircraftType(
      id: 'b738',
      label: '737-800',
      manufacturer: 'Boeing',
      family: '737 NG',
      typicalSeats: 175,
      rangeKm: 5400,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'The workhorse NG: longer than the -700 with the same flat-bottom engines. Look for the dorsal fin fillet and blended or split-scimitar winglets.',
    ),
    AircraftType(
      id: 'b38m',
      label: '737 MAX 8',
      manufacturer: 'Boeing',
      family: '737 MAX',
      typicalSeats: 178,
      rangeKm: 6570,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Distinctive split AT winglets and larger LEAP engines with serrated (chevron) nacelle trailing edges set it apart from the NG.',
    ),
    AircraftType(
      id: 'b777',
      label: '777-300ER',
      manufacturer: 'Boeing',
      family: '777 widebody',
      typicalSeats: 365,
      rangeKm: 13650,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Huge twin with the largest engines in service and a six-wheel main bogie. The raked, blade-like wingtips identify the ER.',
    ),
    AircraftType(
      id: 'b787',
      label: '787-9',
      manufacturer: 'Boeing',
      family: '787 Dreamliner',
      typicalSeats: 290,
      rangeKm: 14140,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Smooth nose, raked wingtips that flex upward in flight, and chevron-edged engine nacelles. No eyebrow windows above the cockpit.',
    ),
    AircraftType(
      id: 'e190',
      label: 'E190',
      manufacturer: 'Embraer',
      family: 'E-Jet',
      typicalSeats: 100,
      rangeKm: 4500,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Compact regional jet with a pointed nose and engines set well forward under a high-mounted wing. Double-bubble fuselage cross-section.',
    ),
    AircraftType(
      id: 'a350',
      label: 'A350-900',
      manufacturer: 'Airbus',
      family: 'A350 XWB',
      typicalSeats: 315,
      rangeKm: 15000,
      engines: 2,
      engineMount: 'Underwing',
      spotterTip:
          'Curved, blended wingtips and the dark "racoon mask" cockpit window surround. Quietest of the big twins on approach.',
    ),
    AircraftType(
      id: 'crj9',
      label: 'CRJ900',
      manufacturer: 'Bombardier',
      family: 'CRJ',
      typicalSeats: 76,
      rangeKm: 2800,
      engines: 2,
      engineMount: 'Rear fuselage',
      spotterTip:
          'Slim tube with rear-mounted engines and a T-tail. Sits low to the ground; common on short regional hops.',
    ),
    AircraftType(
      id: 'at76',
      label: 'ATR 72',
      manufacturer: 'ATR',
      family: 'ATR turboprop',
      typicalSeats: 70,
      rangeKm: 1500,
      engines: 2,
      engineMount: 'High wing',
      spotterTip:
          'High-wing turboprop with large six-blade props and a tall T-tail. The square windows and stalky gear are unmistakable.',
    ),
  ];

  static AircraftType byId(String id) =>
      all.firstWhere((a) => a.id == id, orElse: () => all.first);
}
