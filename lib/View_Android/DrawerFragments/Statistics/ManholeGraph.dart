import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/Authentication/Wait.dart';
import 'package:flutter/material.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/Graphs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class ManholeGraph extends StatelessWidget {
  final List<ChartSeries<ManHoleData, int>> seriesManHoleData;
  final double lastDay;
  bool showNoDatafoundflag;
  
  ManholeGraph({this.seriesManHoleData, this.lastDay, @required this.showNoDatafoundflag});
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(right: 8.0),
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: showNoDatafoundflag?
             AppConstant.noDataFound():seriesManHoleData.length!=0? SfCartesianChart(
              enableMultiSelection: false,

              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: "Day : Condn",
              ),

              series: seriesManHoleData,
              enableAxisAnimation: true,
              title: ChartTitle(text: 'ManHole Condn analysis'),
              legend: Legend(isVisible: true),
              //tooltipBehavior: TooltipBehavior(enable: true),
              primaryYAxis: NumericAxis(
                interval: 1,
                maximum: 1,
                title: AxisTitle(
                  text: "ManHole Condn"
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