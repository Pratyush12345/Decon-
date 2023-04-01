import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/graphs_provider.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/levelGraph.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:Decon/Models/Models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphsVM {
  static GraphsVM intsance = GraphsVM._();
  GraphsVM._();
  BuildContext context;
  List<ChartSeries<LinearData, int>> _seriesLinearData;
  List<ChartSeries<TempData, int>> _seriesTempData;
  List<ChartSeries<ManHoleData, int>> _seriesManHoleData;
  String currentMM, currentYY;
  String _monthNo;
  String monthSelected, yearSelected, _sheetURL, _scriptEditorURL;
  List<LinearData> _data1 ;
  List<TempData> _data2 ;
  List<ManHoleData> _data3 ;
  DeviceData _deviceData;
  List<DataFromSheet> _levelData = [];
  List<DataFromSheet> _manHoleData = [];
  List<DataFromSheet> _temperatureData = [];
  int i; var result;

  final Map<String, String> _monthstonum = {
    "January": "01",
    "February": "02",
    "March": "03",
    "April": "04",
    "May": "05",
    "June": "06",
    "July": "07",
    "August": "08",
    "September": "09",
    "October": "10",
    "November": "11",
    "December": "12"
  };
  final Map<int, String> _numtomonths = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };
  final List<String> monthslist = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  // final List<String> yearlist = [
  //   "2019",
  //   "2020",
  //   "2021",
  //   "2022",
  //   "2023",
  //   "2024",
  //   "2025",
  // ];
  final List<String> yearlist = [
    "${(DateTime.now().year-1)}",
    "${DateTime.now().year}",
  ];
  final Map<String, int> _endDateMap = {
    "01": 31,
    "02": 28,
    "03": 31,
    "04": 30,
    "05": 31,
    "06": 30,
    "07": 31,
    "08": 31,
    "09": 30,
    "10": 31,
    "11": 30,
    "12": 31,
  };
  

  initfields(){
    _data1 = [];
    _data2 = [];
    _data3 = [];
    _seriesLinearData = [];
    _seriesTempData = [];
    _seriesManHoleData = [];
  }

  _loadGraphs(){
    Provider.of<LinearGraphProvider>(context, listen: false).reinitialize();
    Provider.of<TempGraphProvider>(context, listen: false).reinitialize();
    Provider.of<OpenManholeGraphProvider>(context, listen: false).reinitialize();
    _callFunctions();
    initfields();
  }

  _callFunctions() async{
    String searchKey = "$_monthNo/$currentYY";
    // print("device id---------${_deviceData.id.split("_")[2].substring(1, _deviceData.id.split("_")[2].length)}");
    // print("sheet url----------${_sheetURL}");
    // print("search key--------${searchKey}");
    // print("secrip teditot url--------${_scriptEditorURL}");
    String url1 = "$_scriptEditorURL?searchKey=$searchKey&deviceNo=${_deviceData.id.split("_")[2].substring(1, _deviceData.id.split("_")[2].length)}&sheetURL=$_sheetURL&sheetNo=DataSheet";
    print("url1111111-------$url1");
   result = await getDataFromSheetList(url1);
   print("--------------------------");
   print(result);
   print("--------------------------");
   if(GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].graphs.contains("${HomePageVM.instance.getSeriesCode}_LevelGraph"))
    _createLevelGraphDatapoints();
   if(GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].graphs.contains("${HomePageVM.instance.getSeriesCode}_TemperatureGraph"))
    _createTempGraphDatapoints();
   if(GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].graphs.contains("${HomePageVM.instance.getSeriesCode}_ManholeGraph"))
    _createOpenGraphDatapoints();
  }
  onChangeYear(String selectedYear){
  GraphsVM.intsance.yearSelected = selectedYear;
  currentYY = GraphsVM.intsance.yearSelected.toString();
  _loadGraphs();                
  }

  onChangeMonth(String selectedMonth){
  GraphsVM.intsance.monthSelected = selectedMonth;
  _monthNo = _monthstonum[monthSelected].toString();
  _loadGraphs();
  }

  init(BuildContext _context,String sheetURL, String scriptEditorURL, DeviceData deviceData){
    initfields();
    DateTime _date = DateTime.now();
    int mm = _date.month;
    int yy = _date.year;
    _monthNo = mm.toString().length == 1 ? "0$mm" : "$mm";
    currentMM = _numtomonths[mm];
    monthSelected = currentMM;
    currentYY = yy.toString();
    yearSelected = currentYY;
    _sheetURL = sheetURL;
    _scriptEditorURL = scriptEditorURL;
    _deviceData = deviceData;
    context = _context;
    print("SheetUrl====================$_sheetURL");
    print("SheetUrl====================$_scriptEditorURL");
    _loadGraphs();
 
  }

  getDataFromSheetList(String _url) async {
    return await http.get(Uri.parse(_url)).then((response) {
      print("responsed .body========% ${response.body.length}");
      if(response.body.length<=2){
        print("in ifffffffffffff");
       return null;
      }
      else{
      var jsonFeedback = convert.jsonDecode(response.body) as List; 
      if(HomePageVM.instance.getSeriesCode == "S0"|| HomePageVM.instance.getSeriesCode == "S1"){
      _levelData = jsonFeedback.map((json) => DataFromSheet.fromLevelJson(json)).toList();
      _manHoleData = jsonFeedback.map((json) => DataFromSheet.fromOpenManholeJson(json)).toList();
      }
      if(HomePageVM.instance.getSeriesCode == "S1")
      _temperatureData = jsonFeedback.map((json) => DataFromSheet.fromTempJson(json)).toList();
      return "data found";
      }
    });
  }

  String formattedDate(String date){
    String formattedDate;
    DateTime dateTime = DateTime.parse(date);
    print(dateTime.hour);
    print(dateTime.minute);
    formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}  ${DateFormat('jms').format(dateTime)}";
    return formattedDate;
  }

  _createLevelGraphDatapoints() {
      int i = 1, ground = 0, normal = 0, informative = 0, critical = 0;
      _data1.clear();
      for (i = 1; i <= _endDateMap[_monthNo]; i++) {
        ground = 0;
        normal = 0;
        informative = 0;
        critical = 0;
        _levelData.forEach((element) {
          String date = i.toString().length == 1 ? "0$i" : "$i";
          if (element.date.contains("$date/$_monthNo/$currentYY\n")) {
            if (element.value == "0") {
              ground++;
            } else if (element.value == "1") {
              normal++;
            } else if (element.value == "2") {
              informative++;
            } else if (element.value == "3") {
              critical++;
            }
          }
        });

        if (ground == 0 && normal == 0 && informative == 0 && critical == 0) {
          _data1.add(LinearData(i, 0));
        } else {
          if (critical >= normal &&
              critical >= informative &&
              critical >= ground) {
            _data1.add(LinearData(i, 3));
          } else if (informative >= normal &&
              informative >= ground &&
              informative >= critical) {
            _data1.add(LinearData(i, 2));
          } else if (normal >= informative &&
              normal >= ground &&
              normal >= critical) {
            _data1.add(LinearData(i, 1));
          } else {
            _data1.add(LinearData(i, 0));
          }
        }
      }
      _seriesLinearData.add(LineSeries(
        dataSource: _data1,
        isVisibleInLegend: false,
        animationDuration: 1000,
        xAxisName: "Days",
        yAxisName: "Levels",
        color: Color(0xff990099),
        enableTooltip: true,
        xValueMapper: (LinearData data, _) => data.yearval,
        yValueMapper: (LinearData data, _) => data.levelval,
        name: "",
        markerSettings: MarkerSettings(
            isVisible: true,
            width: 3.0,
            shape: DataMarkerType.circle,
            height: 3.0),
      ));

      Provider.of<LinearGraphProvider>(context, listen: false).linearChangeGraph(_seriesLinearData, _endDateMap[_monthNo], result == null? true: false);
    
    
  }

  _createTempGraphDatapoints() {
    
      int i = 1;
      _data2.clear();
      for (i = 1; i <= _endDateMap[_monthNo]; i++) {
        _temperatureData.forEach((element) {
          print(element.date);
          String date = i.toString().length == 1 ? "0$i" : "$i";
          if (element.date.contains("$date/$_monthNo/$currentYY\n")) {
            _data2.add(TempData(i, double.parse(element.value)));
          } else {
            if (_data2.length >= 1)
              _data2.add(TempData(i, _data2[_data2.length - 1].temp));
            else {
              _data2.add(TempData(i, 0.0));
            }
          }
        });
      }
      _seriesTempData.add(LineSeries(
        dataSource: _data2,
        isVisibleInLegend: false,
        animationDuration: 1000,
        xAxisName: "Days",
        yAxisName: "Temperature",
        color: Color(0xff990099),
        enableTooltip: true,
        xValueMapper: (TempData data, _) => data.yearval,
        yValueMapper: (TempData data, _) => data.temp,
        name: "",
        markerSettings: MarkerSettings(
            isVisible: true,
            width: 3.0,
            shape: DataMarkerType.circle,
            height: 3.0),
      ));
      Provider.of<TempGraphProvider>(context, listen: false).tempChangeGraph(_seriesTempData, _endDateMap[_monthNo], result == null? true: false);
    
  }

  _createOpenGraphDatapoints() {
    
      int i = 1, open = 0, close = 0;
      _data3.clear();
      for (i = 1; i <= _endDateMap[_monthNo]; i++) {
        open = 0;
        close = 0;
        _manHoleData.forEach((element) {
          String date = i.toString().length == 1 ? "0$i" : "$i";
          if (element.date.contains("$date/$_monthNo/$currentYY\n")) {
            if (element.value == "0") {
              open++;
            } else if (element.value == "1") {
              close++;
            }
          }
        });

        if (open == 0 && close == 0) {
          _data3.add(ManHoleData(i, 0));
        } else {
          if (close >= open) {
            _data3.add(ManHoleData(i, 1));
          } else {
            _data3.add(ManHoleData(i, 0));
          }
        }
      }
      _seriesManHoleData.add(StepLineSeries(
        dataSource: _data3,
        isVisibleInLegend: false,
        animationDuration: 1000,
        xAxisName: "Days",
        yAxisName: "ManHole Condn",
        color: Color(0xff990099),
        enableTooltip: true,
        xValueMapper: (ManHoleData data, _) => data.yearval,
        yValueMapper: (ManHoleData data, _) => data.condn,
        name: "",
        markerSettings: MarkerSettings(
            isVisible: true,
            width: 3.0,
            shape: DataMarkerType.circle,
            height: 3.0),
      ));
      Provider.of<OpenManholeGraphProvider>(context, listen: false).openManholeChangeGraph(_seriesManHoleData, _endDateMap[_monthNo], result == null? true: false);
  }
}