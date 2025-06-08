import 'package:memoraisa/app/core/generated/translations.g.dart';

AppLocale getLocaleFromString(String localeString) {
  switch (localeString) {
    case "English":
      return AppLocale.en;
    case "Español":
      return AppLocale.es;
    case "Català":
      return AppLocale.ca;
    default:
      return AppLocale.en;
  }
}

String getStringFromLocale(AppLocale locale) {
  switch (locale) {
    case AppLocale.es:
      return "Español";
    case AppLocale.ca:
      return "Català";
    default:
      return "English";
  }
}
