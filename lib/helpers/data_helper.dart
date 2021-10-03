import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:sunshiner/models/daily_province_data_model.dart';
import 'package:sunshiner/models/province_data_model.dart';

Future<ProvinceDataModel> getDataFromLocation(DateTime initialDate,
    DateTime endDate, String country, String province) async {
  Duration duration = endDate.difference(initialDate);
  List<DailyProvinceDataModel> dailyData = [];

  for (int i = 0; i < duration.inDays; i++) {
    DateTime currentDate = initialDate.add(Duration(days: i));
    final String? dateUrlParameter =
        "${(currentDate.month as String).padLeft(2, '0')}-${(currentDate.day as String).padLeft(2, '0')}-${currentDate.year}";

    Uri uri = Uri.parse(
        "https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/$dateUrlParameter.csv");

    final http.Response response = await http.get(uri);

    if (response.body.isNotEmpty) {
      // Obtém dados de todos os países
      List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
        eol: '\n',
      ).convert(response.body);

      // remove o título.
      rowsAsListOfValues.removeAt(0);

      // Obtém os dados do local do usuário
      List<dynamic> localeData = rowsAsListOfValues.firstWhere(
          (List<dynamic> element) =>
              element[3] == country && element[2] == province);

      if (localeData.isEmpty) {
        localeData =
            rowsAsListOfValues.firstWhere((element) => element[3] == country);

        if (localeData.isNotEmpty) {
          dailyData
              .add(DailyProvinceDataModel.fromCsv(localeData, currentDate));
        }
      }
    }
  }

  return ProvinceDataModel(
      data: dailyData,
      country: country,
      province: province,
      initialPeriod: initialDate,
      endPeriod: endDate);
}
