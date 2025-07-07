// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'MoodMap';

  @override
  String get selectMood => 'Оберіть настрій';

  @override
  String get saveMood => 'Зберегти настрій';

  @override
  String get moodSaved => 'Настрій збережено';

  @override
  String get moodHistory => 'Історія настрою';

  @override
  String get noMoodHistory => 'Історії немає';

  @override
  String get happy => '😊 Щасливий';

  @override
  String get sad => '😢 Сумний';

  @override
  String get angry => '😠 Злий';

  @override
  String get calm => '😌 Спокійний';
}
