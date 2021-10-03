import 'dart:math';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:sunshiner/constants.dart';
import 'package:sunshiner/helpers/geohelper.dart';
import 'package:sunshiner/models/daily_model.dart';
import 'package:sunshiner/models/vaccination_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<List<VaccinationModel>> getVaccinationData() async {
  Uri url = Uri.parse(vaccineUrl);

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

// Position position = await getPosition();
Future<VaccinationModel?> getVaccinationDataByLocality(
    Position position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  String estado = placemarks[0].administrativeArea ?? "";
  String pais = placemarks[0].country ?? "";
  print(estado + ", " + pais);

  List<VaccinationModel> list = await getVaccinationData();
  List<VaccinationModel> filter = list.where((e) => e.country == pais).toList();
  if (list.isNotEmpty) {
    List<VaccinationModel> countryList = list
        .where((element) => (element.country == pais || element.state == pais))
        .toList();
    if (countryList.isEmpty) return null;
    VaccinationModel closest = countryList[0];
    double min = double.maxFinite;

    try {
      // FIXME caso o local seja perto do centro do pais, vai dar ruim
      for (VaccinationModel e in filter) {
        if (e.state.contains(estado)) {
          closest = e;
          break;
        }
        String address =
            (e.state.isNotEmpty) ? e.state + ", " + e.country : e.country;

        List<Location> locations = await locationFromAddress(address);

        Location current = locations.first;
        double dist = Geolocator.distanceBetween(current.latitude,
            current.longitude, position.latitude, position.longitude);

        print(dist.toString() + "  " + address);
        if (min > dist) {
          min = dist;
          closest = e;
        }
      }
    } on Exception catch (e) {
      print(e);
    }
    return closest;
  }
  return null;
}

Future<List<DailyModel>> getInfo({String url = deathUrl}) async {
  Uri uri = Uri.parse(url);

  http.Response response = await http.get(uri);

  List<DailyModel> results = [];

  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
    eol: '\n',
  ).convert(response.body);
  List<dynamic> header = rowsAsListOfValues[0];
  rowsAsListOfValues.removeAt(0);

  results.addAll(
      rowsAsListOfValues.map((e) => DailyModel.fromMap(header, e)).toList());

  return results;
}

Future<void> getInfoFromLocality(Position currentPosition,
    {String url = deathUrl}) async {
  List<DailyModel> list = await getInfo(url: url);
  double min = double.maxFinite;
  DailyModel dailyModel;

  list.forEach((e) {
    //todo fazer um break aqui
    if (e.latitude != null && e.longitude != null) {
      double dist = Geolocator.distanceBetween(currentPosition.latitude,
          currentPosition.longitude, e.latitude!, e.longitude!);
      if (dist < min) {
        dailyModel = e;
      }
    }
  });
}
