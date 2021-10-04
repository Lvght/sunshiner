import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:sunshiner/helpers/data_helper.dart';
import 'package:sunshiner/models/daily_province_data_model.dart';
import 'package:sunshiner/models/province_data_model.dart';
import 'package:sunshiner/models/state_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sunshiner/helpers/geohelper.dart';

/// Mostra a evolução das mortes globais ao longo do tempo.

class GlobalDeathDataDisplay extends GlobalGenericDataDisplay {
  const GlobalDeathDataDisplay({Key? key}) : super(key: key);

  @override
  dynamic getAttribute(e) => e.deaths;
}

class GlobalConfirmedDataDisplay extends GlobalGenericDataDisplay {
  const GlobalConfirmedDataDisplay({Key? key}) : super(key: key);

  @override
  dynamic getAttribute(e) => e.confirmed;
}

class GlobalGenericDataDisplay extends StatefulWidget {
  dynamic getAttribute(e) => e;

  String? getState(BuildContext context) =>
      Provider.of<StateModel>(context, listen: false).state;

  String? getCountry(BuildContext context) =>
      Provider.of<StateModel>(context, listen: false).country;

  const GlobalGenericDataDisplay({Key? key})
      : super(
          key: key,
        );

  @override
  State<GlobalGenericDataDisplay> createState() =>
      _GlobalGenericDataDisplayState();
}

class _GlobalGenericDataDisplayState extends State<GlobalGenericDataDisplay> {
  final List<Color> gradientColors = [
    const Color(0xffff4a4a),
    const Color(0xffff5b5b),
  ];
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (BuildContext context) {
      return FutureBuilder(
          future: getDataFromLocation(
              DateTime.now().add(const Duration(days: -7)),
              DateTime.now(),
              widget.getCountry(context),
              widget.getState(context)),
          builder: (BuildContext context,
              AsyncSnapshot<ProvinceDataModel?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.data == null) {
                  return const Center(
                    child: Text(
                        'Você deve habilitar o acesso à sua localização para que possamos mostrar dados de seu país.'),
                  );
                }
                return SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                        bottomTitles: SideTitles(showTitles: false),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getSpots(snapshot.data, widget.getAttribute),
                          colors: [
                            ColorTween(
                                    begin: gradientColors[0],
                                    end: gradientColors[1])
                                .lerp(1)!,
                            ColorTween(
                                    begin: gradientColors[0],
                                    end: gradientColors[1])
                                .lerp(1)!,
                          ],
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            colors: [
                              ColorTween(
                                      begin: gradientColors[0],
                                      end: gradientColors[1])
                                  .lerp(1)!,
                              ColorTween(
                                      begin: gradientColors[0],
                                      end: gradientColors[1])
                                  .lerp(1)!,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
          });
    });
  } //

  List<FlSpot> _getSpots(
      ProvinceDataModel? data, Function(dynamic) getAttribute) {
    if (data == null || data.data.isEmpty) return [];
    List<FlSpot> results = [];
    List<DailyProvinceDataModel> notnullList =
        data.data.where((element) => getAttribute(element) != null).toList();
    int total = getAttribute(notnullList.first);
    data.data.forEach((value) {
      if (getAttribute(value) != null) {
        results.add(FlSpot(value.date.microsecondsSinceEpoch.toDouble(),
            (getAttribute(value)! - total).toDouble()));
        total = getAttribute(value)!;
      }
    });

    return results;
  }

  // Future<ProvinceDataModel?> _fetchData(BuildContext context) async {
  //   String? country = Provider.of<StateModel>(context, listen: false).country;
  //   String? province = Provider.of<StateModel>(context, listen: false).state;

  //   if (country == null || country.isEmpty) {}

  //   return null;
  // }

}
