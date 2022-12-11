import 'dart:convert';

import 'package:celepraty/Celebrity/HomeScreen/celebrity_home_page.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/chat/chatRoom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../../Account/UserForm.dart';
import '../UserAds/UserAdsOrdersApi.dart';

bool clickUserGift = false;

class UserGiftDetials extends StatefulWidget {
  final int? i;
  final String? description;
  final String? image;
  final String? advTitle;
  final String? platform;
  final String? token;
  final int? state;
  final int? orderId;
  final int? price;
  final String? rejectResonName;
  final String? rejectResonNameAdmin;
  final int? rejectResonId;
  final String? celebrityName;
  final int? celebrityId;
  final String? celebrityImage;
  final String? celebrityPagUrl;
  final String? time;
  final String? from;
  final String? to;
  final String? advType;
  final int userId;
  final String? celImage;
  const UserGiftDetials({
    Key? key,
    this.i,
    this.description,
    this.image,
    this.advTitle,
    this.platform,
    this.token,
    this.orderId,
    this.state,
    this.price,
    this.rejectResonName,
    this.rejectResonId,
    this.celebrityName,
    this.celebrityId,
    this.celebrityImage,
    this.celebrityPagUrl,
    this.time,
    this.from,
    this.to,
    this.advType,
    required this.userId,
    this.celImage,
    this.rejectResonNameAdmin,
  }) : super(key: key);

  @override
  State<UserGiftDetials> createState() => _UserGiftDetialsState();
}

