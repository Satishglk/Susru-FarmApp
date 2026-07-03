import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/emergency_contact.dart';
import '../services/database_helper.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<EmergencyContact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final contacts = await DatabaseHelper.instance.getContacts();
    setState(() => _contacts = contacts);
  }

  Future<void> _addContact() async {
    final l = AppLocalizations.of(context)!;
    final roleCtrl = ValueNotifier(kContactRoles.first);
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.addContact),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<String>(
              valueListenable: roleCtrl,
              builder: (_, value, _) => DropdownButtonFormField<String>(
                initialValue: value,
                decoration: InputDecoration(labelText: l.role),
                items: kContactRoles
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => roleCtrl.value = v!,
              ),
            ),
            TextField(
                controller: nameCtrl, decoration: InputDecoration(labelText: l.name)),
            TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(labelText: l.phoneNumber),
                keyboardType: TextInputType.phone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
                return;
              }
              await DatabaseHelper.instance.insertContact(EmergencyContact(
                role: roleCtrl.value,
                name: nameCtrl.text.trim(),
                phoneNumber: phoneCtrl.text.trim(),
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

  IconData _iconForRole(String role) {
    switch (role) {
      case 'Veterinarian':
        return Icons.medical_services;
      case 'Ambulance':
        return Icons.local_hospital;
      case 'Extension Officer':
        return Icons.support_agent;
      default:
        return Icons.contact_phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.emergencyContacts)),
      body: _contacts.isEmpty
          ? Center(child: Text(l.noContactsYet))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, i) {
                final c = _contacts[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(_iconForRole(c.role))),
                    title: Text(c.name),
                    subtitle: Text('${c.role} · ${c.phoneNumber}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () =>
                          launchUrl(Uri(scheme: 'tel', path: c.phoneNumber)),
                    ),
                    onLongPress: () async {
                      await DatabaseHelper.instance.deleteContact(c.id!);
                      _load();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}
