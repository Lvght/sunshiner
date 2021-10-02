//Province/State,Country/Region,Lat,Long

class DailyModel {
  final String country;
  final String state;
  final double? latitude;
  final double? longitude;
  final Map<String, int> deaths;

  // Construtor.s
  DailyModel(
      {required this.country,
      required this.state,
      required this.latitude,
      required this.longitude,
      required this.deaths});

  factory DailyModel.fromMap(List header, List props) {
    String state = props[0];
    String country = props[1];
    double? latitude = props[2] is double ? props[2] : null;
    double? longitude = props[3] is double ? props[3] : null;

    Map<String, int> deaths = {};

    for (var i = 4; i < header.length; i++) {
      deaths[header[i]] = props[i];
    }

    return DailyModel(
        state: state,
        country: country,
        latitude: latitude,
        longitude: longitude,
        deaths: deaths);
  }
}
