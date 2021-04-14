import 'dart:async';
import 'package:provider/provider.dart';
import 'package:Decon/Controller/Providers/home_page_providers.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/DrawerFragments/5_AddDevice/AddDevice.dart';
import 'package:Decon/View_Android/DrawerFragments/6_AboutVysion.dart';
import 'package:Decon/View_Android/OverflowChat/noticeBoard.dart';
import 'package:Decon/Controller/Services/GlobalVariable.dart';
import 'package:Decon/View_Android/Bottom_Navigation/2_AllDevices.dart';
import 'package:Decon/View_Android/DrawerFragments/2_DeviceSetting/2_DeviceSetting.dart';
import 'package:Decon/View_Android/Bottom_Navigation/PeopleForAdmin.dart';
import 'package:Decon/View_Android/Bottom_Navigation/PeopleForManager.dart';
import 'package:Decon/View_Android/DrawerFragments/7_Contact.dart';
import 'package:Decon/View_Android/DrawerFragments/4_HealthReport.dart';
import 'package:Decon/View_Android/DrawerFragments/1_Home.dart';
import 'package:Decon/View_Android/DrawerFragments/3_Statistics/3_Statistics.dart';
import 'package:Decon/Controller/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Widget middleContainer;
  bool _isfromDrawer = true;
  int _selectedDrawerIndex = 0, _currentIndex = 0;
  int simStatus = 0, countbattery = 0, counttemp = 0;
  String _itemSelected;
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  _getBottomNavItem(int position) {
    switch (position) {
      case 0:
        return Home();
        break;
      case 1:
        return AllDevices(
          sheetURL: HomePageVM.instance.getSheetURL,
        );
      case 2:
        if (Auth.instance.post == "Manager")
          return People();
        else
          return PeopleForAdmin(
            fromManager: false,
            cityCode: HomePageVM.instance.getCityCode,
          );
    }
  }

  _getDrawerItemWidget(int position) {
    switch (position) {
      case 0:
        return Home();
        break;
      case 1:
        return DeviceSettings(
          cityCode: HomePageVM.instance.getCityCode,
        );
        break;
      case 2:
        return Stats(sheetURL: HomePageVM.instance.getSheetURL);
        break;
      case 3:
        return HealthReport();
        break;
      case 4:
        return AddDevice();
        break;
      case 5:
        return AboutVysion();
        break;
      case 6:
        return Contact();
        break;
      default:
        return "Error Ocurred";
    }
  }

  _onSelectedItem(int index) {
    setState(() {
      _isfromDrawer = true;
      _selectedDrawerIndex = index;
    });
    _scafoldKey.currentState.openEndDrawer();
  }

  @override
  void initState() {
    HomePageVM.instance.initialize(context);
    super.initState();
  }

  @override
  void dispose() {
    HomePageVM.instance.dispose();
    super.dispose();
  }

  Future showErrorDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text('Are You Sure?'), actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop("Yes");
              },
              elevation: 5.0,
              child: Text('YES'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop("No");
              },
              elevation: 5.0,
              child: Text('NO'),
            )
          ]);
        });
  }

  String _setTitle(int position) {
    switch (position) {
      case 0:
        return 'Home';
        break;
      case 1:
        return 'Device Settings';
        break;
      case 2:
        return 'Statistics';
        break;
      case 3:
        return 'Maintenance Report';
        break;
      case 4:
        return 'Add Device';
        break;
      case 5:
        return 'About Vysion';
        break;
      case 6:
        return 'Contact';
        break;
      default:
        return " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final drawerItems = [
      Item(
          Text("Home",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.home_rounded,
            color: gc,
          )),
      Item(
          Text("Device Settings",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.settings,
            color: tc,
          )),
      Item(
          Text("Statistics",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.assessment,
            color: tc,
          )),
      Item(
          Text("Maintenance Report",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.build,
            color: tc,
          )),
      Item(
          Text("Add Devices",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.add,
            color: tc,
          )),
      Item(
          Text("About Vysion",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.verified_user,
            color: tc,
          )),
      Item(
          Text("Contact Us",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.settings_phone,
            color: tc,
          )),
      Item(
          Text("Log Out",
              style: TextStyle(
                  color: gc,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.b * 4.08)),
          Icon(
            Icons.logout,
            color: tc,
          )),
    ];
    final bottomNavTitiles = ["Home", "Devices", "Teams"];
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      if (i != 7) {
        drawerOptions.add(ListTile(
          leading: drawerItems[i].icon,
          title: drawerItems[i].title,
          selected: i == _selectedDrawerIndex,
          onTap: () {
            _onSelectedItem(i);
          },
        ));
      } else {
        drawerOptions.add(ListTile(
          leading: drawerItems[i].icon,
          title: drawerItems[i].title,
          selected: i == _selectedDrawerIndex,
          onTap: () {
            Navigator.of(context).pop();
            showErrorDialog(context).then((onValue) {
              if (onValue == "Yes") {
                Auth.instance.signOut();
              }
            });
          },
        ));
      }
    }

    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.grey,
            ),
            onPressed: () {
              _scafoldKey.currentState.openDrawer();
            }),
        title: _isfromDrawer
            ? _selectedDrawerIndex == 0
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(SizeConfig.b * 3.0, 0, 0, 0),
                    height: SizeConfig.v * 5,
                    width: SizeConfig.b * 80,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 222, 224, 224),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.b * 2.7)),
                    child: Consumer<ChangeWhenGetCity>(
                      builder: (context, object, child) {
                        return Consumer<ChangeCity>(
                          builder: (context, changeList, child) =>
                              DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down_rounded),
                            elevation: 8,
                            dropdownColor: Color(0xff263238),
                            isDense: false,
                            underline: SizedBox(
                              height: 0.0,
                            ),
                            items: object.citiesMap.values
                                .map((dropDownStringitem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringitem,
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(12.0, 8.0, 4.0, 4.0),
                                  width: SizeConfig.b * 80,
                                  height: SizeConfig.v * 4,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 222, 224, 224)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.b * 1)),
                                  child: Text(
                                    dropDownStringitem,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValueSelected) {
                              _itemSelected = newValueSelected;
                              Provider.of<ChangeCity>(context, listen: false)
                                  .reinitialize();

                              object.citiesMap.forEach((key, value) {
                                if (value == newValueSelected)
                                  HomePageVM.instance.setCityCode = key;
                              });
                              VariableGlobal.iscitychanged = true;
                              HomePageVM.instance.callSetQuery();
                            },
                            isExpanded: true,
                            hint: Text(
                              "Dummy City",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                            value: _itemSelected ?? null,
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    _setTitle(_selectedDrawerIndex),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black87),
                  )
            : Auth.instance.post == "Manager"
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(SizeConfig.b * 3.0, 0, 0, 0),
                    height: SizeConfig.v * 5,
                    width: SizeConfig.b * 80,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 222, 224, 224),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.b * 2.7)),
                    child: Consumer<ChangeWhenGetCity>(
                      builder: (context, object, child) {
                        return Consumer<ChangeCity>(
                          builder: (context, changeList, child) =>
                              DropdownButton<String>(
                            icon: Icon(Icons.arrow_drop_down_rounded),
                            elevation: 8,
                            dropdownColor: Color(0xff263238),
                            isDense: false,
                            underline: SizedBox(
                              height: 0.0,
                            ),
                            items: object.citiesMap.values
                                .map((dropDownStringitem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringitem,
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(12.0, 8.0, 4.0, 4.0),
                                  width: SizeConfig.b * 80,
                                  height: SizeConfig.v * 4,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 222, 224, 224)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.b * 2.7)),
                                  child: Text(
                                    dropDownStringitem,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValueSelected) {
                              _itemSelected = newValueSelected;
                              Provider.of<ChangeCity>(context, listen: false)
                                  .reinitialize();

                              object.citiesMap.forEach((key, value) {
                                if (value == newValueSelected)
                                  HomePageVM.instance.setCityCode = key;
                              });
                              VariableGlobal.iscitychanged = true;
                              HomePageVM.instance.callSetQuery();
                            },
                            isExpanded: true,
                            hint: Text(
                              "Dummy City",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                            value: _itemSelected ?? null,
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    "${Auth.instance.cityName ?? "Demo City"}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add_box,
                color: Colors.black,
              ),
              onPressed: () {
                if (context != null)
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SplashCarousel())
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NoticeBoard(
                            cityMap: HomePageVM.instance.getCitiesMap,
                          )));
              })
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xffF4F3F3),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                margin: EdgeInsets.fromLTRB(0, 0, 0, SizeConfig.v * 1.25),
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.b * 1.2,
                    SizeConfig.v * 1.25,
                    SizeConfig.b * 0.8,
                    SizeConfig.v * 1.25),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: SizeConfig.b * 3),
                            CircleAvatar(
                              radius: SizeConfig.b * 11,
                              backgroundImage: AssetImage("assets/f.png"),
                            ),
                            SizedBox(width: SizeConfig.b * 3),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text("${Auth.instance.displayName ?? ""}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig.b * 5.09)),
                                  SizedBox(height: SizeConfig.v * 1.5),
                                  Text(
                                      "${FirebaseAuth.instance.currentUser?.phoneNumber ?? ""}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: SizeConfig.b * 4.08)),
                                ]))
                          ]),
                    ]),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color(0xff263238),
                      Color(0xff005A87),
                    ])),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: drawerOptions,
              )
            ],
          ),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _isfromDrawer
              ? _getDrawerItemWidget(_selectedDrawerIndex)
              : _getBottomNavItem(_currentIndex)),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        selectedFontSize: 14.0,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff263238),
        iconSize: 20.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              size: SizeConfig.screenHeight * 23 / 640,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.memory,
                size: SizeConfig.screenHeight * 23 / 640,
              ),
              label: 'Devices'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                size: SizeConfig.screenHeight * 23 / 640,
              ),
              label: 'Team'),
        ],
        onTap: (index) {
          setState(() {
            _isfromDrawer = false;
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

const gc = Colors.black;
const tc = Color(0xff263238);
