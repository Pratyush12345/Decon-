import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/all_people_viewmodel.dart';
import 'package:Decon/Controller/ViewModels/people_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/View_Android/Dialogs/Add_Delegates.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/profile_screen.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllPeopleDummy extends StatefulWidget {
  AllPeopleDummy( 
      {Key key, })
      : super(key: key);

  @override
  _AllPeopleDummy createState() => _AllPeopleDummy();
}


class _AllPeopleDummy extends State<AllPeopleDummy> {
  List<UserDetailModel> _listOfAdminTeam = [];
  List<UserDetailModel> _listOfManagerTeam = [];
                                                        
  _initialize() async{
    
    PeopleVM.instance.init();
    AllPeopleVM.instance.init(context);
    _listOfAdminTeam = [UserDetailModel(clientsVisible: ",C0", post: "Engineer", phoneNo: "+919977623450", name: "Urvish Patel", delegate: "Admin Team", key: "DummyAdminTeam1"),
    UserDetailModel(clientsVisible: ",C0", post: "Technician", phoneNo: "+917878343400", name: "Zilanee Sheikh", delegate: "Admin Team", key: "DummyAdminTeam2")];
    _listOfManagerTeam = [UserDetailModel(clientsVisible: ",C0", post: "Janitor", phoneNo: "+917799202010", name: "Atul Joshi", delegate: "Manager Team", key: "DummyManagerTeam1"),
    UserDetailModel(clientsVisible: ",C0", post: "Technician", phoneNo: "+919993331010", name: "Naimish Dave", delegate: "Manager Team", key: "DummyManagerTeam2"),
    UserDetailModel(clientsVisible: ",C0", post: "Supervisor", phoneNo: "+918990991020", name: "Sandip Parmar", delegate: "Manager Team", key: "DummyManagerTeam3")];
    await AllPeopleVM.instance.getManagerDetailDummy();
    await AllPeopleVM.instance.getAdminDetailDummy();
    setState(() { });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future showDelegatesDialog(BuildContext context) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,  
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        builder: (context) {
          return Add_Delegates(list: GlobalVar.strAccessLevel=="2" ? _listOfManagerTeam : _listOfAdminTeam,
          secondarylist: GlobalVar.strAccessLevel=="2" ?  _listOfAdminTeam : _listOfManagerTeam ,
          adminDetail: AllPeopleVM.instance.adminDetailModel);
        });
  }

  Future showDeleteDialog(BuildContext context) {
    return showAnimatedDialog(
        context: context,
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
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
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(elevation: 10,
        titleSpacing: -3,
        leading: GlobalVar.strAccessLevel == "1"?
             InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child:  Icon(Icons.arrow_back_ios, color: blc, size: b * 16),
        ): SizedBox(),
        iconTheme: IconThemeData(color: blc),
        title: Text(
                
                "Demo Client",
                
          style: txtS(Colors.black, 16, FontWeight.w500),), 
        backgroundColor: Colors.white,
      ), 
      floatingActionButton: GlobalVar.strAccessLevel == "2" || GlobalVar.strAccessLevel == "3"
          ? FloatingActionButton(
              backgroundColor: Color(0xff0099FF),
              onPressed: () {
                showDelegatesDialog(context);
              },
              child: SvgPicture.asset(
                'images/AddUser.svg',
                allowDrawingOutsideViewBox: true,
              ),
            )
          : SizedBox(
              height: 0.0,
            ),
      body: SingleChildScrollView(
         
        padding: EdgeInsets.symmetric(horizontal: b * 22),
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            sh(11),
              Text(
                "Manager",
                style: txtS(dc, 14, FontWeight.w400),
              ),
              sh(8),
              InkWell(
                 onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: AllPeopleVM.instance.managerDetailModel, )));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: h * 8),
                  padding: EdgeInsets.symmetric(
                      vertical: h * 14.45, horizontal: b * 17),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(b * 10),
                    border: Border.all(
                      color: Color(0xff065e87),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: h * 46,
                        width: b * 46,
                        decoration: BoxDecoration(
                          color: Color(0xff6d6d6d),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacer(),
                      AllPeopleVM.instance.managerDetailModel == null? AppConstant.circulerProgressIndicator():
                      AllPeopleVM.instance.managerDetailModel.key == null? AppConstant.noDataFound(): 
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${AllPeopleVM.instance.managerDetailModel.name??""}",
                            style:
                                txtS(Color(0xff065e87), 15.51, FontWeight.w500),
                          ),
                          Text(
                            "${AllPeopleVM.instance.managerDetailModel.phoneNo??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                txtS(Color(0xff858585), 11.63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
            sh(16),
              Text(
                "Admin",
                style: txtS(dc, 14, FontWeight.w400),
              ),
              sh(8),
              InkWell(
                onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: AllPeopleVM.instance.adminDetailModel, )));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: h * 8),
                  padding: EdgeInsets.symmetric(
                      vertical: h * 14.45, horizontal: b * 17),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(b * 10),
                    border: Border.all(
                      color: Color(0xff065e87),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: h * 46,
                        width: b * 46,
                        decoration: BoxDecoration(
                          color: Color(0xff6d6d6d),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Spacer(),
                      AllPeopleVM.instance.adminDetailModel == null? AppConstant.circulerProgressIndicator():
                     AllPeopleVM.instance.adminDetailModel.key == null? AppConstant.noDataFound(): 
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${AllPeopleVM.instance.adminDetailModel.name??""}",
                            style:
                                txtS(Color(0xff065e87), 15.51, FontWeight.w500),
                          ),
                          Text(
                            "${AllPeopleVM.instance.adminDetailModel.delegate??""}",
                            style:
                                txtS(Color(0xff065e87), 15.51, FontWeight.w500),
                          ),
                          Text(
                            "${AllPeopleVM.instance.adminDetailModel.phoneNo??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                txtS(Color(0xff858585), 11.63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
            SizedBox(width: SizeConfig.b * 5),
            Row(
                children: [
                  Text(
                    "Manager Team",
                    style: txtS(dc, 13.57, FontWeight.w400),
                  ),
                  Spacer(),
                    Text(
                      "Total:${_listOfManagerTeam?.length}",
                      style: txtS(Color(0xff858585), 12, FontWeight.w400),
                    ),
                  
                ],
              ),
            SizedBox(height: SizeConfig.v * 1),
            Container(
              height: h *200,
              child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _listOfManagerTeam.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return InkWell(
                                onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: _listOfManagerTeam[index], )));
                                },
                                onLongPress: () {
                                  showDeleteDialog(context).then((value) async {
                                  
                                    if (value == "Yes") {
                                        }
                                  });
                                },
                    
                    child: Container(
                      margin: EdgeInsets.only(bottom: h * 8),
                      padding: EdgeInsets.symmetric(
                          vertical: h * 11, horizontal: b * 17),
                      decoration: BoxDecoration(
                        color: Color(0xfff1f1f1),
                        borderRadius: BorderRadius.circular(b * 10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: h * 36,
                            width: b * 36,
                            decoration: BoxDecoration(
                              color: Color(0xff6d6d6d),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: b * 10),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_listOfManagerTeam[index].name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(dc, 15.51, FontWeight.w400),
                                ),
                                Text(
                                   _listOfManagerTeam[index].post.split("@")[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                                Text(
                                  _listOfManagerTeam[index].phoneNo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ); 
                             
                            })
            ),
            SizedBox(height: 10.0,),
            Row(
                children: [
                  Text(
                    "Admin Team",
                    style: txtS(dc, 13.57, FontWeight.w400),
                  ),
                  Spacer(),
                    Text(
                      "Total:${_listOfAdminTeam?.length??0}",
                      style: txtS(Color(0xff858585), 12, FontWeight.w400),
                    ),
                  
                ],
              ),
            Container(
              height: h *200,
              child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _listOfAdminTeam.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return InkWell(
                            onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: _listOfAdminTeam[index], )));
                                },
                             onLongPress: () {
                            
                              showDeleteDialog(context).then((value) async {
                              
                                if (value == "Yes") {
                                }
                              });
                            },
                    
                    child: Container(
                      margin: EdgeInsets.only(bottom: h * 8),
                      padding: EdgeInsets.symmetric(
                          vertical: h * 11, horizontal: b * 17),
                      decoration: BoxDecoration(
                        color: Color(0xfff1f1f1),
                        borderRadius: BorderRadius.circular(b * 10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: h * 36,
                            width: b * 36,
                            decoration: BoxDecoration(
                              color: Color(0xff6d6d6d),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: b * 10),
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _listOfAdminTeam[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(dc, 15.51, FontWeight.w400),
                                ),
                                Text(
                                  _listOfAdminTeam[index].post.split("@")[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                                Text(
                                  _listOfAdminTeam[index].phoneNo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: txtS(Color(0xff858585), 11.63,
                                      FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                        })
                  
                  
                
              
            )
          ],
        ),
      ),
    );
  }
}
