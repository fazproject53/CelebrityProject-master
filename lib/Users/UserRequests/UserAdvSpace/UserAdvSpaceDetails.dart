import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../Account/UserForm.dart';
import '../../../Celebrity/Requests/DownloadImages.dart';
import '../../../Models/Methods/method.dart';
import '../../../Models/Variables/Variables.dart';
import '../../Exploer/viewDataImage.dart';
import '../../chat/chatRoom.dart';
import '../UserAds/UserAdsOrdersApi.dart';

bool clickUserAdvSpace = false;

class UserAdvSpaceDetails extends StatefulWidget {
  int? i;
  final String? image;
  final String? description;
  final int? price;
  final String? advTitle;
  final String? advType;
  final String? platform;
  final String? token;
  final int? state;
  final int? orderId;
  final String? rejectResonName;
  final int? rejectResonId;
  final String? rejectResonNameAdmin;
  final String? link;
  final int userId;
  final String? celImage;
  final String? celebrityName;
  final int? celebrityId;
  final String? commercialRecord;
  UserAdvSpaceDetails({
    Key? key,
    this.description,
    this.price,
    this.advTitle,
    this.advType,
    this.platform,
    this.token,
    this.state,
    this.orderId,
    this.rejectResonName,
    this.rejectResonId,
    this.i,
    this.image,
    this.link,
    required this.userId,
    this.celImage,
    this.celebrityName,
    this.celebrityId,
    this.commercialRecord,
    this.rejectResonNameAdmin,
  }) : super(key: key);

  @override
  State<UserAdvSpaceDetails> createState() => _UserAdvSpaceDetailsState();
}

