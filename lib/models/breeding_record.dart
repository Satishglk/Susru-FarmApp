class BreedingRecord {
  final int? id;
  final int animalId;
  final String date;
  final String eventType;
  final String? sireInfo;
  final String? outcome;
  final String? expectedDueDate;

  BreedingRecord({
    this.id,
    required this.animalId,
    required this.date,
    required this.eventType,
    this.sireInfo,
    this.outcome,
    this.expectedDueDate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'animal_id': animalId,
        'date': date,
        'event_type': eventType,
        'sire_info': sireInfo,
        'outcome': outcome,
        'expected_due_date': expectedDueDate,
      };

  factory BreedingRecord.fromMap(Map<String, dynamic> map) => BreedingRecord(
        id: map['id'] as int?,
        animalId: map['animal_id'] as int,
        date: map['date'] as String,
        eventType: map['event_type'] as String,
        sireInfo: map['sire_info'] as String?,
        outcome: map['outcome'] as String?,
        expectedDueDate: map['expected_due_date'] as String?,
      );
}

const kBreedingEventTypes = <String>[
  'Heat',
  'Insemination',
  'Pregnancy Check',
  'Birth',
];
