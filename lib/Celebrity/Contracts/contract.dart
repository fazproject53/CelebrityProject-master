import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Celebrity/Contracts/ContractModel.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/invoice/Invoice.dart';
import 'package:celepraty/invoice/ivoice_info_list.dart';
import 'package:flutter/foundation.dart';
import 'package:hand_signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../orders/ContinueAdvArea.dart';

//import 'package:pdf/widgets.dart' as pw;

class contract extends StatefulWidget {
  _contractState createState() => _contractState();
}

class _contractState extends State<contract> {
  Future<InvoiceModel>? invoices;
  bool ready = false;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  var png;
  final _baseUrl = 'https://mobile.celebrityads.net/api/celebrity/contracts';
  int _page = 1;

  bool ActiveConnection = false;
  String T = "";

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  String? phone, taxnumber;
  // This holds the posts fetched from the server
  List _posts = [];
  ScrollController _controller = ScrollController();

  String? desc;
  List<String> imagePaths = [];
  final imagePicker = ImagePicker();
  final file = File('example.pdf');

  //  final pdf = pw.Document();
  DateTime date = DateTime.now();
  String? userToken;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getContracts();
        print(_posts.length.toString()+':::::::::::::::');
      });
    });
    _controller.addListener(_loadMore);
    super.initState();
  }
  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  void _loadMore() async {
    print('#########################################################');

    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false && _controller.position.maxScrollExtent ==
        _controller.offset) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;
      try {
        final res =
        await http.get(Uri.parse("$_baseUrl?page=$_page"), headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        });

        if (InvoiceModel
            .fromJson(jsonDecode(res.body))
            .data!
            .billings!
            .isNotEmpty) {
          setState(() {
            _posts.addAll(InvoiceModel
                .fromJson(jsonDecode(res.body))
                .data!
                .billings!);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: drowAppBar('العقود', context),
          body:  !isConnectSection?Center(
              child: Padding(
                padding:  EdgeInsets.only(top: 0.h),
                child: SizedBox(
                    height: 300.h,
                    width: 250.w,
                    child: internetConnection(
                        context, reload: () {
                      setState(() {
                        getContracts();
                        isConnectSection = true;
                      });
                    })),
              )): !serverExceptions? Container(
            height: getSize(context).height/1.5,
            child: Center(
                child: checkServerException(context)
            ),
          ): !timeoutException? Center(
            child: checkTimeOutException(context, reload: (){ setState(() {
              getContracts();
            });}),
          ):SafeArea(
            child: SingleChildScrollView(
              controller: _controller,
              child: _isFirstLoadRunning? Center(
                  child: mainLoad(context)): Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  text(context, '   العقود ', textHeadSize, black),

                  _posts.isEmpty
                      ? Padding(
                    padding: EdgeInsets.only(
                        top: getSize(context).height / 7),
                    child: Center(child: Column(
                      children: [
                        LottieBuilder.asset(
                            'assets/lottie/invoicesempty.json',
                            height: 200.h),
                        text(context, 'لا يوجد عقود لعرضهم حاليا',
                            textHeadSize, black),
                      ],
                    ),),
                  )
                      :
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        ListView.builder(

                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _posts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 75.h,
                                child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left:8.0),
                                                child: Icon(
                                                  Icons.receipt_long,
                                                  color:
                                                  black.withOpacity(0.80),
                                                  size: 27,
                                                ),
                                              ),
                                              // SizedBox(width: 20.w),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    text(
                                                        context,
                                                         'تنفيذ عقد '+_posts[index].adType.name  ,
                                                        textTitleSize,
                                                        black),
                                                    text(
                                                        context,
                                                        _posts[index].user.name,
                                                        14,
                                                        green),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(width: 23.w,height: 10.h,),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              text(
                                                  context,
                                                  _posts[index].date.toString(),
                                                  textError,
                                                  grey!),
                                              SizedBox()
                                            ],
                                          ),
                                  InkWell(
                                                    child: Padding(
                                                      padding:  EdgeInsets.only(left: 10.0.w, right: 10.w),
                                                      child:  Icon(
                                                        Icons
                                                            .visibility,
                                                        size: 25,
                                                        color: black.withOpacity(0.70),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      goTopagepush(context, ContinueAdvArea(
                                                        description: '',
                                                        advLink: "",
                                                        advOrAdvSpace: 'مساحة اعلانية',
                                                        platform: "",
                                                        advTitle: "",
                                                        celerityVerifiedType:
                                                        "",
                                                        avdTime: "",
                                                        celerityCityName:
                                                        "اسم المشهور",
                                                        celerityEmail: "",
                                                        celerityIdNumber:
                                                        "",
                                                        celerityName:"",
                                                        celerityNationality:
                                                        "",
                                                        celerityPhone: "",
                                                        celerityVerifiedNumber:
                                                        "",
                                                        userCityName:"",
                                                        userEmail: "",
                                                        userIdNumber: "",
                                                        userName: "",
                                                        userNationality:
                                                        "",
                                                        userPhone: "",
                                                        userVerifiedNumber:
                                                        "",
                                                        userVerifiedType:
                                                        ' سجل تجاري ',
                                                        file: file,
                                                        token: userToken,
                                                        cel: null,
                                                        date: "",
                                                        pagelink: "",
                                                        time:"",
                                                        type: 'مساحة اعلانية',
                                                        commercialrecord:null,
                                                        copun: "",
                                                        image:null,
                                                          celeritySigntion: ""));
                                                    },
                                                  ),

                                        ],
                                      ),
                                    )
                                    // children: [
                                    //   Container(
                                    //       margin:
                                    //       EdgeInsets.only(top: 10.h),
                                    //       height: 70.h,
                                    //       decoration: BoxDecoration(
                                    //         color: fillWhite,
                                    //         border: Border(
                                    //             top: BorderSide(
                                    //                 color: lightGrey
                                    //                     .withOpacity(
                                    //                     0.10))),
                                    //       ),
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //         MainAxisAlignment
                                    //             .spaceBetween,
                                    //         children: [
                                    //           Padding(
                                    //             padding: EdgeInsets
                                    //                 .only(
                                    //                 right: 15.0.w),
                                    //             child: text(context,
                                    //                 'التفاصيل', textError,
                                    //                 grey!),
                                    //           ),
                                    //           SingleChildScrollView(
                                    //             child: Container(
                                    //               child: text(
                                    //                   context,
                                    //                   _posts[index].user.name,
                                    //                   textError,
                                    //                   black),
                                    //               width: 200.w,
                                    //               margin: EdgeInsets
                                    //                   .only(
                                    //                   right: 10.w),
                                    //             ),
                                    //           ),
                                    //           Padding(
                                    //             padding: EdgeInsets
                                    //                 .only(
                                    //                 left: 20.w),
                                    //             child: Row(children: [
                                    //               InkWell(
                                    //                 child: const Icon(
                                    //                   Icons
                                    //                       .visibility,
                                    //                   size: 25,
                                    //                 ),
                                    //                 onTap: () {
                                    //                   goTopagepush(context, ContinueAdvArea(
                                    //                     description: '',
                                    //                     advLink: "",
                                    //                     advOrAdvSpace: 'مساحة اعلانية',
                                    //                     platform: "",
                                    //                     advTitle: "",
                                    //                     celerityVerifiedType:
                                    //                     "",
                                    //                     avdTime: "",
                                    //                     celerityCityName:
                                    //                     "اسم المشهور",
                                    //                     celerityEmail: "",
                                    //                     celerityIdNumber:
                                    //                     "",
                                    //                     celerityName:"",
                                    //                     celerityNationality:
                                    //                     "",
                                    //                     celerityPhone: "",
                                    //                     celerityVerifiedNumber:
                                    //                     "",
                                    //                     userCityName:"",
                                    //                     userEmail: "",
                                    //                     userIdNumber: "",
                                    //                     userName: "",
                                    //                     userNationality:
                                    //                     "",
                                    //                     userPhone: "",
                                    //                     userVerifiedNumber:
                                    //                     "",
                                    //                     userVerifiedType:
                                    //                     ' سجل تجاري ',
                                    //                     file: file,
                                    //                     token: userToken,
                                    //                     cel: null,
                                    //                     date: "",
                                    //                     pagelink: "",
                                    //                     time:"",
                                    //                     type: 'مساحة اعلانية',
                                    //                     commercialrecord:null,
                                    //                     copun: "",
                                    //                     image:null,
                                    //                       celeritySigntion: ""));
                                    //                 },
                                    //               ),
                                    //
                                    //             ]),
                                    //           ),
                                    //         ],
                                    //       ))
                                    // ]
                                ),
                              ),
                            );
                          },
                        ),
                        if (_isLoadMoreRunning == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
  Widget invoice2(index) {
    return SingleChildScrollView(
      child:  StatefulBuilder(
          builder: (BuildContext context, StateSetter setState /*You can rename this!*/){
            return Column(
              children: [
                InkWell(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 450.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: lightGrey.withOpacity(0.30)),
                      ),
                      Container(
                        width: 60.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.all(
                                Radius.circular(50))),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 200.h),
                text(context, 'هنا العقد', 20, black),
                SizedBox(height: 220.h),
                Padding(
                  padding:  EdgeInsets.only(right: 100.w),
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(right: 180.w),
                        child: text(context, 'التوقيع', 20, black),
                      ),
                      InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (contextt){
                            return Column(
                              children: [
                                SizedBox(height: 200.h),
                                text(context, '', 20, black),
                                Container(
                                  height: 300.h,
                                  width: 300.w,
                                  color: Colors.white,
                                  child: HandSignature(
                                    control: control,
                                    color: Colors.blueGrey,
                                    width: 0.5,
                                    maxWidth: 5.0,
                                    type: SignatureDrawType.shape,
                                    onPointerUp: () async {
                                      png = await control.toImage();
                                      Navigator.pop(contextt);
                                      // showDialog(context: context, builder: (contextt){
                                      //   return Image.memory(png!.buffer.asUint8List());

                                      //   });
                                    },
                                  ),
                                ),
                                SizedBox(height: 200.h),
                              ],
                            );

                          }).whenComplete(() => setState((){ready = true;}));
                        },
                        child: Container(
                          height: 120,
                          width: 500.w,
                          color: Colors.white24,
                          child: png==null? SizedBox():Padding(
                            padding:  EdgeInsets.only(right: 150.w),
                            child: ready?Image.memory(png!.buffer.asUint8List()):SizedBox(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );}
      ),
    );
  }
  Widget invoice(index) {
    return SingleChildScrollView(
      child:  Column(
        children: [
          Column(
            children: [
              InkWell(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 450.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: lightGrey.withOpacity(0.30)),
                    ),
                    Container(
                      width: 60.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.all(
                              Radius.circular(50))),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: GradientText(
                      'منصة المشاهير',
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Cairo",
                          fontWeight: FontWeight.bold),
                      colors: const [
                        Color(0xff0ab3d0),
                        Color(0xffe468ca)
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/image/log.png',
                    height: 90.h,
                    width: 90.w,
                  ),
                ],
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Directionality(
                        textDirection: TextDirection.rtl,
                        child: text(
                            context,
                            _posts[index]
                                .date!.toString(),
                            15,
                            grey!)),
                    text(context, 'فاتورة ضريبية', 18,
                        black.withOpacity(0.75),
                        fontWeight: FontWeight.bold),
                  ],
                ),
                margin: EdgeInsets.only(
                    top: 15.h, left: 15.w, right: 15.w),
              ),
              padding(
                15,
                15,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    text(context,
                        _posts[index].order!
                            .id.toString() + '#', 18,
                        black.withOpacity(0.75),
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 15.h,
                    ),
                    text(context, 'رقم الطلب : ' +
                        _posts[index].order!
                            .id.toString(), 15, black),
                    text(context, 'رقم الفاتورة : ' +
                        _posts[index]
                            .billingId.toString(), 15, black),
                    Divider(
                      color: black,
                    )
                  ],
                ),
              ),
              padding(
                  0,
                  15,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      text(context, ': مصدرة من ', 18, blue,
                          fontWeight: FontWeight.bold),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Container(
                              child: text(
                                  context, "منصة المشاهير", 15,
                                  black),
                              margin: EdgeInsets.only(left: 10.w)),
                          text(context, ': الموقع الالكتروني', 15,
                              black.withOpacity(0.75),
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Container(
                            child: text(context,
                                taxnumber!, 15,
                                black),
                            margin: EdgeInsets.only(left: 10.w),
                          ),
                          text(context, ': الرقم الضريبي', 15,
                              black.withOpacity(0.75),
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Container(
                              child: text(context,
                                  phone!, 15,
                                  black),
                              margin: EdgeInsets.only(left: 10.w)),
                          text(context, ': الهاتف', 15,
                              black.withOpacity(0.75),
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      Divider(
                        color: black,
                      )
                    ],
                  )),
              padding(
                  0,
                  15,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      text(context, ': مصدرة الى ', 18, pink,
                          fontWeight: FontWeight.bold),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Container(
                              child: text(context,
                                  _posts[index].celebrity!
                                      .country!.name!, 15, black),
                              margin: EdgeInsets.only(left: 5.w)),
                          Container(
                              child: text(context,
                                  _posts[index].celebrity!
                                      .name!, 15,
                                  black.withOpacity(0.75),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        child: text(context,
                            '+966'+_posts[index]
                                .celebrity!.phonenumber!.replaceAll('+966','')
                            , 15, black),
                        margin: EdgeInsets.only(left: 10.w),
                        alignment: Alignment.bottomLeft,
                      ),
                      Divider(
                        color: black,
                      )
                    ],
                  )),
              padding(
                  0,
                  15,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      text(context, 'تفاصيل الدفع', 17,
                          black.withOpacity(0.75),
                          fontWeight: FontWeight.bold),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Container(
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: text(context,
                                    _posts[index].price
                                        .toString() + " ر . س", 15,
                                    blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              margin: EdgeInsets.only(left: 20.w)),
                          text(context, ': المبلغ', 17, blue,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment
                      //       .spaceBetween,
                      //   children: [
                      //     Container(
                      //       child: text(context,
                      //           _posts[index].paymentMehtod!
                      //               .name!, 15, black),
                      //       margin: EdgeInsets.only(left: 30.w),
                      //     ),
                      //     Container(
                      //         child: text(
                      //             context, ':طريقة الدفع', 15,
                      //             black.withOpacity(0.75),
                      //             fontWeight: FontWeight.bold)),
                      //   ],
                      // ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  )),
              Container(
                color: grey!.withOpacity(0.40),
                height: 45.h,
                margin: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        text(context, 'المجموع', 15, black),
                        SizedBox(
                          width: 50.w,
                        ),
                        text(context, 'السعر', 15, black),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        text(context, 'المنتج', 15, black),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),

                            Container(
                              width: 150.w,
                              child: text(
                                  context,
                                  _posts[index].order!
                                      .adType!.name! == "اعلان"
                                      ? ' طلب' +
                                      _posts[index].order!
                                          .adType!.name! + ' ل' +
                                      _posts[index].order!
                                          .advertisingAdType!.name!
                                      :
                                  _posts[index].order!
                                      .adType!.name! == "اهداء"
                                      ? ' طلب ' +
                                      _posts[index].order!
                                          .adType!.name! + ' / ' +
                                      _posts[index].order!
                                          .giftType!.name! +
                                      " بمناسبة  " + 'عيد ميلاد'
                                      :
                                  _posts[index].order!
                                      .adType!.name! ==
                                      "مساحة اعلانية" ? ' طلب ' +
                                      'مساحة اعلانية' : '',
                                  13.5,
                                  black),
                            ),
                            // SizedBox(width: 10.w,),
                            // Image.asset('assets/image/logo.png', height: 50.h, width: 50.w,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: [
                            SizedBox(
                              width: 30.w,
                            ),
                            text(context, _posts[index].price!
                                .toString() + " ر . س  ", 15,
                                black),
                            SizedBox(
                              width: 40.w,
                            ),
                            text(context, _posts[index].price!
                                .toString() + " ر . س  ", 15,
                                black),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      color: black,
                      thickness: 1.5,
                    ),


                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),
                            text(
                                context, 'اجمالي الطلب', 15, black),
                          ],
                        ),
                        Row(
                          children: [
                            text(context, _posts[index].priceAfterTax == null? ' ' :_posts[index].priceAfterTax! +
                                ' ر . س ', 15, black),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      color: black,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    text(
                        context,
                        'شكرا لتعاملكم مع منصتنا ,,, نتمنى لكم يوما رائعا',
                        17,
                        black.withOpacity(0.75),
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 10.h,
                    ),
                    Divider(
                      color: black,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoadMoreRunning == true)
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void getContracts() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

   try{
      final response = await http.get(
          Uri.parse('$_baseUrl?page=$_page'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        setState(() {
          _posts = Contract
              .fromJson(jsonDecode(response.body))
              .data!.orders!;
        });
        print(response.body);

      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
        setState(() {
          timeoutException = false;
        });
        return Future.error('TimeoutException');
      } else {
        setState(() {
          serverExceptions = false;
        });
        return Future.error('serverExceptions');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
      print(_isFirstLoadRunning.toString()+'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    });
  }
}
