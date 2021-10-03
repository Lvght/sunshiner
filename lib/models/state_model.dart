import 'package:geolocator/geolocator.dart';

class StateModel {
  String? country;
  String? state;
  Position? position;

  void setUserLocale({Position? position, String? state, String? country}) {
    this.country = country;
    this.state = state;
    this.position = position;
  }

  // Info sobre a lozalização do usuário.
  // List<GeneralDailyPandemicInformation> currentLocaleInformation;

  // /// Info. sobre outros países (apenas mortes)
  // List<GlobalDeathInformationCell> globalDeathInformation;

  // // Info. sobre outros países (número de vacinados)
}
