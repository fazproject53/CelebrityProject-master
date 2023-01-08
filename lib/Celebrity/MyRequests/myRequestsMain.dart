import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';
import 'MyAdSpace/MyAdSpace.dart';
import 'MyAds/MyAdvertisin.dart';
import 'MyGift/MyGift.dart';
bool isDisConnectToInternet_=true;
class MyRequestsMainPage extends StatefulWidget {
  final String? whereTo;
  const MyRequestsMainPage({Key? key, this.whereTo}) : super(key: key);

  @override
  State<MyRequestsMainPage> createState() => _MyRequestsMainPageState();
}

class _MyRequestsMainPageState extends State<MyRequestsMainPage> with AutomaticKeepAliveClientMixin{
  int? isSelected = 1;
  bool grandiedAds=false;
  bool grandiedAdsSpace=true;
  bool grandiedGift=true;

  @override
  void initState() {
    super.initState();
    widget.whereTo == null?
    setState(() {
      isSelected = 1;
    }) : widget.whereTo == 'gift'?
    setState(() {
      isSelected = 2;
      grandiedAds=true;
      grandiedAdsSpace=true;
      grandiedGift=false;
    }) : setState(() {
      isSelected = 3;
      grandiedAds=true;
      grandiedAdsSpace=false;
      grandiedGift= true;
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar(requestBar, context),
          body:isDisConnectToInternet_==false?Center(child: internetConnection(context)):
          Column( children: [

            SizedBox(
              height: 26.h,
            ),
            //صف الاختيارات-------------------------------
            drowRowButton(context),
            SizedBox(
              height: 42.h,
            ),
            //النص-------------------------------

            Padding(
              padding: EdgeInsets.only(left: 28.w, right: 28.w),
              child: Align(
                alignment: Alignment.topRight,
                child: text(context,
                    isSelected == 1
                        ?  "طلبات الاعلانات الخاصة بك"
                        : isSelected == 2
                        ? "طلبات الاهداءات الخاصة بك"
                        : "طلبات المساحة الاعلانية الخاصة بك",
                    //,
                    textSubHeadSize,
                    black,

                    fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 20.h,
            ),

            //الطلبات وفق التصنيف-------------------------------

            Expanded(
              flex: 4,
              child: isSelected == 1
                  ?  const MyAdvertisment()
                  : isSelected == 2
                  ?    const MyGift()
                  :    const MyAdSpace(),
            ),
          ]),
        ));
  }

//Selection----------------------------------------------------------------------
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
                  'الاعلانات',
                  14,
                  grandiedAds? black:white,
                      () {
                    setState(() {
                      isSelected = 1;
                      grandiedAdsSpace=true;
                      grandiedAds =false;
                      grandiedGift=true;
                    });
                    print("adv$isSelected");
                  },
                ),
                gradient: grandiedAds
            ),
          ),

          SizedBox(width: 17.w),
//الاهداءات-------------------------------------------------------
          Expanded(
            child: gradientContainer(
                96,
                buttoms(
                  context,
                  'الاهداءات',
                  14,
                  grandiedGift? black:white,
                      () {
                    setState(() {
                      isSelected = 2;
                      grandiedAdsSpace=true;
                      grandiedAds =true;
                      grandiedGift=false;
                    });
                    print("gift$isSelected");
                  },
                ),
                gradient: grandiedGift
            ),
          ),

          SizedBox(width: 17.w),
//المساحة الاعلانية-------------------------------------------------------

          Expanded(
            child: gradientContainer(
                96,
                buttoms(
                  context,
                  'المساحة الاعلانية',
                  14,
                  grandiedAdsSpace? black:white,
                      () {
                    setState(() {
                      isSelected = 3;
                      grandiedAdsSpace=false;
                      grandiedAds =true;
                      grandiedGift=true;
                    });
                    print("space$isSelected");
                  },
                ),
                gradient: grandiedAdsSpace
            ),

          ),
//-------------------------------------------------------
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>  true;
}
