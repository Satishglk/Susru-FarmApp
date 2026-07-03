class HealthRecord {
  final int? id;
  final int animalId;
  final String date;
  final String type;
  final String description;
  final String? medicine;
  final String? vetName;
  final String? nextDueDate;

  HealthRecord({
    this.id,
    required this.animalId,
    required this.date,
    required this.type,
    this.description = '',
    this.medicine,
    this.vetName,
    this.nextDueDate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'animal_id': animalId,
        'date': date,
        'type': type,
        'description': description,
        'medicine': medicine,
        'vet_name': vetName,
        'next_due_date': nextDueDate,
      };

  factory HealthRecord.fromMap(Map<String, dynamic> map) => HealthRecord(
        id: map['id'] as int?,
        animalId: map['animal_id'] as int,
        date: map['date'] as String,
        type: map['type'] as String,
        description: map['description'] as String? ?? '',
        medicine: map['medicine'] as String?,
        vetName: map['vet_name'] as String?,
        nextDueDate: map['next_due_date'] as String?,
      );
}

const kHealthRecordTypes = <String>[
  'Vaccination',
  'Illness',
  'Treatment',
  'Checkup',
];
