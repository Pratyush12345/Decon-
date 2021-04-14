import 'package:Decon/View_Android/Bottom_Navigation/PeopleForAdmin.dart';
import 'package:Decon/View_Android/Dialogs/Add_Admin.dart';
import 'package:Decon/View_Android/Dialogs/Add_Manager.dart';
import 'package:Decon/View_Android/Dialogs/Replace_Admin.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Controller/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class People extends StatefulWidget {
  final BuildContext menuScreenContext;
  People({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _People createState() => _People();
}

const gc = Colors.black;
const tc = Color(0xff263238);

class _People extends State<People> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<DelegateModel> _listofAdmins = List();
  List<DelegateModel> _listofManagers = List();
  String _searcheAdmindValue = "", _searchedManagerValue = "";
  Map _citiesMap;
  bool _citySearchBar = false;
  bool _managerSearchBar = false;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future showManagerDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Add_man();
        });
  }

  Future showAdminDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Add_admin(
            cityLength: _listofAdmins.length,
          );
        });
  }

  Future showReplaceAdminDialog(BuildContext context, String cityCode,
      String cityName, String stateName, String phoneNo) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Replace_Admin(
            cityCode: cityCode,
            cityName: cityName,
            stateName: stateName,
            phoneNo: phoneNo,
          );
        });
  }

  Future showDeleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text('Delete user?'), actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
              indicatorWeight: 2,
              indicatorColor: Color(0xff0099FF),
              labelPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.b * 0.76, vertical: 0),
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'Managers',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.b * 5.09,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Tab(
                  child: Text(
                    'Cities',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.b * 5.09,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ]),
          Expanded(
            flex: 2,
            child: new TabBarView(
              controller: _tabController,
              children: <Widget>[
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Color(0xff0099FF),
                    elevation: 2,
                    onPressed: () {
                      showManagerDialog(context);
                    },
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                  body: Container(
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.v * 3),
                        Row(
                          mainAxisAlignment: _managerSearchBar
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _managerSearchBar
                                ? Container(
                                    width: SizeConfig.screenWidth * 320 / 360,
                                    height: SizeConfig.screenHeight * 30 / 640,
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _searchedManagerValue = value;
                                        });
                                      },
                                      style: TextStyle(
                                          fontSize: SizeConfig.b * 4.3),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          size: 20,
                                        ),
                                        isDense: true,
                                        filled: true,
                                        fillColor: Color(0xffDEE0E0),
                                        hintText: 'Search by Name / Contact',
                                        hintStyle: TextStyle(
                                            fontSize: SizeConfig.b * 4),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  SizeConfig.b * 1.1)),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  SizeConfig.b * 1.1)),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      right: SizeConfig.b * 5.1,
                                    ),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.search_rounded,
                                          color: Color(0xff263238),
                                          size: SizeConfig.screenHeight *
                                              22 /
                                              640,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _managerSearchBar =
                                                !_managerSearchBar;
                                          });
                                        }),
                                  ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.v * 2),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: StreamBuilder<Event>(
                              stream: FirebaseDatabase.instance
                                  .reference()
                                  .child("managerList")
                                  .onValue,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _listofManagers.clear();

                                  snapshot.data.snapshot?.value
                                      ?.forEach((key, value) {
                                    Map _map = {};
                                    String rangeofDevices =
                                        value["rangeOfDeviceEx"];
                                    if (rangeofDevices != "None" &&
                                        rangeofDevices != null)
                                      rangeofDevices
                                          .replaceAll("{", "")
                                          .replaceAll("}", "")
                                          .split(",")
                                          .forEach((element) {
                                        String key = element.split(":")[0];
                                        String val = element.split(":")[1];
                                        _map[key] = val;
                                      });
                                    if (value["name"]
                                            .toString()
                                            .toLowerCase()
                                            .contains(_searchedManagerValue
                                                .toLowerCase()) ||
                                        value["phoneNo"]
                                            .toString()
                                            .contains(_searchedManagerValue) ||
                                        _searchedManagerValue == "")
                                      _listofManagers.add(DelegateModel(
                                          uid: key,
                                          stateName: value["stateName"],
                                          rangeOfDeviceEx: _map,
                                          numb: value["phoneNo"],
                                          cityName: value["cityName"],
                                          post: value["post"],
                                          name: value["name"]));
                                  });

                                  return ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: _listofManagers.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return InkWell(
                                          onLongPress: () {
                                            showDeleteDialog(context)
                                                .then((value) async {
                                              print(value);
                                              if (value == "Yes") {
                                                DataSnapshot snapshot =
                                                    await FirebaseDatabase
                                                        .instance
                                                        .reference()
                                                        .child("/managerList/")
                                                        .orderByChild("phoneNo")
                                                        .equalTo(
                                                            _listofManagers[
                                                                    index]
                                                                .numb)
                                                        .once();
                                                Map _map = snapshot.value;
                                                _map.forEach((key, value) {
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child(
                                                          "/managerList/$key")
                                                      .remove();
                                                });
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                SizeConfig.b * 5.1,
                                                SizeConfig.v * 1,
                                                SizeConfig.b * 5.1,
                                                0),
                                            child: Material(
                                              color: Color(0xffececec),
                                              elevation: 2,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig.b * 1.2),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    SizeConfig.b * 5.1,
                                                    SizeConfig.v * 1,
                                                    SizeConfig.b * 5.1,
                                                    SizeConfig.v * 1),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _listofManagers[index]
                                                              .name,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  SizeConfig.b *
                                                                      4.071,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          _listofManagers[index]
                                                              .numb,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  SizeConfig.b *
                                                                      3.2),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    SizeConfig
                                                                            .b *
                                                                        1.2),
                                                        color:
                                                            Color(0x804ADB58),
                                                      ),
                                                      height:
                                                          SizeConfig.v * 2.86,
                                                      width:
                                                          SizeConfig.v * 2.86,
                                                      child: IconButton(
                                                        onPressed: null,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        icon: Icon(Icons.call,
                                                            color: Colors.white,
                                                            size: SizeConfig.b *
                                                                4),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                } else {
                                  return Center(
                                    child: Text('${snapshot.error}'),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Color(0xff0099FF),
                    elevation: 2,
                    onPressed: () {
                      showAdminDialog(context);
                    },
                    child: Icon(
                      Icons.add,
                    ),
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.v * 3),
                        Row(
                          mainAxisAlignment: _citySearchBar
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            _citySearchBar
                                ? Container(
                                    width: SizeConfig.screenWidth * 320 / 360,
                                    height: SizeConfig.screenHeight * 30 / 640,
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _searcheAdmindValue = value;
                                        });
                                      },
                                      style: TextStyle(
                                          fontSize: SizeConfig.b * 4.3),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search_rounded,
                                          size: 20,
                                        ),
                                        isDense: true,
                                        filled: true,
                                        fillColor: Color(0xffDEE0E0),
                                        hintText: 'Search by Name / Contact',
                                        hintStyle: TextStyle(
                                            fontSize: SizeConfig.b * 4),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  SizeConfig.b * 1.1)),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  SizeConfig.b * 1.1)),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      right: SizeConfig.b * 5.1,
                                    ),
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.search_rounded,
                                          color: Color(0xff263238),
                                          size: SizeConfig.screenHeight *
                                              22 /
                                              640,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _citySearchBar = !_citySearchBar;
                                          });
                                        }),
                                  ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.v * 2),
                        Expanded(
                            child: SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: StreamBuilder<Event>(
                                    stream: FirebaseDatabase.instance
                                        .reference()
                                        .child("adminsList")
                                        .onValue,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        _listofAdmins.clear();

                                        snapshot.data.snapshot?.value
                                            ?.forEach((key, value) {
                                          Map _map = {};
                                          String rangeofDevices =
                                              value["rangeOfDeviceEx"];
                                          if (rangeofDevices != "None" &&
                                              rangeofDevices != null)
                                            rangeofDevices
                                                .replaceAll("{", "")
                                                .replaceAll("}", "")
                                                .split(",")
                                                .forEach((element) {
                                              String key =
                                                  element.split(":")[0];
                                              String val =
                                                  element.split(":")[1];
                                              _map[key] = val;
                                            });
                                          if (value["name"]
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains(_searcheAdmindValue
                                                      .toLowerCase()) ||
                                              value["phoneNo"]
                                                  .toString()
                                                  .contains(
                                                      _searcheAdmindValue) ||
                                              _searcheAdmindValue == "") {
                                            _listofAdmins.add(DelegateModel(
                                                uid: key,
                                                stateName: value["stateName"],
                                                rangeOfDeviceEx: _map,
                                                cityName: value["cityName"],
                                                numb: value["phoneNo"],
                                                cityCode: value["cityCode"],
                                                post: value["post"],
                                                name: value["name"]));
                                          }
                                        });

                                        return ListView.builder(
                                            physics: ScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            itemCount: _listofAdmins.length,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              return InkWell(
                                                onLongPress: () {
                                                  showReplaceAdminDialog(
                                                      context,
                                                      _listofAdmins[index]
                                                          .cityCode,
                                                      _listofAdmins[index]
                                                          .cityName,
                                                      _listofAdmins[index]
                                                          .stateName,
                                                      _listofAdmins[index]
                                                          .numb);
                                                },
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PeopleForAdmin(
                                                        fromManager: true,
                                                        cityCode:
                                                            "${_listofAdmins[index].cityCode}",
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      SizeConfig.b * 5.1,
                                                      SizeConfig.v * 1,
                                                      SizeConfig.b * 5.1,
                                                      0),
                                                  child: Material(
                                                    elevation: 2,
                                                    color: Color(0xffececec),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            SizeConfig.b * 1),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              SizeConfig.b *
                                                                  5.1,
                                                              SizeConfig.v * 1,
                                                              SizeConfig.b *
                                                                  5.1,
                                                              SizeConfig.v * 1),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: SizeConfig
                                                                            .b *
                                                                        40.72,
                                                                    child: Text(
                                                                      _listofAdmins[
                                                                              index]
                                                                          .name,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            SizeConfig.b *
                                                                                4.5,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: SizeConfig
                                                                              .v *
                                                                          0.5),
                                                                  Text(
                                                                    _listofAdmins[
                                                                            index]
                                                                        .post
                                                                        .split(
                                                                            "@")[1],
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff464646),
                                                                        fontSize:
                                                                            SizeConfig.b *
                                                                                3.1,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                      height: SizeConfig
                                                                              .v *
                                                                          0.5),
                                                                  Text(
                                                                    _listofAdmins[
                                                                            index]
                                                                        .numb,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xff464646),
                                                                      fontSize:
                                                                          SizeConfig.b *
                                                                              3.1,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                          Spacer(),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "${_listofAdmins[index].cityName}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        SizeConfig.b *
                                                                            4.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${_listofAdmins[index].stateName}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          SizeConfig.b *
                                                                              4.0),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return Center(
                                          child: Text('${snapshot.error}'),
                                        );
                                      }
                                    })))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
