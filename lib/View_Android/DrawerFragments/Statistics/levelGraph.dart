import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/Authentication/Wait.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LevelGraph extends StatelessWidget {
  final List<ChartSeries<LinearData, int>> seriesLinearData;
  bool showNoDatafoundflag;
  final double lastDay;
  LevelGraph({this.seriesLinearData, this.lastDay, @required this.showNoDatafoundflag});
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(right: 8.0),
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: showNoDatafoundflag?
             AppConstant.noDataFound():
             seriesLinearData.length!=0? SfCartesianChart(
              enableMultiSelection: false,

              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: "Day : Level",
              ),

              series: seriesLinearData,
              enableAxisAnimation: true,
              title: ChartTitle(text: 'Level analysis'),
              legend: Legend(isVisible: true),
              //tooltipBehavior: TooltipBehavior(enable: true),
              primaryYAxis: NumericAxis(
                interval: 1,
                maximum: 3,
                title: AxisTitle(
                  text: "Levels"
                )


              ),
              primaryXAxis: NumericAxis(
                interval: 5,
                maximum: lastDay,
                title: AxisTitle(
                  text: "Days"
                  
                )
                ),
            ):Wait()
          );

  }
}