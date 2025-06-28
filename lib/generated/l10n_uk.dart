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
  String get chooseMood => 'Виберіть ваш настрій:';

  @override
  String get happy => 'Щасливий';

  @override
  String get sad => 'Сумний';

  @override
  String get angry => 'Злий';

  @override
  String get changeLanguage => 'Змінити мову';

  @override
  String get moodSaved => 'Настрій збережено';

  @override
  String get moodHistory => 'Історія Настрою';
}
