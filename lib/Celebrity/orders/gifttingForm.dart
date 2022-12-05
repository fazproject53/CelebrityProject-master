
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Celebrity/celebrityHomePage.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../Account/LoggingSingUpAPI.dart';
import '../../MainScreen/main_screen_navigation.dart';
import '../../Users/UserRequests/UserReguistMainPage.dart';
import '../Pricing/ModelPricing.dart';
import '../Requests/ReguistMainPage.dart';



class gifttingForm extends StatefulWidget{

  final String? id, image,privacyPolicy, name;
  const gifttingForm({Key? key,  this.id, this.image,this.privacyPolicy, this.name}) : super(key: key);
  _gifttingFormState createState() => _gifttingFormState();
}
String? userToken;
class _gifttingFormState extends State<gifttingForm>{

  bool ocasionChosen = true;
  bool typeChosen = true;
  final _formKey = GlobalKey<FormState>();
  Future<GiftType>? types;
  Future<OccasionType>? otypes;
  Future<Pricing>? pricing;
  final TextEditingController desc =  TextEditingController();
  final TextEditingController from =  TextEditingController();
  final TextEditingController to =  TextEditingController();
  final TextEditingController copun =  TextEditingController();

  DateTime current = DateTime.now();
  String ocassion = 'اختر المناسبة الخاصة';
  String type = 'نوع الاهداء';
  var ocassionlist =[];
  var typelist =[];
  bool activateIt = false;
   bool check =false;
   bool  warn = false;
  bool  datewarn = false;
  List<DropdownMenuItem<Object?>> _dropdownTestItem = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItem2 = [];
  bool dateInvalid = false;
  ///_value
  var _selectedTest;

