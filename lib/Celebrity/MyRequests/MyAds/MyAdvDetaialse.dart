import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Celebrity/MyRequests/MyAds/MyAdvertisinApi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Account/UserForm.dart';
import '../../../Models/Methods/method.dart';
import '../../../Models/Variables/Variables.dart';
import '../../HomeScreen/celebrity_home_page.dart';
import '../../Requests/DownloadImages.dart';

bool myClickAdv = false;

class MyAdvDetials extends StatefulWidget {
  final int? i;
  final String? description;
  final String? image;
  final String? advTitle;
  final String? advDate;
  final String? platform;
  final String? userName;
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
  final int? userId;
  final String? celImage;
  final String? commercialRecord;
  final String? owner;
  final String? celerityCityName;
  final String? celerityEmail;
  final String? celerityIdNumber;
  final String? celerityName;
  final String? celerityNationality;
  final String? celerityPhone;
  final String? celerityVerifiedNumber;
  final String? celerityVerifiedType;
  final String? userCityName;
  final String? userEmail;
  final String? userIdNumber;
  final String? userNationality;
  final String? userPhone;
  final String? userVerifiedNumber;
  final String? userVerifiedType;
  final String? singture;
  final String? celeritySigntion;
  final DateTime? sendDate;
  const MyAdvDetials(
      {Key? key,
      this.i,
      this.description,
      this.image,
      this.advTitle,
      this.advDate,
      this.platform,
      this.userName,
      this.token,
      this.state,
      this.orderId,
      this.price,
      this.rejectResonName,
      this.rejectResonNameAdmin,
      this.rejectResonId,
      this.celebrityName,
      this.celebrityId,
      this.celebrityImage,
      this.celebrityPagUrl,
      this.time,
      this.userId,
      this.celImage,
      this.commercialRecord,
      this.owner,
      this.celerityCityName,
      this.celerityEmail,
      this.celerityIdNumber,
      this.celerityName,
      this.celerityNationality,
      this.celerityPhone,
      this.celerityVerifiedNumber,
      this.celerityVerifiedType,
      this.userCityName,
      this.userEmail,
      this.userIdNumber,
      this.userNationality,
      this.userPhone,
      this.userVerifiedNumber,
      this.userVerifiedType,
      this.singture,
      this.celeritySigntion,
      this.sendDate})
      : super(key: key);

  @override
  State<MyAdvDetials> createState() => _MyAdvDetialsState();
}

