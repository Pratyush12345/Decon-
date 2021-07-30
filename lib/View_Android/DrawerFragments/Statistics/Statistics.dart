import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/View_Android/DrawerFragments/Statistics/Graphs.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';


class Stats extends StatefulWidget {
  Stats({Key key})
      : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}


class _StatsState extends State<Stats> {
  List<DeviceData> _filteredDeviceData = [];
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
     child: Consumer<ChangeDeviceData>(
          builder: (context, changeList, child){
            _filteredDeviceData = [];
            changeList.allDeviceData.forEach((element) {
            _filteredDeviceData.add(element);
            });
    
        return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.v * 3),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.b * 3, SizeConfig.v * 0.8, SizeConfig.b * 1.3, 0),
              height: SizeConfig.v * 5.5,
              width: SizeConfig.b * 86.52,
              decoration: BoxDecoration(
                color: Color(0xffDEE0E0),
                borderRadius: BorderRadius.circular(SizeConfig.b * 7.7),
              ),
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
                style: TextStyle(fontSize: SizeConfig.b * 4.3),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 30.0,
                  ),
                  isDense: true,
                  hintText: 'Search by DeviceID/ location',
                  hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                  border: InputBorder.none,
                ),
              ),
            ),
          ]),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Graphs(
                            scriptEditorURL: HomePageVM.instance.getScriptEditorURL,
                            deviceData: _filteredDeviceData[index],
                            sheetURL: HomePageVM.instance.getSheetURL,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: SizeConfig.b * 68.71,
                              padding: EdgeInsets.fromLTRB(
                                  SizeConfig.b * 5.1,
                                  SizeConfig.v * 0.72,
                                  SizeConfig.b * 5.1,
                                  SizeConfig.v * 0.72),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "${_filteredDeviceData[index].id.split("_")[2].replaceAll("D", "Device ")}",
                                            style: TextStyle(
                                                fontSize: SizeConfig.b * 5.09,
                                                fontWeight: FontWeight.w500)),
                                        Container(
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      SizeConfig.b * 1.5,
                                                  vertical: SizeConfig.v * 0.8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          SizeConfig.b * 1.53),
                                                  color: Color(0xff0099FF)),
                                              child: Text(
                                                  _filteredDeviceData[index].id,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig.b *
                                                          3.57))),
                                        ),
                                      ]),
                                  SizedBox(height: SizeConfig.v * 1),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          radius: SizeConfig.b * 1.781,
                                          backgroundColor: _levelsColor[
                                              _filteredDeviceData[index]
                                                  .wlevel]),
                                      SizedBox(width: SizeConfig.b * 2),
                                      Text(
                                          "${levels[_filteredDeviceData[index].wlevel]}",
                                          style: TextStyle(
                                              fontSize: SizeConfig.b * 3.57))
                                    ],
                                  ),
                                  SizedBox(height: SizeConfig.v * 1),
                                  Container(
                                      width: 270,
                                      child: Text(
                                          _filteredDeviceData[index].address,
                                          style: TextStyle(
                                              fontSize: SizeConfig.b * 3.563,
                                              color: Color(0xff5C6266)))),
                                  SizedBox(height: SizeConfig.v * 1.8),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: null,
                                icon: Icon(Icons.arrow_forward_ios)),
                            SizedBox(width: SizeConfig.b * 5)
                          ],
                        ),
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