  Timer? _timer;
  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = selectedTest;
      selectedTest['no'] == 0?{
        print('the number chosen is 0'),_selectedTest =null}:null;
    });
  }

  String? userToken;

  var _selectedTest2;
  onChangeDropdownTests2(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest2 = selectedTest;
    });
  }

  @override
  void initState() {
    types = getGiftType();
    otypes = getOcassionType();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        pricing = fetchCelebrityPricing(widget.id!);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    print(_dropdownTestItem2.length);


          return  Directionality(
            textDirection: TextDirection.rtl,
            child:Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: drowAppBar('طلب اهداء', context),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(height: 335.h,
                              width: 1000.w,
                              child: CachedNetworkImage(imageUrl:widget.image!, color: Colors.black45, colorBlendMode:BlendMode.darken,fit: BoxFit.cover,)),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(' اطلب اهداء\n' + 'شخصي من  ' + widget.name! + ' الان',
                                  style: TextStyle(fontWeight: FontWeight.normal,fontSize: textSubHeadSize, color: white , fontFamily: 'Cairo'), ),
                          ),


                              ],
                           ),
                        ]),
                    Container(
                      child: Form(
                        key: _formKey,
                        child: paddingg(12, 12, 5, Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 10.h,),
                              padding(10, 12, Container( alignment : Alignment.topRight,child:  text(context, ' فضلا ادخل البيانات الصحيحة',textSubHeadSize,textBlack,fontWeight: FontWeight.normal,
                                family: 'Cairo', )),),

                              //========================== form ===============================================


                              const SizedBox(height: 30,),

                          FutureBuilder(
                            future: pricing,
    builder: ((context, AsyncSnapshot<Pricing> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center();
    } else if (snapshot.connectionState ==
    ConnectionState.active ||
    snapshot.connectionState == ConnectionState.done) {
    if (snapshot.hasError) {
    return Center(child: Text(snapshot.error.toString()));
    //---------------------------------------------------------------------------
    } else if (snapshot.hasData) {
      snapshot.data!.data != null && _selectedTest2 != null  && snapshot.data!.data!.price!.giftVoicePrice != null
          && snapshot.data!.data!.price!.giftVedioPrice != null  ?  activateIt = true :null;
      return snapshot.data!.data == null || _selectedTest2 == null?
     const SizedBox(): paddingg(15, 15, 12, Container(height: 55.h,decoration: BoxDecoration(color: deepPink, borderRadius: BorderRadius.circular(8)),
                                  child:   Padding(
                                    padding: EdgeInsets.all(10),
                                    child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:  [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Text('سعر الاهداء', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: white , fontFamily: 'Cairo'), ),
                                        ),
                                        Text( typelist.indexOf(_selectedTest2) == 1? snapshot.data!.data!.price!.giftVedioPrice.toString() + ' ر.س ': typelist.indexOf(_selectedTest2) == 2 ? snapshot.data!.data!.price!.giftVoicePrice.toString() + ' ر.س ':
                                        typelist.indexOf(_selectedTest2) == 3? snapshot.data!.data!.price!.giftImagePrice.toString() + ' ر.س ' : '', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17, color: white , fontFamily: 'Cairo'), ),
                                      ],
                                    ),),),
                                );
    } else {
      return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
    }
    } else {
      return Center(
          child: Text('State: ${snapshot.connectionState}'));
    }
    })),
                              FutureBuilder(
                                  future: otypes,
                                  builder: ((context, AsyncSnapshot<OccasionType> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return  paddingg(15, 15, 12,
                                        DropdownBelow(
                                          dropdownColor: lightGrey.withOpacity(0.10),
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
                                          EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                          boxWidth: 500.w,
                                          boxHeight: 45.h,
                                          boxDecoration: BoxDecoration(
                                              border:  Border.all(color: newGrey, width: 0.5),
                                              color: lightGrey.withOpacity(0.10),
                                              borderRadius: BorderRadius.circular(8.r)),
                                          ///Icons
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey,
                                          ),
                                          hint:  Text(
                                            ocassion,
                                            textDirection: TextDirection.rtl,
                                          ),
                                          value: _selectedTest,
                                          items: _dropdownTestItem,
                                          onChanged: onChangeDropdownTests,
                                        ),
                                      );
                                    } else if (snapshot.connectionState == ConnectionState.active ||
                                        snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Center(child: Text(snapshot.error.toString()));
                                        //---------------------------------------------------------------------------
                                      } else if (snapshot.hasData) {
                                        _dropdownTestItem.isEmpty?{
                                        ocassionlist.add({'no': 0, 'keyword': 'اختر نوع المناسبة'}),
                                        for(int i =0; i< snapshot.data!.data!.length; i++) {
                                          ocassionlist.add({'no': snapshot.data!.data![i].id!, 'keyword': snapshot.data!.data![i].name!}),
                                        },
                                        _dropdownTestItem = buildDropdownTestItems(ocassionlist)
                                        } : null;

                                        return   paddingg(15, 15, 12,
                                          Container(
                                            child: DropdownBelow(
                                              dropdownColor:white,
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
                                              EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                              boxWidth: 500.w,
                                              boxHeight: 45.h,
                                              boxDecoration: BoxDecoration(
                                                  border:  Border.all(color: newGrey, width: 0.5),
                                                  color: lightGrey.withOpacity(0.10),
                                                  borderRadius: BorderRadius.circular(8.r)),
                                              ///Icons
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.grey,
                                              ),
                                              hint:  Text(
                                                ocassion,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              value: _selectedTest,
                                              items: _dropdownTestItem,
                                              onChanged: onChangeDropdownTests,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
                                      }
                                    } else {
                                      return Center(
                                          child: Text('State: ${snapshot.connectionState}'));
                                    }
                                  })),
                              !ocasionChosen && _selectedTest == null?
                              padding( 10,20, text(context, ocasionChosen && _selectedTest == null?'':'الرجاء اختيار مناسبة الاعلان', textError, _selectedTest != null ?white:red!,)):
                                  SizedBox(height: 10.h,),
                              FutureBuilder(
                                  future: types,
                                  builder: ((context, AsyncSnapshot<GiftType> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return  paddingg(15, 15, 0,
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
                                          EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                          dropdownColor: newGrey,
                                          boxWidth: 500.w,
                                          boxHeight: 45.h,
                                          boxDecoration: BoxDecoration(
                                              border:  Border.all(color: newGrey, width: 0.5),
                                              color: lightGrey.withOpacity(0.10),
                                              borderRadius: BorderRadius.circular(8.r)),
                                          ///Icons
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.grey,
                                          ),
                                          hint:  Text(
                                            type,
                                            textDirection: TextDirection.rtl,
                                          ),
                                          value: _selectedTest2,
                                          items: _dropdownTestItem2,
                                          onChanged: onChangeDropdownTests2,
                                        ),
                                      );
                                    } else if (snapshot.connectionState == ConnectionState.active ||
                                        snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Center(child: Text(snapshot.error.toString()));
                                        //---------------------------------------------------------------------------
                                      } else if (snapshot.hasData) {
                                        _dropdownTestItem2.isEmpty?{
                                        typelist.add({'no': 0, 'keyword': 'نوع الاهداء'}),
                                        for(int i =0; i< snapshot.data!.data!.length; i++) {
                                          typelist.add({'no': snapshot.data!.data![i].id!, 'keyword': '${snapshot.data!.data![i].name!}'}),
                                        },
                                        _dropdownTestItem2 = buildDropdownTestItems(typelist),
                                        } : null;

                                        return paddingg(15, 15, 0,
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
                                            EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                            dropdownColor: white,
                                            boxWidth: 450.w,
                                            boxHeight: 45.h,
                                            boxDecoration: BoxDecoration(
                                                border:  Border.all(color: newGrey, width: 0.5),
                                                color: lightGrey.withOpacity(0.10),
                                                borderRadius: BorderRadius.circular(8.r)),
                                            ///Icons
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.grey,
                                            ),
                                            hint:  Text(
                                              type,
                                              textDirection: TextDirection.rtl,
                                            ),
                                            value: _selectedTest2,
                                            items: _dropdownTestItem2,
                                            onChanged: onChangeDropdownTests2,
                                          ),
                                        );
                                      } else {
                                        return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
                                      }
                                    } else {
                                      return Center(
                                          child: Text('State: ${snapshot.connectionState}'));
                                    }
                                  })),

                              !typeChosen && _selectedTest2 == null?
                              padding( 10,20, text(context, typeChosen && _selectedTest2 == null?'':'الرجاء اختيار منصة الاعلان', 13, _selectedTest2 != null ?white:red!,)):
                                  SizedBox(height: 10.h,),
                              Row(
                                children: [
                                  Expanded(
                                    child: paddingg(3.w, 15.w, 0.h,textFieldNoIcon(context, 'من', textFieldSize, false, from,(String? value) {
                                      if (value == null || value.isEmpty) {
                                      return 'حقل اجباري';}
                                      if (value.length > 14) {
                                        return 'لقد تجاوزت الحد المسموح';}
                                      return null;},false),),),
                                  Expanded(
                                    child: paddingg(15.w, 3.w, 0.h,textFieldNoIcon(context, 'الى', textFieldSize, false, to,(String? value) {if (value == null || value.isEmpty) {
                                      return 'حقل اجباري';}
                                    if (value.length > 14) {
                                      return 'لقد تجاوزت الحد المسموح';}
                                    return null;}, false),),
                                  ),

                                ],
                              ),

                              paddingg(15.w, 15.w, 12.h,textFieldDesc(
                                context,'الوصف الخاص بالاهداء', textFieldSize, false, desc,(String? value) {
                                  if (value == null || value.isEmpty) {
                                return 'حقل اجباري';
                                  }
                                  if (value.length < 40) {
                                    return 'الحد الادنى لحروف الوصف 40 حرف';
                                  }
                                  if (value.length > 200) {
                                    return 'الحد الاقصى لحروف الوصف 200 حرف';
                                  }
                                  return null;},),),
                              paddingg(15.w, 15.w, 12.h,textFieldNoIcon(context, 'ادخل كود الخصم',textFieldSize, false, copun,(String? value) { return null;},true),),


                              paddingg(15.w, 15.w, 15.h,SizedBox(height: 45.h,child: InkWell(
                                child: gradientContainerNoborder(50.w, Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(scheduale, color: white,),
                                    SizedBox(width: 15.w,),
                                    text(context, current.day != DateTime.now().day ?current.year.toString()+ '/'+current.month.toString()+ '/'+current.day.toString() : 'تاريخ الاهداء', textFieldSize, white, fontWeight: FontWeight.bold),
                                  ],
                                )),onTap: () async {  DateTime? endDate =
                              await showDatePicker(
                                  builder: (context, child) {
                                    return Theme(
                                        data: ThemeData.light().copyWith(
                                            colorScheme:
                                            const ColorScheme.light(primary: purple, onPrimary: white)),
                                        child: child!);}
                                  context:
                                  context,
                                  initialDate:
                                  current,
                                  firstDate:
                                  DateTime(
                                      2000),
                                  lastDate:
                                  DateTime(
                                      2100));
                              if (endDate == null)
                                return;
                              setState(() {
                                datewarn =false;
                                current= endDate;
                                current.isBefore(DateTime.now()) ?{ current.day != DateTime.now().day?dateInvalid= true: dateInvalid= false}:
                                dateInvalid= false;
                              });
                              FocusManager.instance.primaryFocus
                                  ?.unfocus();},
                              )),),

                              paddingg(15.w, 20.w, 5.h,text(context,datewarn?'الرجاء اختيار تاريخ الاهداء':dateInvalid? 'التاريخ غير صالح':'', textError,red!,)),

                              paddingg(0,0,12.h, CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                title:     RichText(
                                    text:  TextSpan(children: [
                                      TextSpan(
                                          text:
                                          ' عند طلب الاهداء ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة ب ',
                                          style: TextStyle(
                                              color: black, fontFamily: 'Cairo', fontSize: textFieldSize.sp)),
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()..onTap = () async {
                                            showDialogFunc(context, '', widget.privacyPolicy);
                                          },
                                          text: widget.name.toString() ,
                                          style: TextStyle(
                                              color: blue, fontFamily: 'Cairo', fontSize: textFieldSize.sp))
                                    ])),
                                value: check,
                                selectedTileColor: warn == true? red: black,
                                subtitle: Text(warn == true?'حتى تتمكن من طلب الاهداء يجب الموافقة على الشروط والاحكام':'' ,style: TextStyle(color: red , fontSize: textError.sp, fontFamily:'Cairo'),),
                                onChanged: (value) {
                                  setState(() {
                                    setState(() {
                                      check = value!;
                                    });
                                  });
                                },)

                                ,),

                              SizedBox(height: 30.h,),
                              check && activateIt? padding(15.w, 15.w, gradientContainerNoborder(getSize(context).width,
                                buttoms(context, 'رفع الطلب', largeButtonSize, white, (){
                                  if(!ocasionChosen || !typeChosen){ _selectedTest == null? ocasionChosen= false: ocasionChosen = true;
                                  _selectedTest2 == null? typeChosen= false: typeChosen = true;}
                                _formKey.currentState!.validate()?{
                                check && current.day != DateTime.now().day && _selectedTest != null && _selectedTest2 != null && !current.isBefore(DateTime.now()) ?{

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context2) {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      addGift().then((value) => {
                                        value.contains('true')
                                            ? {
                                          Navigator.pop(context2),
                                      gotoPageAndRemovePrevious(context, const UserRequestMainPage(
                                          whereTo: 'gift',

                                      )
                                      )
                                          ,

                                          //done
                                          showMassage(context, 'تم ',
                                              value.replaceAll('true', ''),
                                              done: done),
                                        }
                                            :  value == 'SocketException'?
                                        { Navigator.pop(context2),
                                          showMassage(
                                            context2,
                                            'خطا',
                                            socketException,
                                          )}
                                            :{
                                          value == 'serverException'? {
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
                                                'لا يمكنك اكمال رفع الطلب',
                                              )
                                            } :{Navigator.pop(context),
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

                                } : setState((){
                                  _selectedTest == null? ocasionChosen= false: ocasionChosen = true;
                                  _selectedTest2 == null? typeChosen= false: typeChosen = true;
                                  current.isBefore(DateTime.now())? dateInvalid = true: false;
                                  !check? warn = true: false;
                                current.day == DateTime.now().day? datewarn = true: false;}),
                                }: null;
                                }),)):

                              padding(15, 15, Container(width: getSize(context).width,
                                  decoration: BoxDecoration( borderRadius: BorderRadius.circular(8.r),   color: grey,),
                                  child: buttoms(context,'رفع الطلب', largeButtonSize, white, (){})
                              ),),
                               SizedBox(height: 30.h,),
                              SizedBox(height: 50.h,),


                            ]),
                        ),),),
                  ],
                ),
              ),),
          );
        }


        Future<String> addGift() async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/order/gift/add',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
        body: jsonEncode(<String, dynamic>{
          'celebrity_id': widget.id!,
          'date': current.toString(),
          'occasion_id': _selectedTest == null
              ? ocassionlist.indexOf(0)
              : ocassionlist.indexOf(_selectedTest),
          'gift_type_id': _selectedTest2 == null
              ? typelist.indexOf(0)
              : typelist.indexOf(_selectedTest2),
          'description': desc.text,
          'from': from.text,
          'to': to.text,
          'celebrity_promo_code': copun.text,

        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        return jsonDecode(response.body)['message']['ar']+jsonDecode(response.body)['success'].toString();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(alignment: Alignment.centerRight,child: Text(i['keyword'], textAlign: TextAlign.start,))),

        ),
      );
    }
    return items;
  }
}

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
                  text(context, 'سياسة الاهداء', 16, black,
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


// get gift type

Future<GiftType> getGiftType() async {
   final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/gift-types'),);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
   GiftType g = GiftType.fromJson(jsonDecode(response.body));
    return g;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load activity');
  }
}

