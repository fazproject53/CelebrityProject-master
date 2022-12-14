import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:animations/animations.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../Account/UserForm.dart';
import '../../chat/chat_Screen.dart';
import '../Ads/AdvertisinApi.dart';

bool clickGift = false;

class GiftDetials extends StatefulWidget {
  int? i;
  final String? description;
  final int? price;
  final String? advTitle;
  final String? advType;
  final String? platform;
  final String? token;
  final int? state;
  final int? orderId;
  final String? userImage;
  final String? rejectResonName;
  final int? rejectResonId;
  final String? from;
  final String? to;
  final int userId;
  final String? userName;
  final String? type;
  GiftDetials(
      {Key? key,
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
      this.from,
      this.to,
      required this.userId,
      this.userName,
      this.userImage, this.type})
      : super(key: key);

  @override
  State<GiftDetials> createState() => _GiftDetialsState();
}

class _GiftDetialsState extends State<GiftDetials> {
  int? resonRejectId;
  bool showDetials = true;
  String? resonReject;
  bool isReject = true;
  List<String> rejectResonsList = [];
  List<int> rejectResonsId= [];
  TextEditingController reson = TextEditingController();
  GlobalKey<FormState> resonKey = GlobalKey();
  File? fileVideo;
  String? videoName;
  String? imageURL;
  bool isClicked = false;
  VideoPlayerController? controller;
  @override
  void initState() {
    super.initState();
    getRejectReson();
    print(widget.state);
  }

