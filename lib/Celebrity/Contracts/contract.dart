import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as Path;
import 'package:celepraty/Celebrity/Contracts/ContractModel.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/invoice/Invoice.dart';
import 'package:celepraty/invoice/InvoicePdf.dart';
import 'package:flutter/foundation.dart';
import 'package:hand_signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../Requests/GenerateContract.dart';
import 'package:async/async.dart';

//import 'package:pdf/widgets.dart' as pw;

bool signed = false;
class contract extends StatefulWidget {
  _contractState createState() => _contractState();
}

class _contractState extends State<contract> {
  Future<InvoiceModel>? invoices;

  PlatformContract? platformContract;
  bool ready = false;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  Map<String,bool> typetext=HashMap();
  Map<String,bool> datetext=HashMap();
  Map<String,bool> usertext=HashMap();
  List<Widget> typefilter = [];
  List<Widget> datefilter = [];
  List<Widget> userfilter = [];
  bool isChckid = false;
  ByteData? png;
  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  int helpp = 0;
  List dateChoices=['اليوم','اخر اسبوع','اخر شهر'];

  List help =[];
  final _baseUrl = 'https://mobile.celebrityads.net/api/celebrity/contracts';
  int _page = 1;
  List posttemp =[];
  bool ActiveConnection = false;
  String T = "";

  List thisWeek =[];
  List thisWeek2 =[];

  List thisMonth =[];
  List thisMonth2 =[];
  // There is next page or not
  bool _hasNextPage = true;
  Uint8List? bytes;
  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;
  bool both = false;
  bool datef = false;
  bool typef = false;
  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  String? phone, taxnumber;
  // This holds the posts fetched from the server
  List _posts = [];
  List _postsfilter = [];
  ScrollController _controller = ScrollController();

  String? desc;
  List<String> imagePaths = [];
  final imagePicker = ImagePicker();
  final file = File('example.pdf');

  //  final pdf = pw.Document();
  DateTime date = DateTime.now();
  String? userToken;
int counter = 0;
  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getContracts();
        print(_posts.length.toString()+':::::::::::::::');
        thisWeek2.add(DateTime.now());
        thisWeek.add(DateTime.now().year.toString()+'/'+DateTime.now().month.toString()+'/'+DateTime.now().day.toString());
        for(int i =0; i<6; i++){
          thisWeek.add(thisWeek2[i].subtract(Duration(days: 1)).year.toString()+'/'+thisWeek2[i].subtract(Duration(days: 1)).month.toString()+
              '/'+thisWeek2[i].subtract(Duration(days: 1)).day.toString());
          thisWeek2.add(thisWeek2[i].subtract(Duration(days: 1)));
        }

