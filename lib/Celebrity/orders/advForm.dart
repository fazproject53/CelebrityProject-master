import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Celebrity/MyRequests/myRequestsMain.dart';
import 'package:celepraty/Celebrity/orders/gifttingForm.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../MainScreen/main_screen_navigation.dart';
import '../../Users/Exploer/viewData.dart';
import '../../Users/UserRequests/UserReguistMainPage.dart';
import '../Pricing/ModelPricing.dart';
import '../celebrityHomePage.dart';
import 'AdvFormResponse.dart';

class advForm extends StatefulWidget{
  final String? id,image, name, privacyPolicy;
  const advForm({Key? key,  this.id, this.image, this.name, this.privacyPolicy}) : super(key: key);
  _advFormState createState() => _advFormState();
}

class _advFormState extends State<advForm> {
  String? resp;
  Future<Platform>? platforms;
  String? userToken;
  int? _value = 1;
  bool isValue1 = false;
  int? _value2 = 1;
  int? _value3 = 1;
  int? _value4 = 1;
  Future<Pricing>? pricing;
  var platformlist = [];
  bool dateInvalid = false;
  bool platformChosen = true;
  String platform = 'اختر منصة العرض';
  String? showFile;
  List<DropdownMenuItem<Object?>> _dropdownTestItem = [];
  bool activateIt = false;
  var _selectedTest;
  bool file2Warn = false;
  Timer? _timer;


  //-----------------------------------------------------------------------------
  List<Widget> terms = [];
  List<String> termsToApi=[];
  int i = -1;
  bool adding = true;
  TextEditingController termController = TextEditingController();
  // باقي كود ال كونترولر في ال initState
  ScrollController? _controller;
  //-----------------------------------------------------------------------------

