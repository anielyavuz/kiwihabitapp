import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class GraphicPage extends StatefulWidget {
  const GraphicPage({Key? key}) : super(key: key);

  @override
  State<GraphicPage> createState() => _GraphicPageState();
}

class _GraphicPageState extends State<GraphicPage> {
  final Color _yaziTipiRengi = Color(0xffE4EBDE);

  @override
  Widget build(BuildContext context) {
    late var _appHeaderText =
        AppLocalizations.of(context)!.appHeader.toString();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(21, 9, 35, 1),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          // Image.asset(
                          //   "assets/images/kiwiLogo.png",
                          //   height: 100,
                          //   width: 100,
                          // ),
                          Container(
                            child: Center(
                                child: Text(
                              "Analysis Page",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.philosopher(
                                  fontSize: 32, color: _yaziTipiRengi),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 7,
                          minY: 0,
                          maxY: 6,
                          // gridData: FlGridData(
                          //   show: true,
                          //   getDrawingHorizontalLine: (value) {
                          //     return FlLine(
                          //       color: Color.fromARGB(255, 15, 116, 199),
                          //       strokeWidth: 1,
                          //     );
                          //   },
                          //   drawVerticalLine: true,
                          //   getDrawingVerticalLine: (value) {
                          //     return FlLine(
                          //       color: Color.fromARGB(255, 18, 97, 162),
                          //       strokeWidth: 1,
                          //     );
                          //   },
                          // ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: Color.fromARGB(255, 239, 239, 239),
                                width: 1),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              color: _yaziTipiRengi,
                              spots: [
                                FlSpot(0, 3),
                                FlSpot(1, 2),
                                FlSpot(2, 5),
                                FlSpot(3, 2.5),
                                FlSpot(4, 4),
                                FlSpot(5, 3),
                                FlSpot(6, 4),
                                FlSpot(7, 4),
                              ],
                              isCurved: true,

                              barWidth: 2,
                              // dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Color.fromARGB(90, 54, 151, 42),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 5,
                child: Container(
                  height: 40,
                  child: IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