class _MyAdvDetialsState extends State<MyAdvDetials> {
  int? resonRejectId;
  bool showDetials = true;
  List<String> rejectResonsList = [];
  String? resonReject;
  bool isReject = true;
  TextEditingController? price;
  TextEditingController reson = TextEditingController();
  GlobalKey<FormState> priceKey = GlobalKey();
  GlobalKey<FormState> resonKey = GlobalKey();
//====================================================================
  @override
  void initState() {
    super.initState();
    getRejectReson();
    print('state:${widget.state}');
    print('commercialRecord:${widget.commercialRecord}');
    print('owner:${widget.owner}');

    price = widget.price! > 0
        ? TextEditingController(text: '${widget.price}')
        : TextEditingController();
  }
//====================================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: drowAppBar("???????????? ??????????", context),
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
                            '?????? ??????????: ' + widget.orderId!.toString(),
                            textSubHeadSize,
                            black,
                            //fontWeight: FontWeight.bold,
                            align: TextAlign.justify,
                          ),
                        ),
                        const Spacer(),
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
                                '' + widget.price!.toString() + ' ??.??',
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
                              '???? ' + widget.celebrityName!,
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
//ad title-----------------------------------------------------

            Container(
              //color: black,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.h),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      Icon(
                        orders,
                        color: pink,
                        size: 33.r,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      text(
                        context,
                        '?????????? ??' + widget.advTitle!,
                        textSubHeadSize,
                        black,
                        //fontWeight: FontWeight.bold,
                        align: TextAlign.justify,
                      ),
                      const Spacer(),
//platform----------------------------------------------------------------
                      const Icon(Icons.hotel_class, color: pink),
                      SizedBox(
                        width: 5.w,
                      ),
                      text(
                        context,
                        '?????????? ??????  ${widget.platform}',
                        textSubHeadSize,
                        black,
                        //fontWeight: FontWeight.bold,
                        align: TextAlign.justify,
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 5.w,
            ),
//description----------------------------------------------------------------------
            Visibility(
              visible: showDetials,
              child: Container(
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
                          '????????????????',
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
            ),
            SizedBox(
              height: 10.h,
            ),
//adv image----------------------------------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
//adv time-------------------------------------------------------------------------------

                  Row(
                    children: [
                      Icon(time, color: pink),
                      SizedBox(
                        width: 5.w,
                      ),
                      text(
                        context,
                        widget.time!,
                        textSubHeadSize,
                        black,
                        //fontWeight: FontWeight.bold,
                        align: TextAlign.right,
                      ),
                    ],
                  ),
//adv image-------------------------------------------------------------------------------
                  InkWell(
                    onTap: () async {
                      var found = await getExistImage(widget.image!);
                      print(found);
                      print('===========================');
                      goTopagepush(
                          context,
                          DownloadImages(
                            image: found == false ? widget.image! : found,
                            fromDevice: found == false ? false : true,
                          ));
                    },
                    child: Row(
                      children: [
                        Icon(image, color: pink),
                        SizedBox(
                          width: 5.w,
                        ),
                        text(
                          context,
                          '???????? ??????????????',
                          textSubHeadSize,
                          black,
                          //fontWeight: FontWeight.bold,
                          align: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
//commercialRecord-------------------------------------------------------------------------------
            widget.owner != '??????' && widget.owner != null
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.r, vertical: 20.h),
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
                  )
                : widget.owner == '??????' &&
                        widget.commercialRecord!.isNotEmpty &&
                        widget.owner != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.r, vertical: 20.h),
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
                                      '???????????? ???????? ?????????????? ???????????? ??????????');
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
                                '???????????? ??????????????????',
                                textSubHeadSize,
                                black,
                                //fontWeight: FontWeight.bold,
                                align: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
            const Spacer(),

//reject reson-----------------------------------------------------
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
                                padding: EdgeInsets.symmetric(horizontal: 30.w),
                                child: text(
                                  context,
                                  widget.state == 8
                                      ? '${widget.rejectResonNameAdmin}'
                                      : '${widget.rejectResonName}',
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

//accept buttom------------------------------------------------------------------------------

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
                            //     ? "????????"
                            //     : widget.state == 3
                            //         ? '????????'
                            //         : widget.state == 2
                            //             ? '???????? ????????'
                            //             : widget.state == 6
                            //                 ? '???? ??????????'
                            //                 : widget.state == 1
                            //                     ? '?????? ????????????????'
                            //                     :
                            widget.state == 2 ? "???????? ????????" : '????????',
                            SmallbuttomSize,
                            widget.state == 3 ||
                                    widget.state == 1 ||
                                    //widget.state == 2 ||
                                    widget.state == 5 ||
                                    widget.state == 6 ||
                                    widget.state == 7 ||
                                    widget.state == 8 ||
                                    widget.state == 9
                                ? reqGrey!
                                : white,
                            widget.state == 3 ||
                                    widget.state == 1 ||
                                    widget.state == 5 ||
                                    widget.state == 6 ||
                                    widget.state == 7 ||
                                    widget.state == 8 ||
                                    widget.state == 9
                                ? null
//Payment Orders==============================================================================
                                : widget.state == 2
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
                                                  int.parse(price!.text))
                                              .then((value) {
                                            if (value == true) {
                                              Navigator.pop(context);
                                              setState(() {
                                                myClickAdv = true;
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
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar(
                                                      context,
                                                      '???? ???????? ?????????? ??????????',
                                                      red,
                                                      error));
                                            }
                                          });
                                        }, bottomColor: pink);
                                      }
//End of payment===================================================================================================
                                    : () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        // if (priceKey.currentState?.validate() ==
                                        //     true) {
                                        print('object');
