import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:sunshiner/helpers/csvgetter.dart';
import 'package:sunshiner/models/state_model.dart';
import 'package:sunshiner/models/daily_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunshiner/helpers/geohelper.dart';

class LocalDataDisplay extends StatefulWidget {
  const LocalDataDisplay({Key? key}) : super(key: key);

  @override
  _LocalDataDisplayState createState() => _LocalDataDisplayState();
}

class _LocalDataDisplayState extends State<LocalDataDisplay> {
  final List<Color> gradientColors = [
    const Color(0xffff4a4a),
    const Color(0xffff5b5b),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Solicita a localização assincronamente.

    return FutureBuilder<DailyModel?>(
        //todo
        future: _getDisplayInfo(context),
        builder: (BuildContext context, AsyncSnapshot<DailyModel?> snapshot) {
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
                        spots: _getSpots(snapshot.data),
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
                        belowBarData: BarAreaData(show: true, colors: [
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(1)!,
                          ColorTween(
                                  begin: gradientColors[0],
                                  end: gradientColors[1])
                              .lerp(1)!,
                        ]),
                      )
                    ])),
              );
          }
        });
  }

  List<FlSpot> _getSpots(DailyModel? data) {
    if (data == null) return [];
    List<FlSpot> results = [];
    int total = 0;
    data.deaths.forEach((key, value) {
      List<String> list = key.split("/");
      if (list[1] == "1") {
        DateTime date = DateTime.parse(
            // convertendo M/D/YY para YYYY-MM-DD
            "20${list[2]}-${list[0].padLeft(2, '0')}-${list[1].padLeft(2, '0')}");
        results.add(FlSpot(date.millisecondsSinceEpoch.toDouble(),
            (value - total).toDouble()));
        total = value;
      }
    });

    return results;
  }
}

Future<DailyModel?> _getDisplayInfo(BuildContext context) async {
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

  return getCountryInfo(userLocationCountry);
}

// LineChartData _getChartData(List<VaccinationModel> data) => LineChartData(
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: SideTitles(showTitles: false),
//         topTitles: SideTitles(showTitles: false),
//         bottomTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           getTitles: (double i) => 'Title${i}',
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           interval: 1,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//           ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 1:
//                 return '10k';
//               case 3:
//                 return '30k';
//               case 5:
//                 return '50k';
//             }
//             return '';
//           },
//           reservedSize: 32,
//           margin: 12,
//         ),
//       ),
//     );

  // Future<void> _requireUserLocale()

//   Future<DailyModel?> _getDailyModelForCurrentPosition() async =>
//       await getInfoFromLocality(await getPosition());
// }
