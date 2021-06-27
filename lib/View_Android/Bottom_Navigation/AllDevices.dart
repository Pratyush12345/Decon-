import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/View_Android/Dialogs/Filter_dialogbox.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/Graphs.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';

import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class AllDevices extends StatefulWidget {

  @override
  _AllDevicesState createState() => _AllDevicesState();
}


class _AllDevicesState extends State<AllDevices> {
  List<DeviceData> _listDeviceData = [];
  bool isdeviceSearched= false;
  String __itemSelected;
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
  
  @override
  void initState() {
    super.initState();
  }
  _filterDevices(List<DeviceData> allDeviceData) {
                    isdeviceSearched = true;
                    setState(() {
                      _listDeviceData.clear();
                      for (var i = 0; i < allDeviceData.length; i++) {
                        if (__itemSelected == "None") {
                          isdeviceSearched = false;
                          _listDeviceData.add(allDeviceData[i]);
                        } else if (__itemSelected == "Ground Level") {
                          if (allDeviceData[i].wlevel == 0) {
                            _listDeviceData.add(allDeviceData[i]);
                          }
                        } else if (__itemSelected == "Normal Level") {
                          if (allDeviceData[i].wlevel == 1) {
                            _listDeviceData.add(allDeviceData[i]);
                          }
                        } else if (__itemSelected == "Informative Level") {
                          if (allDeviceData[i].wlevel == 2) {
                            _listDeviceData.add(allDeviceData[i]);
                          }
                        } else if (__itemSelected == "Critical Level") {
                          if (allDeviceData[i].wlevel == 3) {
                            _listDeviceData.add(allDeviceData[i]);
                          }
                        } else if (__itemSelected == "Open Manholes") {
                          if (allDeviceData[i].wlevel == 0) {
                            _listDeviceData.add(allDeviceData[i]);
                          }
                        } else if (__itemSelected == "High Temperature") {
                          if (allDeviceData[i].wlevel == 0) {
                            _listDeviceData.add(allDeviceData[i]);
                          }
                        } else if (__itemSelected == "Insufficient Battery") {
                          if (allDeviceData[i].battery <= 80) {
                            _listDeviceData.add(allDeviceData[i]);
                          }
                        }
                      }
                    });
                  }
   Future showFilterDialog(BuildContext context, List<DeviceData> _allList) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,    
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return FilterDialogDevice(selected: __itemSelected);
        }).then((value) { 
          if(value!=null){
          __itemSelected = value;
          _filterDevices( _allList);
          }
          });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: b * 20),          
      child: Consumer<ChangeDeviceData>(
          builder: (context, changeList, child){
            if(!isdeviceSearched)
            _listDeviceData = List.from(changeList.allDeviceData);
    
        return changeList.allDeviceData == null?AppConstant.circulerProgressIndicator():
        changeList.allDeviceData.isEmpty?AppConstant.noDataFound():
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.v * 3),
          Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.center,
                      width: b * 340,
                      decoration: BoxDecoration(
                        border: Border.all(color: dc, width: 0.5),
                        color: Color(0xffffffff),
                        borderRadius: BorderRadius.circular(b * 60),
                      ),
                      child: TextField(
                         onChanged: (val){
                            if(val.isNotEmpty){
                            _listDeviceData = changeList.allDeviceData.where((element) => element.id.toLowerCase().contains(val.toLowerCase()) || element.address.toLowerCase().contains(val.toLowerCase()) ).toList();
                            isdeviceSearched = true;
                            }else{
                              isdeviceSearched = false;
                            _listDeviceData = changeList.allDeviceData;
                            }
                            setState(() {});
                          },
                  
                        style: TextStyle(fontSize: b * 14, color: dc),
                        decoration: InputDecoration(
                          prefixIcon: InkWell(
                            child: Icon(Icons.search, color: Colors.black),
                            onTap: null,
                          ),
                          isDense: true,
                          isCollapsed: true,
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 40, maxHeight: 24),
                          hintText: 'Search by Device Id/ Location',
                          hintStyle: TextStyle(
                            fontSize: b * 14,
                            color: Color(0xff858585),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: h * 12, horizontal: b * 13),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        showFilterDialog(context,changeList.allDeviceData);
                      },
                      child: Container(
                        height: h * 45,
                        padding: EdgeInsets.symmetric(horizontal: b * 18),
                        width: b * 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: blc, width: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'images/filter.svg',
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
          
          SizedBox(height: SizeConfig.v * 1),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listDeviceData.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return 
                    InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Graphs(
                                  scriptEditorURL: HomePageVM.instance.getScriptEditorURL,
                                  deviceData: _listDeviceData[index],
                                  sheetURL: HomePageVM.instance.getSheetURL,
                                )));
      },
      child: Container(
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
              "${_listDeviceData[index].id.split("_")[2].replaceAll("D", "Device ")}",
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
                'ID : ${_listDeviceData[index].id}',
                style: txtS(Colors.white, 12, FontWeight.w400),
              ),
                ),
                Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: b * 6),
                  height: h * 12,
                  width: b * 12,
                  decoration: BoxDecoration(
                    color: _levelsColor[_listDeviceData[index].wlevel],
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  levels[_listDeviceData[index].wlevel],
                  style: txtS(_levelsColor[_listDeviceData[index].id], 12, FontWeight.w400),
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
                "${_listDeviceData[index].distance??""}m",
                style: txtS(blc, 14, FontWeight.w400),
              ),
                ]),
                Row(children: [
              Icon(Icons.battery_charging_full, size: b * 16, color: blc),
              Text(
                "${_listDeviceData[index].battery??""}%",
                style: txtS(blc, 14, FontWeight.w400),
              ),
                ]),
                if(HomePageVM.instance.getSeriesCode == "S1")
                Row(children: [
              Icon(Icons.thermostat_sharp, size: b * 16, color: blc),
              Text(
                "${_listDeviceData[index].temperature??""}\u2103",
                style: txtS(blc, 14, FontWeight.w400),
              ),
                ]),
                Row(children: [
              Icon(Icons.arrow_upward, size: b * 16, color: blc),
              Text(
                "${_listDeviceData[index].openManhole??""}",
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
                "${_listDeviceData[index].signalStrength??""}",
                style: txtS(blc, 14, FontWeight.w400),
              ),
                ]),
              ],
            ),
            sh(23),
            Text(
              "${_listDeviceData[index].address??""}",
              style: txtS(dc, 12, FontWeight.w400),
            ),
          ],
        ),
      ),
    );                        
                  })),
        ],
      );
  },
    ),
    );
  }
}
