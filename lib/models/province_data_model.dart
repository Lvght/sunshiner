import 'package:sunshiner/models/daily_province_data_model.dart';

class ProvinceDataModel {
  List<DailyProvinceDataModel> data;
  final String? country;
  final String? province;
  final DateTime initialPeriod;
  final DateTime endPeriod;

  ProvinceDataModel({
    required this.data,
    required this.country,
    required this.province,
    required this.initialPeriod,
    required this.endPeriod,
  });
}