class _UserAdvSpaceDetailsState extends State<UserAdvSpaceDetails> {
  bool showDetials = true;
  int? resonRejectId;
  String? resonReject;
  bool isReject = true;
  List<String> rejectResonsList = [];
  List<int> rejectResonsId= [];
  TextEditingController reson = TextEditingController();
  GlobalKey<FormState> resonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getRejectReson();
    print(rejectResonsList);
    print(widget.commercialRecord);
    print('state ${widget.state}');
    print('price ${widget.price}');
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      setState(() {
        showDetials = false;
      });
    } else {
      setState(() {
        showDetials = true;
      });
    }
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: drowAppBar("???????????? ??????????", context),
            body: Container(
              //color: black,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
//title----------------------------------------------------------
                  Container(
                    // height: MediaQuery.of(context).size.height/4,
                    width: MediaQuery.of(context).size.width,
                    //color: red,
                    margin: EdgeInsets.symmetric(horizontal: 20.r),
                    child: text(
                      context,
                      '?????? ??????????: ' + widget.orderId!.toString(),
                      textSubHeadSize,
                      black,
                      //fontWeight: FontWeight.bold,
                      align: TextAlign.right,
                    ),
                  ),
//price----------------------------------------------------------
                  Container(
                    // height: MediaQuery.of(context).size.height/4,
                    width: MediaQuery.of(context).size.width,
                    //color: red,
                    margin: EdgeInsets.symmetric(horizontal: 20.r),
                    child: text(
                      context,
                      '?????? ??????????????: ' + widget.price!.toString() + ' ??.??',
                      textSubHeadSize,
                      black,
                      //fontWeight: FontWeight.bold,
                      align: TextAlign.right,
                    ),
                  ),
//image----------------------------------------------------------
                  Visibility(
                    visible: showDetials,
                    child: SizedBox(
                      height: 200.h,
                      child: InkWell(
                        onTap: () async {
                          var found = await getExistImage(widget.image!);
                          print(found);
                          goTopagepush(
                              context,
                              DownloadImages(
                                image:found==false? widget.image!:found,
                                fromDevice: found==false?false:true,
                              ));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 20.r),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              image: DecorationImage(
                                  image: NetworkImage
                                  //CachedNetworkImageProvider
                                    (
                                    widget.image!,
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
//link------------------------------------------------------------------------
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.r),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.ads_click,
                          color: pink,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        InkWell(
                          onTap: () async {
                            var url = widget.link!;
                            if (await canLaunch(url.toString())) {
                              await launch(url.toString());
                            } else {
                              showMassage(context, '???????????? ?????? ??????????',
                                  '???????????? ?????? ????????');
                            }
                          },
                          child: text(
                            context,
                            '???????? ???????????? ????????????????????  ',
                            textSubHeadSize,
                            black,
                            //fontWeight: FontWeight.bold,
                            align: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //SizedBox(height: 10.h),
//commercialRecord-------------------------------------------------------------------------------
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.h),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description,
                          color: pink,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        InkWell(
                          onTap: () async {
                            if (widget.commercialRecord!.isEmpty) {
                              showMassage(context, '???????????? ??????????',
                                  '???????????? ?????? ?????????? ?????????? ??????????');
                            } else if (widget.commercialRecord
                                        ?.contains('.jpg') ==
                                    true ||
                                widget.commercialRecord?.contains('.png') ==
                                    true) {
                              print('immmmmmmmmmmmmmmmmmmmmmmage file');
                              goTopagepush(
                                  context,
                                  DownloadImages(
                                    image: widget.commercialRecord!,
                                  ));
                            } else if (widget.commercialRecord
                                    ?.contains('.pdf') ==
                                true) {
                              openFile(url: widget.commercialRecord!);
                            } else {
                              showMassage(
                                  context,
                                  '???????????? ?????? ??????????',
                                  ' png ' +
                                      ' ???? ' +
                                      ' jpg ' +
                                      ' pdf ' +
                                      '???????? ?????????? ?????? ???????????? ?????? ???? ???????? ');
                            }
                          },
                          child: text(
                            context,
                            '?????????? ??????????????',
                            textSubHeadSize,
                            black,
                            //fontWeight: FontWeight.bold,
                            align: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
//reject reson -----------------------------------------------------
                  Visibility(
                      visible: isReject,
                      child: widget.state == 3 ||
                              widget.state == 5 ||
                              widget.state == 8
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.r),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.quiz,
                                          color: pink,
                                          size: 25.r,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        text(
                                          context,
                                          '?????? ??????????',
                                          textSubHeadSize,
                                          black,
                                          //fontWeight: FontWeight.bold,
                                          align: TextAlign.right,
                                        ),
                                      ],
                                    ),
//-------------------------------
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      child: text(
                                        context,
                                        widget.state == 8
                                            ? '${widget.rejectResonNameAdmin}'
                                            : widget.rejectResonName!,
                                        textSubHeadSize-1,
                                        deepBlack,
                                        //fontWeight: FontWeight.bold,
                                        align: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          :
//price field-------------------------------------------------------------------------------
                          const SizedBox()),
//accept buttom-----------------------------------------------------

                  isReject
                      ? Container(
                          width: double.infinity,
                          height: 50,
                          //color: Colors.red,
                          margin: EdgeInsets.all(20.r),
                          child: Row(children: [
                            Expanded(
                              flex: 2,
                              child: gradientContainer(
                                double.infinity,
                                buttoms(
                                  context,
                                  widget.state == 4 ? "???????? ????????" : '????????',
                                  //         : widget.state == 2
                                  //             ? '???????? ???? ????????????????'
                                  //             : widget.state == 6
                                  //                 ? '???? ??????????'
                                  //                 : widget.state == 1
                                  //                     ? '?????? ????????????????'
                                  //                     :

                                  SmallbuttomSize,
                                  widget.state == 3 ||
                                          widget.state == 1 ||
                                          widget.state == 2 ||
                                          widget.state == 5 ||
                                          widget.state == 6 ||
                                          widget.state == 7 ||
                                          widget.state == 8||
                                      widget.state == 9
                                      ? reqGrey!
                                      : white,
                                  widget.state == 3 ||
                                          widget.state == 1 ||
                                          widget.state == 2 ||
                                          widget.state == 5 ||
                                          widget.state == 6 ||
                                          widget.state == 7 ||
                                          widget.state == 8||
                                      widget.state == 9
                                      ? null
                                      : widget.state == 4

//Payment Orders==============================================================================
                                          ? () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              failureDialog(
                                                  context,
                                                  '?????????? ??????????',
                                                  '???? ?????? ?????????? ???? ?????????? ?????????? ????????????',
                                                  "assets/lottie/payment.json",
                                                  '??????', () {
                                                Navigator.pop(context);
                                                loadingDialogue(context);

                                                paymentOrder(
                                                        widget.token!,
                                                        widget.orderId!,
                                                        int.parse('3'))
                                                    .then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      clickUserAdvSpace = true;
                                                    });
                                                    successfullyDialog(
                                                        context,
                                                        '???? ?????????? ??????????',
                                                        "assets/lottie/SuccessfulCheck.json",
                                                        '??????????', () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    });
                                                  } else if (value ==
                                                      "SocketException") {
                                                    Navigator.pop(context);
                                                    showMassage(
                                                        context,
                                                        '?????????? ???? ????????????????',
                                                        socketException);
                                                  } else if (value ==
                                                      'Insufficient balance!') {
                                                    Navigator.pop(context);
                                                    showMassage(
                                                        context,
                                                        '???????????? ?????? ????????',
                                                        '???????? ?????????? ?????? ???????? ???????????? ?????????? ?????? ???????????? ???? ?????????? ?????????? ?????????? ???????????? ???????????? ?????????? ??????????');
                                                  } else if (value ==
                                                      "TimeoutException") {
                                                    Navigator.pop(context);
                                                    showMassage(
                                                        context,
                                                        '?????????? ???? ????????????',
                                                        timeoutException);
                                                  } else if (value ==
                                                      'serverException') {
                                                    Navigator.pop(context);
                                                    showMassage(
                                                        context,
                                                        '?????????? ???? ????????????',
                                                        serverException);
                                                  } else {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar(
                                                            context,
                                                            '???? ???????? ?????????? ??????????',
                                                            red,
                                                            error));
                                                  }
                                                });
                                              }, bottomColor: pink);
                                            }

//End Payment Orders==============================================================================

                                          : () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              loadingDialogue(context);

                                              userAcceptAdvertisingOrder(
                                                      widget.token!,
                                                      widget.orderId!,
                                                      int.parse(''))
                                                  .then((value) {
                                                if (value == true) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    clickUserAdvSpace = true;
                                                  });
                                                  successfullyDialog(
                                                      context,
                                                      '???? ???????? ?????????? ??????????',
                                                      "assets/lottie/SuccessfulCheck.json",
                                                      '??????????', () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                } else if (value ==
                                                    "SocketException") {
                                                  Navigator.pop(context);
                                                  showMassage(
                                                      context,
                                                      '?????????? ???? ????????????????',
                                                      socketException);
                                                } else if (value ==
                                                    "User is banned!") {
                                                  Navigator.pop(context);
                                                  showMassage(
                                                      context,
                                                      '?????? ???? ?????????? ??????????',
                                                      '???? ?????????? ?????????? ???????? ?????????? ???????????? ???????????? ?????????? ??????????');
                                                } else if (value ==
                                                    "TimeoutException") {
                                                  Navigator.pop(context);
                                                  showMassage(
                                                      context,
                                                      '?????????? ???? ????????????',
                                                      timeoutException);
                                                } else if (value ==
                                                    'serverException') {
                                                  Navigator.pop(context);
                                                  showMassage(
                                                      context,
                                                      '?????????? ???? ????????????',
                                                      serverException);
                                                } else {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar(
                                                          context,
                                                          '???? ???????? ?????????? ??????????',
                                                          red,
                                                          error));
                                                }
                                              });
                                            },
                                  evaluation: 0,
                                ),
                                height: 50,
                                color: widget.state == 3 ||
                                        widget.state == 1 ||
                                        widget.state == 2 ||
                                        widget.state == 5 ||
                                        widget.state == 6 ||
                                        widget.state == 7 ||
                                        widget.state == 8||
                                    widget.state == 9
                                    ? reqGrey!
                                    : Colors.transparent,
                                gradient: widget.state == 3 ||
                                        widget.state == 1 ||
                                        widget.state == 2 ||
                                        widget.state == 5 ||
                                        widget.state == 6 ||
                                        widget.state == 7 ||
                                        widget.state == 8||
                                    widget.state == 9
                                    ? true
                                    : false,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),

