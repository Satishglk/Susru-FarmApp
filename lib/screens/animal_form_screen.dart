import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/animal.dart';
import '../services/database_helper.dart';

class AnimalFormScreen extends StatefulWidget {
  final Animal? animal;
  const AnimalFormScreen({super.key, this.animal});

  @override
  State<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _breed;
  late TextEditingController _birthDate;
  late TextEditingController _notes;
  String _species = kAnimalSpecies.first;
  String _sex = 'Female';

  @override
  void initState() {
    super.initState();
    final a = widget.animal;
    _name = TextEditingController(text: a?.name ?? '');
    _breed = TextEditingController(text: a?.breed ?? '');
    _birthDate = TextEditingController(text: a?.birthDate ?? '');
    _notes = TextEditingController(text: a?.notes ?? '');
    _species = a?.species ?? kAnimalSpecies.first;
    _sex = a?.sex.isNotEmpty == true ? a!.sex : 'Female';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final animal = Animal(
      id: widget.animal?.id,
      name: _name.text.trim(),
      species: _species,
      breed: _breed.text.trim(),
      sex: _sex,
      birthDate: _birthDate.text.trim().isEmpty ? null : _birthDate.text.trim(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    if (widget.animal == null) {
      await DatabaseHelper.instance.insertAnimal(animal);
    } else {
      await DatabaseHelper.instance.updateAnimal(animal);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.animal == null ? l.addAnimal : l.editAnimal)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: InputDecoration(labelText: l.name),
              validator: (v) => (v == null || v.trim().isEmpty) ? l.name : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _species,
              decoration: InputDecoration(labelText: l.species),
              items: kAnimalSpecies
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _species = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _breed,
              decoration: InputDecoration(labelText: l.breed),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _sex,
              decoration: InputDecoration(labelText: l.sex),
              items: [
                DropdownMenuItem(value: 'Female', child: Text(l.female)),
                DropdownMenuItem(value: 'Male', child: Text(l.male)),
              ],
              onChanged: (v) => setState(() => _sex = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _birthDate,
              decoration:
                  InputDecoration(labelText: l.birthDate, hintText: 'YYYY-MM-DD'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  _birthDate.text = picked.toIso8601String().split('T').first;
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              decoration: InputDecoration(labelText: l.notes),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(l.save)),
          ],
        ),
      ),
    );
  }
}
