import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/UserRequests/UserCelebrate.dart';
import 'package:celepraty/Users/UserRequests/UserMeating.dart';
import 'package:celepraty/Users/UserRequests/UserShare.dart';
import 'package:celepraty/Users/UserRequests/UserSuggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'UserAds/UserAdvertisments.dart';
import 'UserAdvSpace/UserAdSpace.dart';
import 'UserGift/UserGift.dart';

class UserRequestMainPage extends StatefulWidget {
  final String? whereTo;
  const UserRequestMainPage({Key? key, this.whereTo}) : super(key: key);

  @override
  State<UserRequestMainPage> createState() => _UserRequestMainPageState();
}

class _UserRequestMainPageState extends State<UserRequestMainPage> {
  int? isSelected = 1;
  bool grandiedAds = false;
  bool grandiedAdsSpace = true;
  bool grandiedGift = true;
//--------------------------
  bool grandiedMeting = true;
  bool grandiedCelebrate = true;
  bool grandiedShare = true;
  bool grandiedSuggestion = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.whereTo == null
        ? setState(() {
            isSelected = 1;
          })
        : widget.whereTo == 'gift'
            ? setState(() {
                isSelected = 2;
                grandiedAds = true;
                grandiedAdsSpace = true;
                grandiedGift = false;
              })
            : setState(() {
                isSelected = 3;
                grandiedAds = true;
                grandiedAdsSpace = false;
                grandiedGift = true;
              });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar(requestBar, context),
          body: Column(children: [
            SizedBox(
              height: 26.h,
            ),
            //صف الاختيارات-------------------------------
            Expanded(flex: 1, child: drowRowButton(context)),
            SizedBox(
              height: 42.h,
            ),
            //النص-------------------------------

            Padding(
              padding: EdgeInsets.only(left: 28.w, right: 28.w),
              child: Align(
                alignment: Alignment.topRight,
                child: text(
                    context,
                    isSelected == 1
                        ? "طلبات الاعلانات الخاصة بك"
                        : isSelected == 2
                            ? "طلبات الاهداءات الخاصة بك"
                            : isSelected == 3
                                ? "طلبات المساحة الاعلانية الخاصة بك"
                                : isSelected == 4
                                    ? "طلبات تدشين افتتاح/حفل الخاصة بك"
                                    : isSelected == 5
                                        ? "طلبات اللقاء الخاصة بك"
                                        : isSelected == 6
                                            ? "الابداعات"
                                            : "الاقتراحات",
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
              flex: 8,
              child: isSelected == 1
                  ? const UserAdvertisment()
                  : isSelected == 2
                      ? const UserGift()
                      : isSelected == 3
                          ? const UserAdSpace()
                          : isSelected == 4
                              ? const UserCelebrate()
                              : isSelected == 5
                                  ? const UserMeating()
                                  : isSelected == 6
                                      ? const UserShare()
                                      : const UserSuggestion(),
            ),
          ]),
        ));
  }

//Selection----------------------------------------------------------------------
  Widget drowRowButton(BuildContext context) {
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
                  grandiedAds ? black : white,
                  () {
                    setState(() {
                      isSelected = 1;
                      grandiedAdsSpace = true;
                      grandiedAds = false;
                      grandiedGift = true;
                    });
                    print("adv$isSelected");
                  },
                ),
                gradient: grandiedAds),
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
                  grandiedGift ? black : white,
                  () {
                    setState(() {
                      isSelected = 2;
                      grandiedAdsSpace = true;
                      grandiedAds = true;
                      grandiedGift = false;
                    });
                    print("gift$isSelected");
                  },
                ),
                gradient: grandiedGift),
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
                  grandiedAdsSpace ? black : white,
                  () {
                    setState(() {
                      isSelected = 3;
                      grandiedAdsSpace = false;
                      grandiedAds = true;
                      grandiedGift = true;
                    });
                    print("space$isSelected");
                  },
                ),
                gradient: grandiedAdsSpace),
          ),
//-------------------------------------------------------
        ],
      ),
    );
  }
}

//Selection----------------------------------------------------------------------
// Widget drowRowButton(BuildContext context) {
//   return Padding(
//     padding: EdgeInsets.only(left: 0.w, right: 20.w),
//     child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.all(5.r),
//         addAutomaticKeepAlives: true,
//         itemCount: 7,
//         itemBuilder: (context, index) {
//           return Row(
//             children: [
//               gradientContainer(
//                   110,
//                   buttoms(
//                     context,
//                     names[index],
//                     14,
//                     grandiedAds ? black : white,
//                         () {
//                       setState(() {
//                         isSelected = 1;
//                         grandiedAdsSpace = true;
//                         grandiedAds = false;
//                         grandiedGift = true;
//                       });
//                       print("adv$isSelected");
//                     },
//                   ),
//                   gradient: grandiedAds),
//               SizedBox(
//                 width: 10.w,
//               )
//             ],
//           );
//         }),
//   );
//
// //       Padding(
// //       padding: EdgeInsets.only(left: 28.w, right: 28.w),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// // //الاعلانات-------------------------------------------------------
// //           Expanded(
// //             child: gradientContainer(
// //                 96,
// //                 buttoms(
// //                   context,
// //                   'الاعلانات',
// //                   14,
// //                   grandiedAds ? black : white,
// //                   () {
// //                     setState(() {
// //                       isSelected = 1;
// //                       grandiedAdsSpace = true;
// //                       grandiedAds = false;
// //                       grandiedGift = true;
// //                     });
// //                     print("adv$isSelected");
// //                   },
// //                 ),
// //                 gradient: grandiedAds),
// //           ),
// //
// //           SizedBox(width: 17.w),
// // //الاهداءات-------------------------------------------------------
// //           Expanded(
// //             child: gradientContainer(
// //                 96,
// //                 buttoms(
// //                   context,
// //                   'الاهداءات',
// //                   14,
// //                   grandiedGift ? black : white,
// //                   () {
// //                     setState(() {
// //                       isSelected = 2;
// //                       grandiedAdsSpace = true;
// //                       grandiedAds = true;
// //                       grandiedGift = false;
// //                     });
// //                     print("gift$isSelected");
// //                   },
// //                 ),
// //                 gradient: grandiedGift),
// //           ),
// //
// //           SizedBox(width: 17.w),
// // //المساحة الاعلانية-------------------------------------------------------
// //
// //           Expanded(
// //             child: gradientContainer(
// //                 96,
// //                 buttoms(
// //                   context,
// //                   'المساحة الاعلانية',
// //                   14,
// //                   grandiedAdsSpace ? black : white,
// //                   () {
// //                     setState(() {
// //                       isSelected = 3;
// //                       grandiedAdsSpace = false;
// //                       grandiedAds = true;
// //                       grandiedGift = true;
// //                     });
// //                     print("space$isSelected");
// //                   },
// //                 ),
// //                 gradient: grandiedAdsSpace),
// //           ),
// // //-------------------------------------------------------
// //         ],
// //       ),
// //     );
// }