// gifting type model

class GiftType {
  bool? success;
  List<DataOcattion>? data;
  MessageOccasion? message;

  GiftType({this.success, this.data, this.message});

  GiftType.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataOcattion>[];
      json['data'].forEach((v) {
        data!.add(new DataOcattion.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new MessageOccasion.fromJson(json['message']) : null;
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

// occasion type

Future<OccasionType> getOcassionType() async {
  final response = await http.get(
    Uri.parse('https://mobile.celebrityads.net/api/occasions'),);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    OccasionType o= OccasionType.fromJson(jsonDecode(response.body));
    o.data!.forEach((element) {print(element.name);});
    return o;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load activity');
  }
}

Future<Pricing> fetchCelebrityPricing(String id ) async {
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

// occasion model

class OccasionType {
  bool? success;
  List<DataOcattion>? data;
  MessageOccasion? message;

  OccasionType({this.success, this.data, this.message});

  OccasionType.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataOcattion>[];
      json['data'].forEach((v) {
        data!.add(new DataOcattion.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new MessageOccasion.fromJson(json['message']) : null;
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

class DataOcattion {
  int? id;
  String? name;
  String? nameEn;

  DataOcattion({this.id, this.name, this.nameEn});

  DataOcattion.fromJson(Map<String, dynamic> json) {
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

class MessageOccasion {
  String? en;
  String? ar;

  MessageOccasion({this.en, this.ar});

  MessageOccasion.fromJson(Map<String, dynamic> json) {
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

// Gift main get

