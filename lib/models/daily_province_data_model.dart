class DailyProvinceDataModel {
  DateTime date;
  String? country;
  String? state;
  double? longitude;
  double? latitude;
  int? deaths;
  int? recovered;
  int? confirmed;
  String? combinedKey;
  double? caseFatalityRatio;
  int? active;

  DailyProvinceDataModel(
      {required this.date,
      required this.country,
      required this.state,
      required this.longitude,
      required this.latitude,
      required this.deaths,
      required this.recovered,
      required this.confirmed,
      required this.combinedKey,
      required this.caseFatalityRatio,
      required this.active});

  factory DailyProvinceDataModel.fromCsv(List<dynamic> csvData, DateTime date) {
    final String? state = csvData[2];
    final String? country = csvData[3];
    final double? latitude = csvData[5] is String ? null : csvData[5];
    final double? longitude = csvData[6] is String ? null : csvData[6];
    final int? confirmed = csvData[7] is String ? null : csvData[7];
    final int? deaths = csvData[8] is String ? null : csvData[8];
    final int? recovered = csvData[9] is String ? null : csvData[9];
    final int? active = csvData[10] is String ? null : csvData[10];
    final String? combinedKey = csvData[11];
    final double? fatality = csvData[13] is String ? null : csvData[13];

    return DailyProvinceDataModel(
        date: date,
        country: country,
        state: state,
        longitude: longitude,
        latitude: latitude,
        deaths: deaths,
        recovered: recovered,
        confirmed: confirmed,
        combinedKey: combinedKey,
        caseFatalityRatio: fatality,
        active: active);
  }
}