//reject buttom-------------------------------------------------

                            Expanded(
                              flex: 2,
                              child: gradientContainer(
                                double.infinity,
                                buttoms(
                                  context,
                                  // widget.state == 3
                                  //     ? "?????? ???? ??????????????"
                                  //     : widget.state == 4
                                  //         ? '??????'
                                  //         : widget.state == 5
                                  //             ? '?????? ???? ????????????????'
                                  //             : widget.state == 6
                                  //                 ? '??????'
                                  //                 :
                                  '?????????? ??????????',
                                  SmallbuttomSize,
                                  widget.state == 3 ||
                                          widget.state == 4 ||
                                          widget.state == 5 ||
                                          widget.state == 2 ||
                                          widget.state == 6 ||
                                          //widget.state == 7 ||
                                          widget.state == 8||
                                      widget.state == 9
                                      ? reqGrey!
                                      : black,
                                  widget.state == 4 ||
                                          widget.state == 3 ||
                                          widget.state == 5 ||
                                          widget.state == 2 ||
                                          widget.state == 6 ||
                                          //widget.state == 7 ||
                                          widget.state == 8||
                                      widget.state == 9
                                      ? null
                                      : () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          rejectResonsList.isNotEmpty
                                              ? showBottomSheetModel(context)
                                              : '';
                                        },
                                  //evaluation: 1,
                                ),
                                height: 50,
                                gradient: true,
                                color: widget.state == 3 ||
                                        widget.state == 4 ||
                                        widget.state == 5 ||
                                        widget.state == 2 ||
                                        widget.state == 6 ||
                                        //widget.state == 7 ||
                                        widget.state == 8||
                                    widget.state == 9
                                    ? reqGrey!
                                    : pink,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
//---------------------------------------------------------
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                       flex: 1,
//                                       child: InkWell(
//                                           onTap: widget.state == 3 ||
//                                                   widget.state == 5 ||
//                                                   widget.state == 7 ||
//                                                   widget.state == 8
//                                               ? null
//                                               : () {
//                                                   goTopagepush(
//                                                       context,
//                                                       chatRoom(
//                                                         createUserId:
//                                                             widget.celebrityId,
//                                                         createName: widget
//                                                             .celebrityName,
//                                                         createImage:
//                                                             widget.celImage,
//                                                       ));
//                                                   // userCreateConversation(widget.userId,
//                                                   //     widget.token!)
//                                                   //     .then((value) {
//                                                   //   if (value == true) {
//                                                   //     goTopagepush(context, chatRoom());
//                                                   //   } else if (value == "SocketException") {
//                                                   //     showMassage(context, '?????????? ???? ????????????????',
//                                                   //         ' ???????????? ?????????? ?????????????????? ???? ?????????? ???????????? ');
//                                                   //   } else if (value == "TimeoutException") {
//                                                   //     showMassage(context, '?????????? ???? ????????????', 'TimeoutException');
//                                                   //   } else if (value == 'serverException') {
//                                                   //     showMassage(context, '?????????? ???? ????????????',
//                                                   //         '?????? ?????? ???? ?????????? ?????????????? ????????????????, ?????????? ?????????????? ??????????');
//                                                   //   } else {
//                                                   //     showMassage(context, '?????????? ???? ????????????',
//                                                   //         '?????? ?????? ???? ?????????? ?????????????? ????????????????, ?????????? ?????????????? ??????????');
//                                                   //
//                                                   //   }
//                                                   // });
//                                                 },
//                                           child: Icon(Icons.forum_outlined,
//                                               color: widget.state == 3 ||
//                                                       widget.state == 5 ||
//                                                       widget.state == 7 ||
//                                                       widget.state == 8
//                                                   ? reqGrey!
//                                                   : pink)))
//                                 ],
//                               ),
//                             ),
                            //height: 50,
                            //gradient: true,
                            //),
                            //)
                          ]))
                      :
                      //confirm reject---------------------------------------------------------------
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 4.0.w),
                                child: text(
                                  context,
                                  '?????? ??????????',
                                  17,
                                  black,
                                  //fontWeight: FontWeight.bold,
                                  align: TextAlign.right,
                                ),
                              ),
                              SizedBox(height: 10.h),
