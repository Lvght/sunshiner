import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:sunshiner/models/daily_province_data_model.dart';
import 'package:sunshiner/models/province_data_model.dart';

Future<ProvinceDataModel> getDataFromLocation(DateTime initialDate,
    DateTime endDate, String? country, String? province) async {
  Duration duration = endDate.difference(initialDate);
  List<DailyProvinceDataModel> dailyData = [];

  for (int i = 0; i < duration.inDays; i++) {
    DateTime currentDate = initialDate.add(Duration(days: i));
    final String? dateUrlParameter =
        "${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}-${currentDate.year}";

    Uri uri = Uri.parse(
        "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/$dateUrlParameter.csv");

    final http.Response response = await http.get(uri);

    if (response.body.isNotEmpty) {
      // Obtém dados de todos os países
      List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
        eol: '\n',
      ).convert(response.body);

      // remove o título.
      rowsAsListOfValues.removeAt(0);

      // Obtém os dados do local do usuário
      if (rowsAsListOfValues.isNotEmpty) {
        List<dynamic> localeData = [];

        try {
          List<List<dynamic>> filter = rowsAsListOfValues
              .where((List<dynamic> element) =>
                  element.length >= 4 &&
                  element[3] == country &&
                  element[2] == province)
              .toList();

          localeData = filter.isNotEmpty ? filter.first : [];
        } on Exception catch (e) {
          localeData = [];
        }

        if (localeData.isEmpty) {
          localeData =
              rowsAsListOfValues.firstWhere((element) => element[3] == country);
        } else {
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
