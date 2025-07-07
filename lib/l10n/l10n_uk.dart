// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Карта Настрою';

  @override
  String get selectMood => 'Обери свій настрій';

  @override
  String get saveMood => 'Зберегти настрій';

  @override
  String get moodSaved => 'Настрій збережено';

  @override
  String get moodHistory => 'Історія Настрою';

  @override
  String get noMoodHistory => 'Історія пуста';

  @override
  String get happy => 'Радісний';

  @override
  String get sad => 'Сумний';

  @override
  String get neutral => 'Нейтральний';
}