  TextEditingController balanceFrom = TextEditingController();
  TextEditingController balanceTo = TextEditingController();

  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = selectedTest;
      platformChosen = true;
      if (selectedTest['no'] == 0) {
        _selectedTest = null;
      }
    });
  }

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          alignment: Alignment.centerRight,
          value: i,
          child: Directionality(
              textDirection: TextDirection.rtl,child: Container( alignment: Alignment.centerRight,child: Text(i['keyword'], textDirection: TextDirection.rtl,))),

        ),
      );
    }
    return items;
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController description = new TextEditingController();
  final TextEditingController coupon = new TextEditingController();
  final TextEditingController pageLink = new TextEditingController();
  final TextEditingController subject =  TextEditingController();
  List<int> saveList = [];
  DateTime current = DateTime.now();
  bool checkit = false;
  bool warn2 = false;
  bool datewarn2 = false;
  bool warnimage = false;

  File? file, file2;
  Stream? streamm;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        platforms = fetchPlatform();
        pricing = fetchCelebrityPricingg(widget.id!);
      });
    });
     _controller = ScrollController();
    _dropdownTestItem = buildDropdownTestItems(platformlist);
    super.initState();
  }
  Future<Platform> fetchPlatform() async {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/platforms'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return Platform.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: drowAppBar('طلب اعلان', context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                  alignment: Alignment.bottomRight,
                  children: [ Container(height: 340.h,
                      width: 1000.w,
                      child:CachedNetworkImage(imageUrl:widget.image!, color: Colors.black45,
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,)),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'اطلب اعلان\n' + 'شخصي من ' + widget.name! + ' الان',
                        style: TextStyle(fontWeight: FontWeight.normal,
                            fontSize: textSubHeadSize,
                            color: white,
                            fontFamily: 'Cairo'),),
                    ),
                  ]),
              Container(
                child: Form(
                  key: _formKey,
                  child: paddingg(12, 12, 5, Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.h,),
                        padding(10, 12, Container(alignment: Alignment.topRight,
                            child: text(
                              context, ' فضلا ادخل البيانات الصحيحة', textSubHeadSize,
                              textBlack, fontWeight: FontWeight.normal,
                              family: 'Cairo',)),),

                        //========================== form ===============================================
                        FutureBuilder(
                            future: pricing,
                            builder: ((context, AsyncSnapshot<
                                Pricing> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(snapshot.error.toString()));
                                  //---------------------------------------------------------------------------
                                } else if (snapshot.hasData) {
                                  snapshot.data!.data != null &&
                                      snapshot.data!.data!.price!
                                          .advertisingPriceFrom != null &&
                                      snapshot.data!.data!.price!
                                          .advertisingPriceTo != null ?
                                  activateIt = true : null;
                                  return SizedBox();
                                } else {
                                  return const Center(
                                      child: Text('لايوجد لينك لعرضهم حاليا'));
                                }
                              } else {
                                return Center(
                                    child: Text(
                                        'State: ${snapshot.connectionState}'));
                              }
                            })),
                        SizedBox(height: 30,),
                        FutureBuilder(
                            future: platforms,
                            builder: ((context, AsyncSnapshot<
                                Platform> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return paddingg(15, 15, 12,
                                  DropdownBelow(
                                    itemWidth: 380.w,

                                    ///text style inside the menu
                                    itemTextstyle: TextStyle(
                                      fontSize: textFieldSize.sp,
                                      fontWeight: FontWeight.w400,
                                      color: black,
                                      fontFamily: 'Cairo',),

                                    ///hint style
                                    boxTextstyle: TextStyle(
                                        fontSize: textFieldSize.sp,
                                        fontWeight: FontWeight.w400,
                                        color: grey,
                                        fontFamily: 'Cairo'),

                                    ///box style
                                    boxPadding:
                                    EdgeInsets.fromLTRB(13.w, 0.h, 13.w, 0.h),
                                    boxWidth: 500.w,
                                    boxHeight: 40.h,
                                    boxDecoration: BoxDecoration(
                                        border: Border.all(
                                            color: newGrey, width: 0.5),
                                        color: lightGrey.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(
                                            8.r)),

                                    ///Icons
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    hint: Text(
                                      platform,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    value: _selectedTest,
                                    items: _dropdownTestItem,
                                    onChanged: onChangeDropdownTests,
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(snapshot.error.toString()));
                                  //---------------------------------------------------------------------------
                                } else if (snapshot.hasData) {
                                  _dropdownTestItem.isEmpty ? {
                                    platformlist.add({
                                      'no': 0,
                                      'keyword': 'اختر منصة العرض'
                                    }),
                                    for(int i = 0; i <
                                        snapshot.data!.data!.length; i++) {
                                      platformlist.add({
                                        'no': snapshot.data!.data![i].id!,
                                        'keyword': '${snapshot.data!.data![i]
                                            .name!}'
                                      }),
                                    },
                                    _dropdownTestItem =
                                        buildDropdownTestItems(platformlist),
                                  } : null;

                                  return paddingg(15, 15, 12,
                                    DropdownBelow(
                                      itemWidth: 370.w,

                                      ///text style inside the menu
                                      itemTextstyle: TextStyle(
                                        fontSize: textFieldSize.sp,
                                        fontWeight: FontWeight.w400,
                                        color: black,
                                        fontFamily: 'Cairo',),

                                      ///hint style
                                      boxTextstyle: TextStyle(
                                          fontSize: textFieldSize.sp,
                                          fontWeight: FontWeight.w400,
                                          color: grey,
                                          fontFamily: 'Cairo'),

                                      ///box style
                                      boxPadding:
                                      EdgeInsets.fromLTRB(
                                          13.w, 0.h, 13.w, 0.h),
                                      boxWidth: 500.w,
                                      boxHeight: 40.h,
                                      boxDecoration: BoxDecoration(
                                          border: Border.all(
                                              color: newGrey, width: 0.5),
                                          color: lightGrey.withOpacity(0.10),
                                          borderRadius: BorderRadius.circular(
                                              8.r)),

                                      ///Icons
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                                      hint: Text(
                                        platform,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      value: _selectedTest,
                                      items: _dropdownTestItem,
                                      onChanged: onChangeDropdownTests,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: Text('لايوجد لينك لعرضهم حاليا'));
                                }
                              } else {
                                return Center(
                                    child: Text(
                                        'State: ${snapshot.connectionState}'));
                              }
                            })),

                        platformChosen && _selectedTest == null
                            ?SizedBox(height: 10.h,): SizedBox(
                          height: _selectedTest !=
                              null? 10.h: 20.h ,
                              child: padding(10, 20, text(context,
                              'الرجاء اختيار منصة الاعلان', textError, _selectedTest !=
                              null ? white : red!,)),
                            ),

                        paddingg(
                          15.w, 15.w, 0.h,
                          textFieldNoIcon(
                              context, 'موضوع الاعلان', textFieldSize, false, subject,
                                  (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'حقل اجباري';
                                }
                                return null;
                              }, false),
                        ),

                        paddingg(15.w, 15.w, 10.h, textFieldDesc(
                          context, ' الوصف الخاص بالاعلان', textFieldSize, true,
                          description, (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'حقل اجباري';
                          }

                          if (value.length < 80) {
                            return 'الحد الادنى لحروف الوصف 80 حرف';
                          }
                          if (value.length > 200) {
                            return 'الحد الاقصى لحروف الوصف 200 حرف';
                          }
                          return null;
                        },),),
                        paddingg(15.w, 15.w, 12.h, textFieldNoIcon(
                            context,
                            'اضافة رابط',
                            textFieldSize,
                            false,
                            pageLink, (String? value) {
                          bool _validURL;
                          if(value!.contains('https://') || value.contains('http://') ){
                            _validURL = Uri.parse(value).isAbsolute;
                            print(value.toString());
                          }else{
                            _validURL = Uri.parse('https://' +value).isAbsolute;
                          }
                          return  _validURL? null: 'الرابط غير صحيح';
                        },
                            false),),
                        paddingg(15.w, 15.w, 12.h, textFieldNoIcon(
                            context,
                            'ادخل كود الخصم',
                            textFieldSize,
                            false,
                            coupon, (String? value) {
                          return null;
                        },
                            false),),

                        SizedBox(height: 20,),

                        padding(8, 20, text(context, 'مالك الاعلان', textFieldSize+1, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Radio<int>(
                                            value: 1,
                                            groupValue:
                                            _value,
                                            activeColor:
                                            blue,
                                            onChanged:
                                                (value) {
                                              setState(() {
                                                _value =
                                                    value;
                                                isValue1 =
                                                false;
                                              });
                                            }),
                                      ),
                                      text(
                                          context,
                                          "فرد",
                                          textFieldSize+1,
                                          ligthtBlack,
                                          family:
                                          'DINNextLTArabic'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Radio<int>(
                                            value: 2,
                                            groupValue:
                                            _value,
                                            activeColor:
                                            blue,
                                            onChanged:
                                                (value) {
                                              setState(() {
                                                _value =
                                                    value;
                                                isValue1 =
                                                true;
                                              });
                                            }),
                                      ),
                                      text(
                                          context,
                                          "مؤسسة/ شركة ",
                                          textFieldSize+1,
                                          ligthtBlack,
                                          family:
                                          'DINNextLTArabic'),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Transform.scale(
                                  //       scale: 0.8,
                                  //       child: Radio<int>(
                                  //           value: 3,
                                  //           groupValue:
                                  //           _value,
                                  //           activeColor:
                                  //           blue,
                                  //           onChanged:
                                  //               (value) {
                                  //             setState(() {
                                  //               _value =
                                  //                   value;
                                  //               isValue1 =
                                  //               true;
                                  //             });
                                  //           }),
                                  //     ),
                                  //     text(
                                  //         context,
                                  //         "شركة",
                                  //         14,
                                  //         ligthtBlack,
                                  //         family:
                                  //         'DINNextLTArabic'),
                                  //   ],
                                  // ),
                                ],
                              ),
                               //
                               Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(right: 10.0.w),
                                    child: InkWell(
                                      onTap: (){setState(() {
                                        file2 != null? OpenFile.open('$showFile'): getFile2(context);
                                      });},
                                      child: Container(child: Row(children: [IconButton(icon: Icon(Icons.upload_rounded),onPressed:(){setState(() {
                                        getFile2(context);
                                      });},color: purple,), text(context, file2 != null? Path.basename(file2!.path):_value == 1? ' قم بإرفاق وثيقة ( العمل الحر او معروف ) pdf ':' قم بإرفاق ملف السجل التجاري  pdf', textFieldSize, black)])),
                                    ),
                                  ),
                                  file2Warn && file2 == null? Padding(
                                      padding:  EdgeInsets.only(right: 30.0.w),
                                      child:  text(context, file2Warn && file2 == null && _value != 1? '*يجب رفع السجل التجاري لاكمال الطلب':'*يجب رفع وثيقة ( العمل الحر او معروف ) لاكمال الطلب', textFieldSize, red!,align: TextAlign.right)):
                                      SizedBox(),
                                ],
                              ),


                            ],
                          ),
                        ),
                        padding(8, 20, text(context, 'صفة الاعلان', textFieldSize+1, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 1,
                                        groupValue:
                                        _value2,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value2 =
                                                value;
                                            isValue1 =
                                            false;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "يلزم الحضور",
                                      15,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 2,
                                        groupValue:
                                        _value2,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value2 =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "لا يلزم الحضور",
                                      15,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        padding(8, 20, text(context, 'نوع الاعلان', textFieldSize+1, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 2,
                                        groupValue:
                                        _value3,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value3 =
                                                value;
                                            isValue1 =
                                            false;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "خدمة",
                                      textFieldSize+1,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 1,
                                        groupValue:
                                        _value3,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value3 =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "منتج",
                                      textFieldSize+1,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        padding(8, 20, text(context, 'توقيت الاعلان', textFieldSize+1, black,
                            fontWeight: FontWeight.bold)),
                        Container(
                          margin: EdgeInsets.only(
                              top: 3.h, right: 2.w),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 1,
                                        groupValue:
                                        _value4,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value4 =
                                                value;
                                            isValue1 =
                                            false;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "صباحا",
                                      textFieldSize+1,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                              Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Radio<int>(
                                        value: 2,
                                        groupValue:
                                        _value4,
                                        activeColor:
                                        blue,
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _value4 =
                                                value;
                                            isValue1 =
                                            true;
                                          });
                                        }),
                                  ),
                                  text(
                                      context,
                                      "مساء",
                                      textFieldSize+1,
                                      ligthtBlack,
                                      family:
                                      'DINNextLTArabic'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //

                    paddingg(15, 15, 30,InkWell(
                      onTap: (){
                        FocusManager
                            .instance.primaryFocus
                            ?.unfocus();
                        showTermsDialog(context);
                      adding && terms.isEmpty?{terms.add(Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding:  EdgeInsets.only(top:15.h),
                          child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                        ),
                      ),),
                        setState(() {
                          adding= false;
                        })}: null;},
                      child: Container(height: 50.h,
                        decoration: BoxDecoration(color: grey!.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8.r), border: Border.all(color: black,width: 0.5.w)),child: paddingg(15, 15,0, Align(
                          alignment:Alignment.centerLeft,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [

                                Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    text(context,termsToApi.isEmpty ?' اضافة بنود العقد': 'معاينة وتعديل البنود', 17, newGrey),
                                    GestureDetector(
                                      onTap: (){

                                      },
                                      child: IconButton(onPressed:(){
                                        FocusManager
                                            .instance.primaryFocus
                                            ?.unfocus();
                                        showTermsDialog(context);
                                        adding && terms.isEmpty?{terms.add(Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:15.h),
                                              child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                                            ),
                                          ),),
                                        setState(() {
                                        adding= false;
                                        })}: null;

                                      print('when close -----------------------');
                                      },icon: Icon(termsToApi.isEmpty ?add:show, color: newGrey,)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),),
                    )),
                        SizedBox(height: 10.h,),
                        paddingg(3.w, 15.w, 0.h,  text(context, 'ميزانية الاعلان (ر.س)', 17, newGrey)),
                        SizedBox(height: 5.h,),
                        Row(
                          children: [
                            Expanded(
                              child: paddingg(3.w, 15.w, 0.h,textFieldNoIcon(context, 'السعر الادنى للاعلان', textFieldSize, false, balanceFrom,(String? value) {
                                if (value == null || value.isEmpty) {
                                  return ;}

                                return null;},false,
                                keyboardType:
                                TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly
                                ],),),),
                            Expanded(
                              child: paddingg(15.w, 3.w, 0.h,textFieldNoIcon(context, 'السعر الاعلى للاعلان', textFieldSize, false, balanceTo,(String? value) {if (value == null || value.isEmpty) {
                                return ;}
                              return null;}, false,
                                keyboardType:
                                TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly
                                ],),),
                            ),

                          ],
                        ),
                        paddingg(15, 15, 30, uploadImg(50, 45, text(context,
                            file != null
                                ? 'تغيير الصورة'
                                : 'قم بإرفاق ملف الاعلان', textFieldSize, black), () {
                          FocusManager
                              .instance.primaryFocus
                              ?.unfocus();
                          getFile(context);
                        }),),
                        InkWell(
                            onTap: () {

                              file != null ? showDialog(
                                useSafeArea: true,
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  _timer = Timer(Duration(seconds: 2), () {
                                    Navigator.of(context)
                                        .pop(); // == First dialog closed
                                  });
                                  return
                                    Container(
                                        height: double.infinity,
                                        child: Image.file(file!));
                                },
                              ) : null;
                            },
                            child: paddingg(15.w, 30.w, file != null ? 10.h : 0
                                .h, Row(
                              children: [
                                file != null ? const Icon(
                                  Icons.image, color: newGrey,) : const SizedBox(),
                                SizedBox(width: file != null ? 5.w : 0.w),
                                text(context, warnimage && file == null
                                    ? 'الرجاء اضافة صورة'
                                    : file != null ? 'معاينة الصورة' : '',
                                  file != null ? textFieldSize : textError,
                                  file != null ? black : red!,),
                              ],
                            ))),

                        paddingg(15, 15, 15, SizedBox(height: 45.h,
                            child: InkWell(
                              child: gradientContainerNoborder(97, Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(scheduale, color: white,),
                                  SizedBox(width: 15.w,),
                                  text(context, current.day != DateTime
                                      .now()
                                      .day ? current.year.toString() + '/' +
                                      current.month.toString() + '/' +
                                      current.day.toString() : 'تاريخ الاعلان',
                                      textFieldSize, white,
                                      fontWeight: FontWeight.bold),
                                ],
                              )), onTap: () async {
                              FocusManager
                                  .instance.primaryFocus
                                  ?.unfocus();
                              DateTime? endDate =
                              await showDatePicker(
                                  builder: (context, child) {
                                    return Theme(
                                        data: ThemeData.light().copyWith(
                                            colorScheme:
                                            const ColorScheme.light(
                                                primary: purple,
                                                onPrimary: white)),
                                        child: child!);
                                  }
                                  context:context,
                                  initialDate:
                                  current,
                                  firstDate:
                                  DateTime(2000),
                                  lastDate: DateTime(2100));

                              if (endDate == null)
                                return;
                              setState(() {
                                current = endDate;
                                current.isBefore(DateTime.now()) && current.day != DateTime.now().day?dateInvalid= true:dateInvalid= false;
                                current.day != DateTime.now().day? datewarn2 = false:null;
                              });
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();
                            },
                            )),),
                        paddingg(15.w, 20.w, 2.h, text(
                          context, datewarn2 ? 'الرجاء اختيار تاريخ النشر':dateInvalid? 'التاريخ غير صالح':'',
                          textFieldSize, datewarn2 || dateInvalid ? red! : white,)),

                        paddingg(0, 0, 12, CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title:  RichText(
                              text:  TextSpan(children: [
                                TextSpan(
                                    text:
                                    ' عند طلب الاهداء ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة ب ',
                                    style: TextStyle(
                                        color: black, fontFamily: 'Cairo', fontSize: 12)),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = () async {
                                      showDialogFunc(context, '', widget.privacyPolicy);
                                    },
                                    text: widget.name.toString() ,
                                    style: TextStyle(
                                        color: blue, fontFamily: 'Cairo', fontSize: 12))
                              ])),
                          value: checkit,
                          subtitle: Text(warn2
                              ? 'حتى تتمكن من الطلب  يجب الموافقة على الشروط والاحكام'
                              : '',
                            style: TextStyle(color: red, fontSize: textFieldSize),),
                          selectedTileColor: black,
                          onChanged: (value) {
                            setState(() {
                              setState(() {
                                checkit = value!;
                              });
                            });
                          },),),
                        const SizedBox(height: 30,),
                        checkit && activateIt ?
                        padding(15, 15, gradientContainerNoborder(getSize(
                            context).width, buttoms(
                            context, 'رفع الطلب', largeButtonSize, white, () {
                          _formKey.currentState!.validate() ? {
                            checkit && current.day != DateTime
                                .now()
                                .day && file != null && platformChosen == true && !current.isBefore(DateTime.now()) && ((file2 !=null ))
                                ? {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context2) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  addAdOrder().then((value) => {
                                    value.contains('true')
                                        ? {
                                      Navigator.pop(context2),
                                      currentuser == 'user' ? gotoPageAndRemovePrevious(context2, const UserRequestMainPage()): gotoPageAndRemovePrevious(context2, const MyRequestsMainPage(
                                      )
                                      ),
                                      Navigator.pop(context),
                                      //done
                                      showMassage(context2, 'تم بنجاح',
                                          value.replaceAll('true', ''),
                                          done: done),
                                    }
                                        :  value == 'SocketException'?
                                    { Navigator.pop(context),
                                      Navigator.pop(context2),
                                      showMassage(
                                        context2,
                                        'خطا',
                                       socketException,
                                      )}
                                        :{
                                      value == 'serverException'? {
                                        Navigator.pop(context),
                                        Navigator.pop(context2),
                                        showMassage(
                                          context2,
                                          'خطا',
                                          serverException,
                                        )
                                      }:{

                                          value.replaceAll('false', '') ==  'المستخدم محظور'? {
                                          Navigator.pop(context),
                                            Navigator.pop(context2),
                                          showMassage(
                                            context2,
                                            'خطا',
                                            'لا يمكنك اكمال رفع الطلب ',
                                          )
                                        } :{
                                        Navigator.pop(context),
                                            Navigator.pop(context2),
                                        showMassage(
                                          context2,
                                          'خطا',
                                            value.replaceAll('false', ''),
                                        )}
                                      }

                                    }
                                  });

                                  // == First dialog closed
                                  return AlertDialog(
                                    titlePadding: EdgeInsets.zero,
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    content: SizedBox(
                                      width: double.infinity,
                                      height: 150.h,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Lottie.asset(
                                          "assets/lottie/loding.json",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),


                            }
                                : setState(() {
                              _selectedTest == null
                                  ? platformChosen = false
                                  : platformChosen = true;
                              !checkit ? warn2 = true : false;
                              current.isBefore(DateTime.now())? dateInvalid = true: false;
                              current.day == DateTime
                                  .now()
                                  .day ? datewarn2 = true : false;
                              file == null ? warnimage = true : false;
                              file2  == null ? file2Warn = true:false;
                            }),

                          } : null;
                        }))) :

                        padding(15, 15, Container(width: getSize(context).width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: grey,),
                            child: buttoms(
                                context, 'رفع الطلب', largeButtonSize, white, () {})
                        ),),
                        SizedBox(height: 80.h,),

                      ]),
                  ),),),
            ],
          ),
        ),),
    );
  }

  buildCkechboxList(list) {
    return SizedBox(
      height: 150.h,
      child: Padding(
        padding: const EdgeInsets.all(2.0),

      ),
    );
  }
  Future<File?> getFile2(context) async {
    FilePickerResult? pickedFile =
    await FilePicker.platform.pickFiles(type: FileType.any);
    if (pickedFile == null) {
      return null;
    }
    final File f = File(pickedFile.paths[0]!);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.paths[0]!);
    final String fileExtension = Path.extension(fileName);
    File newImage = await f.copy('$path/$fileName');
    if(  fileExtension == ".pdf" ) {
      setState(() {
        file2 = newImage;
        showFile= path + '/' +fileName;
      });
    }else{
      showMassage(context, 'عذرا', 'pdf صيغة الملف غير مسموح بها, الرجاء رفع ملف بصيغة ');
   }
  }
  Future<File?> getFile(context) async {
    PickedFile? pickedFile =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File f = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
    final String fileExtension = Path.extension(fileName);
    File newImage = await f.copy('$path/$fileName');
    if (fileExtension == ".png" || fileExtension == ".jpg") {
      setState(() {
        file = newImage;
      });
    } else {
      showMassage(context, 'عذرا', 'png او jpg صيغة الصورة غير مسموح بها, الرجاء رفع الصورة بصيغة ');
    }

    // }else{ ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(
    //   content: Text(
    //       "امتداد الصورة غير مسموح به",style: TextStyle(color: Colors.red)),
    // ));}
  }

  Future<Pricing> fetchCelebrityPricingg(String id) async {
    String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDAzNzUwY2MyNjFjNDY1NjY2YjcwODJlYjgzYmFmYzA0ZjQzMGRlYzEyMzAwYTY5NTE1ZDNlZTYwYWYzYjc0Y2IxMmJiYzA3ZTYzODAwMWYiLCJpYXQiOjE2NTMxMTY4MjcuMTk0MDc3OTY4NTk3NDEyMTA5Mzc1LCJuYmYiOjE2NTMxMTY4MjcuMTk0MDg0ODgyNzM2MjA2MDU0Njg3NSwiZXhwIjoxNjg0NjUyODI3LjE5MDA0ODkzMzAyOTE3NDgwNDY4NzUsInN1YiI6IjExIiwic2NvcGVzIjpbXX0.GUQgvMFS-0VA9wOAhHf7UaX41lo7m8hRm0y4mI70eeAZ0Y9p2CB5613svXrrYJX74SfdUM4y2q48DD-IeT67uydUP3QS9inIyRVTDcEqNPd3i54YplpfP8uSyOCGehmtl5aKKEVAvZLOZS8C-aLIEgEWC2ixwRKwr89K0G70eQ7wHYYHQ3NOruxrpc_izZ5awskVSKwbDVnn9L9-HbE86uP4Y8B5Cjy9tZBGJ-6gJtj3KYP89-YiDlWj6GWs52ShPwXlbMNFVDzPa3oz44eKZ5wNnJJBiky7paAb1hUNq9Q012vJrtazHq5ENGrkQ23LL0n61ITCZ8da1RhUx_g6BYJBvc_10nMuwWxRKCr9l5wygmIItHAGXxB8f8ypQ0vLfTeDUAZa_Wrc_BJwiZU8jSdvPZuoUH937_KcwFQScKoL7VuwbbmskFHrkGZMxMnbDrEedl0TefFQpqUAs9jK4ngiaJgerJJ9qpoCCn4xMSGl_ZJmeQTQzMwcLYdjI0txbSFIieSl6M2muHedWhWscXpzzBhdMOM87cCZYuAP4Gml80jywHCUeyN9ORVkG_hji588pvW5Ur8ZzRitlqJoYtztU3Gq2n6sOn0sRShjTHQGPWWyj5fluqsok3gxpeux5esjG_uLCpJaekrfK3ji2DYp-wB-OBjTGPUqlG9W_fs';
    final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/celebrity/price/$id'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return Pricing.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  Future<String> addAdOrder() async {
    var stream2;
    var length2;
    var multipartFile2;
    try {
      var stream;
      var length;
      var uri;
      var request;
      Map<String, String> headers;
      var response;
      var body;
      String message = '';
      stream = await http.ByteStream(DelegatingStream.typed(file!.openRead()));
      // get file length
      length = await file!.length();
      if(file2 != null) {
        stream2 = new http.ByteStream(
            DelegatingStream.typed(file2!.openRead()));
        // get file length
        length2 = await file2!.length();
      }
      // string to uri
      uri =
          Uri.parse(
              "https://mobile.celebrityads.net/api/order/advertising/add");

      headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };
      // create multipart request
      request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: Path.basename(file!.path));
      if(file2 != null){
        multipartFile2 = http.MultipartFile('commercial_record', stream2, length2,
            filename: Path.basename(file2!.path));}
      // multipart that takes file
      // multipartFile = new http.MultipartFile('file', file!.bytes.toList(), length,
      //     filename: file!.name),
      // listen for response
      if(file2 != null){
        multipartFile2 = http.MultipartFile('commercial_record', stream2, length2,
            filename: Path.basename(file2!.path));}
      ///value
      ///value1
      ///value2
      ///value3

      request.files.add(multipartFile);
      file2 != null? request.files.add(multipartFile2): request.fields["commercial_record"] = '';
      request.headers.addAll(headers);
      request.fields["celebrity_id"] = widget.id.toString();
      request.fields["date"] = current.toString();
      request.fields[" platform_id"] =
          platformlist.indexOf(_selectedTest).toString();
      request.fields["description"] = description.text;
      request.fields["celebrity_promo_code"] = coupon.text;

      request.fields["ad_owner_id"] = _value.toString();
      request.fields["ad_feature_id"] = _value2.toString();
      request.fields["ad_timing_id"] = _value4.toString();

      request.fields["advertising_ad_type_id"] = _value3.toString();
      request.fields["advertising_name"] = subject.text;
      request.fields["advertising_link"] = pageLink.text.contains('https://') ||  pageLink.text.contains('http://')?pageLink.text: 'https://'+  pageLink.text;
      response = await request.send();
      // response.stream.transform(utf8.decoder).listen((value) async {
      //   print(value);
      //   setState(()  {
      //     Responsee rr = Responsee.fromJson(jsonDecode(value));
      //     resp = 'تم';
      //
      //   });
      // });

      http.Response respo = await http.Response.fromStream(response);
      print("Result: ${response.statusCode}");
      return jsonDecode(respo.body)['message']['ar']+jsonDecode(respo.body)['success'].toString();
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


  //-----------------------------------------------------------------
  showTermsDialog(context){

    print(termsToApi.length.toString()+'////////////////////////////////////////');
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context2) {
          return StatefulBuilder(
            builder: (context2,sets){
              return Padding(
                padding:  EdgeInsets.only(top: 100.h, bottom: MediaQuery.of(context2).viewInsets.bottom, left: 20.w, right:20.w ),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.transparent,
                    child: Card(
                      child: Padding(
                          padding:  EdgeInsets.only(top: 30.h, bottom: 20.h, left: 10.w, right:10.w ),
                          child: paddingg(15, 15,0, Column(
                            children: [
                              Container(
                                height:425.h,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    SingleChildScrollView(
                                      child: Container(height: 425.h, width: double.infinity,child:
                                      ListView.builder(
                                        shrinkWrap:true,
                                        itemCount: terms.length,
                                        controller: _controller,
                                        itemBuilder: (context, index){
                                          return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child:
                                              Column(children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children:[
                                                      Row(
                                                        children: [
                                                          terms[index],
                                                        ],
                                                      ),

                                                      adding?
                                                      index != 0 && !adding?
                                                      i == index?
                                                      InkWell(onTap:(){sets((){ updateTerm(index);
                                                      i = -1;
                                                      });},child: Icon(done)):Row(children: [
                                                        InkWell(onTap:(){sets((){removeTerm(index);});},child: Icon(remove, color: red,)),SizedBox(width: 13.w,),
                                                        InkWell(onTap: () {
                                                          setState(() {
                                                            i = index;
                                                          });
                                                          sets(() {
                                                            i = index;
                                                            editTerm(index);
                                                            print(i.toString() + '................................');
                                                          });},child: Icon(editDiscount, color: newGrey,))],):
                                                      index != terms.length && adding?
                                                      i != index?
                                                      Row(children: [
                                                        InkWell(onTap:(){sets((){removeTerm(index);});},child: Icon(remove, color: red,)),SizedBox(width: 13.w,),
                                                        InkWell(onTap: (){
                                                          setState(() {
                                                            i = index;
                                                          });
                                                          sets(() {
                                                            i = index;
                                                            print(i.toString() + '................................');
                                                            editTerm(index);
                                                          });},child: Icon(editDiscount, color: newGrey,))],):  InkWell(onTap:(){sets((){ updateTerm(index);
                                                      i = -1;});},child: Icon(done, color: newGrey,)):SizedBox():SizedBox(),


                                                    ]),
                                                index != terms.length && adding?   SizedBox(
                                                  width: 300.w,
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(top: 10.h),
                                                    child: Divider(height: 0.75.h,),
                                                  ),
                                                ):  index != terms.length-1?
                                                SizedBox(
                                                  width: 300.w,
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(top: 10.h),
                                                    child: Divider(height: 0.75.h,),
                                                  ),
                                                )
                                                    : SizedBox()],)

                                          );
                                        },

                                      )),
                                    ),


                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    !adding? IconButton(onPressed: (){
                                      sets(() {
                                        terms.removeAt(0);
                                        termController.clear();
                                        adding = true;
                                      });
                                    },icon: Icon(cancel, color: newGrey,)):SizedBox(),
                                    SizedBox(width: 10.w,),
                                    IconButton(onPressed:  (){
                                      sets(() {
                                        print(adding.toString() +'when open -----------------------');
                                        adding?{
                                          terms.insert(0,Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:20.h),
                                              child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                                            ),
                                          ),),
                                          adding = false}:{
                                          terms.removeAt(0),
                                          termController.text.isEmpty?
                                              null:
                                          terms.add(Container(
                                            width:230.w,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:8.h),
                                              child: SizedBox(width: 230.w,child: text(context, termController.text, 16, black,align: TextAlign.start,)),
                                            ),
                                          )),


                                          termController.text.isEmpty?
                                          null: termsToApi.add(termController.text),
                                          setState(() {

                                          }),
                                          termController.clear(),
                                          adding = true,
                                        };
                                        print('when open -----------------------');
                                        !adding?_animateToIndex(0,50.0.h):_animateToIndex(terms.length,200.0.h);
                                      });
                                    },icon: Icon( !adding?Icons.done:i != -1?null:Icons.add, color: newGrey,size: 35.r,)),

                                  ],
                                ),
                              ),
                            ],
                          ))),
                    ),
                  ),
                ),
              );
            },
          );});
  }
  removeTerm(index){
    print(index.toString()+'the index count');
      setState(() {
      // termsToApi.removeAt(index);
      terms.removeAt(index);
       termsToApi.removeAt(index);
    });

  }
  updateTerm(index){
    setState(() {
      // termsToApi.removeAt(index);
      terms.removeAt(index);
     terms.insert(index, Container(width:200.w,
       child: Padding(
         padding:  EdgeInsets.only(top:8.h),
         child: SizedBox(width: 220.w,child: text(context, termController.text, 16, black,align: TextAlign.start,)),
       ),
     ));
    });
    i =-1;
    termsToApi[index] = termController.text;
    termController.clear();
  }
  editTerm(index){
    setState(() {
      termController.text = termsToApi[index];
      // termsToApi.removeAt(index);
      terms.removeAt(index);
      terms.insert(index, Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding:  EdgeInsets.only(top:20.h),
          child: Row(
            children: [
              //Icon(Icons.done),
              Container(width:270.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
            ],
          ),
        ),
      ),);
      // termsToApi.removeAt(index);
    });

  }
  void _animateToIndex(int index, double height) {
    _controller!.animateTo(
      index * height,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
  //--------------------------------------------------------
  showDialogFunc(context, title, areaDes) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: white,
              ),
              padding: EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
              height: 400.h,
              width: 380.w,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: TextDirection.rtl,
                  children: [
                    ///Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///text
                        text(context, 'تفاصيل سياسة التعامل', 14, grey!),
                      ],
                    ),

                    SizedBox(
                      height: 30.h,
                    ),

                    ///---------------------

                    ///Area Title
                    text(context, 'سياسة الاعلان', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Area Details
                    text(
                      context,
                      areaDes,
                      14,
                      ligthtBlack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Platform {
  bool? success;
  List<Data>? data;
  Message? message;

  Platform({this.success, this.data, this.message});

  Platform.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? nameEn;

  Data({this.id, this.name, this.nameEn});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class Message {
  String? en;
  String? ar;

  Message({this.en, this.ar});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}