import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sunshiner/helpers/csvgetter.dart';
import 'package:sunshiner/models/vaccination_model.dart';
import 'package:sunshiner/models/daily_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sunshiner/helpers/geohelper.dart';

class LocalDataDisplay extends StatefulWidget {
  LocalDataDisplay({Key? key}) : super(key: key);

  @override
  _LocalDataDisplayState createState() => _LocalDataDisplayState();
}

class _LocalDataDisplayState extends State<LocalDataDisplay> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
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
        future: getCountryInfo("Brazil"),
        builder: (BuildContext context, AsyncSnapshot<DailyModel?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return SizedBox(
                height: 300,
                child: LineChart(LineChartData(
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: SideTitles(showTitles: false),
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTextStyles: (context, value) => const TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        getTitles: (value) {
                          // print(value);
                          return 'a';
                        },
                        margin: 8,
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _getSpots(snapshot.data),
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

  List<FlSpot> _getSpots(DailyModel? data) {
    if (data == null) return [];
    List<FlSpot> results = [];
    int total = 0;
    data.deaths.forEach((key, value) {
      List<String> list = key.split("/");
      if (list[1] == "1") {
        DateTime date = DateTime.parse(
            "20${list[2]}-${list[0].padLeft(2, '0')}-${list[1].padLeft(2, '0')}");
        results.add(FlSpot(date.millisecondsSinceEpoch.toDouble(),
            (value - total).toDouble()));
        total = value;
      }
    });

    return results;
  }
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
