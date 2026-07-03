import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/animal.dart';
import '../models/breeding_record.dart';
import '../models/health_record.dart';
import '../services/database_helper.dart';
import 'animal_form_screen.dart';

class AnimalDetailScreen extends StatefulWidget {
  final Animal animal;
  const AnimalDetailScreen({super.key, required this.animal});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HealthRecord> _health = [];
  List<BreedingRecord> _breeding = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  Future<void> _load() async {
    final health =
        await DatabaseHelper.instance.getHealthRecords(animalId: widget.animal.id);
    final breeding = await DatabaseHelper.instance
        .getBreedingRecords(animalId: widget.animal.id);
    setState(() {
      _health = health;
      _breeding = breeding;
    });
  }

  Future<void> _addHealthRecord() async {
    final l = AppLocalizations.of(context)!;
    final typeCtrl = ValueNotifier(kHealthRecordTypes.first);
    final dateCtrl = TextEditingController(
        text: DateTime.now().toIso8601String().split('T').first);
    final descCtrl = TextEditingController();
    final medicineCtrl = TextEditingController();
    final vetCtrl = TextEditingController();
    final dueCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.addHealthRecord),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: typeCtrl,
                builder: (_, value, _) => DropdownButtonFormField<String>(
                  initialValue: value,
                  decoration: InputDecoration(labelText: l.type),
                  items: kHealthRecordTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => typeCtrl.value = v!,
                ),
              ),
              TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(labelText: l.date)),
              TextField(
                  controller: descCtrl,
                  decoration: InputDecoration(labelText: l.description)),
              TextField(
                  controller: medicineCtrl,
                  decoration: InputDecoration(labelText: l.medicine)),
              TextField(
                  controller: vetCtrl,
                  decoration: InputDecoration(labelText: l.vetName)),
              TextField(
                  controller: dueCtrl,
                  decoration: InputDecoration(labelText: l.nextDueDate)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              await DatabaseHelper.instance.insertHealthRecord(HealthRecord(
                animalId: widget.animal.id!,
                date: dateCtrl.text.trim(),
                type: typeCtrl.value,
                description: descCtrl.text.trim(),
                medicine:
                    medicineCtrl.text.trim().isEmpty ? null : medicineCtrl.text.trim(),
                vetName: vetCtrl.text.trim().isEmpty ? null : vetCtrl.text.trim(),
                nextDueDate:
                    dueCtrl.text.trim().isEmpty ? null : dueCtrl.text.trim(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
              _load();
            },
            child: Text(l.save),
          ),
        ],
      ),
    );
  }

  Future<void> _addBreedingRecord() async {
    final l = AppLocalizations.of(context)!;
    final typeCtrl = ValueNotifier(kBreedingEventTypes.first);
    final dateCtrl = TextEditingController(
        text: DateTime.now().toIso8601String().split('T').first);
    final sireCtrl = TextEditingController();
    final outcomeCtrl = TextEditingController();
    final dueCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.addBreedingRecord),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: typeCtrl,
                builder: (_, value, _) => DropdownButtonFormField<String>(
                  initialValue: value,
                  decoration: InputDecoration(labelText: l.eventType),
                  items: kBreedingEventTypes
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => typeCtrl.value = v!,
                ),
              ),
              TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(labelText: l.date)),
              TextField(
                  controller: sireCtrl,
                  decoration: InputDecoration(labelText: l.sireInfo)),
              TextField(
                  controller: outcomeCtrl,
                  decoration: InputDecoration(labelText: l.outcome)),
              TextField(
                  controller: dueCtrl,
                  decoration: InputDecoration(labelText: l.expectedDueDate)),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              await DatabaseHelper.instance.insertBreedingRecord(BreedingRecord(
                animalId: widget.animal.id!,
                date: dateCtrl.text.trim(),
                eventType: typeCtrl.value,
                sireInfo: sireCtrl.text.trim().isEmpty ? null : sireCtrl.text.trim(),
                outcome:
                    outcomeCtrl.text.trim().isEmpty ? null : outcomeCtrl.text.trim(),
                expectedDueDate:
                    dueCtrl.text.trim().isEmpty ? null : dueCtrl.text.trim(),
              ));
              if (ctx.mounted) Navigator.pop(ctx);
              _load();
            },
            child: Text(l.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animal.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AnimalFormScreen(animal: widget.animal),
              ));
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await DatabaseHelper.instance.deleteAnimal(widget.animal.id!);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l.healthRecords),
            Tab(text: l.breedingRecords),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _health.isEmpty
              ? Center(child: Text(l.noHealthRecordsYet))
              : ListView.builder(
                  itemCount: _health.length,
                  itemBuilder: (context, i) {
                    final h = _health[i];
                    return ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: Text('${h.type} — ${h.date}'),
                      subtitle: Text(h.description),
                      onLongPress: () async {
                        await DatabaseHelper.instance.deleteHealthRecord(h.id!);
                        _load();
                      },
                    );
                  },
                ),
          _breeding.isEmpty
              ? Center(child: Text(l.noBreedingRecordsYet))
              : ListView.builder(
                  itemCount: _breeding.length,
                  itemBuilder: (context, i) {
                    final b = _breeding[i];
                    return ListTile(
                      leading: const Icon(Icons.favorite),
                      title: Text('${b.eventType} — ${b.date}'),
                      subtitle: Text(b.outcome ?? ''),
                      onLongPress: () async {
                        await DatabaseHelper.instance.deleteBreedingRecord(b.id!);
                        _load();
                      },
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _tabController.index == 0 ? _addHealthRecord() : _addBreedingRecord(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
