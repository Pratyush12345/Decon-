import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Controller/ViewModels/manager_list_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/Dialogs/Add_Manager.dart';
import 'package:Decon/View_Android/Dialogs/dialogBoxConfirmAdd.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ManagersList extends StatefulWidget {
  String managerUid;
  final String clientName;
  ManagersList({@required this.managerUid, @required this.clientName});
  @override
  _ManagersListState createState() => _ManagersListState();
}

class _ManagersListState extends State<ManagersList> {
  List<UserDetailModel> _listUserDetailModel;
  final TextEditingController search = TextEditingController();

  int _selectedIndex = -1;
  Future showManagerDialog(BuildContext context) {
    return showAnimatedDialog(
        barrierDismissible:  true,
        context: context,
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),
        
        builder: (context) {
          return Add_man(list: _listUserDetailModel??[],);
        });
  }

  void dialogBoxConfirmAdd(BuildContext context) {
  showAnimatedDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return DialogBoxConfirmAdd(managerName: _listUserDetailModel[_selectedIndex].name, clientName: widget.clientName ,);
    },
    animationType: DialogTransitionType.scaleRotate,
    curve: Curves.fastOutSlowIn,
    duration: Duration(milliseconds: 400),
  ).then((value){
    if(value == "YES")
    Navigator.of(context).pop(_listUserDetailModel[_selectedIndex]);
  });
}

  @override
    void initState() {
      _listUserDetailModel = [];
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
     appBar: AppBar(leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: blc, size: b * 16),
        ),
        elevation: 10,
        titleSpacing: -3,
        iconTheme: IconThemeData(color: blc),
        title: Text(
          "Add Client",
          style: txtS(Colors.black, 16, FontWeight.w500),
        ),
        backgroundColor: Colors.white,
      
     
     
     ),
     floatingActionButton: FloatingActionButton(
       backgroundColor: blc,
        child: SvgPicture.asset(
          'images/AddUser.svg',
          allowDrawingOutsideViewBox: true,
        ),
       onPressed: (){
           showManagerDialog(context);
       },
     ),
     body: Container(
       padding: EdgeInsets.symmetric(horizontal: b * 22),
       
       child: Column(
         children: [
           sh(27),
            Container(
              alignment: Alignment.center,
              width: b * 340,
              decoration: BoxDecoration(
                border: Border.all(color: dc, width: 0.5),
                color: Color(0xffffffff),
                borderRadius: BorderRadius.circular(b * 60),
              ),
              child: TextField(
                onChanged: (val){
                  _listUserDetailModel = ManagerListVM.instance.onSearchManager(val);
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
                  hintText: 'Search by Name',
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
            sh(20),
            
           Container(
             height: MediaQuery.of(context).size.height*0.7,
             child: StreamBuilder<Event>(
               stream: FirebaseDatabase.instance.reference().child("managers").onValue,
               builder: (context, snapshot){
                 if(snapshot.hasData){
                      Map datamap = snapshot.data.snapshot.value;
                      if(!ManagerListVM.instance.isManagerSearched){
                      _listUserDetailModel = [];
                      datamap?.forEach((key, value) {
                        _listUserDetailModel.add(UserDetailModel.fromJson(key.toString(), value));
                      });
                      if(widget.managerUid!=null){
                        _selectedIndex = _listUserDetailModel.indexWhere((element) => element.key == widget.managerUid);
                        widget.managerUid = null;
                      }
                      ManagerListVM.instance.setManagerList = _listUserDetailModel;
                      }
                    if(snapshot.data.snapshot.value!=null)
                      return ListView.builder(
                    itemCount: _listUserDetailModel.length,
                    itemBuilder: (context, index){
                    return Card(
                      child: ListTile(
                        //leading: Text("${_listUserDetailModel[index].clientsVisible??""}"),
                              
                        leading: Container(
                                      height: h * 25,
                                      width: b * 25,
                                      decoration: BoxDecoration(
                                        color: Color(0xff6d6d6d),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                        title: Text("${_listUserDetailModel[index].name}",
                        style: txtS(blc, 16, FontWeight.w400)),
                        subtitle: Text("${_listUserDetailModel[index].phoneNo}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: txtS(dc, 14, FontWeight.w400)),
                        trailing: Container(
                          width: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 50.0,
                                child: Text("${_listUserDetailModel[index].clientsVisible.replaceFirst(",", "")??""}",
                                maxLines: 3,),
                              ),
                              Checkbox(
                                value: index == _selectedIndex, 
                                onChanged: (val){
                                  _selectedIndex = index;
                                  print("_selected index========$_selectedIndex");
                                  setState(() {});
                                }),
                            ],
                          ),
                        ),
                    )
                    );
                    
                    });
                    else
                    return AppConstant.noDataFound();
                 }
                 else{
                   if(snapshot.hasError)
                   return Center(
                        child: Text('${snapshot.error}'),
                      );
                   else
                   return AppConstant.circulerProgressIndicator();   
                 }
               }       
               
             ),
           ),
           MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: blc,
              padding: EdgeInsets.symmetric(vertical: h * 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(b * 6),
              ),
              onPressed: () {
                dialogBoxConfirmAdd(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: h * 10),
                alignment: Alignment.center,
                child: Text(
                  "Save" ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: b * 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
         ],
       ),
     )
    );
  }
}