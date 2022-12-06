import 'dart:io';

import 'package:celepraty/Celebrity/Activity/studio/studio.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/celebrity/Activity/news/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ActivityScreen extends StatefulWidget {
  final String? move;
  const ActivityScreen({Key? key, this.move}) : super(key: key);

  @override
  _ActivityScreenMainState createState() => _ActivityScreenMainState();
  }

class _ActivityScreenMainState extends State<ActivityScreen> with AutomaticKeepAliveClientMixin{
  int? isSelected = 1;
  bool grandientStudio=false;
  bool grandientnews=true;
  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //CheckUserConnection();
    widget.move == null?
    setState(() {
      isSelected = 1;
      grandientnews=true;
      grandientStudio =false;
    }) :   setState(() {
      isSelected = 2;
      grandientnews=false;
      grandientStudio =true;
    });
  }
  // @override
  // void dispose() {
  //   for(int i =0 ; i < videoss.length; i++){
  //     videoss[i]!.dispose();
  //   }
  //   super.dispose();
  // }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: drowAppBar("التفاعلات", context),
        body: Column( children: [

          SizedBox(
            height: 26.h,
          ),
          //صف الاختيارات-------------------------------
          drowRowButton(context),
          SizedBox(
            height: 30.h,
          ),
          //النص-------------------------------

          if(isSelected == 1)
          Padding(
            padding: EdgeInsets.only(left: 28.w, right: 28.w),
            child: text(context,
               "التفاعلات الخاصة بمنشوراتك",
                //,
                textSubHeadSize,
                black,
                fontWeight: FontWeight.bold),
          ),

          SizedBox(
            height: 10.h,
          ),

          //الطلبات وفق التصنيف-------------------------------

          Expanded(
            flex: 4,
            child: isSelected == 1
                ?  Studio()
                : news()
          ),
        ])
      )
    );
  }
  drowRowButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 28.w, right: 28.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
//الاعلانات-------------------------------------------------------
          Expanded(
            child: gradientContainer(
                96,
                buttoms(
                  context,
                  'الاستديو',
                  textTitleSize,
                  grandientStudio? black:white,
                      () {
                    setState(() {
                      isSelected = 1;
                      grandientnews=true;
                      grandientStudio =false;
                    });
                    print("adv$isSelected");
                  },
                ),
                gradient: grandientStudio ,color: grey!, height: 50,
            ),
          ),

          SizedBox(width: 17.w),
//الاهداءات-------------------------------------------------------
          Expanded(
            child: gradientContainer(
                96,
                buttoms(
                  context,
                  'الاخبار',
                  textTitleSize,
                  grandientnews? black:white,
                      () {
                    setState(() {
                      isSelected = 2;
                      grandientStudio=true;
                      grandientnews =false;
                    });
                    print("gift$isSelected");
                  },
                ),
                gradient: grandientnews,color: grey!, height: 50,
            ),
          ),

          SizedBox(width: 17.w),
//المساحة الاعلانية-------------------------------------------------------


//-------------------------------------------------------
        ],
      ),
    );
  }
}
