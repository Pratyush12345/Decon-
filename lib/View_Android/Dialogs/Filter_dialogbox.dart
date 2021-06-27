import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:flutter/material.dart';

class FilterDialogDevice extends StatelessWidget {
  final String selected;
  FilterDialogDevice({ Key key, @required this.selected }) : super(key: key);
  
  List<String> _filterList = [
    "None",
    "Ground Level",
    "Normal Level",
    "Informative Level",
    "Critical Level",
    "Open Manholes",
    "High Temperature",
    "Insufficient Battery"
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: b * 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 12),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          sh(4),
                      Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: b * 16,
                            color: dc,
                            fontWeight: FontWeight.w500,
                          ),
                          ),
          Container(
            height: MediaQuery.of(context).size.height *0.4,
            padding: EdgeInsets.fromLTRB(b * 13, h * 1, b * 13, h * 16),
            child: 
              ListView.builder(
                itemCount: _filterList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(_filterList[index]);
                          },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: h * 10),
                          decoration: !(selected == '${_filterList[index]}')? BoxDecoration(
                        border: Border.all(color: blc),
                        borderRadius: BorderRadius.circular(b * 6)):
                        BoxDecoration(
                        color: blc,
                        borderRadius: BorderRadius.circular(b * 6)),
                            
                          alignment: Alignment.center,
                          child: Text(
                            '${_filterList[index]}',
                            style: !(selected == '${_filterList[index]}')? TextStyle(
                            color: blc,
                            fontSize: b * 16,
                            fontWeight: FontWeight.w500):
                            TextStyle(
                            color: Colors.white,
                            fontSize: b * 16,
                            fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      sh(8)
                    ],
                  );
                }
              ),  
           ),
        ]),
      ),
    );

  }
}