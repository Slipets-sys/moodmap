// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MoodMap';

  @override
  String get selectMood => 'Select your mood';

  @override
  String get saveMood => 'Save Mood';

  @override
  String get moodSaved => 'Mood saved';

  @override
  String get moodHistory => 'Mood History';

  @override
  String get noMoodHistory => 'No mood history';

  @override
  String get happy => '😊 Happy';

  @override
  String get sad => '😢 Sad';

  @override
  String get angry => '😠 Angry';

  @override
  String get calm => '😌 Calm';

  @override
  String get mapTitle => 'Emotion Map';
}
