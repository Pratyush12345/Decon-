import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/graphs_provider.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/graphs_viewmodel.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/levelGraph.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/TemperatureGraph.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/ManholeGraph.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Decon/Models/Consts/app_constants.dart';



class Graphs extends StatefulWidget {
  final DeviceData deviceData;
  final String sheetURL;
  final String scriptEditorURL;
  Graphs({@required this.deviceData, @required this.scriptEditorURL, @required this.sheetURL});
  @override
  _GraphsState createState() => _GraphsState();
}

class _GraphsState extends State<Graphs> {
  final Map<int, String> _levels = {
    0: "Ground level",
    1: "Normal Level",
    2: "Infromative Level",
    3: "Critical Level",
    191: "Sensor 1",
    192: "Sensor 2",
    193: "Sensor 3"
  };
  final Map<int, Color> _levelsColor = {
    0: Color(0xffC4C4C4),
    1: Color(0xff69D66D),
    2: Color(0xffE1E357),
    3: Color(0xffD93D3D),
    191: Colors.white,
    192: Colors.white,
    193: Colors.white
  };

  @override
  void initState() {
    super.initState();
    GraphsVM.intsance.init(context,widget.sheetURL, widget.scriptEditorURL, widget.deviceData);
    }

  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      appBar: AppBar(elevation: 10,
        titleSpacing: -3,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: blc, size: b * 16),
        ),
        iconTheme: IconThemeData(color: blc),
        title: Text(
          "${widget.deviceData.id.split("_")[2].replaceAll("D", "Device ")}",
          style: txtS(Colors.black, 16, FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.0,0.0 , 14.0, 0.0),
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
        margin: EdgeInsets.only(bottom: h * 19),
        padding: EdgeInsets.only(
            top: h * 12, bottom: h * 20, left: b * 12, right: b * 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(b * 10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.deviceData.id.split("_")[2].replaceAll("D", "Device ")}",
                  style: txtS(dc, 18, FontWeight.w400),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: h * 2, horizontal: b * 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(b * 2),
                    color: dc,
                  ),
                  child: Text(
                    'ID : ${widget.deviceData.id}',
                    style: txtS(Colors.white, 12, FontWeight.w400),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: b * 6),
                      height: h * 12,
                      width: b * 12,
                      decoration: BoxDecoration(
                        color: _levelsColor[widget.deviceData.wlevel],
                        shape: BoxShape.circle,
                      ),
                      child: widget.deviceData.wlevel>= 191? 
                          Icon(Icons.error,
                          size: h * 14,
                          color: Colors.red,): 
                          SizedBox(),
                    ),
                    Text(
                      _levels[widget.deviceData.wlevel],
                      style: txtS(_levelsColor[widget.deviceData.id], 12, FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            sh(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(HomePageVM.instance.getSeriesCode == "S1")
                Row(children: [
                  SvgPicture.asset(
                    'images/distance.svg',
                    allowDrawingOutsideViewBox: true,
                  ),
                  SizedBox(width: b * 5),
                  Text(
                    "${widget.deviceData.distance??""}m",
                    style: txtS(blc, 14, FontWeight.w400),
                  ),
                ]),
                Row(children: [
                  Icon(Icons.battery_charging_full, size: b * 16, color: blc),
                  Text(
                    "${widget.deviceData.battery??""}%",
                    style: txtS(blc, 14, FontWeight.w400),
                  ),
                ]),
                if(HomePageVM.instance.getSeriesCode == "S1")
                Row(children: [
                  Icon(Icons.thermostat_sharp, size: b * 16, color: blc),
                  Text(
                    "${widget.deviceData.temperature??""}\u2103",
                    style: txtS(blc, 14, FontWeight.w400),
                  ),
                ]),
                Row(children: [
                  Icon(Icons.arrow_upward, size: b * 16, color: blc),
                  Text(
                    "${widget.deviceData.openManhole??""}",
                    style: txtS(blc, 14, FontWeight.w400),
                  ),
                ]),
                Row(children: [
                  SvgPicture.asset(
                    'images/signal.svg',
                    allowDrawingOutsideViewBox: true,
                  ),
                  SizedBox(width: b * 5),
                  Text(
                    "${widget.deviceData.signalStrength??""}",
                    style: txtS(blc, 14, FontWeight.w400),
                  ),
                ]),
              ],
            ),
            sh(23),
            Text(
              "${widget.deviceData.address??""}",
              style: txtS(dc, 12, FontWeight.w400),
            ),
          ],
        ),
      ),
                      Text("Last Updated: ${GraphsVM.intsance.formattedDate(widget.deviceData.lastUpdated)}"),
                    
                  SizedBox(height: SizeConfig.v * 0.5),
                  ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: SizeConfig.b * 40,
                height: SizeConfig.v * 11,
                child: DropdownButton<String>(
                  dropdownColor: Color(0xff263238),
                  underline: SizedBox(
                    height: 0.0,
                  ),
                  elevation: 8,
                  items: GraphsVM.intsance.monthslist.map((dropDownStringitem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringitem,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth * 10 / 360,
                            top: SizeConfig.screenHeight * 9 / 640),
                        width: SizeConfig.v * 70,
                        height: SizeConfig.b * 11,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.screenHeight * 8 / 640),
                        ),
                        child: Text(
                          dropDownStringitem,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValueSelected) {
                    setState(() {
                      GraphsVM.intsance.onChangeMonth(newValueSelected);
                      });
                  },
                  isExpanded: true,
                  hint: Text("Select Month"),
                  value: GraphsVM.intsance.monthSelected ?? null,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                width: SizeConfig.b * 30,
                height: SizeConfig.v * 11,
                child: DropdownButton<String>(
                  dropdownColor: Color(0xff263238),
                  underline: SizedBox(
                    height: 0.0,
                  ),
                  elevation: 8,
                  items: GraphsVM.intsance.yearlist.map((dropDownStringitem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringitem,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth * 10 / 360,
                            top: SizeConfig.screenHeight * 9 / 640),
                        width: SizeConfig.v * 60,
                        height: SizeConfig.b * 11,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.screenHeight * 8 / 640),
                        ),
                        child: Text(
                          dropDownStringitem,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValueSelected) {
                    setState(() {
                      GraphsVM.intsance.onChangeYear(newValueSelected);
                      });
                  },
                  isExpanded: true,
                  hint: Text("Select Year"),
                  value: GraphsVM.intsance.yearSelected ?? null,
                ),
              ),
            ],
          ),
          if(GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].graphs.contains("${HomePageVM.instance.getSeriesCode}_LevelGraph"))
          Consumer<LinearGraphProvider>(
            builder: (context, model, child)=>
            LevelGraph(
              seriesLinearData: model.seriesLinearData,
              lastDay: double.parse(model.noOfDays.toString()),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          if(GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].graphs.contains("${HomePageVM.instance.getSeriesCode}_ManholeGraph"))
          Consumer<OpenManholeGraphProvider>(
            builder: (context, model, child)=>
             ManholeGraph(
                seriesManHoleData: model.seriesManHoleData,
                lastDay: double.parse(model.noOfDays.toString())),
          ),
          SizedBox(
            height: 20.0,
          ),
          if(GlobalVar.seriesMap[HomePageVM.instance.getSeriesCode].graphs.contains("${HomePageVM.instance.getSeriesCode}_TemperatureGraph"))
          Consumer<TempGraphProvider>(
            builder: (context,model ,child)=>
            TempGraph(
                seriesTempData: model.seriesTempData,
                lastDay: double.parse(model.noOfDays.toString())),
          ),
          
        ],
      ),
    );
  }
}

