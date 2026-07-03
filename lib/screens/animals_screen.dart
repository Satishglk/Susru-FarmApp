import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/animal.dart';
import '../services/database_helper.dart';
import 'animal_detail_screen.dart';
import 'animal_form_screen.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  List<Animal> _animals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final animals = await DatabaseHelper.instance.getAnimals();
    setState(() => _animals = animals);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.animals)),
      body: _animals.isEmpty
          ? Center(child: Text(l.noAnimalsYet))
          : ListView.builder(
              itemCount: _animals.length,
              itemBuilder: (context, i) {
                final a = _animals[i];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.pets)),
                  title: Text(a.name),
                  subtitle: Text('${a.species} · ${a.breed}'),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AnimalDetailScreen(animal: a),
                    ));
                    _load();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AnimalFormScreen()));
          _load();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
