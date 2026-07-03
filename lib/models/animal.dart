class Animal {
  final int? id;
  final String name;
  final String species;
  final String breed;
  final String sex;
  final String? birthDate;
  final String? notes;

  Animal({
    this.id,
    required this.name,
    required this.species,
    this.breed = '',
    this.sex = '',
    this.birthDate,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'species': species,
        'breed': breed,
        'sex': sex,
        'birth_date': birthDate,
        'notes': notes,
      };

  factory Animal.fromMap(Map<String, dynamic> map) => Animal(
        id: map['id'] as int?,
        name: map['name'] as String,
        species: map['species'] as String,
        breed: map['breed'] as String? ?? '',
        sex: map['sex'] as String? ?? '',
        birthDate: map['birth_date'] as String?,
        notes: map['notes'] as String?,
      );
}

const kAnimalSpecies = <String>[
  'Cattle',
  'Buffalo',
  'Goat',
  'Sheep',
  'Poultry',
  'Pig',
  'Horse',
  'Other',
];
