import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';

class BottomLayout extends StatefulWidget {
  final List<DeviceData> allDeviceData;
  BottomLayout({this.allDeviceData});
  @override
  State<StatefulWidget> createState() {
    return BottomLayoutState();
  }
}

class BottomLayoutState extends State<BottomLayout>
    with SingleTickerProviderStateMixin {
  Animation groundAnimation,
      normalAnimation,
      informativeAnimation,
      criticalAnimation;
  AnimationController animationController;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<int> _count = List(4);
  int countground = 0,
      countnormal = 0,
      countinformative = 0,
      countcritical = 0,
      countbattery = 0,
      counttemp = 0;
  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    print("Length of All device is ${widget.allDeviceData.length}");
    _count = countDevices(widget.allDeviceData);
    counttemp = 0;
    countbattery = 0;
    widget.allDeviceData.forEach((element) {
      if (element.battery < Auth.instance.batteryThresholdvalue) {
        countbattery++;
      }
      if (element.temperature < Auth.instance.tempThresholdValue) {
        counttemp++;
      }
    });
    groundAnimation = IntTween(begin: 0, end: _count[0]).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    normalAnimation = IntTween(begin: 0, end: _count[1]).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    informativeAnimation = IntTween(begin: 0, end: _count[2]).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    criticalAnimation = IntTween(begin: 0, end: _count[3]).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease));

    animationController.forward();

    return
        //EasyLocalizationProvider(
        //     data: data,
        //     child:
        AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Container(
          width: SizeConfig.b * 98,
          padding:
              EdgeInsets.fromLTRB(SizeConfig.b * 2.6, 0, SizeConfig.b * 2.6, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.b * 3.81),
            color: Color(0xff263238),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.b * 1.8, vertical: SizeConfig.v * 1),
                child: Text(
                  "Total Devices With",
                  style: TextStyle(
                      fontSize: SizeConfig.b * 4.1, color: Colors.white),
                ),
              ),
              SizedBox(height: SizeConfig.v * 1.5),
              Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: SizeConfig.b * 45.8,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.b * 1.8,
                                vertical: SizeConfig.v * 1),
                            child: Row(
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Color(0xffD93D3D),
                                      radius: SizeConfig.b * 1.6),
                                  SizedBox(width: SizeConfig.b * 2),
                                  Text("Critical Level",
                                      style: TextStyle(
                                          fontSize: SizeConfig.b * 3.05,
                                          color: Colors.white)),
                                ]),
                                Spacer(),
                                Text("${criticalAnimation.value}",
                                    style: TextStyle(
                                        fontSize: SizeConfig.b * 3.05,
                                        color: Colors.white))
                              ],
                            )),
                        SizedBox(height: SizeConfig.v * 0.5),
                        Container(
                            width: SizeConfig.b * 45.8,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.b * 1.8,
                                vertical: SizeConfig.v * 1),
                            child: Row(
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Color(0xffE1E357),
                                      radius: SizeConfig.b * 1.5),
                                  SizedBox(width: SizeConfig.b * 2),
                                  Text("Informative Level",
                                      style: TextStyle(
                                          fontSize: SizeConfig.b * 3.05,
                                          color: Colors.white)),
                                ]),
                                Spacer(),
                                Text("${informativeAnimation.value}",
                                    style: TextStyle(
                                        fontSize: SizeConfig.b * 3.05,
                                        color: Colors.white))
                              ],
                            )),
                        SizedBox(height: SizeConfig.v * 0.5),
                        Container(
                            width: SizeConfig.b * 45.8,
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.b * 1.8,
                                vertical: SizeConfig.v * 1),
                            child: Row(
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Color(0xff69D66D),
                                      radius: SizeConfig.b * 1.5),
                                  SizedBox(width: SizeConfig.b * 2),
                                  Text("Normal Level",
                                      style: TextStyle(
                                          fontSize: SizeConfig.b * 3.05,
                                          color: Colors.white)),
                                ]),
                                Spacer(),
                                Text("${normalAnimation.value}",
                                    style: TextStyle(
                                        fontSize: SizeConfig.b * 3.05,
                                        color: Colors.white))
                              ],
                            )),
                        SizedBox(height: SizeConfig.v * 0.5),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.b * 1.8,
                                vertical: SizeConfig.v * 1),
                            width: SizeConfig.b * 45.8,
                            child: Row(
                              children: [
                                Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Color(0xffC4C4C4),
                                      radius: SizeConfig.b * 1.4),
                                  SizedBox(width: SizeConfig.b * 2),
                                  Text("Ground Level",
                                      style: TextStyle(
                                          fontSize: SizeConfig.b * 3.05,
                                          color: Colors.white)),
                                ]),
                                Spacer(),
                                Text("${groundAnimation.value}",
                                    style: TextStyle(
                                        fontSize: SizeConfig.b * 3.05,
                                        color: Colors.white))
                              ],
                            )),
                      ]),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.b * 1.8,
                            vertical: SizeConfig.v * 1),
                        decoration: BoxDecoration(
                          color: Color(0xff5F6265),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.b * 7.64),
                        ),
                        width: SizeConfig.b * 44,
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.b * 4),
                            Text(
                              "Open Manholes",
                              style: TextStyle(
                                  fontSize: SizeConfig.b * 3.05,
                                  color: Colors.white),
                            ),
                            Spacer(),
                            Text(
                              '5',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 2),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.v * 1.5),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.b * 1.8,
                            vertical: SizeConfig.v * 1),
                        decoration: BoxDecoration(
                          color: Color(0xff5F6265),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.b * 7.64),
                        ),
                        width: SizeConfig.b * 44,
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.b * 4),
                            Text(
                              "High Temperature",
                              style: TextStyle(
                                  fontSize: SizeConfig.b * 3.05,
                                  color: Colors.white),
                            ),
                            Spacer(),
                            Text(
                              '5',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 2),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.v * 1.5),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.b * 1.8,
                            vertical: SizeConfig.v * 1),
                        decoration: BoxDecoration(
                          color: Color(0xff5F6265),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.b * 7.64),
                        ),
                        width: SizeConfig.b * 44,
                        child: Row(
                          children: [
                            SizedBox(width: SizeConfig.b * 4),
                            Text(
                              "Insufficient Energy",
                              style: TextStyle(
                                  fontSize: SizeConfig.b * 3.05,
                                  color: Colors.white),
                            ),
                            Spacer(),
                            Text(
                              '$countbattery',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: SizeConfig.b * 2),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

List<int> countDevices(List<DeviceData> _allDevicedata) {
  print("Length ${_allDevicedata.length}");
  List<int> _count = List(4);
  int _ground = 0, _normal = 0, _informative = 0, _critical = 0;
  for (var i = 0; i < _allDevicedata.length; i++) {
    if (_allDevicedata[i].wlevel == 0) {
      _ground++;
    } else if (_allDevicedata[i].wlevel == 1) {
      _normal++;
    } else if (_allDevicedata[i].wlevel == 2) {
      _informative++;
    } else {
      _critical++;
    }
  }
  _count[0] = _ground;
  _count[1] = _normal;
  _count[2] = _informative;
  _count[3] = _critical;
  print("ground ${_count[0]}");
  print("normal ${_count[1]}");
  print("informative ${_count[2]}");
  print("critical${_count[3]}");

  return _count;
}
