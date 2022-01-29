import 'package:Decon/Models/Models.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LinearGraphProvider extends ChangeNotifier{
  List<ChartSeries<LinearData, int>> seriesLinearData;
  int noOfDays;
  bool showNoDatafound = false;
  reinitialize(){
   showNoDatafound = false;
   seriesLinearData = [];
   noOfDays = 0;
   notifyListeners();
  }

  linearChangeGraph(List<ChartSeries<LinearData, int>> _seriesLinearData, int _noOfDays, bool _showNoDatafoundMsg){
   seriesLinearData = _seriesLinearData;
   noOfDays = _noOfDays;
   showNoDatafound = _showNoDatafoundMsg;
   notifyListeners();
  }

}
class TempGraphProvider extends ChangeNotifier{
  List<ChartSeries<TempData, int>> seriesTempData;
  int noOfDays;
  bool showNoDatafound = false;
  
  reinitialize(){
   showNoDatafound = false; 
   seriesTempData = [];
   noOfDays = 0;
   notifyListeners();
  }

  tempChangeGraph(List<ChartSeries<TempData, int>> _seriesTempData, int _noOfDays, bool _showNoDatafoundMsg){
   seriesTempData = _seriesTempData;
   noOfDays = _noOfDays;
   showNoDatafound = _showNoDatafoundMsg;
   notifyListeners();
  }

}
class OpenManholeGraphProvider extends ChangeNotifier{
  List<ChartSeries<ManHoleData, int>> seriesManHoleData;
  int noOfDays;
  bool showNoDatafound = false;
  
  reinitialize(){
   showNoDatafound = false;
   seriesManHoleData = [];
   noOfDays = 0;
   notifyListeners();
  }

  openManholeChangeGraph(List<ChartSeries<ManHoleData, int>> _seriesManHoleData, int _noOfDays , bool _showNoDatafoundMsg){
    seriesManHoleData = _seriesManHoleData;
    noOfDays = _noOfDays;
    showNoDatafound = _showNoDatafoundMsg;
    notifyListeners();
  }

}