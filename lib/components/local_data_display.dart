import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sunshiner/helpers/csvgetter.dart';

class LocalDataDisplay extends StatelessWidget {
  LocalDataDisplay({Key? key}) : super(key: key);
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getVaccinationData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return SizedBox(
                height: 200,
                child: LineChart(LineChartData(minY: 3, lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3.44),
                      FlSpot(2.6, 3.44),
                      FlSpot(4.9, 3.44),
                      FlSpot(6.8, 3.44),
                      FlSpot(8, 3.44),
                      FlSpot(9.5, 3.44),
                      FlSpot(11, 3.44),
                      FlSpot(20, 1000),
                    ],
                    colors: [
                      ColorTween(
                              begin: gradientColors[0], end: gradientColors[1])
                          .lerp(0.2)!,
                      ColorTween(
                              begin: gradientColors[0], end: gradientColors[1])
                          .lerp(0.2)!,
                    ],
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(show: true, colors: [
                      ColorTween(
                              begin: gradientColors[0], end: gradientColors[1])
                          .lerp(0.2)!
                          .withOpacity(0.1),
                      ColorTween(
                              begin: gradientColors[0], end: gradientColors[1])
                          .lerp(0.2)!
                          .withOpacity(0.1),
                    ]),
                  )
                ])),
              );
          }
        });
  }
}
