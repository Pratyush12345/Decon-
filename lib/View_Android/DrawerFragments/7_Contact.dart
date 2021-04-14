import 'package:flutter/material.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';

class Contact extends StatefulWidget {
  final BuildContext menuScreenContext;
  Contact({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _Contact createState() => _Contact();
}

const gc = Colors.black;
const tc = Color(0xff263238);

class _Contact extends State<Contact> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.v * 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on),
                SizedBox(width: SizeConfig.b * 6),
                Text("SVNIT Campus, Surat, Gujarat",
                    style: TextStyle(fontSize: SizeConfig.b * 4.3))
              ],
            ),
            SizedBox(height: SizeConfig.v * 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.mail),
                SizedBox(width: SizeConfig.b * 6),
                Text("vysiontechnology@gmail.com",
                    style: TextStyle(fontSize: SizeConfig.b * 4.3))
              ],
            ),
            SizedBox(height: SizeConfig.v * 6),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 16 / 360),
                  child: Text(
                    'GET IN TOUCH',
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 16 / 360,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff828282),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.v * 4),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 16 / 360),
              child: TextField(
                maxLines: 1,
                style: TextStyle(fontSize: SizeConfig.b * 4.3),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Mail',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDADADA)),
                  ),
                  hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 10 / 360,
                    vertical: SizeConfig.screenHeight * 5 / 640,
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.v * 6),
            Container(
              alignment: Alignment.topCenter,
              height: SizeConfig.screenHeight * 135 / 640,
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 16 / 360),
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 10 / 360),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffDADADA),
                ),
              ),
              child: TextField(
                maxLines: null,
                style: TextStyle(fontSize: SizeConfig.b * 4.3),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Message',
                  hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.v * 7),
            SizedBox(
              child: MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.b * 15.3,
                      vertical: SizeConfig.v * 1.8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.b * 8.0),
                    color: Color(0xff00A3FF),
                  ),
                  child: Text(
                    'SEND',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.b * 4.2,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