//-------------------------------------------------------------------------
                              resonReject == '????????'
                                  ? Form(
                                      key: resonKey,
                                      child: textField2(
                                          context,
                                          Icons.unpublished,
                                          '',
                                          textFieldSize,
                                          false,
                                          reson,
                                          empty,
                                          hitText: '???????? ?????? ??????????'),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.r),
                                      child: text(
                                        context,
                                        '$resonReject',
                                        textSubHeadSize,
                                        black,
                                        //fontWeight: FontWeight.bold,
                                        align: TextAlign.right,
                                      ),
                                    ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 55),
                              //--------------------------------
                              //const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.0.h),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: gradientContainer(
                                        double.infinity,
                                        buttoms(
                                          context,
                                          "??????????",
                                          largeButtonSize,
                                          white,
                                          () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            if (resonReject == '????????') {
                                              if (resonKey.currentState?.validate() ==
                                                  true) {
                                                loadingDialogue(context);

                                                userRejectAdvertisingOrder(
                                                        widget.token!,
                                                        widget.orderId!,
                                                        reson.text,
                                                        0)
                                                    .then((value) {
                                                  if (value == true) {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      clickUserAdvSpace = true;
                                                    });
                                                    successfullyDialog(
                                                        context,
                                                        '???? ?????????? ?????????? ??????????',
                                                        "assets/lottie/SuccessfulCheck.json",
                                                        '??????????', () {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    });
                                                  } else if (value ==
                                                      "SocketException") {
                                                    Navigator.pop(context);
                                                    showMassage(
                                                        context,
                                                        '?????????? ???? ????????????????',
                                                        socketException);
                                                  } else if (value ==
                                                      "TimeoutException") {
                                                    Navigator.pop(context);
                                                    showMassage(
                                                        context,
                                                        '?????????? ???? ????????????',
                                                        timeoutException);
                                                  } else if (value ==
                                                      'serverException') {
                                                    Navigator.pop(context);
                                                    showMassage(
                                                        context,
                                                        '?????????? ???? ????????????',
                                                        serverException);
                                                  } else {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(snackBar(
                                                            context,
                                                            '???? ?????????? ?????? ?????????????? ??????????',
                                                            red,
                                                            error));
                                                  }
                                                });
                                              }
                                            } else {
                                              loadingDialogue(context);

                                              userRejectAdvertisingOrder(
                                                      widget.token!,
                                                      widget.orderId!,
                                                      resonReject!,
                                                      resonRejectId!)
                                                  .then((value) {
                                                if (value == true) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    clickUserAdvSpace = true;
                                                  });
                                                  successfullyDialog(
                                                      context,
                                                      '???? ?????????? ?????????? ??????????',
                                                      "assets/lottie/SuccessfulCheck.json",
                                                      '??????????', () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  });
                                                } else if (value ==
                                                    "SocketException") {
                                                  Navigator.pop(context);
                                                  showMassage(
                                                      context,
                                                      '?????????? ???? ????????????????',
                                                      socketException);
                                                } else if (value ==
                                                    "TimeoutException") {
                                                  Navigator.pop(context);
                                                  showMassage(
                                                      context,
                                                      '?????????? ???? ????????????',
                                                      timeoutException);
                                                } else if (value ==
                                                    'serverException') {
                                                  Navigator.pop(context);
                                                  showMassage(
                                                      context,
                                                      '?????????? ???? ????????????',
                                                      serverException);
                                                } else {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar(
                                                          context,
                                                          '???? ?????????? ?????? ?????????????? ??????????',
                                                          red,
                                                          error));
                                                }
                                              });
                                            }
                                          },
                                          evaluation: 0,
                                        ),
                                        height: 50,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25.w,
                                    ),
