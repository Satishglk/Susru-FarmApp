import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../l10n/app_localizations.dart';
import '../services/voice_command_service.dart';

/// Shows a modal bottom sheet that listens for a voice command in the
/// current UI language and resolves with the matched [VoiceCommand], or
/// null if the sheet was dismissed without a recognized command.
Future<VoiceCommand?> showVoiceCommandSheet(BuildContext context) {
  return showModalBottomSheet<VoiceCommand>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const VoiceCommandSheet(),
  );
}

class VoiceCommandSheet extends StatefulWidget {
  const VoiceCommandSheet({super.key});

  @override
  State<VoiceCommandSheet> createState() => _VoiceCommandSheetState();
}

class _VoiceCommandSheetState extends State<VoiceCommandSheet> {
  final VoiceCommandService _service = VoiceCommandService();
  String _recognized = '';
  bool _listening = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      setState(() => _error = 'micPermissionNeeded');
      return;
    }
    final available = await _service.init();
    if (!available) {
      setState(() => _error = 'speechNotAvailable');
      return;
    }
    if (!mounted) return;
    final localeCode = context.read<AppState>().locale.languageCode;
    setState(() => _listening = true);
    await _service.listen(
      uiLocaleCode: localeCode,
      onResult: (text, isFinal) {
        setState(() => _recognized = text);
        if (isFinal) {
          final command = VoiceCommandLocales.match(text, localeCode);
          setState(() => _listening = false);
          Future.delayed(const Duration(milliseconds: 400), () {
            if (mounted) Navigator.of(context).pop(command);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _service.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _listening ? Icons.mic : Icons.mic_none,
              size: 64,
              color: _listening ? Colors.red : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              _error != null
                  ? (_error == 'micPermissionNeeded'
                      ? l.micPermissionNeeded
                      : l.speechNotAvailable)
                  : (_listening ? l.listening : l.tapMicToSpeak),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (_recognized.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('"$_recognized"',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.close),
            ),
          ],
        ),
      ),
    );
  }
}
