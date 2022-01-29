import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';


class AboutVysion extends StatefulWidget {
  final BuildContext menuScreenContext;
  AboutVysion({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _AboutVysion createState() => _AboutVysion();
}


class _AboutVysion extends State<AboutVysion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return ListView(
      children: [
        sh(25),
        Container(
              alignment: Alignment.center,
              height: 200.0,
              width: 300.0,
              child: Image.asset('images/logo.png')),
         sh(18),       
        Container(
          padding: EdgeInsets.symmetric(horizontal: b * 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                "About Company",
                style: txtS(Colors.black, 20, FontWeight.w700),
              ),
              sh(8),
              Text(
                "Vysion Technology is a Gujarat based technology startup working in trending Domains like IoT, AI and Cloud to Empower Smart cities and industry.\n\nVysion Technology is Incubated by Gujarat government under SSIP initiative. We are team of young, enthusiastic and skilled engineers working to achieve our Vision",
                style: txtS(Color(0xff5c6266), 14, FontWeight.w400),
              ),
              sh(40),
              Text(
                "Vision",
                style: txtS(Colors.black, 20, FontWeight.w700),
              ),
              sh(8),
              Text(
                "Our vision is to empower and develop a country by providing a series of IoT, AI and cloud based smart solutions in different sectors to eradict the bottleneck problems faced by the country.Our products aim to transform and develop smart cities and industry. ",
                style: txtS(Color(0xff5c6266), 14, FontWeight.w400),
              ),
            ],
          ),
        ),
        // Stack(
        //   alignment: Alignment.center,
        //   children: [
        //     Container(
        //       width: SizeConfig.screenWidth,
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           stops: [
        //             0.1,
        //             0.56,
        //             0.95,
        //           ],
        //           colors: [
        //             Color(0xffc4c4c4).withOpacity(0.15),
        //             dc.withOpacity(0.57),
        //             dc.withOpacity(1),
        //           ],
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
