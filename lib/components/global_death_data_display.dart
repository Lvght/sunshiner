import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunshiner/helpers/data_helper.dart';
import 'package:sunshiner/models/province_data_model.dart';
import 'package:sunshiner/models/state_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sunshiner/helpers/geohelper.dart';

/// Mostra a evolução das mortes globais ao longo do tempo.
class GlobalDeathDataDisplay extends StatefulWidget {
  const GlobalDeathDataDisplay({Key? key}) : super(key: key);

  @override
  State<GlobalDeathDataDisplay> createState() => _GlobalDeathDataDisplayState();
}

class _GlobalDeathDataDisplayState extends State<GlobalDeathDataDisplay> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDisplayInfo(context),
        builder:
            (BuildContext context, AsyncSnapshot<ProvinceDataModel?> snapshot) {
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
                child: LineChart(LineChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: SideTitles(showTitles: false),
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(showTitles: false),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _getSpots(snapshot.data, (e) => e.deaths),
                        colors: [
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(0.2)!,
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(0.2)!,
                        ],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(show: false, colors: [
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(0.2)!
                              .withOpacity(0.1),
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(0.2)!
                              .withOpacity(0.1),
                        ]),
                      )
                    ])),
              );
          }
        });
  }

  Future<ProvinceDataModel?> _getDisplayInfo(BuildContext context) async {
    String? userLocationCountry =
        Provider.of<StateModel>(context, listen: false).country;
    String? userLocationState =
        Provider.of<StateModel>(context, listen: false).state;

    // Caso a informação aida não tenha sido carregada.
    if (userLocationCountry == null || userLocationCountry.isEmpty) {
      Position? position = await getPosition();

      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude,
            localeIdentifier: "en_US");
        userLocationCountry = placemarks[0].country ?? "";
        userLocationState = placemarks[0].administrativeArea ?? "";

        Provider.of<StateModel>(context, listen: false).setUserLocale(
            country: userLocationCountry,
            state: userLocationState,
            position: position);
      }
      // Ocorreu uma falha ao obter a localização.
      else {
        return null;
      }
    }
    ProvinceDataModel data = await getDataFromLocation(
        DateTime.now().add(const Duration(days: -7)),
        DateTime.now(),
        Provider.of<StateModel>(context, listen: false).country,
        Provider.of<StateModel>(context, listen: false).state);

    return data;
  }

  List<FlSpot> _getSpots(
      ProvinceDataModel? data, Function(dynamic) getAttribute) {
    if (data == null || data.data.isEmpty) return [];
    List<FlSpot> results = [];
    int total = getAttribute(data.data.first)!;
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
