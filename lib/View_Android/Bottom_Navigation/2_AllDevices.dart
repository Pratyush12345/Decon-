import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/View_Android/DrawerFragments/3_Statistics/Graphs.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';

import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllDevices extends StatefulWidget {
  final BuildContext menuScreenContext;
  //final List<DeviceData> allDeviceData;
  final String sheetURL;
  AllDevices({Key key, this.menuScreenContext, this.sheetURL})
      : super(key: key);

  @override
  _AllDevicesState createState() => _AllDevicesState();
}

const gc = Colors.black;
const tc = Color(0xff263238);

class _AllDevicesState extends State<AllDevices> {
  List<DeviceData> _filteredDeviceData = [];

  final _searchText = TextEditingController();
  final list = [
    "None",
    "Ground Level",
    "Normal Level",
    "Informative Level",
    "Critical Level",
    "Open Manholes",
    "High Temperature",
    "Insufficient Battery"
  ];
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Consumer<ChangeCity>(
        builder: (context, changeList, child) {
          _filteredDeviceData = [];
          changeList.allDeviceData.forEach((element) {
            _filteredDeviceData.add(element);
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.v * 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                      width: SizeConfig.b * 63.61,
                      height: SizeConfig.screenHeight * 30 / 640,
                      child: TextField(
                        onChanged: (value) {
                          _filteredDeviceData.clear();
                          changeList.allDeviceData.forEach((element) {
                            _filteredDeviceData.add(element);
                          });
                          setState(() {
                            _filteredDeviceData.removeWhere((element) {
                              if (!element.address
                                  .toLowerCase()
                                  .contains(value.trim().toLowerCase())) {
                                if (!element.id
                                    .toLowerCase()
                                    .contains(value.trim().toLowerCase()))
                                  return true;
                                else
                                  return false;
                              }
                              return false;
                            });
                          });
                        },
                        controller: _searchText,
                        style: TextStyle(fontSize: SizeConfig.b * 4.3),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 22.0,
                          ),
                          isDense: true,
                          hintText: 'Search by Device/ ID/ location',
                          hintStyle: TextStyle(fontSize: SizeConfig.b * 3.2),
                          filled: true,
                          fillColor: Color(0xfff6f6f6),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(60.0)),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(60.0)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(SizeConfig.b * 7.7),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: SizeConfig.b * 3.0,
                        right: SizeConfig.b * 3.0,
                      ),
                      height: SizeConfig.screenHeight * 30 / 640,
                      width: SizeConfig.b * 28,
                      decoration: BoxDecoration(
                        color: Color(0xff263238),
                        borderRadius: BorderRadius.circular(SizeConfig.b * 7.7),
                      ),
                      child: DropdownButton<String>(
                        style: TextStyle(color: Colors.white),
                        icon: Icon(
                          Icons.filter_list_rounded,
                          color: Colors.white,
                          size: SizeConfig.screenHeight * 18 / 640,
                        ),
                        isExpanded: true,
                        dropdownColor: Color(0xff263238),
                        underline: SizedBox(height: 0.0),
                        elevation: 8,
                        items: list.map((dropDownStringitem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringitem,
                            child: Container(
                              padding: EdgeInsets.only(left: 4),
                              height: SizeConfig.screenHeight * 30 / 640,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 222, 224, 224)
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dropDownStringitem,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: SizeConfig.b * 3.2),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValueSelected) {
                          setState(() {
                            __itemSelected = newValueSelected;
                            _filteredDeviceData.clear();
                            for (var i = 0;
                                i < changeList.allDeviceData.length;
                                i++) {
                              if (__itemSelected == "None") {
                                _filteredDeviceData
                                    .add(changeList.allDeviceData[i]);
                              } else if (__itemSelected == "Ground Level") {
                                if (changeList.allDeviceData[i].wlevel == 0) {
                                  _filteredDeviceData
                                      .add(changeList.allDeviceData[i]);
                                }
                              } else if (__itemSelected == "Normal Level") {
                                if (changeList.allDeviceData[i].wlevel == 1) {
                                  _filteredDeviceData
                                      .add(changeList.allDeviceData[i]);
                                }
                              } else if (__itemSelected ==
                                  "Informative Level") {
                                if (changeList.allDeviceData[i].wlevel == 2) {
                                  _filteredDeviceData
                                      .add(changeList.allDeviceData[i]);
                                }
                              } else if (__itemSelected == "Critical Level") {
                                if (changeList.allDeviceData[i].wlevel == 3) {
                                  _filteredDeviceData
                                      .add(changeList.allDeviceData[i]);
                                }
                              } else if (__itemSelected == "Open Manholes") {
                                if (changeList.allDeviceData[i].wlevel == 0) {
                                  _filteredDeviceData
                                      .add(changeList.allDeviceData[i]);
                                }
                              } else if (__itemSelected == "High Temperature") {
                                if (changeList.allDeviceData[i].wlevel == 0) {
                                  _filteredDeviceData
                                      .add(changeList.allDeviceData[i]);
                                }
                              } else if (__itemSelected ==
                                  "Insufficient Battery") {
                                if (changeList.allDeviceData[i].battery <= 80) {
                                  _filteredDeviceData
                                      .add(changeList.allDeviceData[i]);
                                }
                              }
                            }
                          });
                        },
                        hint: Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: SizeConfig.b * 3.2,
                            color: Colors.white,
                          ),
                        ),
                        value: __itemSelected ?? null,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.v * 1),
              Divider(color: Color(0xffCACACA), thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _filteredDeviceData.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Graphs(
                                    deviceData: _filteredDeviceData[index],
                                    sheetURL: widget.sheetURL,
                                  )));
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(
                                        SizeConfig.b * 3.6,
                                        SizeConfig.v * 0.8,
                                        SizeConfig.b * 2.6,
                                        SizeConfig.v * 0.8),
                                    width: SizeConfig.b * 72,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${_filteredDeviceData[index].id.split("_")[2].replaceAll("D", "Device ")}",
                                              style: TextStyle(
                                                  fontSize: SizeConfig.b * 5.09,
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: SizeConfig.v * 1),
                                          Row(children: [
                                            CircleAvatar(
                                                radius: SizeConfig.b * 1.781,
                                                backgroundColor: _levelsColor[
                                                    _filteredDeviceData[index]
                                                        .wlevel]),
                                            SizedBox(width: SizeConfig.b * 2),
                                            Text(
                                                "${levels[_filteredDeviceData[index].wlevel]}",
                                                style: TextStyle(
                                                    fontSize:
                                                        SizeConfig.b * 3.57))
                                          ]),
                                          SizedBox(height: SizeConfig.v * 1),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  SizeConfig.b * 5.6, 0, 0, 0),
                                              child: Text(
                                                  _filteredDeviceData[index]
                                                      .address,
                                                  style: TextStyle(
                                                      fontSize:
                                                          SizeConfig.b * 3.054,
                                                      color:
                                                          Color(0xff0099FF)))),
                                        ])),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.b * 1,
                                              vertical: SizeConfig.v * 0.6),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig.b * 2),
                                              color: Color(0xff0099FF)),
                                          child: Text(
                                              _filteredDeviceData[index].id,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      SizeConfig.b * 3.57))),
                                      SizedBox(height: SizeConfig.v * 0.5),
                                      Row(children: [
                                        Icon(Icons.arrow_upward,
                                            size: SizeConfig.b * 4),
                                        SizedBox(width: SizeConfig.b * 1),
                                        Text(
                                            "${_filteredDeviceData[index].openManhole}m")
                                      ]),
                                      SizedBox(height: SizeConfig.v * 0.5),
                                      Row(children: [
                                        Icon(Icons.battery_charging_full,
                                            color: Colors.green,
                                            size: SizeConfig.b * 4),
                                        SizedBox(width: SizeConfig.b * 1),
                                        Text(
                                            "${_filteredDeviceData[index].battery}%")
                                      ]),
                                      SizedBox(height: SizeConfig.v * 0.5),
                                      Row(
                                        children: [
                                          Icon(Icons.thermostat_rounded,
                                              color: Colors.redAccent,
                                              size: SizeConfig.b * 4),
                                          SizedBox(width: SizeConfig.b * 1),
                                          Text(
                                              "${_filteredDeviceData[index].temperature}\u2103")
                                        ],
                                      ),
                                      SizedBox(height: SizeConfig.v * 0.5),
                                      Row(
                                        children: [
                                          Icon(
                                              Icons.signal_cellular_alt_rounded,
                                              color: Colors.grey,
                                              size: SizeConfig.b * 4),
                                          SizedBox(width: SizeConfig.b * 1),
                                          Text('2')
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: SizeConfig.v * 1),
                            Divider(color: Color(0xffCACACA), thickness: 1),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