        thisMonth2.add(DateTime.now());
        thisMonth.add(DateTime.now().year.toString()+'/'+DateTime.now().month.toString()+'/'+DateTime.now().day.toString());
        for(int i =0; i<30; i++){
          thisMonth.add(thisMonth2[i].subtract(Duration(days: 1)).year.toString()+'/'+thisMonth2[i].subtract(Duration(days: 1)).month.toString()+
              '/'+thisMonth2[i].subtract(Duration(days: 1)).day.toString());
          thisMonth2.add(thisMonth2[i].subtract(Duration(days: 1)));
        }
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
  List<String> temp=[];
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
                        Container(alignment:Alignment.topRight,child: text(context, '   العقود ', textHeadSize, black)),
                        SizedBox(height: 30.h,),
                        Padding(
                          padding:  EdgeInsets.only(left:20.w, top:10.h),
                          child: InkWell(onTap:(){
                            showDialog(context: context, builder: (BuildContext contextt){
                              return Center(
                                  child: Container(
                                    decoration:BoxDecoration(color: white,
                                    borderRadius: BorderRadius.circular(10.r))
                                    ,height: 550.h, width: 350.w,child:Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(height: 20.h,),
                                            text(context, 'نوع العقد', 18, black),
                                          SizedBox(height: 10.h,),
                                          Wrap(textDirection: TextDirection.rtl,children: typefilter),
                                            SizedBox(height: 10.h,),
                                            text(context, 'التاريخ', 18, black),
                                            SizedBox(height: 10.h,),
                                            Wrap(textDirection: TextDirection.rtl,children: datefilter),
                                            SizedBox(height: 10.h,),
                                            text(context, userfilter.isEmpty?'':'اسم المستخدم', 18, black),
                                            SizedBox(height: 10.h,),
                                            Container(height: 180.h,child: SingleChildScrollView(child: Wrap(textDirection: TextDirection.rtl,children:userfilter))),
                                        ],),
                                            Card(
                                              elevation: 0,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap:(){Navigator.pop(contextt);
                                                    setState(() {
                                                      typetext.forEach((key, value) {
                                                        value == true?{typetext[key] = false}:null;
                                                      });
                                                      datetext.forEach((key, value) {
                                                        value == true?{datetext[key] = false}:null;
                                                      });
                                                      _posts.length < _postsfilter.length?_posts=_postsfilter: null;
                                                    });
                                                    },
                                                    child: Container(
                                                      margin:EdgeInsets.only(left: 5.w,right: 5.3.w, bottom: 5.h),height: 40.h,width:100,decoration: BoxDecoration(color: grey, borderRadius:
                                                    BorderRadius.circular(10.r),),child: Center(child: text(context, 'الغاء', 17, white)),),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      print(typef.toString()+ 'at first ........................');
                                                      print(datef.toString()+ 'at first ........................');
                                                      Navigator.pop(context);
                                                      setState((){
                                                        typetext.forEach((key, value) {
                                                          value == true?{ setState((){!temp.contains(key)?temp.add(key):null; typef = true;})}:{temp.contains(key)?  setState((){temp.remove(key);}):null};
                                                        });
                                                        datetext.forEach((key, value) {
                                                          value == true?{ !temp.contains(key)?temp.add(key):null, datef = true}:{temp.contains(key)? temp.remove(key):null};
                                                        });

                                                        setState(() {
                                                          if(typef == true && datef == true){
                                                            both = true;
                                                          }
                                                        });
                                                        print(typef.toString()+ 'after loop ........................');
                                                        print(datef.toString()+ 'after loop ........................');
                                                        _posts.length > _postsfilter.length?{
                                                          print('posts length is longer ........................'),
                                                          setState(() {
                                                            _postsfilter= _posts;
                                                            _posts = [];
                                                          }),
                                                          print(temp.length.toString()+'=============================================='),
                                                          for(int j =0; j< temp.length; j++){
                                                            print(temp[j]),
                                                            _posts.addAll(_postsfilter.where((element) => temp[j] =='اعلان'|| temp[j] =='مساحة اعلانية' ||temp[j] =='عقد المنصة'?element.runtimeType == Orders?element.adType.name == temp[j] && !_posts.contains(element) :
                                                            temp[j] =='عقد المنصة' && !_posts.contains(element)? true:false:
                                                            temp[j] == 'اخر شهر'?
                                                            element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()):
                                                            thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                            ):
                                                            temp[j] == 'اليوم'?
                                                            element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
                                                                DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                DateTime.now().year.toString() && !_posts.contains(element):
                                                            DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
                                                                DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                DateTime.now().year.toString() && !_posts.contains(element)
                                                                :
                                                            element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
                                                            thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                            ) && !_posts.contains(element)
                                                            )
                                                            ),
                                                          },
                                                        }:{
                                                          both?
                                                          {
                                                            print(temp.length.toString()+'=============================================='),
                                                            print('both have values ........................'),
                                                            posttemp.addAll(_postsfilter),
                                                            _posts = [],
                                                            for(int j =0; j< temp.length; j++){
                                                              _posts.addAll(posttemp.where((element) =>
                                                              temp[j] == 'اخر شهر'?
                                                              element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                  DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
                                                              thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                  DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                              ) && !_posts.contains(element):
                                                              temp[j] == 'اليوم'?
                                                              element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
                                                                  DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                  DateTime.now().year.toString() && !_posts.contains(element):
                                                              DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
                                                                  DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                  DateTime.now().year.toString() && !_posts.contains(element)
                                                                  : temp[j] == 'اخر اسبوع'?
                                                              element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                  DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
                                                              thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                  DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                              ) && !_posts.contains(element):false
                                                              )
                                                              ),
                                                            },
                                                            help = _posts,
                                                            _posts = [],
                                                            setState(() {
                                                              for(int j =0; j< temp.length; j++){
                                                                _posts.addAll(help.where((element) => element.runtimeType == Orders?element.adType.name == temp[j] && !_posts.contains(element):
                                                                temp[j] =='عقد المنصة'&& !_posts.contains(element)? true:false
                                                                ));
                                                              };
                                                            }),

                                                          }:
                                                          {
                                                            print(temp.length.toString()+'=============================================='),
                                                            if(typef == false && datef == false){
                                                              _posts = [],
                                                              for(int j =0; j< temp.length; j++){
                                                                print(temp[j]),
                                                                _posts.addAll(_postsfilter.where((element) => element.runtimeType == Orders?element.adType.name == temp[j] :
                                                                temp[j] =='عقد المنصة'? true:
                                                                temp[j] == 'اخر شهر'?
                                                                element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                    DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()):
                                                                thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                    DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                                ):
                                                                temp[j] == 'اليوم'?
                                                                element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
                                                                    DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                    DateTime.now().year.toString() && !_posts.contains(element):
                                                                DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
                                                                    DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                    DateTime.now().year.toString() && !_posts.contains(element)
                                                                    :temp[j] == 'اخر اسبوع'?
                                                                element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                    DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
                                                                thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                    DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                                ) && !_posts.contains(element):false
                                                                )
                                                                ),
                                                              },
                                                            }else{
                                                              print('not both have values ........................'),
                                                              //posttemp = _posts,
                                                              _posts = [],

                                                              for(int j =0; j< temp.length; j++){
                                                                _posts.addAll(_postsfilter.where((element) =>
                                                                temp[j] == 'اخر شهر'?
                                                                element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                    DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
                                                                thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                    DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                                ) && !_posts.contains(element):
                                                                temp[j] == 'اليوم'?
                                                                element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
                                                                    DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                    DateTime.now().year.toString() && !_posts.contains(element):
                                                                DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
                                                                    DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
                                                                    DateTime.now().year.toString() && !_posts.contains(element)
                                                                    : temp[j] == 'اخر اسبوع'?
                                                                element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
                                                                    DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
                                                                thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
                                                                    DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
                                                                ) && !_posts.contains(element):false
                                                                )
                                                                ),
                                                              },


                                                              setState(() {
                                                                for(int j =0; j< temp.length; j++){
                                                                  _posts.addAll(_postsfilter.where((element) => element.runtimeType == Orders?element.adType.name == temp[j] && !_posts.contains(element):
                                                                  temp[j] =='عقد المنصة'&& !_posts.contains(element)? true:false
                                                                  )
                                                                  );
                                                                };
                                                              }),
                                                            }
                                                            ,},

                                                          temp.isEmpty? _posts=_postsfilter:null,
                                                          setState((){typef = false; datef = false; both = false;})
                                                        };

                                                      });},
                                                    child: Container(
                                                      margin:EdgeInsets.only(right: 5.3.w, bottom: 5.h),height: 40.h,width: 192.w,decoration: BoxDecoration(color: blue, borderRadius:
                                                    BorderRadius.circular(10.r),),child: Center(child: text(context, 'تطبيق', 17, white)),),
                                                  ),
                                                ],
                                              ),
                                            )

                                        ],
                                      ),
                                    )));
                            });
                          },child: Icon(Icons.filter_list, size: 40.r, color:black.withOpacity(0.70))),
                        )
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //   InkWell(
                        //     onTap:(){showBottomSheett2(context,
                        //         BottomSheetMenue(context,'نوع العقد',typetext,typefilter));},
                        //     child: Container(
                        //         height: 35.h,
                        //         decoration: BoxDecoration(border: Border.all(color: black.withOpacity(0.60))),
                        //     child: Padding(
                        //       padding:  EdgeInsets.only(left: 8.w,right: 8.w),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //         text(context, 'نوع العقد', 15, black),
                        //         SizedBox(width: 10.w,),
                        //         Icon(Icons.arrow_drop_down,size:30.r, color:grey)
                        //       ],),
                        //     )),
                        //   ),
                        //   SizedBox(width: 10.w,),
                        //   InkWell(
                        //     onTap: (){
                        //       showBottomSheett2(context,
                        //         BottomSheetMenue(context,'التاريخ',datetext,datefilter));
                        //     },
                        //     child: Container(
                        //         height: 35.h,
                        //         decoration: BoxDecoration(border: Border.all(color: black.withOpacity(0.60))),
                        //         child: Center(
                        //           child: Padding(
                        //             padding:  EdgeInsets.only(left: 8.w,right: 8.w),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 text(context, 'التاريخ', 15, black),
                        //                 SizedBox(width: 10.w,),
                        //                 Icon(Icons.arrow_drop_down,size:30.r, color:grey)
                        //               ],),
                        //           ),
                        //         )),
                        //   ),
                        //     SizedBox(width: 10.w,),
                        //   InkWell(
                        //     onTap: (){},
                        //     child: Container(
                        //         height: 35.h,
                        //         decoration: BoxDecoration(border: Border.all(color: black.withOpacity(0.60))),
                        //         child: Center(
                        //           child: Padding(
                        //             padding:  EdgeInsets.only(left: 8.w,right: 8.w),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //                 text(context, 'اسم المستخدم', 15, black),
                        //                 SizedBox(width: 10.w,),
                        //                 Icon(Icons.arrow_drop_down,size:30.r, color:grey)
                        //               ],),
                        //           ),
                        //         )),
                        //   )
                        // ],),

                      ],
                    ),
                  ),

                  _posts.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 80.h,
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
                                               'تنفيذ عقد المنصة ',
                                              textTitleSize,
                                              black),
                                          text(
                                              context,
                                            'منصات المشاهير',
                                              14,
                                              green),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    SizedBox(width: 5.w,),
                                    InkWell(
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: 10.0.w, right: 10.w),
                                        child:  Icon(
                                          Icons.pending_actions,
                                          size: 25,
                                          color: black.withOpacity(0.70),
                                        ),
                                      ),
                                      onTap: () async {
                                        showContract();
                                        // loadingDialogue(context);
                                        // Uint8List?  bytes = await GenerateContract.generateContractSingUP(
                                        // );
                                        // final directory = await getTemporaryDirectory();
                                        // final filepath = directory.path + '/' + "contract.pdf";
                                        // File file = await File(filepath).writeAsBytes(bytes);
                                        // await InvoicePdf.openFile(file);
                                        // Navigator.pop(context);
                                      }
                                    ),
                                  ],
                                ),


                              ],
                            ),
                          )

                      ),
                    ),
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
                                height: 80.h,
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
                                                        _posts[index].runtimeType == PlatformContract?  'تنفيذ عقد المنصة ':'تنفيذ عقد '+_posts[index].adType.name  ,
                                                        textTitleSize,
                                                        black),
                                                    text(
                                                        context,
                                                        _posts[index].runtimeType == PlatformContract?'منصات المشاهير': _posts[index].user.name,
                                                        14,
                                                        green),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  text(
                                                      context,
                                                      _posts[index].runtimeType == PlatformContract? DateTime.parse(platformContract!.date.toString()).year.toString()+'/'
                                                          + DateTime.parse(platformContract!.date.toString()).month.toString()+'/'+
                                                          DateTime.parse(platformContract!.date.toString()).day.toString():
                                                      DateTime.parse(_posts[index].contract.date.toString()).year.toString()+'/'
                                                      + DateTime.parse(_posts[index].contract.date.toString()).month.toString()+'/'+
                                                          DateTime.parse(_posts[index].contract.date.toString()).day.toString(),
                                                      textError,
                                                      grey!),
                                                  SizedBox()
                                                ],
                                              ),
                                              SizedBox(width: 5.w,),
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
                                                onTap: _posts[index].runtimeType == PlatformContract?
                                                    () async {
                                                  loadingDialogue(context);
                                                  Uint8List?  bytes = await GenerateContract.generateContractSingUP(
                                                  );
                                                  final directory = await getTemporaryDirectory();
                                                  final filepath = directory.path + '/' + "contract.pdf";
                                                  File file = await File(filepath).writeAsBytes(bytes);
                                                  await InvoicePdf.openFile(file);
                                                  Navigator.pop(context);
                                                }
                                                    :() async {
                                                  loadingDialogue(context);
                                                  Uint8List?  bytes = await GenerateContract.generateContract(
                                                      advDescription: _posts[index].adType.name == 'مساحة اعلانية'?"": _posts[index].description,
                                                      advLink: _posts[index].adType.name == 'مساحة اعلانية'?_posts[index].link: '',
                                                      advOrAdvSpace: _posts[index].adType.name== 'مساحة اعلانية'?'مساحة اعلانية':'إعلان',
                                                      platform: '${_posts[index].platform?.name}',
                                                      advProductOrService:'${ _posts[index].advertisingAdType?.name}',
                                                      celerityVerifiedType:
                                                      _posts[index].celebrity.celebrityType == 'person'?'رخصة اعلانية':
                                                      'سجل تجاري',
                                                      advTime:'${_posts[index].adTiming?.name}',
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
                                                      sendDate: DateTime.parse(_posts[index].contract.date).day.toString()+'/'+
                                                          DateTime.parse(_posts[index].contract.date).month.toString()+'/'+
                                                          DateTime.parse(_posts[index].contract.date).year.toString(),
                                                      advDate:  _posts[index].date!,
                                                      userSingture: _posts[index].contract.userSignature,
                                                      celeritySigntion:  _posts[index].contract.celebritySignature);
                                                  final directory = await getTemporaryDirectory();
                                                  final filepath = directory.path + '/' + "contract.pdf";
                                                  File file = await File(filepath).writeAsBytes(bytes);
                                                  await InvoicePdf.openFile(file);
                                                  Navigator.pop(context);

                                                },
                                              ),
                                            ],
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
  // Widget invoice2(index) {
  //   return SingleChildScrollView(
  //     child:  StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState /*You can rename this!*/){
  //           return Column(
  //             children: [
  //               InkWell(
  //                 child: Stack(
  //                   alignment: Alignment.center,
  //                   children: [
  //                     Container(
  //                       width: 450.w,
  //                       height: 60.h,
  //                       decoration: BoxDecoration(
  //                           borderRadius: const BorderRadius.only(
  //                               topLeft: Radius.circular(20),
  //                               topRight: Radius.circular(20)),
  //                           color: lightGrey.withOpacity(0.30)),
  //                     ),
  //                     Container(
  //                       width: 60.w,
  //                       height: 5.h,
  //                       decoration: BoxDecoration(
  //                           color: grey,
  //                           borderRadius: BorderRadius.all(
  //                               Radius.circular(50))),
  //                     ),
  //                   ],
  //                 ),
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               SizedBox(height: 200.h),
  //               text(context, 'هنا العقد', 20, black),
  //               SizedBox(height: 220.h),
  //               Padding(
  //                 padding:  EdgeInsets.only(right: 100.w),
  //                 child: Column(
  //                   children: [
  //                     Padding(
  //                       padding:  EdgeInsets.only(right: 180.w),
  //                       child: text(context, 'التوقيع', 20, black),
  //                     ),
  //                     InkWell(
  //                       onTap: (){
  //                         showDialog(context: context, builder: (contextt){
  //                           return Column(
  //                             children: [
  //                               SizedBox(height: 200.h),
  //                               text(context, '', 20, black),
  //                               Container(
  //                                 height: 300.h,
  //                                 width: 300.w,
  //                                 color: Colors.white,
  //                                 child: HandSignature(
  //                                   control: control,
  //                                   color: Colors.blueGrey,
  //                                   width: 0.5,
  //                                   maxWidth: 5.0,
  //                                   type: SignatureDrawType.shape,
  //                                   onPointerUp: () async {
  //                                     png = await control.toImage();
  //                                     Navigator.pop(contextt);
  //                                     // showDialog(context: context, builder: (contextt){
  //                                     //   return Image.memory(png!.buffer.asUint8List());
  //
  //                                     //   });
  //                                   },
  //                                 ),
  //                               ),
  //                               SizedBox(height: 200.h),
  //                             ],
  //                           );
  //
  //                         }).whenComplete(() => setState((){ready = true;}));
  //                       },
  //                       child: Container(
  //                         height: 120,
  //                         width: 500.w,
  //                         color: Colors.white24,
  //                         child: png==null? SizedBox():Padding(
  //                           padding:  EdgeInsets.only(right: 150.w),
  //                           child: ready?Image.memory(png!.buffer.asUint8List()):SizedBox(),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );}
  //     ),
  //   );
  // }

  // Widget BottomSheetMenue(context, textt, Map textfilterr,List<Widget> filter) {
  //   return SingleChildScrollView(
  //     child: Container(
  //       height: 400.h,
  //      color: Colors.transparent,
  //       child: Stack(
  //         alignment: Alignment.topLeft,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(top: 20.h),
  //             child: Container(
  //
  //               decoration: BoxDecoration(  color:white,borderRadius:  BorderRadius.only(
  //                   topLeft: Radius.circular(50), topRight: Radius.circular(50)),),
  //
  //               width: double.infinity,
  //              // height: 230.h,
  //               child: Column(
  //                   children:[
  //                     SizedBox(height: 35.h,),
  //                     Container(margin:EdgeInsets.only(right: 20.w),alignment:Alignment.topRight,child:
  //                     text(context, textt, 21, black,fontWeight: FontWeight.bold)),
  //                     SizedBox(height: 20.h,),
  //                   Container(height:200.h,child: ListView(children: filter,)),
  //                   InkWell(
  //                     onTap: (){
  //                       print(typef.toString()+ 'at first ........................');
  //                       print(datef.toString()+ 'at first ........................');
  //                       Navigator.pop(context);
  //                       setState((){
  //                         typetext.forEach((key, value) {
  //                             value == true?{ setState((){!temp.contains(key)?temp.add(key):null; typef = true;})}:{temp.contains(key)?  setState((){temp.remove(key);}):null};
  //                         });
  //                         datetext.forEach((key, value) {
  //                           value == true?{ !temp.contains(key)?temp.add(key):null, datef = true}:{temp.contains(key)? temp.remove(key):null};
  //                         });
  //
  //                         setState(() {
  //                           if(typef == true && datef == true){
  //                             both = true;
  //                           }
  //                         });
  //                         print(typef.toString()+ 'after loop ........................');
  //                         print(datef.toString()+ 'after loop ........................');
  //                         _posts.length > _postsfilter.length?{
  //                           print('posts length is longer ........................'),
  //                         setState(() {
  //                         _postsfilter= _posts;
  //                         _posts = [];
  //                         }),
  //                           print(temp.length.toString()+'=============================================='),
  //                           for(int j =0; j< temp.length; j++){
  //                             print(temp[j]),
  //                             _posts.addAll(_postsfilter.where((element) => textt == 'نوع العقد'?element.runtimeType == Orders?element.adType.name == temp[j] && !_posts.contains(element) :
  //                             temp[j] =='عقد المنصة' && !_posts.contains(element)? true:false:
  //                             temp[j] == 'اخر شهر'?
  //                             element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                                 DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()):
  //                             thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                                 DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                             ):
  //                             temp[j] == 'اليوم'?
  //                             element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
  //                                 DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                                 DateTime.now().year.toString() && !_posts.contains(element):
  //                             DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
  //                                 DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                                 DateTime.now().year.toString() && !_posts.contains(element)
  //                                 :
  //                             element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                                 DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
  //                             thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                                 DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                             ) && !_posts.contains(element)
  //                             )
  //                             ),
  //                           },
  //                         }:{
  //                           both?
  //                               {
  //                                 print(temp.length.toString()+'=============================================='),
  //                                 print('both have values ........................'),
  //                                posttemp.addAll(_posts),
  //                                 _posts = [],
  //                               for(int j =0; j< temp.length; j++){
  //                               _posts.addAll(posttemp.where((element) =>
  //                               temp[j] == 'اخر شهر'?
  //                               element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                               DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
  //                               thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                               DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                               ) && !_posts.contains(element):
  //                               temp[j] == 'اليوم'?
  //                               element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
  //                               DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                               DateTime.now().year.toString() && !_posts.contains(element):
  //                               DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
  //                               DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                               DateTime.now().year.toString() && !_posts.contains(element)
  //                                   : temp[j] == 'اخر اسبوع'?
  //                               element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                               DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
  //                               thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                               DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                               ) && !_posts.contains(element):false
  //                               )
  //                               ),
  //                               },
  //                                 help = _posts,
  //                                 _posts = [],
  //                               setState(() {
  //                               for(int j =0; j< temp.length; j++){
  //                               _posts.addAll(help.where((element) => element.runtimeType == Orders?element.adType.name == temp[j] && !_posts.contains(element):
  //                               temp[j] =='عقد المنصة'&& !_posts.contains(element)? true:false
  //                               ));
  //                               };
  //                               }),
  //
  //                               }:
  //                               {
  //                                 print(temp.length.toString()+'=============================================='),
  //                                 if(typef == false && datef == false){
  //                                   _posts = [],
  //                                   for(int j =0; j< temp.length; j++){
  //                                     print(temp[j]),
  //                                     _posts.addAll(_postsfilter.where((element) => element.runtimeType == Orders?element.adType.name == temp[j] :
  //                                     temp[j] =='عقد المنصة'? true:
  //                                     temp[j] == 'اخر شهر'?
  //                                     element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                                         DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()):
  //                                     thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                                         DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                                     ):
  //                                     temp[j] == 'اليوم'?
  //                                     element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
  //                                         DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                                         DateTime.now().year.toString() && !_posts.contains(element):
  //                                     DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
  //                                         DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                                         DateTime.now().year.toString() && !_posts.contains(element)
  //                                         :temp[j] == 'اخر اسبوع'?
  //                                     element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                                         DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
  //                                     thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                                         DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                                     ) && !_posts.contains(element):false
  //                                     )
  //                                     ),
  //                                   },
  //                                 }else{
  //                                   print('not both have values ........................'),
  //                                    //posttemp = _posts,
  //                                   _posts = [],
  //
  //                                   for(int j =0; j< temp.length; j++){
  //                                     _posts.addAll(_postsfilter.where((element) =>
  //                                     temp[j] == 'اخر شهر'?
  //                                     element.runtimeType != Orders? thisMonth.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                                         DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
  //                                     thisMonth.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                                         DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                                     ) && !_posts.contains(element):
  //                                     temp[j] == 'اليوم'?
  //                                     element.runtimeType != Orders?DateTime.parse(element.date).day.toString() + '/'+  DateTime.parse(element.date).month.toString()+'/'+
  //                                         DateTime.parse(element.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                                         DateTime.now().year.toString() && !_posts.contains(element):
  //                                     DateTime.parse(element.contract.date).day.toString() + '/'+  DateTime.parse(element.contract.date).month.toString()+'/'+
  //                                         DateTime.parse(element.contract.date).year.toString() == DateTime.now().day.toString()  + '/'+ DateTime.now().month.toString()+'/'+
  //                                         DateTime.now().year.toString() && !_posts.contains(element)
  //                                         : temp[j] == 'اخر اسبوع'?
  //                                     element.runtimeType != Orders? thisWeek.contains(DateTime.parse(element.date).year.toString()+'/'+
  //                                         DateTime.parse(element.date).month.toString()+'/'+DateTime.parse(element.date).day.toString()) && !_posts.contains(element):
  //                                     thisWeek.contains(DateTime.parse(element.contract.date).year.toString()+'/'+
  //                                         DateTime.parse(element.contract.date).month.toString()+'/'+DateTime.parse(element.contract.date).day.toString()
  //                                     ) && !_posts.contains(element):false
  //                                     )
  //                                     ),
  //                                   },
  //
  //
  //                                   setState(() {
  //                                     for(int j =0; j< temp.length; j++){
  //                                       _posts.addAll(_postsfilter.where((element) => element.runtimeType == Orders?element.adType.name == temp[j] && !_posts.contains(element):
  //                                       temp[j] =='عقد المنصة'&& !_posts.contains(element)? true:false
  //                                       )
  //                                       );
  //                                     };
  //                                   }),
  //                                 }
  //                               ,},
  //
  //                         temp.isEmpty? _posts=_postsfilter:null,
  //                           setState((){typef = false; datef = false; both = false;})
  //                         };
  //
  //                         });},
  //                     child: Container(margin:EdgeInsets.all(20),height: 40.h,width: double.infinity,decoration: BoxDecoration(color: blue, borderRadius:
  //                     BorderRadius.circular(10.r),),child: Center(child: text(context, 'تطبيق', 17, white)),),
  //                   )],
  //   ),
  //             ),
  //           ),
  //           InkWell(
  //             onTap:(){Navigator.pop(context);},
  //             child: Padding(
  //               padding:  EdgeInsets.only(left: 30.w,top: 10.h),
  //               child: CircleAvatar( backgroundColor:white,radius : 20.r,child: Icon(Icons.clear,color: black.withOpacity(0.60), size:30.r)),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ));
  // }
  // void showBottomSheett2(context, buttomMenue) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       elevation: 0,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(50), topRight: Radius.circular(50)),
  //       ),
  //       backgroundColor:  Colors.transparent,
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
  //           // margin: EdgeInsets.only(right: 10, left: 10),
  //           // color: Colors.transparent.withOpacity(0.5),
  //           height: 400.h,
  //           child: Container(
  //            // margin: EdgeInsets.only(left: 5, right: 5),
  //             height: 180.h,
  //             child: buttomMenue,
  //             decoration: BoxDecoration(
  //                 color: Colors.transparent, borderRadius: BorderRadius.circular(8)),
  //           ),
  //         );
  //       });
  // }
  //
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
          Contract
              .fromJson(jsonDecode(response.body))
              .data!.platformContract != null? _posts.add(Contract
              .fromJson(jsonDecode(response.body))
              .data!.platformContract!):null;
          _posts.addAll(Contract
              .fromJson(jsonDecode(response.body))
              .data!.orders!);
          Contract
              .fromJson(jsonDecode(response.body))
              .data!.platformContract != null?platformContract =Contract
              .fromJson(jsonDecode(response.body))
              .data!.platformContract!: null;

          typetext.putIfAbsent('عقد المنصة', ()=> false);
          typefilter.add(Directionality(
            textDirection: TextDirection.rtl,
            child: StatefulBuilder(
              builder: (contexx, setS){return
                Card(
                  elevation: 0,
                  child: InkWell(
                  onTap:(){
                    setS(() {
                      typetext['عقد المنصة'] = !typetext['عقد المنصة']!;
                    });
                  },
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(color:  typetext['عقد المنصة']!?blue:white,
                        border: Border.all(color:  typetext['عقد المنصة']!?white:blue, width: 1),
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 18.w),
                      child: text(context, 'عقد المنصة', 20,  typetext['عقد المنصة']!?white:blue),
                    ),

                  ),
                ),);},

            ),
          ));

          for(int i =0; i< _posts.length-1; i++){
            typetext.keys.contains(Contract
                .fromJson(jsonDecode(response.body))
                .data!.orders![i].adType!.name!)? null:{
              typetext.putIfAbsent(Contract
                  .fromJson(jsonDecode(response.body))
                  .data!
                  .orders![i].adType!.name!, () => false),

          typefilter.add(
          Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
          builder: (contexx, setS){return
            Card(
              elevation: 0,
              child: InkWell(
              onTap:(){
                setS(() {
                  typetext[Contract
                      .fromJson(jsonDecode(response.body))
                      .data!.orders![i].adType!.name!] = !typetext[Contract
                      .fromJson(jsonDecode(response.body))
                      .data!.orders![i].adType!.name!]!;
                });
              },
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(color: typetext[Contract
                    .fromJson(jsonDecode(response.body))
                    .data!.orders![i].adType!.name!]!?blue:white,
                    border: Border.all(color:  typetext[Contract
                        .fromJson(jsonDecode(response.body))
                        .data!.orders![i].adType!.name!]!?white:blue, width: 1),
                    borderRadius: BorderRadius.circular(10.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: text(context, Contract
                      .fromJson(jsonDecode(response.body))
                      .data!.orders![i].adType!.name!, 20,  typetext[Contract
                      .fromJson(jsonDecode(response.body))
                      .data!.orders![i].adType!.name!]!?white:blue),
                ),

              ),
            ),);
          },

          ),
          )),
           } ;
          }

          for(int i =0; i< _posts.length-1; i++){
            usertext.keys.contains(Contract
                .fromJson(jsonDecode(response.body))
                .data!.orders![i].user!.name!)?null:{
              usertext.putIfAbsent(Contract
                  .fromJson(jsonDecode(response.body))
                  .data!.orders![i].user!.name!, () => false),
          userfilter.add(
          Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
          builder: (contexx, setS){return
          Card(
          elevation: 0,
          child: InkWell(
          onTap:(){
          setS(() {
          usertext[ Contract
              .fromJson(jsonDecode(response.body))
              .data!.orders![i].user!.name!] = ! usertext[ Contract
              .fromJson(jsonDecode(response.body))
              .data!.orders![i].user!.name!]!;
          });
          },
          child: Container(
          height: 40.h,
          width: 150.w,
          decoration: BoxDecoration(color: usertext[ Contract
              .fromJson(jsonDecode(response.body))
              .data!.orders![i].user!.name!]!?blue:white,
          border: Border.all(color:   usertext[ Contract
              .fromJson(jsonDecode(response.body))
              .data!.orders![i].user!.name!]!?white:blue, width: 1),
          borderRadius: BorderRadius.circular(10.r)),
          child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 0.w),
          child: Center(
            child: text(context,  Contract
                .fromJson(jsonDecode(response.body))
                .data!.orders![i].user!.name!, 20,   usertext[ Contract
                .fromJson(jsonDecode(response.body))
                .data!.orders![i].user!.name!]!?white:blue),
          ),
          ),

          ),
          ),);
          },

          ),
          ))
            };


          }

   for(int i =0; i< dateChoices.length; i++){
     datetext.keys.contains(dateChoices[i]) ? null:{
       datetext.putIfAbsent(dateChoices[i], ()=> false),
       datefilter.add(
           Directionality(
             textDirection: TextDirection.rtl,
             child: StatefulBuilder(
               builder: (contexx, setS){return
                 Card(
                   elevation: 0,
                   child: InkWell(
                     onTap:(){
                       setS(() {
                         datetext[dateChoices[i]] = !datetext[dateChoices[i]]!;
                       });
                     },
                     child: Container(
                       height: 40.h,
                       decoration: BoxDecoration(color: datetext[dateChoices[i]]!?blue:white,
                           border: Border.all(color:  datetext[dateChoices[i]]!?white:blue, width: 1),
                           borderRadius: BorderRadius.circular(10.r)),
                       child: Padding(
                         padding:  EdgeInsets.symmetric(horizontal: 15.w),
                         child: text(context, i ==0? 'اليوم': i==1? 'اخر اسبوع':'اخر شهر', 20,  datetext[dateChoices[i]]!?white:blue),
                       ),

                     ),
                   ),);
                 },

             ),
           )),
     } ;
   }

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

  showContract() {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.70),
        context: context,
        builder: (context2) {
          return StatefulBuilder(builder: (context, setState2) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              elevation: 5,
              backgroundColor: white,
              contentPadding:
              EdgeInsets.only(top: 5.h, right: 10.w, left: 10.w),
              actionsPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.all(10.r),
              content: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
//Contract==================================================================================

                    Expanded(
                      flex: 8,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: black, width: 0.5)),
                        child: PdfPreview(
                          dynamicLayout: true,
                          maxPageWidth: double.infinity,
                          previewPageMargin: EdgeInsets.only(bottom: 5.h, top: 0),
                          loadingWidget: const CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                            color: blue,
                          ),
                          build: (format) async {
                            if (mounted) {
                              bytes =
                              await GenerateContract.generateContractSingUP(
                                format: format,
                              );
                            }
                            return bytes!;
                          },
                          allowSharing: false,
                          canChangeOrientation: false,
                          canDebug: false,
                          allowPrinting: false,
                          canChangePageFormat: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
//confirm============================================================================
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          height:70.h,
                          child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: text(
                              context,
                              'قرات العقد واوافق عليه',
                              textTitleSize - 1,
                              black,
                            ),
                            value: isChckid,
                            selectedTileColor: black,
                            onChanged: (value) {
                              setState2(() {
                                isChckid = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
//Signtuer==================================================================================
                    Expanded(
                        flex: 3,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: png != null && helpp == 1
                              ? Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: Image.memory(
                                    png!.buffer.asUint8List(),
                                  )),
                              Padding(
                                padding: EdgeInsets.all(5.0.w),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.redo,
                                    size: 35.r,
                                  ),
                                  color: black,
                                  onPressed: () {
                                    if (mounted) {
                                      setState2(() {
                                        png = null;
                                        control.clear();
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          )
                              : HandSignature(
                            control: control,
                            color: Colors.blueGrey,
                            width: 0.5,
                            maxWidth: 3.0,
                            type: SignatureDrawType.shape,
                            onPointerUp: () async {
                              png = await control
                                  .toImage()
                                  .whenComplete(() {
                                if (mounted) {
                                  setState2(() {
                                    helpp = 1;
                                  });
                                }
                              });

                              // showDialog(context: context, builder: (contextt){
                              //   return Image.memory(png!.buffer.asUint8List());

                              //   });
                            },
                          ),
                        )),
                  ],
                ),
              ),
              //
              actions: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: png != null
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: buttoms(
                            context, 'إالغاء', 18, Colors.white, () {
                          Navigator.pop(context);

                          setState(() {
                            png = null;
                            control.clear();
                            isChckid = false;
                          });
                        }, backgrounColor: Colors.grey),
                      ),
//Sing up============================================================================
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 4,
                        child: buttoms(
                          context,
                          'موافقة',
                          18,
                          white,
                          isChckid == false
                              ? null
                              : () {
                            setState(() {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext
                                context2) {
                                  FocusManager
                                      .instance.primaryFocus
                                      ?.unfocus();
                                  sign().then((value) => {
                                    value.contains(
                                        'true')
                                        ? {
                                      Navigator.pop(
                                          context2),
                                       Navigator.pop(context),
                                      //done
                                      showMassage(
                                          context,
                                          'تم بنجاح',
                                          value.replaceAll('true',
                                              ''),
                                          done:
                                          done),
                                      getContracts(),
                                  setState(() {
                                  png = null;
                                  control.clear();
                                  isChckid = false;
                                  }),
                                  signed = true
                                    }
                                        : value ==
                                        'SocketException'
                                        ? {
                                      Navigator.pop(context),
                                      Navigator.pop(context2),
                                      showMassage(
                                        context2,
                                        'خطا',
                                        socketException,
                                      )
                                    }
                                        : {
                                      value == 'serverException'
                                          ? {
                                        Navigator.pop(context),
                                        Navigator.pop(context2),
                                        showMassage(
                                          context2,
                                          'خطا',
                                          serverException,
                                        )
                                      }
                                          : {
                                        value.replaceAll('false', '') == 'المستخدم محظور'
                                            ? {
                                          Navigator.pop(context),
                                          Navigator.pop(context2),
                                          showMassage(
                                            context2,
                                            'خطا',
                                            'لا يمكنك اكمال رفع الطلب ',
                                          )
                                        }
                                            : {
                                          //كود الخصم غير موجود
                                          Navigator.pop(context),
                                          Navigator.pop(context2),
                                          showMassage(
                                            context,
                                            'خطا',
                                            value.replaceAll('false', ''),
                                          )
                                        }
                                      }
                                    }
                                  });

                                  // == First dialog closed
                                  return AlertDialog(
                                    titlePadding: EdgeInsets.zero,
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    content: Center(
                                      child: SizedBox(
                                        width: 300.w,
                                        height: 150.h,
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Lottie.asset(
                                            "assets/lottie/loding.json",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                          },
                          backgrounColor: isChckid == false
                              ? Colors.grey.withOpacity(0.5)
                              : blue,
                          //horizontal: 40.w
                          //kjk
                        ),
                      ),
                    ],
                  )
                      : const SizedBox(),
                )
              ],
            );
          });
        });
  }

  Future<String> sign() async {
    try {
      final directory = await getTemporaryDirectory();
      final filepath = directory.path + '/' + "signature.png";

      File imgFile =
      await File(filepath).writeAsBytes(png!.buffer.asUint8List());

      var stream3 = http.ByteStream(DelegatingStream.typed(imgFile.openRead()));
      // get file length
      var length3 = await imgFile.length();

      // string to uri
      var uri =
      Uri.parse("https://mobile.celebrityads.net/api/celebrity/contracts/signature");

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer ${userToken}"
      };
      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile3 = http.MultipartFile(
          'celebrity_signature', stream3, length3,
          filename: Path.basename(imgFile.path));
      //
      // listen for response
      request.files.add(multipartFile3);
      request.headers.addAll(headers);
      var response = await request.send();
      http.Response respo = await http.Response.fromStream(response);
      print(jsonDecode(respo.body));
      print(jsonDecode(respo.body)['message']['ar']);
      return jsonDecode(respo.body)['message']['ar'] +
          jsonDecode(respo.body)['success'].toString();
    } catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }
}
