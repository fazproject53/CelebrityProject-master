import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:celepraty/Celebrity/Contracts/ContractModel.dart';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/invoice/Invoice.dart';
import 'package:celepraty/invoice/InvoicePdf.dart';
import 'package:celepraty/invoice/ivoice_info_list.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:hand_signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../Requests/GenerateContract.dart';
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
  List<Widget> typefilter = [];
  List<Widget> datefilter = [];
  List<Widget> userfilter = [];
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(context, '   العقود ', textHeadSize, black),
                        Padding(
                          padding:  EdgeInsets.only(left:20.w),
                          child: InkWell(onTap:(){
                            showDialog(context: context, builder: (BuildContext context){
                              return Center(
                                  child: Container( 
                                    decoration:BoxDecoration(color: white,
                                    borderRadius: BorderRadius.circular(10.r))
                                    ,height: 500.h, width: 350.w,child:Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 20.h,),
                                        text(context, 'نوع العقد', 18, black),
                                      SizedBox(height: 5.h,),
                                      Wrap(children: typefilter),
                                        SizedBox(height: 10.h,),
                                        text(context, 'التاريخ', 18, black),
                                        SizedBox(height: 5.h,),
                                        Wrap(children: datefilter),
                                        SizedBox(height: 10.h,),
                                        text(context, 'اسم المستخدم', 18, black),
                                        SizedBox(height: 5.h,),
                                        Wrap(children:userfilter),
                                  ],),
                                    )));
                            });
                          },child: Icon(Icons.filter_list, size: 40.r, color:black.withOpacity(0.70))),
                        )
                      ],
                    ),
                  ),

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
                          height: 10.h,
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
                                                    onTap: () async {
                                                      loadingDialogue(context);
                                                      Uint8List?  bytes = await GenerateContract.generateContract(
                                                          advDescription: _posts[index].adType.name == 'مساحة اعلانية'?"":'',
                                                          advLink: _posts[index].link,
                                                          advOrAdvSpace: _posts[index].adType.name,
                                                          platform: '',
                                                          advProductOrService: '',
                                                          celerityVerifiedType:
                                                          _posts[index].celebrity.celebrityType == 'person'?'رخصة اعلانية':
                                                          'سجل تجاري',
                                                          advTime: "",
                                                          celerityCityName: _posts[index].celebrity.city.name,
                                                          celerityEmail: _posts[index].celebrity.email,
                                                          celerityIdNumber:_posts[index].celebrity.idNumber,
                                                          celerityName: _posts[index].celebrity.name,
                                                          celerityNationality: _posts[index].celebrity.nationality.countryArNationality,
                                                          celerityPhone:_posts[index].celebrity.phonenumber,
                                                          celerityVerifiedNumber:
                                                          _posts[index].celebrity.commercialRegistrationNumber,
                                                          userCityName: _posts[index].user.city.name,
                                                          userEmail: _posts[index].user.email,
                                                          userIdNumber:_posts[index].user.idNumber,
                                                          userName:_posts[index].user.name,
                                                          userNationality:  _posts[index].user.nationality.countryArNationality,
                                                          userPhone:  _posts[index].user.phonenumber,
                                                          userVerifiedNumber:  _posts[index].user.commercialRegistrationNumber,
                                                          userVerifiedType:   _posts[index].user.celebrityType == 'person'?'رخصة اعلانية':
                                                          'سجل تجاري',
                                                          advDate:  _posts[index].date!,
                                                          userSingture: _posts[index].contract.userSignature,
                                                          celeritySigntion:  _posts[index].contract.celebritySignature);
                                                      final directory = await getTemporaryDirectory();
                                                      final filepath = directory.path + '/' + "contract.pdf";
                                                      File file = await File(filepath).writeAsBytes(bytes);
                                                      await InvoicePdf.openFile(file);
                                                      Navigator.pop(context);
                                                      // goTopagepush(context, ContinueAdvArea(
                                                      //   description: '',
                                                      //   advLink: "",
                                                      //   advOrAdvSpace: 'مساحة اعلانية',
                                                      //   platform: "",
                                                      //   advTitle: "",
                                                      //   celerityVerifiedType:
                                                      //   "",
                                                      //   avdTime: "",
                                                      //   celerityCityName:
                                                      //   "اسم المشهور",
                                                      //   celerityEmail: "",
                                                      //   celerityIdNumber:
                                                      //   "",
                                                      //   celerityName:"",
                                                      //   celerityNationality:
                                                      //   "",
                                                      //   celerityPhone: "",
                                                      //   celerityVerifiedNumber:
                                                      //   "",
                                                      //   userCityName:"",
                                                      //   userEmail: "",
                                                      //   userIdNumber: "",
                                                      //   userName: "",
                                                      //   userNationality:
                                                      //   "",
                                                      //   userPhone: "",
                                                      //   userVerifiedNumber:
                                                      //   "",
                                                      //   userVerifiedType:
                                                      //   ' سجل تجاري ',
                                                      //   file: file,
                                                      //   token: userToken,
                                                      //   cel: null,
                                                      //   date: "",
                                                      //   pagelink: "",
                                                      //   time:"",
                                                      //   type: 'مساحة اعلانية',
                                                      //   commercialrecord:null,
                                                      //   copun: "",
                                                      //   image:null,
                                                      //     celeritySigntion: ""));
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

          for(int i = 0; i< _posts.length; i++){
            typefilter.contains(
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(height: 40.h, decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: blue, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: text(context, Contract
                          .fromJson(jsonDecode(response.body))
                          .data!.orders![i].adType!.name!, 15, blue),
                    )),
                ))?null:
            typefilter.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(height: 40.h, decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: blue, width: 1)),
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: text(context, Contract
                      .fromJson(jsonDecode(response.body))
                      .data!.orders![i].adType!.name!, 15, blue),
              ),),
                ));

            userfilter.contains(Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 40.h, decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: blue, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: text(context, Contract
                      .fromJson(jsonDecode(response.body))
                      .data!.orders![i].user!.name!, 15, blue),
                ),),
            ))?null:
            userfilter.add( Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 40.h, decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: blue, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: text(context, Contract
                      .fromJson(jsonDecode(response.body))
                      .data!.orders![i].user!.name!, 15, blue),
                ),),
            ));
          }

          datefilter=[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(height: 40.h, decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: blue, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: text(context, 'اخر شهر', 15, blue),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(height: 40.h, decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: blue, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: text(context, 'اخر اسبوع', 15, blue),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(height: 40.h, decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: blue, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: text(context, 'اليوم', 15, blue),
                ),),
            ),
          ];

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
