import 'dart:math' as math;

import 'aircraft_types.dart';

class Airport {
  final String code;
  final String city;
  final String name;
  const Airport(this.code, this.city, this.name);
}

class Airline {
  final String code;
  final String name;
  final String livery;
  const Airline(this.code, this.name, this.livery);
}

class FlightLeg {
  final String flightNumber;
  final Airline airline;
  final Airport origin;
  final Airport destination;
  final AircraftType aircraft;
  final String registration;
  final String status;
  final String departTime;
  final String arriveTime;
  final String gate;
  final String terminal;

  const FlightLeg({
    required this.flightNumber,
    required this.airline,
    required this.origin,
    required this.destination,
    required this.aircraft,
    required this.registration,
    required this.status,
    required this.departTime,
    required this.arriveTime,
    required this.gate,
    required this.terminal,
  });
}

class DemoBoard {
  static const airports = [
    Airport('JFK', 'New York', 'John F. Kennedy Intl'),
    Airport('LHR', 'London', 'Heathrow'),
    Airport('LAX', 'Los Angeles', 'Los Angeles Intl'),
    Airport('DXB', 'Dubai', 'Dubai Intl'),
    Airport('HND', 'Tokyo', 'Haneda'),
    Airport('CDG', 'Paris', 'Charles de Gaulle'),
    Airport('FRA', 'Frankfurt', 'Frankfurt am Main'),
    Airport('SIN', 'Singapore', 'Changi'),
    Airport('AMS', 'Amsterdam', 'Schiphol'),
    Airport('SFO', 'San Francisco', 'San Francisco Intl'),
    Airport('IST', 'Istanbul', 'Istanbul Airport'),
    Airport('MAD', 'Madrid', 'Barajas'),
  ];

  static const airlines = [
    Airline('UAL', 'United', 'Navy belly, white crown, globe tail'),
    Airline('BAW', 'British Airways', 'Speedmarque ribbon on a midnight-blue tail'),
    Airline('DLH', 'Lufthansa', 'Yellow crane on a deep-blue tailfin'),
    Airline('UAE', 'Emirates', 'Red-green-black UAE flag sweep on the fin'),
    Airline('AFR', 'Air France', 'Tricolour stripes trailing off the tail'),
    Airline('KLM', 'KLM', 'Sky-blue body with the crown logo'),
    Airline('SIA', 'Singapore Airlines', 'Gold bird wing on a navy tail'),
    Airline('THY', 'Turkish Airlines', 'Grey body, red tail, tulip motif'),
    Airline('AAL', 'American', 'Bare-metal silver with a split flag tail'),
    Airline('IBE', 'Iberia', 'Red-yellow flowing ribbon on the tail'),
  ];

  static Airport airportByCode(String code) => airports.firstWhere(
        (a) => a.code == code.toUpperCase(),
        orElse: () => airports.first,
      );

  static String _reg(math.Random r) {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final p1 = letters[r.nextInt(letters.length)];
    final p2 = letters[r.nextInt(letters.length)];
    final p3 = letters[r.nextInt(letters.length)];
    final p4 = letters[r.nextInt(letters.length)];
    return 'G-$p1$p2$p3$p4';
  }

  static String _clock(int minutes) {
    final m = ((minutes % 1440) + 1440) % 1440;
    final h = m ~/ 60;
    final mm = m % 60;
    return '${h.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}';
  }

  static const _statuses = ['On time', 'Boarding', 'Delayed', 'In air', 'Landed'];

  static FlightLeg legFromSeed(int seed) {
    final r = math.Random(seed);
    final origin = airports[r.nextInt(airports.length)];
    var dest = airports[r.nextInt(airports.length)];
    if (dest.code == origin.code) {
      dest = airports[(airports.indexOf(origin) + 1) % airports.length];
    }
    final airline = airlines[r.nextInt(airlines.length)];
    final aircraft = AircraftCatalog.all[r.nextInt(AircraftCatalog.all.length)];
    final depart = r.nextInt(1440);
    final duration = 60 + r.nextInt(600);
    return FlightLeg(
      flightNumber: '${airline.code.substring(0, 2)}${100 + r.nextInt(8900)}',
      airline: airline,
      origin: origin,
      destination: dest,
      aircraft: aircraft,
      registration: _reg(r),
      status: _statuses[r.nextInt(_statuses.length)],
      departTime: _clock(depart),
      arriveTime: _clock(depart + duration),
      gate: '${String.fromCharCode(65 + r.nextInt(6))}${1 + r.nextInt(40)}',
      terminal: '${1 + r.nextInt(5)}',
    );
  }

  static FlightLeg lookup(String flightNumber) {
    final cleaned = flightNumber.trim().toUpperCase();
    return legFromSeed(cleaned.hashCode);
  }

  static List<FlightLeg> boardFor(Airport airport, {required bool arrivals}) {
    final base = (airport.code.hashCode ^ (arrivals ? 0x5151 : 0x2727)).abs();
    return List.generate(10, (i) {
      final leg = legFromSeed(base + i * 37);
      if (arrivals) {
        return FlightLeg(
          flightNumber: leg.flightNumber,
          airline: leg.airline,
          origin: leg.origin,
          destination: airport,
          aircraft: leg.aircraft,
          registration: leg.registration,
          status: leg.status,
          departTime: leg.departTime,
          arriveTime: leg.arriveTime,
          gate: leg.gate,
          terminal: leg.terminal,
        );
      }
      return FlightLeg(
        flightNumber: leg.flightNumber,
        airline: leg.airline,
        origin: airport,
        destination: leg.destination,
        aircraft: leg.aircraft,
        registration: leg.registration,
        status: leg.status,
        departTime: leg.departTime,
        arriveTime: leg.arriveTime,
        gate: leg.gate,
        terminal: leg.terminal,
      );
    });
  }

  static List<FlightLeg> overhead(int seed) {
    return List.generate(6, (i) => legFromSeed(seed + i * 911 + 13));
  }
}
