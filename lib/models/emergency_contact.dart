class EmergencyContact {
  final int? id;
  final String role;
  final String name;
  final String phoneNumber;

  EmergencyContact({
    this.id,
    required this.role,
    required this.name,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role,
        'name': name,
        'phone_number': phoneNumber,
      };

  factory EmergencyContact.fromMap(Map<String, dynamic> map) =>
      EmergencyContact(
        id: map['id'] as int?,
        role: map['role'] as String,
        name: map['name'] as String,
        phoneNumber: map['phone_number'] as String,
      );
}

const kContactRoles = <String>[
  'Veterinarian',
  'Extension Officer',
  'Ambulance',
  'Other',
];
