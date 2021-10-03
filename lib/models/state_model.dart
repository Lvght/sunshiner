import 'package:geolocator/geolocator.dart';

class StateModel {
  String? country;
  String? state;
  Position? position;

  String? removeDiacritics(String? str) {
    if (str == null) return str;
    String withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    String withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str!.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  void setUserLocale({Position? position, String? state, String? country}) {
    this.country = removeDiacritics(country);
    this.state = removeDiacritics(state);
    this.position = position;
  }

  // Info sobre a lozalização do usuário.
  // List<GeneralDailyPandemicInformation> currentLocaleInformation;

  // /// Info. sobre outros países (apenas mortes)
  // List<GlobalDeathInformationCell> globalDeathInformation;

  // // Info. sobre outros países (número de vacinados)
}
