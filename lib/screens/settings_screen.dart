import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final appState = context.watch<AppState>();
    final electricityCtrl = TextEditingController(
        text: appState.electricityFactor.toStringAsFixed(2));

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'en', label: Text('English')),
              ButtonSegment(value: 'hi', label: Text('हिंदी')),
              ButtonSegment(value: 'te', label: Text('తెలుగు')),
            ],
            selected: {appState.locale.languageCode},
            onSelectionChanged: (selection) {
              context.read<AppState>().setLocale(Locale(selection.first));
            },
          ),
          const SizedBox(height: 24),
          Text(l.electricityFactor, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: electricityCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onSubmitted: (v) {
              final value = double.tryParse(v);
              if (value != null) {
                context.read<AppState>().setElectricityFactor(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
