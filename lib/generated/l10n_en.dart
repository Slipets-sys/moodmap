// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MoodMap';

  @override
  String get chooseMood => 'Choose your mood:';

  @override
  String get happy => 'Happy';

  @override
  String get sad => 'Sad';

  @override
  String get angry => 'Angry';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get moodSaved => 'Mood saved';

  @override
  String get moodHistory => 'Mood History';
}
