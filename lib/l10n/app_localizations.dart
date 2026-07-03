import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Susru — Farm Caretaker'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @animals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animals;

  /// No description provided for @healthRecords.
  ///
  /// In en, this message translates to:
  /// **'Health Records'**
  String get healthRecords;

  /// No description provided for @breedingRecords.
  ///
  /// In en, this message translates to:
  /// **'Breeding Records'**
  String get breedingRecords;

  /// No description provided for @carbonFootprint.
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint'**
  String get carbonFootprint;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @totalAnimals.
  ///
  /// In en, this message translates to:
  /// **'Total Animals'**
  String get totalAnimals;

  /// No description provided for @upcomingHealthTasks.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Health Tasks'**
  String get upcomingHealthTasks;

  /// No description provided for @emergencyCall.
  ///
  /// In en, this message translates to:
  /// **'Emergency Call'**
  String get emergencyCall;

  /// No description provided for @addAnimal.
  ///
  /// In en, this message translates to:
  /// **'Add Animal'**
  String get addAnimal;

  /// No description provided for @editAnimal.
  ///
  /// In en, this message translates to:
  /// **'Edit Animal'**
  String get editAnimal;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @sex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sex;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @noAnimalsYet.
  ///
  /// In en, this message translates to:
  /// **'No animals yet. Tap + to add one.'**
  String get noAnimalsYet;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @vetName.
  ///
  /// In en, this message translates to:
  /// **'Vet Name'**
  String get vetName;

  /// No description provided for @nextDueDate.
  ///
  /// In en, this message translates to:
  /// **'Next Due Date'**
  String get nextDueDate;

  /// No description provided for @addHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Health Record'**
  String get addHealthRecord;

  /// No description provided for @noHealthRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No health records yet.'**
  String get noHealthRecordsYet;

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get eventType;

  /// No description provided for @sireInfo.
  ///
  /// In en, this message translates to:
  /// **'Sire Info'**
  String get sireInfo;

  /// No description provided for @outcome.
  ///
  /// In en, this message translates to:
  /// **'Outcome'**
  String get outcome;

  /// No description provided for @expectedDueDate.
  ///
  /// In en, this message translates to:
  /// **'Expected Due Date'**
  String get expectedDueDate;

  /// No description provided for @addBreedingRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Breeding Record'**
  String get addBreedingRecord;

  /// No description provided for @noBreedingRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No breeding records yet.'**
  String get noBreedingRecordsYet;

  /// No description provided for @carbonFootprintCalculator.
  ///
  /// In en, this message translates to:
  /// **'Carbon Footprint Calculator'**
  String get carbonFootprintCalculator;

  /// No description provided for @animalCount.
  ///
  /// In en, this message translates to:
  /// **'Number of Animals'**
  String get animalCount;

  /// No description provided for @manureMethod.
  ///
  /// In en, this message translates to:
  /// **'Manure Handling Method'**
  String get manureMethod;

  /// No description provided for @dieselLitres.
  ///
  /// In en, this message translates to:
  /// **'Diesel Used (litres)'**
  String get dieselLitres;

  /// No description provided for @electricityKwh.
  ///
  /// In en, this message translates to:
  /// **'Electricity Used (kWh)'**
  String get electricityKwh;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @totalCo2e.
  ///
  /// In en, this message translates to:
  /// **'Total CO2e'**
  String get totalCo2e;

  /// No description provided for @entericFermentation.
  ///
  /// In en, this message translates to:
  /// **'Enteric Fermentation'**
  String get entericFermentation;

  /// No description provided for @manureManagement.
  ///
  /// In en, this message translates to:
  /// **'Manure Management'**
  String get manureManagement;

  /// No description provided for @dieselUsage.
  ///
  /// In en, this message translates to:
  /// **'Diesel Usage'**
  String get dieselUsage;

  /// No description provided for @electricityUsage.
  ///
  /// In en, this message translates to:
  /// **'Electricity Usage'**
  String get electricityUsage;

  /// No description provided for @kgPerYear.
  ///
  /// In en, this message translates to:
  /// **'kg CO2e / year'**
  String get kgPerYear;

  /// No description provided for @recentCalculations.
  ///
  /// In en, this message translates to:
  /// **'Recent Calculations'**
  String get recentCalculations;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @noContactsYet.
  ///
  /// In en, this message translates to:
  /// **'No emergency contacts yet.'**
  String get noContactsYet;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @electricityFactor.
  ///
  /// In en, this message translates to:
  /// **'Electricity Emission Factor (kg CO2/kWh)'**
  String get electricityFactor;

  /// No description provided for @voiceCommand.
  ///
  /// In en, this message translates to:
  /// **'Voice Command'**
  String get voiceCommand;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get listening;

  /// No description provided for @tapMicToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic and speak a command'**
  String get tapMicToSpeak;

  /// No description provided for @commandNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'Command not recognized. Try again.'**
  String get commandNotRecognized;

  /// No description provided for @micPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is needed for voice commands.'**
  String get micPermissionNeeded;

  /// No description provided for @speechNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device.'**
  String get speechNotAvailable;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
