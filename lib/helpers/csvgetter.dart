import 'dart:math';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:sunshiner/helpers/geohelper.dart';
import 'package:sunshiner/models/deaths_data.dart';
import 'package:sunshiner/models/vaccination_data.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<List<VaccinationModel>> getVacinados() async {
  Uri url = Uri.parse(
      'https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/vaccine_data_global.csv');

  http.Response response = await http.get(url);

  List<VaccinationModel> results = [];

  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
    eol: '\n',
  ).convert(response.body);
  rowsAsListOfValues.removeAt(0);

  results.addAll(
      rowsAsListOfValues.map((e) => VaccinationModel.fromCsv(e)).toList());

  return results;
}

Future<void> getVacinadosFilter() async {
  Position position = await getPosition();

  List<Placemark> placemarks =
      await placemarkFromCoordinates(34.98072041806771, 102.91202278182696);

  String estado = placemarks[0].administrativeArea ?? "";
  String pais = placemarks[0].country ?? "";
  print(estado + ", " + pais);

  List<VaccinationModel> list = await getVacinados();
  List<VaccinationModel> filter = list.where((e) => e.country == pais).toList();
  if (list.isNotEmpty) {
    VaccinationModel closest = list
        .where((element) => element.country == pais && element.state.isEmpty)
        .toList()[0];
    double min = double.maxFinite;

    try {
      for (var e in filter) {
        if (e.state.contains(estado)) {
          closest = e;
          break;
        }
        String concat =
            (e.state.isNotEmpty) ? e.state + ", " + e.country : e.country;

        List<Location> locations = await locationFromAddress(concat);

        Location current = locations.first;
        double dist = Geolocator.distanceBetween(current.latitude,
            current.longitude, position.latitude, position.longitude);
        if (min > dist) {
          min = dist;
          closest = e;
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    print(closest);
  }
}

Future<List<DeathsModel>> getMortes() async {
  Uri url = Uri.parse(
      'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv');

  http.Response response = await http.get(url);

  List<DeathsModel> results = [];

  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
    eol: '\n',
  ).convert(response.body);
  List<dynamic> header = rowsAsListOfValues[0];
  rowsAsListOfValues.removeAt(0);

  results.addAll(
      rowsAsListOfValues.map((e) => DeathsModel.fromMap(header, e)).toList());

  print('aaaa');
  return results;
}

Future<List<DeathsModel>> getNaoMortes() async {
  Uri url = Uri.parse(
      'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv');

  http.Response response = await http.get(url);

  List<DeathsModel> results = [];

  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
    eol: '\n',
  ).convert(response.body);
  List<dynamic> header = rowsAsListOfValues[0];
  rowsAsListOfValues.removeAt(0);

  results.addAll(
      rowsAsListOfValues.map((e) => DeathsModel.fromMap(header, e)).toList());

  print('aaaa');
  return results;
}
