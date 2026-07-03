import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../l10n/app_localizations.dart';
import '../models/animal.dart';
import '../models/emission_log.dart';
import '../services/database_helper.dart';
import '../services/emission_calculator.dart';

class CarbonFootprintScreen extends StatefulWidget {
  const CarbonFootprintScreen({super.key});

  @override
  State<CarbonFootprintScreen> createState() => _CarbonFootprintScreenState();
}

class _CarbonFootprintScreenState extends State<CarbonFootprintScreen> {
  final _formKey = GlobalKey<FormState>();
  String _species = kAnimalSpecies.first;
  String _manureMethod = kManureMethods.first;
  final _countCtrl = TextEditingController(text: '10');
  final _dieselCtrl = TextEditingController(text: '0');
  final _electricityCtrl = TextEditingController(text: '0');

  EmissionBreakdown? _result;
  List<EmissionLog> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final logs = await DatabaseHelper.instance.getEmissionLogs();
    setState(() => _history = logs);
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;
    final electricityFactor = context.read<AppState>().electricityFactor;
    final breakdown = EmissionCalculator.calculate(
      species: _species,
      count: int.parse(_countCtrl.text),
      manureMethod: _manureMethod,
      dieselLitres: double.tryParse(_dieselCtrl.text) ?? 0,
      electricityKwh: double.tryParse(_electricityCtrl.text) ?? 0,
      electricityFactorOverride: electricityFactor,
    );
    setState(() => _result = breakdown);
    await DatabaseHelper.instance.insertEmissionLog(EmissionLog(
      date: DateTime.now().toIso8601String().split('T').first,
      species: _species,
      count: int.parse(_countCtrl.text),
      manureMethod: _manureMethod,
      dieselLitres: double.tryParse(_dieselCtrl.text) ?? 0,
      electricityKwh: double.tryParse(_electricityCtrl.text) ?? 0,
      calculatedCo2eKg: breakdown.totalCo2e,
    ));
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.carbonFootprintCalculator)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                  controller: _countCtrl,
                  decoration: InputDecoration(labelText: l.animalCount),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (int.tryParse(v ?? '') == null) ? l.animalCount : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _manureMethod,
                  decoration: InputDecoration(labelText: l.manureMethod),
                  items: kManureMethods
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => _manureMethod = v!),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _dieselCtrl,
                  decoration: InputDecoration(labelText: l.dieselLitres),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _electricityCtrl,
                  decoration: InputDecoration(labelText: l.electricityKwh),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate),
                  label: Text(l.calculate),
                ),
              ],
            ),
          ),
          if (_result != null) ...[
            const SizedBox(height: 24),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.totalCo2e,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                        '${_result!.totalCo2e.toStringAsFixed(1)} ${l.kgPerYear}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.green.shade800)),
                    const Divider(),
                    _breakdownRow(l.entericFermentation, _result!.entericCo2e),
                    _breakdownRow(l.manureManagement, _result!.manureCo2e),
                    _breakdownRow(l.dieselUsage, _result!.dieselCo2e),
                    _breakdownRow(l.electricityUsage, _result!.electricityCo2e),
                  ],
                ),
              ),
            ),
          ],
          if (_history.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(l.recentCalculations,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._history.take(5).map((h) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.eco),
                    title: Text('${h.species} × ${h.count} — ${h.date}'),
                    trailing: Text('${h.calculatedCo2eKg.toStringAsFixed(0)} kg'),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _breakdownRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${value.toStringAsFixed(1)} kg'),
        ],
      ),
    );
  }
}
