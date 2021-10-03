
// /// Possui dados sobre: mortes, confirmados e recuperados.
// class GeneralDailyPandemicInformation {
//   // info sobre país e coordenada
// }

// class PandemicDataGetter {
//   GenericDailyPandemicInformation? _getDataFromASpecificDate(DateTime t) {
//     // faz a lógica em cima dos dados de data, que já foram buscados na construção.
//     data.filter()
//   }

// Future<void> getDay(DateTime date){
//     String url = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"
//     url += "${date.month}-${date.day}-${date.year}.csv"
//     Uri uri = Uri.parse(url);

//     http.Response response = await http.get(uri);

//     List<VaccinationModel> results = [];

//     List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
//         eol: '\n',
//     ).convert(response.body);
//     rowsAsListOfValues.removeAt(0);

//     // fazer o parsing
//     // results.addAll(
//     //     rowsAsListOfValues.map((e) => VaccinationModel.fromCsv(e)).toList());

//     return results;
        
// }
//   GenericDailyPandemicInformation? _getDataFromASpecificDateAndLocale(DateTime t, Position p) {
    
//   }

//   PandemicDataGetter(DateTime initDate, {DateTime? endDate = DateTime.now()}) {
    
//   }

//   List<GeneralDailyPandemicInformation> data;
// }
