import 'package:speech_to_text/speech_to_text.dart' as stt;

enum VoiceCommand { home, animals, carbon, emergency, settings, callVet, unknown }

/// Maps a UI locale code to the BCP-47 locale id speech_to_text/Android
/// SpeechRecognizer expects, and holds the keyword phrases used to match a
/// recognized utterance to an in-app action. Matching is done by simple
/// substring search rather than an NLU model, so it only needs the offline
/// Android speech recognizer (no internet, no bundled ML model).
class VoiceCommandLocales {
  static const Map<String, String> speechLocaleId = {
    'en': 'en_IN',
    'hi': 'hi_IN',
    'te': 'te_IN',
  };

  static const Map<String, Map<VoiceCommand, List<String>>> phrases = {
    'en': {
      VoiceCommand.home: ['home', 'go home', 'dashboard'],
      VoiceCommand.animals: ['animals', 'show animals', 'my animals'],
      VoiceCommand.carbon: [
        'carbon',
        'carbon footprint',
        'carbon report',
        'emissions'
      ],
      VoiceCommand.emergency: ['emergency', 'emergency contacts'],
      VoiceCommand.settings: ['settings'],
      VoiceCommand.callVet: ['call vet', 'call the vet', 'phone vet'],
    },
    'hi': {
      VoiceCommand.home: ['होम', 'घर'],
      VoiceCommand.animals: ['पशु', 'जानवर'],
      VoiceCommand.carbon: ['कार्बन', 'उत्सर्जन'],
      VoiceCommand.emergency: ['आपातकालीन', 'इमरजेंसी'],
      VoiceCommand.settings: ['सेटिंग'],
      VoiceCommand.callVet: [
        'डॉक्टर को कॉल',
        'पशु चिकित्सक को कॉल',
        'वेट को कॉल'
      ],
    },
    'te': {
      VoiceCommand.home: ['హోమ్', 'ఇల్లు'],
      VoiceCommand.animals: ['జంతువులు', 'పశువులు'],
      VoiceCommand.carbon: ['కార్బన్', 'ఉద్గారాలు'],
      VoiceCommand.emergency: ['అత్యవసర', 'ఎమర్జెన్సీ'],
      VoiceCommand.settings: ['సెట్టింగ్'],
      VoiceCommand.callVet: ['వైద్యుడికి కాల్', 'డాక్టర్ కి కాల్'],
    },
  };

  static VoiceCommand match(String recognizedText, String uiLocaleCode) {
    final text = recognizedText.trim().toLowerCase();
    if (text.isEmpty) return VoiceCommand.unknown;
    final localePhrases = phrases[uiLocaleCode] ?? phrases['en']!;
    for (final entry in localePhrases.entries) {
      for (final phrase in entry.value) {
        if (text.contains(phrase.toLowerCase())) return entry.key;
      }
    }
    return VoiceCommand.unknown;
  }
}

class VoiceCommandService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;

  Future<bool> init() async {
    _available = await _speech.initialize();
    return _available;
  }

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;

  Future<void> listen({
    required String uiLocaleCode,
    required void Function(String recognizedWords, bool isFinal) onResult,
  }) async {
    if (!_available) return;
    final localeId = VoiceCommandLocales.speechLocaleId[uiLocaleCode] ?? 'en_IN';
    await _speech.listen(
      // Forces on-device recognition so voice commands work with no network,
      // matching the app's offline requirement. Without this, both Android
      // and iOS may silently fall back to server-based recognition whenever
      // a network is reachable.
      listenOptions: stt.SpeechListenOptions(localeId: localeId, onDevice: true),
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  Future<void> stop() => _speech.stop();
}
