import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:flutter/material.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:provider/provider.dart';

class BottomLayoutS0 extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return BottomLayoutState();
  }
}

class BottomLayoutState extends State<BottomLayoutS0>
    with SingleTickerProviderStateMixin {
  Animation groundAnimation,
      normalAnimation,
      informativeAnimation,
      criticalAnimation;
  AnimationController animationController;
  bool details = false, _animate = false, _isStart = true;  
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<int> _count = List.filled(4, null);
  int countOpenManhole =0,
      countbattery = 0,
      countError = 0;
  @override
  void initState() {
    _isStart
        ? Future.delayed(Duration(milliseconds: 1100), () {
            setState(() {
              _animate = true;
              _isStart = false;
            });
          })
        : _animate = true;
    animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  Widget informationRow(Color col, String tit, int val) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Container(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: col,
            radius: b * 5.5,
          ),
          SizedBox(width: b * 8),
          Text(
            tit,
            style: txtS(col, 12, FontWeight.w400),
          ),
          SizedBox(width: b * 14),
          Text(
            val.toString(),
            style: txtS(col, 12, FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Container detailRow(String tit, int val) {
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xff3b4e58),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: h * 10),
      child: Row(children: [
        Text(
          tit,
          style: txtS(Colors.white, 12, FontWeight.w400),
        ),
        Spacer(),
        Text(
          val.toString(),
          style: txtS(Colors.white, 12, FontWeight.w600),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    
    return
        Consumer<ChangeDeviceData>(
          builder: (context, model, child){
          print("Length of All device is ${model.allDeviceData.length}");
          _count = countDevices(model.allDeviceData);
          countbattery = 0;
          countError = 0;
          model.allDeviceData.forEach((element) {
            if (element.battery < (GlobalVar.seriesMap["S0"].model as S0DeviceSettingModel).batterythresholdvalue) {
              countbattery++;
            } 
            if(element.wlevel > 3){
              countError++;
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

          return AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget child) {
                return Container(
      margin: EdgeInsets.symmetric(horizontal: b * 5),
      padding: EdgeInsets.symmetric(horizontal: b * 17, vertical: h * 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(b * 10),
        color: dc,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Container(
          child: Text(
            "Total Devices With",
            style: txtS(Colors.white, 16, FontWeight.w400),
          ),
        ),
        sh(18),
        Row(children: [
          Expanded(
            flex: 3,
            child: informationRow(Color(0xffc4c4c4), 'Ground Level', groundAnimation.value),
          ),
          Expanded(
            flex: 2,
            child: informationRow(Color(0xff69d66d), 'Normal Level', normalAnimation.value),
          ),
        ]),
        sh(20),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: informationRow(Color(0xfffcff50), 'Informative Level', informativeAnimation.value),
            ),
            Expanded(
              flex: 2,
              child: informationRow(Color(0xffd93d3d), 'Critical Level', criticalAnimation.value),
            ),
          ],
        ),
        sh(16),
        details
            ? AnimatedOpacity(
                duration: Duration(milliseconds: 1000),
                opacity: _animate ? 1 : 0,
                curve: Curves.easeInOutQuart,
                child: AnimatedPadding(
                  duration: Duration(milliseconds: 1000),
                  padding: _animate
                      ? EdgeInsets.all(0)
                      : const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      detailRow("Open Manholes", countOpenManhole),
                      detailRow("Insufficient Energy", countbattery),
                      detailRow("Error in Devices", countError),
                    ],
                  ),
                ),
              )
            : SizedBox(),
        MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          color: Color(0xff3b4e58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(b * 6),
          ),
          onPressed: () {
            setState(() {
              details = !details;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: h * 10),
            alignment: Alignment.center,
            child: Text(
              details ? 'Hide Details' : "Show Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: b * 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        sh(10),
      ]),
    );
              });
          }
        );
  }
}

List<int> countDevices(List<DeviceData> _allDevicedata) {
  print("Length ${_allDevicedata.length}");
  List<int> _count = List.filled(4, null);
  int _ground = 0, _normal = 0, _informative = 0, _critical = 0;
  for (var i = 0; i < _allDevicedata.length; i++) {
    if (_allDevicedata[i].wlevel == 0) {
      _ground++;
    } else if (_allDevicedata[i].wlevel == 1) {
      _normal++;
    } else if (_allDevicedata[i].wlevel == 2) {
      _informative++;
    } else if(_allDevicedata[i].wlevel == 3) {
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
