import 'package:Decon/View_Android/Authentication/EnterOtp.dart';
import 'package:Decon/View_Android/DrawerFragments/3_Statistics/levelGraph.dart';
import 'package:Decon/View_Android/DrawerFragments/3_Statistics/TemperatureGraph.dart';
import 'package:Decon/View_Android/DrawerFragments/3_Statistics/ManholeGraph.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:Decon/Controller/Utils/sizeConfig.dart';

class Graphs extends StatefulWidget {
  final DeviceData deviceData;
  final String sheetURL;
  Graphs({@required this.deviceData, @required this.sheetURL});
  @override
  _GraphsState createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  List<ChartSeries<LinearData, int>> _seriesLinearData;
  List<ChartSeries<TempData, int>> _seriesTempData;
  List<ChartSeries<ManHoleData, int>> _seriesManHoleData;
  String currentMM, currentYY;
  String monthNo;
  String url;
  String _itemSelected, yearSelected;
  List<LinearData> data1 = [];
  List<TempData> data2 = [];
  List<ManHoleData> data3 = [];
  Map<String, String> _monthstonum = {
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
  Map<int, String> _numtomonths = {
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
  List<String> list = [
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
  List<String> listyear = [
    "2019",
    "2020",
    "2021",
    "2022",
  ];
  Map<String, int> _dataMap = {
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
  final Map<int, String> levels = {
    0: "Ground level",
    1: "Normal Level",
    2: "Infromative Level",
    3: "Critical Level"
  };
  final Map<int, Color> _levelsColor = {
    0: Color(0xffC4C4C4),
    1: Color(0xff69D66D),
    2: Color(0xffE1E357),
    3: Color(0xffD93D3D)
  };
  int i;

  Future<List<FeedbackForm>> getFeedbackList(String _url) async {
    return await http.get(_url).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => FeedbackForm.fromJson(json)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    var _date = DateTime.now();
    int mm = _date.month;
    int yy = _date.year;
    monthNo = mm.toString().length == 1 ? "0$mm" : "$mm";
    currentMM = _numtomonths[mm];
    _itemSelected = currentMM;
    currentYY = yy.toString();
    yearSelected = currentYY;
    print("SheetUrl====================${widget.sheetURL}");
    _createLevelGraphDatapoints();
  }

  _createLevelGraphDatapoints() {
    String searchKey = "$monthNo/$currentYY";
    String url1 =
        "https://script.google.com/macros/s/AKfycbxhhXD1omW3H-nZcJUvfPZje2BdMGgvdTwc2X4x89F0Sh3O_egA/exec?searchKey=$searchKey&deviceNo=${widget.deviceData.id.split("_")[2].substring(1, 2)}&sheetURL=${widget.sheetURL}&sheetNo=Sheet1";
    _seriesLinearData = [];
    _seriesTempData = [];
    _seriesManHoleData = [];

    getFeedbackList(url1).then((value) {
      int i = 1, ground = 0, normal = 0, informative = 0, critical = 0;
      data1.clear();
      for (i = 1; i <= _dataMap[monthNo]; i++) {
        ground = 0;
        normal = 0;
        informative = 0;
        critical = 0;
        value.forEach((element) {
          String date = i.toString().length == 1 ? "0$i" : "$i";
          if (element.date.contains("$date/$monthNo/$currentYY\n")) {
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
          data1.add(LinearData(i, 0));
        } else {
          if (critical >= normal &&
              critical >= informative &&
              critical >= ground) {
            data1.add(LinearData(i, 3));
          } else if (informative >= normal &&
              informative >= ground &&
              informative >= critical) {
            data1.add(LinearData(i, 2));
          } else if (normal >= informative &&
              normal >= ground &&
              normal >= critical) {
            data1.add(LinearData(i, 1));
          } else {
            data1.add(LinearData(i, 0));
          }
        }
      }
      _seriesLinearData.add(LineSeries(
        dataSource: data1,
        isVisibleInLegend: false,
        animationDuration: 1000,
        xAxisName: "Days",
        yAxisName: "Levels",
        color: Color(0xff990099),
        enableTooltip: true,
        xValueMapper: (LinearData data, _) => data.yearval,
        yValueMapper: (LinearData data, _) => data.salesval,
        name: "",
        markerSettings: MarkerSettings(
            isVisible: true,
            width: 3.0,
            shape: DataMarkerType.circle,
            height: 3.0),
      ));
      _createTempGraphDatapoints();
    });
  }

  _createTempGraphDatapoints() {
    String searchKey = "$monthNo/$currentYY";
    String url2 =
        "https://script.google.com/macros/s/AKfycbxhhXD1omW3H-nZcJUvfPZje2BdMGgvdTwc2X4x89F0Sh3O_egA/exec?searchKey=$searchKey&deviceNo=${widget.deviceData.id.split("_")[2].substring(1, 2)}&sheetURL=${widget.sheetURL}&sheetNo=Sheet2";

    getFeedbackList(url2).then((value) {
      int i = 1;
      data2.clear();
      for (i = 1; i <= _dataMap[monthNo]; i++) {
        value.forEach((element) {
          print(element.date);
          String date = i.toString().length == 1 ? "0$i" : "$i";
          if (element.date.contains("$date/$monthNo/$currentYY\n")) {
            data2.add(TempData(i, double.parse(element.value)));
          } else {
            if (data2.length >= 1)
              data2.add(TempData(i, data2[data2.length - 1].temp));
            else {
              data2.add(TempData(i, 0.0));
            }
          }
        });
      }
      _seriesTempData.add(LineSeries(
        dataSource: data2,
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
      _createOpenGraphDatapoints();
    });
  }

  _createOpenGraphDatapoints() {
    String searchKey = "$monthNo/$currentYY";
    String url3 =
        "https://script.google.com/macros/s/AKfycbxhhXD1omW3H-nZcJUvfPZje2BdMGgvdTwc2X4x89F0Sh3O_egA/exec?searchKey=$searchKey&deviceNo=${widget.deviceData.id.split("_")[2].substring(1, 2)}&sheetURL=${widget.sheetURL}&sheetNo=Sheet3";

    getFeedbackList(url3).then((value) {
      int i = 1, open = 0, close = 0;
      data3.clear();
      for (i = 1; i <= _dataMap[monthNo]; i++) {
        open = 0;
        close = 0;
        value.forEach((element) {
          String date = i.toString().length == 1 ? "0$i" : "$i";
          if (element.date.contains("$date/$monthNo/$currentYY\n")) {
            if (element.value == "0") {
              open++;
            } else if (element.value == "1") {
              close++;
            }
          }
        });

        if (open == 0 && close == 0) {
          data3.add(ManHoleData(i, 0));
        } else {
          if (close >= open) {
            data3.add(ManHoleData(i, 1));
          } else {
            data3.add(ManHoleData(i, 0));
          }
        }
      }
      _seriesManHoleData.add(StepLineSeries(
        dataSource: data3,
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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text("Graph")),
      body: ListView(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${widget.deviceData.id.split("_")[2].replaceAll("D", "Device ")}",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 15 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Last Updated : 28/nov/2019",
                          style: TextStyle(color: Color(0xff5C6266)),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.b * 1,
                                vertical: SizeConfig.v * 0.6),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.b * 2),
                                color: Color(0xff0099FF)),
                            child: Text(widget.deviceData.id,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.b * 3.57))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 15 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          CircleAvatar(
                              radius: SizeConfig.b * 1.781,
                              backgroundColor:
                                  _levelsColor[widget.deviceData.wlevel]),
                          SizedBox(width: SizeConfig.b * 0.5),
                          Text("${levels[widget.deviceData.wlevel]}",
                              style: TextStyle(fontSize: SizeConfig.b * 3.57))
                        ]),
                        Row(children: [
                          Icon(Icons.arrow_upward, size: SizeConfig.b * 4),
                          SizedBox(width: SizeConfig.b * 0.5),
                          Text("${widget.deviceData.openManhole}m")
                        ]),
                        Row(children: [
                          Icon(Icons.battery_charging_full,
                              color: Colors.green, size: SizeConfig.b * 4),
                          SizedBox(width: SizeConfig.b * 0.5),
                          Text("${widget.deviceData.battery}%")
                        ]),
                        Row(children: [
                          Icon(
                            Icons.thermostat_rounded,
                            size: SizeConfig.b * 4,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: SizeConfig.b * 0.5),
                          Text("${widget.deviceData.temperature}\u2103")
                        ]),
                        Row(children: [
                          Icon(Icons.signal_cellular_alt_rounded,
                              size: SizeConfig.b * 4),
                          SizedBox(width: SizeConfig.b * 0.5),
                          Text('3')
                        ]),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.v * 1.5),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        SizeConfig.b * 4, 0, SizeConfig.b * 4, 0),
                    child: Text(
                      widget.deviceData.address,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: SizeConfig.b * 4,
                        color: Color(0xff0099FF),
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * 15 / 360),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.b * 30,
                  height: SizeConfig.v * 10,
                  child: DropdownButton<String>(
                    dropdownColor: Color(0xff263238),
                    underline: SizedBox(
                      height: 0.0,
                    ),
                    elevation: 8,
                    items: list.map((dropDownStringitem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringitem,
                        child: Container(
                          width: SizeConfig.v * 60,
                          height: SizeConfig.b * 11,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight * 8 / 640),
                          ),
                          child: Center(
                            child: Text(
                              dropDownStringitem,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValueSelected) {
                      setState(() {
                        _itemSelected = newValueSelected;
                        monthNo = _monthstonum[_itemSelected].toString();
                        print(monthNo);
                        _createLevelGraphDatapoints();
                      });
                    },
                    isExpanded: true,
                    hint: Text("Select Month"),
                    value: _itemSelected ?? null,
                  ),
                ),
                Container(
                  width: SizeConfig.b * 30,
                  height: SizeConfig.v * 10,
                  child: DropdownButton<String>(
                    dropdownColor: Color(0xff263238),
                    underline: SizedBox(
                      height: 0.0,
                    ),
                    elevation: 8,
                    items: listyear.map((dropDownStringitem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringitem,
                        child: Container(
                          width: SizeConfig.v * 60,
                          height: SizeConfig.b * 11,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenHeight * 8 / 640),
                          ),
                          child: Center(
                            child: Text(
                              dropDownStringitem,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValueSelected) {
                      setState(() {
                        yearSelected = newValueSelected;
                        currentYY = yearSelected.toString();
                        print(currentYY);
                        _createLevelGraphDatapoints();
                      });
                    },
                    isExpanded: true,
                    hint: Text("Select Year"),
                    value: yearSelected ?? null,
                  ),
                ),
              ],
            ),
          ),
          LevelGraph(
            seriesLinearData: _seriesLinearData,
            lastDay: double.parse(_dataMap[monthNo].toString()),
          ),
          SizedBox(
            height: 20.0,
          ),
          TempGraph(
              seriesTempData: _seriesTempData,
              lastDay: double.parse(_dataMap[monthNo].toString())),
          SizedBox(
            height: 20.0,
          ),
          ManholeGraph(
              seriesManHoleData: _seriesManHoleData,
              lastDay: double.parse(_dataMap[monthNo].toString()))
        ],
      ),
    );
  }
}

class LinearData {
  int yearval;
  int salesval;
  LinearData(this.yearval, this.salesval);
}

class TempData {
  int yearval;
  double temp;
  TempData(this.yearval, this.temp);
}

class ManHoleData {
  int yearval;
  int condn;
  ManHoleData(this.yearval, this.condn);
}