//cancel reject order========================================================================================================
                                    Expanded(
                                      child: gradientContainer(
                                          MediaQuery.of(context).size.width,
                                          buttoms(
                                            context,
                                            "??????????",
                                            largeButtonSize,
                                            black,
                                                () {
                                              FocusManager
                                                  .instance.primaryFocus
                                                  ?.unfocus();
                                              setState(() {
                                                isReject = true;
                                              });
                                              //
                                            },
                                            evaluation: 0,
                                          ),
                                          height: 50,
                                          color: pink,
                                          gradient: true),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            )));
  }

/*
*
* */
  //----------------------------------------------------------------------------------------------
  showBottomSheetModel(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        elevation: 10,
        backgroundColor: black,
        //isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(70.r), topLeft: Radius.circular(70.r)),
          //side: BorderSide(color: Colors.white, width: 1),
        ),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 20),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(50.r))),
                  width: MediaQuery.of(context).size.width / 9,
                  height: 4.h,
                ),
              ),
              const SizedBox(
                  //height: 15.h,
                  ),
//Reject reson-----------------------------------------------------------------------------
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2.7.h,
                  child: ListView.builder(
                      itemCount: rejectResonsList.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0.w, vertical: 3.h),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                resonReject = rejectResonsList[i];
                                resonRejectId = rejectResonsId.elementAt(i);
                                isReject = false;
                              });
                              print('resonReject: $resonReject');
                              print('resonRejectId: $resonRejectId');
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 46.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                  color: deepPink),
                              child: Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: text(
                                  context,
                                  rejectResonsList[i],
                                  textTitleSize,
                                  white,
                                  fontWeight: FontWeight.bold,
                                  align: TextAlign.right,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
//Another reson-----------------------------------------------------------------------------

              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 3.h),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      resonReject = '????????';
                      isReject = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 46.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0.r),
                        color: deepPink),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: text(
                        context,
                        '????????',
                        textTitleSize,
                        white,
                        fontWeight: FontWeight.bold,
                        align: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

//-------------------------------------------------------------------------
  void getRejectReson() async {
    rejectResonsList.clear();
    rejectResonsId.clear();
    String url = "https://mobile.celebrityads.net/api/reject-resons";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (int i = 0; i < body['data'].length; i++) {

        // if (mounted) {
        setState(() {
          rejectResonsList.add(body['data'][i]['name']);
          rejectResonsId.add(body['data'][i]['id']);
        });
        // }
      }
      print('rejectResonsList: $rejectResonsList');
      print('rejectResonsId: $rejectResonsId');
    } else {
      throw Exception('Failed to load celebrity Reject reson');
    }
  }
  ///Open file==========================================
  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;

    bool b =  File('/data/user/0/com.example.celepraty/app_flutter/'+ name).existsSync();
    print(b.toString()+ '---------------------------------------');
    loadingDialogue(context);
    final file =b? File('/data/user/0/com.example.celepraty/app_flutter/'+ name): await downloadFile(url, name);
    Navigator.pop(context);

    if(file == null) return;

    print('Path IS: ${file.path}');

    OpenFile.open(file.path);

  }

  ///Download file into private folder not visible to user
  Future<File>? downloadFile(String url, String name) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    loadingDialogue(context);
    try {
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      Navigator.pop(context);
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return file;
    }
  }
}