  @override
  Widget build(BuildContext context) {
    var getSize = MediaQuery.of(context).size;
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
            body: LayoutBuilder(builder: (context, constraints) {
              return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification? overscroll) {
                  overscroll!.disallowGlow();
                  return true;},
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
//order number---------------------------------------------------------
                            Visibility(
                              //visible: showDetials,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.r, vertical: 10.h),
                                child: text(
                                  context,
                                  '?????? ??????????: ' + widget.orderId!.toString(),
                                  textSubHeadSize,
                                  black,
                                  //fontWeight: FontWeight.bold,
                                  align: TextAlign.right,
                                ),
                              ),
                            ),

//details-----------------------------------------------------
                            Visibility(
                              // visible: showDetials,
                              child: Container(
                                padding: EdgeInsets.all(10.r),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: pink,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.r))),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.r, vertical: 5.h),
                                height: MediaQuery.of(context).size.height / 6,
                                child: SingleChildScrollView(
                                  child: Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      text(
                                        context,
                                        '????????????????',
                                        textDetails,
                                        black,
                                        //fontWeight: FontWeight.bold,
                                        align: TextAlign.justify,
                                      ),
                                      text(
                                        context,
                                        widget.description! + '',
                                        textDetails,
                                        white,
                                        fontWeight: FontWeight.bold,
                                        align: TextAlign.justify,
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
//username-----------------------------------------------------------------------------
                            Visibility(
                              //  visible: showDetials,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.r, vertical: 10.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      orders,
                                      color: pink,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    text(
                                      context,
                                      widget.type == 'user'
                                          ? '?????????? ???? ???????????????? ' +
                                          widget.userName!
                                          : '?????????? ???? ?????????????? ' +
                                          widget.userName!,
                                      textSubHeadSize,
                                      black,
                                      //fontWeight: FontWeight.bold,
                                      align: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                            ),
//from to if length long-----------------------------------------------------------------------------
                            Container(
                              //color: black,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.r, vertical: 10.h),
                              child:
//from to if length not long--------------------------------------
                                  Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
//from----------------------------------------------------------------
                                  Row(
                                    children: [
                                      Icon(
                                        gift,
                                        color: pink,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      text(
                                        context,
                                        '???? ' + widget.from!,
                                        textSubHeadSize,
                                        black,
                                        //fontWeight: FontWeight.bold,
                                        align: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
//to----------------------------------------------------------------
                                  Row(
                                    children: [
                                      Icon(gift, color: pink),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      text(
                                        context,
                                        '?????? ' + widget.to!,
                                        textSubHeadSize,
                                        black,
                                        //fontWeight: FontWeight.bold,
                                        align: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
//gift type-----------------------------------------------------------------------------
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.r, vertical: 10.h),
                              child: Row(
                                children: [
                                  Icon(
                                    widget.advType == '??????'
                                        ? voiceIcon
                                        : widget.advType == '??????????'
                                            ? videoIcon
                                            : imageIcon,
                                    color: pink,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  text(
                                    context,
                                    '??????????  ' + '${widget.advType}',
                                    textSubHeadSize,
                                    black,
                                    //fontWeight: FontWeight.bold,
                                    align: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
//------------------------------------------------------------------------------------
                            const Spacer(),
                            Visibility(
                                visible: isReject,
                                child: widget.state == 3 || widget.state == 5
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.r),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                  widget.rejectResonName == null
                                                      ? ''
                                                      : widget.rejectResonName!,
                                                  textSubHeadSize - 1,
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
                                            // widget.state == 4
                                            //     ? "?????? ???????? ??????????"
                                            //     : widget.state == 3
                                            //         ? '????????'
                                            //         : widget.state == 2
                                            //             ? '???????? ???? ????????????????'
                                            //             : widget.state == 6
                                            //                 ? '???? ??????????'
                                            //                 :
                                            widget.state == 6
                                                ? '?????????? ??????????'
                                                : '????????',
                                            SmallbuttomSize,
                                            widget.state == 4 ||
                                                    widget.state == 3 ||
                                                    widget.state == 2 ||
                                                    widget.state == 5 ||
                                                    //widget.state == 6 ||
                                                    widget.state == 7 ||
                                                    widget.state == 8 ||
                                                    widget.state == 9
                                                ? reqGrey!
                                                : white,
                                            widget.state == 4 ||
                                                    widget.state == 3 ||
                                                    widget.state == 2 ||
                                                    widget.state == 5 ||
                                                    // widget.state == 6 ||
                                                    widget.state == 7 ||
                                                    widget.state == 8 ||
                                                    widget.state == 9
                                                ? null
//delivery order==================================================================================
                                                : widget.state == 6
                                                    ? () {
                                                        loadingDialogue(
                                                            context);
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        uploadedVideo()
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          if (value == false) {
                                                            showMassage(
                                                                context,
                                                                '???????????? ??????????????',
                                                                '???????????????? ?????? ??????????');
                                                          } else {
                                                            controller != null
                                                                ? showVideo()
                                                                : const SizedBox();
                                                          }
                                                        });
                                                      }
                                                    : () {
                                                        loadingDialogue(
                                                            context);

                                                        acceptAdvertisingOrder(
                                                                widget.token!,
                                                                widget.orderId!,
                                                                widget.price!)
                                                            .then((value) {
                                                          print(
                                                              'n is : $value');
                                                          if (value == true) {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {
                                                              clickGift = true;
                                                            });
                                                            successfullyDialog(
                                                                context,
                                                                '???? ???????? ?????????? ??????????',
                                                                "assets/lottie/SuccessfulCheck.json",
                                                                '??????????', () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          } else if (value ==
                                                              "SocketException") {
                                                            Navigator.pop(
                                                                context);
                                                            showMassage(
                                                                context,
                                                                '?????????? ???? ????????????????',
                                                                socketException);
                                                          } else if (value ==
                                                              "User is banned!") {
                                                            Navigator.pop(
                                                                context);
                                                            showMassage(
                                                                context,
                                                                '???????????????? ??????????',
                                                                '?????? ?????? ???????? ?????? ????????????????');
                                                          } else if (value ==
                                                              "TimeoutException") {
                                                            Navigator.pop(
                                                                context);
                                                            showMassage(
                                                                context,
                                                                '?????????? ???? ????????????',
                                                                timeoutException);
                                                          } else if (value ==
                                                              'serverException') {
                                                            Navigator.pop(
                                                                context);
                                                            showMassage(
                                                                context,
                                                                '?????????? ???? ????????????',
                                                                serverException);
                                                          } else {
                                                            Navigator.pop(
                                                                context);
                                                            print(
                                                                'n is : $value');
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    snackBar(
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
                                          color: widget.state == 4 ||
                                                  widget.state == 3 ||
                                                  widget.state == 2 ||
                                                  widget.state == 5 ||
                                                  // widget.state == 6 ||
                                                  widget.state == 7 ||
                                                  widget.state == 8 ||
                                                  widget.state == 9
                                              ? reqGrey!
                                              : Colors.transparent,
                                          gradient: widget.state == 4 ||
                                                  widget.state == 3 ||
                                                  widget.state == 2 ||
                                                  widget.state == 5 ||
                                                  // widget.state == 6 ||
                                                  widget.state == 7 ||
                                                  widget.state == 8 ||
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
                                            //     ? "?????? ???????? ?????????? "
                                            //     : widget.state == 4
                                            //         ? '??????'
                                            //         : widget.state == 5
                                            //             ? '?????? ???? ????????????????'
                                            //             : widget.state == 6
                                            //                 ? '??????'
                                            //                 :
                                            '??????',
                                            SmallbuttomSize,
                                            widget.state == 4 ||
                                                    widget.state == 3 ||
                                                    widget.state == 2 ||
                                                    widget.state == 5 ||
                                                    widget.state == 6 ||
                                                    widget.state == 7 ||
                                                    widget.state == 8 ||
                                                    widget.state == 9
                                                ? reqGrey!
                                                : black,
                                            widget.state == 4 ||
                                                    widget.state == 3 ||
                                                    widget.state == 2 ||
                                                    widget.state == 5 ||
                                                    widget.state == 6 ||
                                                    widget.state == 7 ||
                                                    widget.state == 8 ||
                                                    widget.state == 9
                                                ? null
                                                : () {
                                                    rejectResonsList.isNotEmpty
                                                        ? showBottomSheetModel(
                                                            context)
                                                        : '';
                                                  },
                                            //evaluation: 1,
                                          ),
                                          height: 50,
                                          gradient: true,
                                          color: widget.state == 4 ||
                                                  widget.state == 3 ||
                                                  widget.state == 2 ||
                                                  widget.state == 5 ||
                                                  widget.state == 6 ||
                                                  widget.state == 7 ||
                                                  widget.state == 8 ||
                                                  widget.state == 9
                                              ? reqGrey!
                                              : pink,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
//chat---------------------------------------------------------
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: InkWell(
                                                    onTap: widget.state == 3 ||
                                                            widget.state == 5 ||
                                                            widget.state == 7 ||
                                                            widget.state == 8 ||
                                                            widget.state == 9
                                                        ? null
                                                        : () {
                                                            goTopagepush(
                                                                context,
                                                                chatScreen(
                                                                  createUserId:
                                                                      widget
                                                                          .userId,
                                                                  createImage:
                                                                      widget
                                                                          .userImage,
                                                                  createName: widget
                                                                      .userName,
                                                                ));
                                                            // createConversation(widget.userId,
                                                            //         widget.token!)
                                                            //     .then((value) {
                                                            //   if (value == true) {
                                                            //     goTopagepush(
                                                            //         context, chatScreen());
                                                            //   } else if (value ==
                                                            //       "SocketException") {
                                                            //     showMassage(
                                                            //         context,
                                                            //         '?????????? ???? ????????????????',
                                                            //         ' ???????????? ?????????? ?????????????????? ???? ?????????? ???????????? ');
                                                            //   } else if (value ==
                                                            //       "TimeoutException") {
                                                            //     showMassage(
                                                            //         context,
                                                            //         '?????????? ???? ????????????',
                                                            //         'TimeoutException');
                                                            //   } else if (value ==
                                                            //       'serverException') {
                                                            //     showMassage(
                                                            //         context,
                                                            //         '?????????? ???? ????????????',
                                                            //         '?????? ?????? ???? ?????????? ?????????????? ????????????????, ?????????? ?????????????? ??????????');
                                                            //   } else {
                                                            //     showMassage(
                                                            //         context,
                                                            //         '?????????? ???? ????????????',
                                                            //         '?????? ?????? ???? ?????????? ?????????????? ????????????????, ?????????? ?????????????? ??????????');
                                                            //   }
                                                            // });
                                                          },
                                                    child: Icon(
                                                        Icons.forum_outlined,
                                                        color: widget.state ==
                                                                    3 ||
                                                                widget.state ==
                                                                    5 ||
                                                                widget.state ==
                                                                    7 ||
                                                                widget.state ==
                                                                    8 ||
                                                                widget.state ==
                                                                    9
                                                            ? reqGrey!
                                                            : pink)))
                                          ],
                                        ),
                                      ),
                                      //height: 50,
                                      //gradient: true,
                                      //),
                                      //)
                                    ]))
                                :
//confirm reject---------------------------------------------------------------
                                Padding(
                                    padding: EdgeInsets.all(10.0.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.0.w),
                                          child: text(
                                            context,
                                            '?????? ??????????',
                                            textSubHeadSize,
                                            deepgrey!,
                                            fontWeight: FontWeight.bold,
                                            align: TextAlign.right,
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
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
                                                ),
                                              )
                                            : Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0.w),
                                                child: text(
                                                  context,
                                                  '$resonReject',
                                                  textSubHeadSize,
                                                  deepBlack,
                                                  //fontWeight: FontWeight.bold,
                                                  align: TextAlign.right,
                                                ),
                                              ),
                                        SizedBox(height: 10.h
                                            // MediaQuery.of(context).size.height /
                                            //     8
                                            ),
//--------------------------------
                                        //const Spacer(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: gradientContainer(
                                                MediaQuery.of(context).size.width,
                                                buttoms(
                                                  context,
                                                  "??????????",
                                                  largeButtonSize,
                                                  white,
                                                  () {
                                                    FocusManager.instance.primaryFocus
                                                        ?.unfocus();
                                                    if (resonReject == '????????') {
                                                      if (resonKey.currentState
                                                              ?.validate() ==
                                                          true) {
                                                        loadingDialogue(context);
                                                        var result =
                                                            rejectAdvertisingOrder(
                                                                widget.token!,
                                                                widget.orderId!,
                                                                reson.text,
                                                                0);
                                                        result.then((value) {
                                                          if (value == true) {
                                                            Navigator.pop(context);
                                                            setState(() {
                                                              clickGift = true;
                                                            });
                                                            successfullyDialog(
                                                                context,
                                                                '???? ?????? ?????????? ??????????',
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
                                                            ScaffoldMessenger.of(
                                                                    context)
                                                                .showSnackBar(snackBar(
                                                                    context,
                                                                    '???? ?????? ?????????? ??????????',
                                                                    red,
                                                                    error));
                                                          }
                                                        });
                                                      }
                                                    } else {
                                                      loadingDialogue(context);

                                                      rejectAdvertisingOrder(
                                                              widget.token!,
                                                              widget.orderId!,
                                                              resonReject!,
                                                              resonRejectId!)
                                                          .then((value) {
                                                        if (value == true) {
                                                          Navigator.pop(context);
                                                          setState(() {
                                                            clickGift = true;
                                                          });
                                                          successfullyDialog(
                                                              context,
                                                              '???? ?????? ?????????? ??????????',
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
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(snackBar(
                                                                  context,
                                                                  '???? ?????? ?????????? ??????????',
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
                                      ],
                                    ),
                                  ),
                          ]),
                    ),
                  ),
                ),
              );
            })));
  }

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
              SizedBox(
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

  //uploaded Video ====================================================================
  Future uploadedVideo() async {
    var videoPicker = await ImagePicker().getVideo(source: ImageSource.gallery);
    if (videoPicker != null) {
      fileVideo = File(videoPicker.path);
      videoName = path.basename(videoPicker.path);
      final String fileExtension = path.extension(videoName!);
      if (fileExtension == ".mp4") {
        controller = VideoPlayerController.file(fileVideo!);
        await controller?.initialize();
        await controller?.play();
        await controller?.setLooping(true);
        print('*************************************************************');
        print('controller: ${controller?.value.isInitialized}');
        print('*************************************************************');
        print('viduo path: $fileVideo');
        print('*************************************************************');
      } else {
        return false;
      }
    }
  }

//show video=========================================================================
  showVideo() async {
    setState(() {
      isClicked = false;
    });
    showModal(
        configuration: const FadeScaleTransitionConfiguration(
          transitionDuration: Duration(milliseconds: 800),
          reverseTransitionDuration: Duration(milliseconds: 500),
        ),
        context: context,
        builder: (context2) => StatefulBuilder(
              builder: (context2, set) => AlertDialog(
                contentPadding: EdgeInsets.all(0.r),
                titlePadding: EdgeInsets.all(10.r),
                insetPadding: EdgeInsets.all(20.r),
                title: Center(
                  child: text(context, '???????????? ?????? ??????????????', 19, black,
                      fontWeight: FontWeight.bold),
                ),
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.bottomCenter,
                    children: [
                      //video=========================================================================
                      InkWell(
                        onTap: () {
                          controller!.value.isPlaying
                              ? controller!.pause()
                              : controller!.play();

                          set(() {
                            isClicked = !isClicked;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            buildFullScreen(
                              child: AspectRatio(
                                aspectRatio: controller!.value.aspectRatio,
                                child: VideoPlayer(
                                  controller!,
                                ),
                              ),
                            ),
                            Visibility(
                                visible: isClicked == true,
                                child: Icon(playViduo,
                                    size: 80.r, color: Colors.white)),
                          ],
                        ),
                      ),
//Progress bar=========================================================================
                      VideoProgressIndicator(
                        controller!,
                        allowScrubbing: false,
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        colors: const VideoProgressColors(
                            backgroundColor: Colors.grey,
                            bufferedColor: Colors.grey,
                            playedColor: purple),
                      ),

                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
//Bottoms==========================================================================
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: buttoms(context2, '??????????', 14, white, () {
                          Navigator.pop(context2);
                        }, backgrounColor: Colors.grey),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                          child: buttoms(
                        context2,
                        '?????? ??????????',
                        14,
                        white,
                        () {
                          controller?.pause();
                          loadingDialogue(context);
                          deliveryOrder(
                                  widget.token!, widget.orderId!, fileVideo!)
                              .then((value) {
                            if (value == true) {
                              Navigator.pop(context);
                              setState(() {
                                clickGift = true;
                              });
                              print('clickGift : $clickGift');
                              successfullyDialog(
                                  context,
                                  '???? ?????? ?????????? ??????????',
                                  "assets/lottie/SuccessfulCheck.json",
                                  '??????????', () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            } else if (value == "SocketException") {
                              Navigator.pop(context);
                              showMassage(context, '?????????? ???? ????????????????',
                                  socketException);
                            } else if (value == "User is banned!") {
                              Navigator.pop(context);
                              showMassage(context, '???????????????? ??????????',
                                  '?????? ?????? ???????? ?????? ????????????????');
                            } else if (value == "TimeoutException") {
                              Navigator.pop(context);
                              showMassage(
                                  context, '?????????? ???? ????????????', timeoutException);
                            } else if (value == 'serverException') {
                              Navigator.pop(context);
                              showMassage(
                                  context, '?????????? ???? ????????????', serverException);
                            } else {
                              Navigator.pop(context);
                              print('n is : $value');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar(context, '$value', red, error));
                            }
                          });
                        },
                        backgrounColor: purple.withOpacity(0.5),
                      )),
                    ],
                  )
                ],
              ),
            )).then((value) {
      controller?.pause();
      controller?.dispose();
      print(
          'pausepausepausepausepausepausepausepausepausepausepausepausepausepausepausepausepausepause');
    });
  }

//=================================================
  Widget buildFullScreen({required Widget child}) {
    final size = controller?.value.size;
    final width = size?.width;
    final height = size?.height;
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }

//====================================================

}

//
