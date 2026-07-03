class EmissionLog {
  final int? id;
  final String date;
  final String species;
  final int count;
  final String manureMethod;
  final double dieselLitres;
  final double electricityKwh;
  final double calculatedCo2eKg;

  EmissionLog({
    this.id,
    required this.date,
    required this.species,
    required this.count,
    required this.manureMethod,
    this.dieselLitres = 0,
    this.electricityKwh = 0,
    required this.calculatedCo2eKg,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'species': species,
        'count': count,
        'manure_method': manureMethod,
        'diesel_litres': dieselLitres,
        'electricity_kwh': electricityKwh,
        'calculated_co2e_kg': calculatedCo2eKg,
      };

  factory EmissionLog.fromMap(Map<String, dynamic> map) => EmissionLog(
        id: map['id'] as int?,
        date: map['date'] as String,
        species: map['species'] as String,
        count: map['count'] as int,
        manureMethod: map['manure_method'] as String,
        dieselLitres: (map['diesel_litres'] as num?)?.toDouble() ?? 0,
        electricityKwh: (map['electricity_kwh'] as num?)?.toDouble() ?? 0,
        calculatedCo2eKg: (map['calculated_co2e_kg'] as num).toDouble(),
      );
}

const kManureMethods = <String>[
  'Pasture / Range',
  'Solid Storage',
  'Liquid / Slurry',
  'Anaerobic Lagoon',
  'Daily Spread',
  'Biogas Digester',
];