class _UserGiftDetialsState extends State<UserGiftDetials>
    with AutomaticKeepAliveClientMixin {
  int? resonRejectId;
  bool showDetials = true;
  List<String> rejectResonsList = [];
  String? resonReject;
  bool isReject = true;
  TextEditingController? price;
  TextEditingController reson = TextEditingController();
  GlobalKey<FormState> priceKey = GlobalKey();
  GlobalKey<FormState> resonKey = GlobalKey();

  @override
  void initState() {

    super.initState();
    getRejectReson();
    print(widget.state);
    price = widget.price! > 0
        ? TextEditingController(text: '${widget.price}')
        : TextEditingController();
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
          resizeToAvoidBottomInset: false,
          appBar: drowAppBar("تفاصيل الطلب", context),
          body: Column(children: [
//image-----------------------------------------------------
            Visibility(
              visible: showDetials,
              child: Container(
                width: double.infinity,
                // height: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 5.h),
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.44),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
//order number--------------------------------------------------------
                        Expanded(
                          flex: 3,
                          child: text(
                            context,
                            'رقم الطلب: ' + widget.orderId!.toString(),
                            textSubHeadSize,
                            black,
                            //fontWeight: FontWeight.bold,
                            align: TextAlign.justify,
                          ),
                        ),
                        // Spacer(),
//price----------------------------------------------------------------
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              //boxShadow: const [BoxShadow(blurRadius: 2)],
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.r),
                              ),
                            ),
                            padding: EdgeInsets.all(2.r),
                            child: Center(
                              child: text(
                                context,
                                '' + widget.price!.toString() + ' ر.س',
                                textSubHeadSize,
                                black,
                                //fontWeight: FontWeight.bold,
                                align: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
//describe-------------------------------------------------------------------------
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {
                              goTopagepush(
                                  context,
                                  CelebrityHome(
                                    pageUrl: widget.celebrityPagUrl,
                                  ));
                            },
                            child: text(
                              context,
                              'من ' + widget.celebrityName!,
                              textSubHeadSize,
                              black,
                              //fontWeight: FontWeight.bold,
                              align: TextAlign.justify,
                            ),
                          ),
                        ),
                        const Spacer(),
//celebrate image----------------------------------------------------------------
                        Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                goTopagepush(
                                    context,
                                    CelebrityHome(
                                      pageUrl: widget.celebrityPagUrl,
                                    ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(44.r),
                                child: CircleAvatar(
                                  radius: 44.r,
                                  backgroundColor:
                                      Colors.amber.withOpacity(0.25),
                                  backgroundImage: NetworkImage(
                                    widget.celebrityImage!,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
//from -----------------------------------------------------

//from to if length long-----------------------------------------------------------------------------
            Container(
              //color: black,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.h),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child:
//from to if length not long--------------------------------------
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            'من ' + widget.from!,
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
                            'الى ' + widget.to!,
                            textSubHeadSize,
                            black,
                            //fontWeight: FontWeight.bold,
                            align: TextAlign.justify,
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 5.w,
            ),
//description----------------------------------------------------------------------
            Container(
                padding: EdgeInsets.all(10.r),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 8,
                decoration: BoxDecoration(
                    color: pink,
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
                margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 5.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        context,
                        'التفاصيل',
                        textDetails,
                        black,
                        //fontWeight: FontWeight.bold,
                        align: TextAlign.justify,
                      ),
                      text(
                        context,
                        widget.description!,
                        textDetails,
                        white,
                        fontWeight: FontWeight.bold,
                        align: TextAlign.justify,
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 10.h,
            ),
//occasion ----------------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Row(
                children: [
                  Icon(
                    widget.advType == 'صوت'
                        ? voiceIcon
                        : widget.advType == 'فيديو'
                            ? videoIcon
                            : imageIcon,
                    color: pink,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  text(
                    context,
                    'اهداء  ' + '${widget.advType}',
                    textSubHeadSize,
                    black,
                    //fontWeight: FontWeight.bold,
                    align: TextAlign.justify,
                  ),
                ],
              ),
            ),

            showDetials == false ? SizedBox(height: 20.h) : const Spacer(),

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
                                    'سبب الرفض',
                                    textSubHeadSize,
                                    black,
                                    //fontWeight: FontWeight.bold,
                                    align: TextAlign.right,
                                  ),
                                ],
                              ),
                              //-------------------------------
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
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
                            // widget.state == 4
                            //     ? "ادفع الان"
                            //     : widget.state == 3
                            //         ? 'قبول'
                            //         : widget.state == 2
                            //             ? 'قبول من المتابع'
                            //             : widget.state == 6
                            //                 ? 'تم الدفع'
                            //                 : widget.state == 1
                            //                     ? 'قيد الانتظار'
                            //                     :
                            widget.state == 4 ? "ادفع الان" : 'قبول',
                            SmallbuttomSize,
                            widget.state == 3 ||
                                    widget.state == 1 ||
                                    widget.state == 2 ||
                                    widget.state == 5 ||
                                    widget.state == 6 ||
                                    widget.state == 7 ||
                                    widget.state == 8
                                ? reqGrey!
                                : white,
                            widget.state == 3 ||
                                    widget.state == 1 ||
                                    widget.state == 2 ||
                                    widget.state == 5 ||
                                    widget.state == 6 ||
                                    widget.state == 7 ||
                                    widget.state == 8
                                ? null
//Payment Orders==============================================================================
                                : widget.state == 4
                                    ? () {
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();
                              failureDialog(
                                  context,
                                  'تاكيد الدفع',
                                  'هل انت متاكد من اكمال عملية الدفع؟',
                                  "assets/lottie/payment.json",
                                  'دفع', () {
                                Navigator.pop(context);
                                loadingDialogue(context);

                                paymentOrder(
                                    widget.token!,
                                    widget.orderId!,
                                    int.parse(price!.text))
                                    .then((value) {
                                  if (value == true) {
                                    Navigator.pop(context);
                                    setState(() {
                                      clickUserGift = true;
                                    });
                                    successfullyDialog(
                                        context,
                                        'تم الدفع بنجاح',
                                        "assets/lottie/SuccessfulCheck.json",
                                        'حسناً', () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  } else if (value ==
                                      "SocketException") {
                                    Navigator.pop(context);
                                    showMassage(
                                        context,
                                        'مشكلة في الانترنت',
                                        socketException);
                                  } else if (value ==
                                      'Insufficient balance!') {
                                    Navigator.pop(context);
                                    showMassage(
                                        context,
                                        'الرصيد غير كافي',
                                        'عفوا رصيدك غير كافي الرجاء اعادة شحن الرصيد من قائمة حسابي واختر الرصيد لاكمال عملية الدفع');
                                  } else if (value ==
                                      "TimeoutException") {
                                    Navigator.pop(context);
                                    showMassage(
                                        context,
                                        'مشكلة في الخادم',
                                        timeoutException);
                                  } else if (value ==
                                      'serverException') {
                                    Navigator.pop(context);
                                    showMassage(
                                        context,
                                        'مشكلة في الخادم',
                                        serverException);
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar(
                                        context,
                                        'تم قبول الطلب مسبقا',
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
                                                int.parse(price!.text))
                                            .then((value) {
                                          if (value == true) {
                                            Navigator.pop(context);
                                            setState(() {
                                              clickUserGift = true;
                                            });
                                            successfullyDialog(
                                                context,
                                                'تم قبول سعر الاهداء',
                                                "assets/lottie/SuccessfulCheck.json",
                                                'حسناً', () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          } else if (value ==
                                              "SocketException") {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الانترنت',
                                                socketException);
                                          } else if (value ==
                                              "User is banned!") {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'خطأ في اكمال الطلب',
                                                'لا يمكنك اكمال قبول الطلب الرجاء مراجعة الدعم الفني');
                                          } else if (value ==
                                              "TimeoutException") {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الخادم',
                                                timeoutException);
                                          } else if (value ==
                                              'serverException') {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الخادم',
                                                serverException);
                                          } else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar(
                                                    context,
                                                    'تم قبول الطلب مسبقا',
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
                                  widget.state == 8
                              ? reqGrey!
                              : Colors.transparent,
                          gradient: widget.state == 3 ||
                                  widget.state == 1 ||
                                  widget.state == 2 ||
                                  widget.state == 5 ||
                                  widget.state == 6 ||
                                  widget.state == 7 ||
                                  widget.state == 8
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
                            //     ? "رفض من المشهور"
                            //         : widget.state == 5
                            //             ? 'رفض من المستخدم'
                            //             : widget.state == 8
                            //                 ? 'رفض من الإدارة'
                            //                 :
                            'الغاء الطلب',
                            SmallbuttomSize,
                            widget.state == 3 ||
                                    widget.state == 4 ||
                                    widget.state == 5 ||
                                    widget.state == 2 ||
                                    widget.state == 6 ||
                                    // widget.state == 7 ||
                                    widget.state == 8
                                ? reqGrey!
                                : black,
                            widget.state == 4 ||
                                    widget.state == 3 ||
                                    widget.state == 5 ||
                                    widget.state == 2 ||
                                    widget.state == 6 ||
                                    // widget.state == 7 ||
                                    widget.state == 8
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
                                  // widget.state == 7 ||
                                  widget.state == 8
                              ? reqGrey!
                              : pink,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
//---------------------------------------------------------
//                       Expanded(
//                         child: Row(
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: InkWell(
//                                     onTap: widget.state == 3 ||
//                                             widget.state == 5 ||
//                                             widget.state == 7 ||
//                                             widget.state == 8
//                                         ? null
//                                         : () {
//                                             goTopagepush(
//                                                 context,
//                                                 chatRoom(
//                                                   createUserId:
//                                                       widget.celebrityId,
//                                                   createName:
//                                                       widget.celebrityName,
//                                                   createImage: widget.celImage,
//                                                 ));
//                                             // userCreateConversation(widget.userId,
//                                             //     widget.token!)
//                                             //     .then((value) {
//                                             //   if (value == true) {
//                                             //     goTopagepush(context, chatRoom());
//                                             //   } else if (value == "SocketException") {
//                                             //     showMassage(context, 'مشكلة في الانترنت',
//                                             //         ' لايوجد اتصال بالانترنت في الوقت الحالي ');
//                                             //   } else if (value == "TimeoutException") {
//                                             //     showMassage(context, 'مشكلة في الخادم', 'TimeoutException');
//                                             //   } else if (value == 'serverException') {
//                                             //     showMassage(context, 'مشكلة في الخادم',
//                                             //         'حدث خطأ ما اثناء استرجاع البيانات, سنقوم باصلاحه قريبا');
//                                             //   } else {
//                                             //     showMassage(context, 'مشكلة في الخادم',
//                                             //         'حدث خطأ ما اثناء استرجاع البيانات, سنقوم باصلاحه قريبا');
//                                             //
//                                             //   }
//                                             // });
//                                           },
//                                     child: Icon(Icons.forum_outlined,
//                                         color: widget.state == 3 ||
//                                                 widget.state == 5 ||
//                                                 widget.state == 7 ||
//                                                 widget.state == 8
//                                             ? reqGrey!
//                                             : pink)))
//                           ],
//                         ),
//                       ),
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
                          padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                          child: text(
                            context,
                            'سبب الرفض',
                            textSubHeadSize,
                            black,
                            //fontWeight: FontWeight.bold,
                            align: TextAlign.right,
                          ),
                        ),
                        SizedBox(height: 10.h),
//-------------------------------------------------------------------------
                        resonReject == 'أخرى'
                            ? Form(
                                key: resonKey,
                                child: textField2(context, Icons.unpublished,
                                    '', textFieldSize, false, reson, empty,
                                    hitText: 'اختر سبب الرفض'),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.r),
                                child: text(
                                  context,
                                  '$resonReject',
                                  textSubHeadSize,
                                  black,
                                  //fontWeight: FontWeight.bold,
                                  align: TextAlign.right,
                                ),
                              ),
                        SizedBox(height: 15.h),
                        //--------------------------------
                        //const Spacer(),
                        gradientContainer(
                          double.infinity,
                          buttoms(
                            context,
                            "تاكيد",
                            largeButtonSize,
                            white,
                            () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (resonReject == 'أخرى') {
                                if (resonKey.currentState?.validate() == true) {
                                  loadingDialogue(context);

                                  userRejectAdvertisingOrder(widget.token!,
                                          widget.orderId!, reson.text, 0)
                                      .then((value) {
                                    if (value == true) {
                                      Navigator.pop(context);
                                      setState(() {
                                        clickUserGift = true;
                                      });
                                      successfullyDialog(
                                          context,
                                          'تم الغاء الطلب بنجاح',
                                          "assets/lottie/SuccessfulCheck.json",
                                          'حسناً', () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    } else if (value == "SocketException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الانترنت',
                                          socketException);
                                    } else if (value == "TimeoutException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          timeoutException);
                                    } else if (value == 'serverException') {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          serverException);
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar(
                                              context,
                                              'تم الغاء الطلب  مسبقا',
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
                                      clickUserGift = true;
                                    });
                                    successfullyDialog(
                                        context,
                                        'تم الغاء الطلب بنجاح',
                                        "assets/lottie/SuccessfulCheck.json",
                                        'حسناً', () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  } else if (value == "SocketException") {
                                    Navigator.pop(context);
                                    showMassage(context, 'مشكلة في الانترنت',
                                        socketException);
                                  } else if (value == "TimeoutException") {
                                    Navigator.pop(context);
                                    showMassage(context, 'مشكلة في الخادم',
                                        timeoutException);
                                  } else if (value == 'serverException') {
                                    Navigator.pop(context);
                                    showMassage(context, 'مشكلة في الخادم',
                                        serverException);
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        snackBar(
                                            context,
                                            'تم الغاء الطلب  مسبقا',
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
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
          ])),
    );
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
                                resonRejectId = i + 1;
                                isReject = false;
                              });
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
                      resonReject = 'أخرى';
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
                        'أخرى',
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
    String url = "https://mobile.celebrityads.net/api/reject-resons";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (int i = 0; i < body['data'].length; i++) {
        rejectResonsList.add(body['data'][i]['name']);
      }
    } else {
      throw Exception('Failed to load celebrity Reject reson');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
