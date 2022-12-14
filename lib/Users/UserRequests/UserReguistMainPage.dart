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
            //???? ????????????????????-------------------------------
            Expanded(flex: 1, child: drowRowButton(context)),
            SizedBox(
              height: 42.h,
            ),
            //????????-------------------------------

            Padding(
              padding: EdgeInsets.only(left: 28.w, right: 28.w),
              child: Align(
                alignment: Alignment.topRight,
                child: text(
                    context,
                    isSelected == 1
                        ? "?????????? ?????????????????? ???????????? ????"
                        : isSelected == 2
                            ? "?????????? ?????????????????? ???????????? ????"
                            : isSelected == 3
                                ? "?????????? ?????????????? ?????????????????? ???????????? ????"
                                : isSelected == 4
                                    ? "?????????? ?????????? ????????????/?????? ???????????? ????"
                                    : isSelected == 5
                                        ? "?????????? ???????????? ???????????? ????"
                                        : isSelected == 6
                                            ? "??????????????????"
                                            : "????????????????????",
                    //,
                    textSubHeadSize,
                    black,
                    fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: 20.h,
            ),

            //?????????????? ?????? ??????????????-------------------------------

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
//??????????????????-------------------------------------------------------
          Expanded(
            child: gradientContainer(
                96,
                buttoms(
                  context,
                  '??????????????????',
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
//??????????????????-------------------------------------------------------
          Expanded(
            child: gradientContainer(
                96,
                buttoms(
                  context,
                  '??????????????????',
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
//?????????????? ??????????????????-------------------------------------------------------

          Expanded(
            child: gradientContainer(
                96,
                buttoms(
                  context,
                  '?????????????? ??????????????????',
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
// // //??????????????????-------------------------------------------------------
// //           Expanded(
// //             child: gradientContainer(
// //                 96,
// //                 buttoms(
// //                   context,
// //                   '??????????????????',
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
// // //??????????????????-------------------------------------------------------
// //           Expanded(
// //             child: gradientContainer(
// //                 96,
// //                 buttoms(
// //                   context,
// //                   '??????????????????',
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
// // //?????????????? ??????????????????-------------------------------------------------------
// //
// //           Expanded(
// //             child: gradientContainer(
// //                 96,
// //                 buttoms(
// //                   context,
// //                   '?????????????? ??????????????????',
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
