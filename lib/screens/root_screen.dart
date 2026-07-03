import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/database_helper.dart';
import '../services/voice_command_service.dart';
import 'home_screen.dart';
import 'animals_screen.dart';
import 'carbon_footprint_screen.dart';
import 'emergency_contacts_screen.dart';
import 'settings_screen.dart';
import 'voice_command_sheet.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  Future<void> _onVoiceCommand(BuildContext context) async {
    final command = await showVoiceCommandSheet(context);
    if (!context.mounted || command == null) return;
    switch (command) {
      case VoiceCommand.home:
        setState(() => _index = 0);
        break;
      case VoiceCommand.animals:
        setState(() => _index = 1);
        break;
      case VoiceCommand.carbon:
        setState(() => _index = 2);
        break;
      case VoiceCommand.emergency:
        setState(() => _index = 3);
        break;
      case VoiceCommand.settings:
        setState(() => _index = 4);
        break;
      case VoiceCommand.callVet:
        final contacts = await DatabaseHelper.instance.getContacts();
        final vet = contacts.where((c) => c.role == 'Veterinarian').isNotEmpty
            ? contacts.firstWhere((c) => c.role == 'Veterinarian')
            : (contacts.isNotEmpty ? contacts.first : null);
        if (vet != null) {
          await launchUrl(Uri(scheme: 'tel', path: vet.phoneNumber));
        }
        break;
      case VoiceCommand.unknown:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.commandNotRecognized)),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final screens = [
      const HomeScreen(),
      const AnimalsScreen(),
      const CarbonFootprintScreen(),
      const EmergencyContactsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onVoiceCommand(context),
        tooltip: l.voiceCommand,
        child: const Icon(Icons.mic),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home), label: l.home),
          NavigationDestination(icon: const Icon(Icons.pets), label: l.animals),
          NavigationDestination(
              icon: const Icon(Icons.eco), label: l.carbonFootprint),
          NavigationDestination(
              icon: const Icon(Icons.emergency), label: l.emergencyContacts),
          NavigationDestination(
              icon: const Icon(Icons.settings), label: l.settings),
        ],
      ),
    );
  }
}
