import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/animal.dart';
import '../models/emergency_contact.dart';
import '../models/health_record.dart';
import '../services/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Animal> _animals = [];
  List<HealthRecord> _upcoming = [];
  EmergencyContact? _primaryContact;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final animals = await DatabaseHelper.instance.getAnimals();
    final health = await DatabaseHelper.instance.getHealthRecords();
    final contacts = await DatabaseHelper.instance.getContacts();
    final today = DateTime.now();
    final upcoming = health.where((h) {
      if (h.nextDueDate == null) return false;
      final due = DateTime.tryParse(h.nextDueDate!);
      return due != null && due.isAfter(today.subtract(const Duration(days: 1)));
    }).toList();
    setState(() {
      _animals = animals;
      _upcoming = upcoming;
      _primaryContact = contacts.isNotEmpty
          ? contacts.firstWhere((c) => c.role == 'Veterinarian',
              orElse: () => contacts.first)
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.appTitle)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.pets,
                    label: l.totalAnimals,
                    value: '${_animals.length}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.event_available,
                    label: l.upcomingHealthTasks,
                    value: '${_upcoming.length}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: const Icon(Icons.emergency, color: Colors.red, size: 36),
                title: Text(l.emergencyCall,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_primaryContact != null
                    ? '${_primaryContact!.name} (${_primaryContact!.role})'
                    : '-'),
                trailing: const Icon(Icons.call, color: Colors.red),
                onTap: _primaryContact == null
                    ? null
                    : () => launchUrl(
                        Uri(scheme: 'tel', path: _primaryContact!.phoneNumber)),
              ),
            ),
            const SizedBox(height: 16),
            if (_upcoming.isNotEmpty) ...[
              Text(l.upcomingHealthTasks,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._upcoming.map((h) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.medical_services),
                      title: Text(h.type),
                      subtitle: Text('${l.nextDueDate}: ${h.nextDueDate}'),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