//generate Contract======================================================================
//                           goTopagepush(
//                               context,
//                               ContinueAdvArea(
//                                 fromOrder: 2,
//                                 token: widget.token,
//                                 orderId: widget.orderId,
//                                 priceController: price!.text,
//                                 description: widget.description!,
//                                 advLink: '',
//                                 advOrAdvSpace: '??????????',
//                                 platform: widget.platform!,
//                                 advTitle: widget.advTitle!,
//                                 celerityVerifiedType:
//                                 widget.celerityVerifiedType!,
//                                 avdTime: widget.time!,
//                                 celerityCityName:
//                                 widget.celerityCityName!,
//                                 celerityEmail:
//                                 widget.celerityEmail!,
//                                 celerityIdNumber:
//                                 widget.celerityIdNumber!,
//                                 celerityName:
//                                 widget.celerityName!,
//                                 celerityNationality:
//                                 widget.celerityNationality!,
//                                 celerityPhone:
//                                 widget.celerityPhone!,
//                                 celerityVerifiedNumber: widget
//                                     .celerityVerifiedNumber!,
//                                 userCityName:
//                                 widget.userCityName!,
//                                 userEmail: widget.userEmail!,
//                                 userIdNumber:
//                                 widget.userIdNumber!,
//                                 userName: widget.userName!,
//                                 userNationality:
//                                 widget.userNationality!,
//                                 userPhone: widget.userPhone!,
//                                 userVerifiedNumber:
//                                 widget.userVerifiedNumber!,
//                                 userVerifiedType:
//                                 widget.userVerifiedType!,
//                                 date: widget.advDate!,
//                                 singture: '',
//                                 celeritySigntion:
//                                 widget.celeritySigntion!,
//                                 sendDate: widget.sendDate,
//                               ));
                                        // }
                                      },
                            evaluation: 0,
                          ),
                          height: 50,
                          color: widget.state == 3 ||
                                  widget.state == 1 ||
                                  //widget.state == 2 ||
                                  widget.state == 5 ||
                                  widget.state == 6 ||
                                  widget.state == 7 ||
                                  widget.state == 8 ||
                                  widget.state == 9
                              ? reqGrey!
                              : Colors.transparent,
                          gradient: widget.state == 3 ||
                                  widget.state == 1 ||
                                  //widget.state == 2 ||
                                  widget.state == 5 ||
                                  widget.state == 6 ||
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
                                    // widget.state == 4 ||
                                    widget.state == 5 ||
                                    widget.state == 2 ||
                                    widget.state == 6 ||
                                    //widget.state == 7 ||
                                    widget.state == 8 ||
                                    widget.state == 9
                                ? reqGrey!
                                : black,
                            // widget.state == 4 ||

                            widget.state == 3 ||
                                    widget.state == 5 ||
                                    widget.state == 2 ||
                                    widget.state == 6 ||
                                    // widget.state == 7 ||
                                    widget.state == 8 ||
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
                                  // widget.state == 4 ||
                                  widget.state == 5 ||
                                  widget.state == 2 ||
                                  widget.state == 6 ||
                                  // widget.state == 7 ||
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
//                                             //     showMassage(context, '?????????? ???? ????????????????',
//                                             //         ' ???????????? ?????????? ?????????????????? ???? ?????????? ???????????? ');
//                                             //   } else if (value == "TimeoutException") {
//                                             //     showMassage(context, '?????????? ???? ????????????', 'TimeoutException');
//                                             //   } else if (value == 'serverException') {
//                                             //     showMassage(context, '?????????? ???? ????????????',
//                                             //         '?????? ?????? ???? ?????????? ?????????????? ????????????????, ?????????? ?????????????? ??????????');
//                                             //   } else {
//                                             //     showMassage(context, '?????????? ???? ????????????',
//                                             //         '?????? ?????? ???? ?????????? ?????????????? ????????????????, ?????????? ?????????????? ??????????');
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
                            '?????? ??????????',
                            textSubHeadSize,
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
                                child: textField2(context, Icons.unpublished,
                                    '', 14, false, reson, empty,
                                    hitText: '???????? ?????? ??????????'),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.r),
                                child: text(
                                  context,
                                  '$resonReject',
                                  17,
                                  black,
                                  //fontWeight: FontWeight.bold,
                                  align: TextAlign.right,
                                ),
                              ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 55),
                        //--------------------------------
                        //const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0.h),
                          child: gradientContainer(
                            double.infinity,
                            buttoms(
                              context,
                              "??????????",
                              largeButtonSize,
                              white,
                              () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (resonReject == '????????') {
                                  if (resonKey.currentState?.validate() ==
                                      true) {
                                    loadingDialogue(context);

                                    userRejectAdvertisingOrder(widget.token!,
                                            widget.orderId!, reson.text, 0)
                                        .then((value) {
                                      if (value == true) {
                                        Navigator.pop(context);
                                        setState(() {
                                          myClickAdv = true;
                                        });
                                        successfullyDialog(
                                            context,
                                            '???? ?????????? ?????????? ??????????',
                                            "assets/lottie/SuccessfulCheck.json",
                                            '??????????', () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      } else if (value == "SocketException") {
                                        Navigator.pop(context);
                                        showMassage(
                                            context,
                                            '?????????? ???? ????????????????',
                                            socketException);
                                      } else if (value == "TimeoutException") {
                                        Navigator.pop(context);
                                        showMassage(context, '?????????? ???? ????????????',
                                            timeoutException);
                                      } else if (value == 'serverException') {
                                        Navigator.pop(context);
                                        showMassage(context, '?????????? ???? ????????????',
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
                                        myClickAdv = true;
                                      });
                                      successfullyDialog(
                                          context,
                                          '???? ?????????? ?????????? ??????????',
                                          "assets/lottie/SuccessfulCheck.json",
                                          '??????????', () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    } else if (value == "SocketException") {
                                      Navigator.pop(context);
                                      showMassage(context, '?????????? ???? ????????????????',
                                          socketException);
                                    } else if (value == "TimeoutException") {
                                      Navigator.pop(context);
                                      showMassage(context, '?????????? ???? ????????????',
                                          timeoutException);
                                    } else if (value == 'serverException') {
                                      Navigator.pop(context);
                                      showMassage(context, '?????????? ???? ????????????',
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
                      ],
                    ),
                  ),
            SizedBox(
              height: 10.h,
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

//==========================================================
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

  ///Open file-------------------------------------------------------------
  Future openFile({required String url, String? fileName}) async {
    final name = fileName ?? url.split('/').last;

    bool b = File('/data/user/0/com.example.celepraty/app_flutter/' + name)
        .existsSync();
    print(b.toString() + '---------------------------------------');
    loadingDialogue(context);
    final file = b
        ? File('/data/user/0/com.example.celepraty/app_flutter/' + name)
        : await downloadFile(url, name);
    Navigator.pop(context);

    if (file == null) return;

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
