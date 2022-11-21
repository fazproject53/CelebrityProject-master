import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Account/LoggingSingUpAPI.dart';
import 'package:celepraty/Celebrity/celebrityHomePage.dart';
import 'package:celepraty/Celebrity/setting/celebratyProfile.dart';
import 'package:celepraty/Celebrity/setting/socialMedia.dart';
import 'package:celepraty/ModelAPI/ModelsAPI.dart';
import 'package:celepraty/Users/CreateOrder/buildAdvOrder.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Account/logging.dart';
import '../../MainScreen/main_screen_navigation.dart';
List<DropdownMenuItem<Object?>> _dropdownTestItems3 = [];
List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
List<int> idsnationality = [];

class profileInformaion extends StatefulWidget {
  _profileInformaionState createState() => _profileInformaionState();
}

class _profileInformaionState extends State<profileInformaion>
// with AutomaticKeepAliveClientMixin
    {
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  Future<CityL>? areas;
  bool nationalityWarn= false;
  Future<CelebrityInformation>? celebrities;
  Future<CityL>? cities;
  Future<Nationality>? countries;
  Future<CategoryL>? categories;
  bool countryChanged = false;
  bool? citychosen;
  bool addHeight = false;
  int? nationalityId;
  bool showText = true;
  bool showText2 = true;
  bool  areadone = false, citydone = false, nationalitydone = false, categorydone = false, genderdone = true;
  int? cityi, countryi, genderi, categoryi;
  String? userToken;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pageLink = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController currentPassword = TextEditingController();

  var currentFocus;
  FocusNode focusNode = FocusNode();
  String? erroremail;
  String? errorphone;
  bool valid = false;
  bool noMatch = false;
  bool editPassword = false;
  bool? genderChosen;
  bool areawarn = false;
  String country = 'الجنيسة';
  String city = 'اختيار المنطقة';
  String category = 'التصنيف';
  String gender = 'الجنس';
  String area = 'اختيار المنطقة';
  String? ContryKey;
  int helper = 0;
  int? catId;
  int? areaId;
  Map<int, String> getid = HashMap();
  Map<int, String> categoriesId = HashMap();
  var citilist = [];
  var countrylist = [];
  var categorylist = [];
  var areaslist = [];
  var genderlist = [
    {'no': 0, 'keyword': 'الجنس'},
    {'no': 1, 'keyword': 'ذكر'},
    {'no': 2, 'keyword': 'انثى'}
  ];


  List<DropdownMenuItem<Object?>> _dropdownTestItems2 = [];
  // List<DropdownMenuItem<Object?>> _dropdownTestItems3 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems4 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems5 = [];

  ///_value
  var _selectedTest;
  int? number;

  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      city = selectedTest['keyword'];
      _selectedTest = selectedTest;
      cityi = selectedTest['no'];
      selectedTest['no'] == 0? {_selectedTest = null,cityi = null }:null;
      citychosen = true;
    });
  }

  var _selectedTest2;

  onChangeDropdownTests2(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest2 = selectedTest;
    });
  }

  var _selectedTest3;

  onChangeDropdownTests3(selectedTest) {
    print(selectedTest);
    setState(() {
      print('the selected nationality number is :' + selectedTest['no'].toString());
      countryChanged = true;
      Logging.theUser!.country = selectedTest['keyword'];
      _selectedTest3 = selectedTest;
      country = selectedTest['keyword'];
      selectedTest['no'] == 0?{ _selectedTest3 = null, nationalityId = null}: {
        nationalityId = idsnationality.elementAt(selectedTest['no']-1),
        print('the id nationality number is :' +nationalityId.toString()),
      };
      nationalityWarn = false;
      getid.forEach((key, value) {
        if (value == Logging.theUser!.country) {
          print(
              key.toString() + '---------------------------------------------');
        }
      });
    });
  }

  var _selectedTest4;

  onChangeDropdownTests4(selectedTest) {
    print(selectedTest);

    setState(() {
      _selectedTest4 = selectedTest;
      _selectedTest4['no'] ==0?   genderChosen = null:
      genderChosen = true;
      print(_selectedTest4['no']);
    });
  }

  var _selectedTest5;

  onChangeDropdownTests5(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest5 = selectedTest;
      area = selectedTest['keyword'];
      areaId = _selectedTest5['no'];
      selectedTest['no'] == 0? _selectedTest5 = null:_selectedTest5['no'];
      _dropdownTestItems.clear();
      city = 'اختيار المدينة';
      cityi = null;
      citilist.clear();
      _selectedTest =null;
      citydone = false;
      cities = fetCities(areaId!);
      print(areaId.toString() + ']]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');
      areawarn = false;
    });
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
          alignment: Alignment.centerRight,
          value: i,
          child: Directionality(
              textDirection: TextDirection.rtl,child: Container( alignment: Alignment.centerRight,child: Text(i['keyword'], textDirection: TextDirection.rtl,))),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        celebrities = fetchCelebrities(userToken!);
      });
    });
    countries = fetCountries();
    categories = fetCategories();
    areas = fetAreas(194);
  //  _dropdownTestItems = buildDropdownTestItems(citilist);
    _dropdownTestItems2 = buildDropdownTestItems(categorylist);
  //  _dropdownTestItems3 = buildDropdownTestItems(countrylist);
    _dropdownTestItems4 = buildDropdownTestItems(genderlist);
    _dropdownTestItems5 = buildDropdownTestItems(areaslist);
    focusNode.addListener(() {
      if (currentFocus.hasPrimaryFocus) {
        addHeight= false;
      }
    });

    super.initState();
  }

  DropdownMenuItem<Object?> buildDropdownTestItems2(i) {
    DropdownMenuItem<Object?> item;
    item =
        DropdownMenuItem(
          alignment: Alignment.centerRight,
          value: i,
          child: Directionality(
              textDirection: TextDirection.rtl,child: Container( alignment: Alignment.centerRight,child: Text(i['keyword'], textDirection: TextDirection.rtl,))),

        );

    return item;
  }

  @override
  Widget build(BuildContext context) {
    // print(genderChosen.toString());
    // getid.forEach((key, value) {
    //   if (value == Logging.theUser!.country) {
    //     print(key.toString() + '---------------------------------------------');
    //     cities = fetCities( 1);
    //   }
    //});
    unfocus() {
      currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('المعلومات الشخصية', context),
        body: GestureDetector(
          onTap: () {
    unfocus();
    setState(() {
    addHeight = false;
    });
    },
          child: SingleChildScrollView(
            child: paddingg(
              12,
              12,
              5,
              FutureBuilder<CelebrityInformation>(
                future: celebrities,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting || areadone== false|| nationalitydone== false  || categorydone == false) {
                    return  (!isConnectSection) ?
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 150.h),
                            child: SizedBox(
                                height: 300.h,
                                width: 250.w,
                                child: internetConnection(
                                    context, reload: () {
                                  setState(() {
                                    celebrities =
                                        fetchCelebrities(userToken!);
                                    isConnectSection = true;
                                  });
                                })),
                          ))
                    :  Center(child: mainLoad(context));
                  } else if (snapshot.connectionState ==
                      ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      if (!isConnectSection) {
                        return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 150.h),
                              child: SizedBox(
                                  height: 300.h,
                                  width: 250.w,
                                  child: internetConnection(
                                      context, reload: () {
                                    setState(() {
                                      celebrities =
                                          fetchCelebrities(userToken!);
                                      isConnectSection = true;
                                    });
                                  })),
                            ));
                      } else {
                        if (!serverExceptions) {
                          return Container(
                            height: getSize(context).height / 1.5,
                            child: Center(
                                child: checkServerException(context)
                            ),
                          );
                        } else {
                          if (!timeoutException) {
                            return Center(
                              child: checkTimeOutException(
                                  context, reload: () {
                                setState(() {
                                  celebrities = fetchCelebrities(userToken!);
                                });
                              }),
                            );
                          }
                        }
                        return const Center(
                            child: Text(
                                'حدث خطا ما اثناء استرجاع البيانات'));
                      }
                      //---------------------------------------------------------------------------
                    } else if (snapshot.hasData) {
                      snapshot.data != null
                          ? {
                        helper == 0
                            ? {
                          name.text = snapshot
                              .data!.data!.celebrity!.name!,
                          email.text = snapshot
                              .data!.data!.celebrity!.email!,
                          password.text = "********",
                          desc.text = snapshot.data!.data!
                              .celebrity!.description!,
                          snapshot.data!.data!.celebrity!
                              .phonenumber! !=
                              ""
                              ? {
                            number = snapshot
                                .data!
                                .data!
                                .celebrity!
                                .phonenumber!
                                .length -
                                9,
                            phone.text = snapshot
                                .data!
                                .data!
                                .celebrity!
                                .phonenumber!
                                .substring(number!),
                          }
                              : phone.text = snapshot.data!.data!
                              .celebrity!.phonenumber!,
                          snapshot.data!.data!.celebrity!
                              .gender !=
                              null
                              ? {
                            gender = snapshot.data!.data!
                                .celebrity!.gender!.name!,
                            genderChosen = true,
                            genderi = snapshot.data!.data!
                                .celebrity!.gender!.id
                          }
                              : gender,
                          snapshot.data!.data!.celebrity!.area != null?{
                      area = snapshot.data!.data!.celebrity!.area!.name!,
                      areaId = snapshot.data!.data!.celebrity!.area!.id,
                            cities = fetCities(areaId!)
                      } :null,
                          pageLink.text = snapshot
                              .data!.data!.celebrity!.pageUrl!,

                          // socialMedia.snap = snapshot
                          //     .data!.data!.celebrity!.snapchat!
                          //     .toString().replaceAll('https://www.snapchat.com/add/', ''),
                          // socialMedia.you = snapshot
                          //     .data!.data!.celebrity!.youtube!
                          //     .toString().replaceAll('https://youtube.com/', ''),
                          // socialMedia.insta = snapshot
                          //     .data!.data!.celebrity!.instagram!
                          //     .toString().replaceAll('https://www.instagram.com/', ''),
                          // socialMedia.face = snapshot
                          //     .data!.data!.celebrity!.facebook!
                          //     .toString().replaceAll('https://www.facebook.com/', ''),
                          // socialMedia.twit = snapshot
                          //     .data!.data!.celebrity!.twitter!
                          //     .toString().replaceAll('https://twitter.com/', ''),
                          //----------------
                          snapshot.data!.data!.celebrity!
                              .category !=
                              null
                              ? {category = snapshot.data!.data!
                              .celebrity!.category!.name!,
                            categoriesId.forEach((key, value) {
                              if (value == snapshot.data!.data!
                                  .celebrity!.category!.name!) {
                                categoryi = key;
                              }
                            })
                          } : '',
                          snapshot.data!.data!.celebrity!
                              .nationality != null
                              ? {
                      nationalityId =  snapshot.data!.data!.celebrity!.nationality!.id,
                            country = snapshot.data!.data!
                                .celebrity!.nationality!.nationalityy_ar!,
                            print(getid.isEmpty.toString()+ '========================================================================='),
                            getid.isEmpty? null: {
                              getid.forEach((key, value) {
                                print(value);
                                if (value == snapshot.data!.data!
                                    .celebrity!.nationality!.nationalityy_ar!) {

                                  print(
                                      'country in build ============================ ' +
                                          (value).toString());
                                }

                              }),

                            },

                      print(
                      'country in build ============================ ' +
                     countryi.toString()),
                          }
                              : '',
                          snapshot.data!.data!.celebrity!.city !=
                              null
                              ? {
                            city = snapshot.data!.data!
                              .celebrity!.city!.name
                              .toString(),
                            citychosen = true,
                            cityi = snapshot.data!.data!
                                .celebrity!.city!.id
                          }
                              : null,

                          helper = 1,
                        }
                            : null
                      }
                          : null;

                      return Container(
                        child: Form(
                          key: _formKey,
                          child: paddingg(
                            12,
                            12,
                            5, Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  padding(
                                    10,
                                    12,
                                    Container(
                                        alignment: Alignment.topRight,
                                        child:  Text(
                                          'فضلا ادخل البيانات الصحيحة',
                                          style: TextStyle(
                                              fontSize: textSubHeadSize,
                                              color: textBlack,
                                              fontFamily: 'Cairo'),
                                        )),
                                  ),

                                  //========================== form ===============================================

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    textFieldNoIcon(
                                        context,
                                        'الاسم',
                                        textFieldSize,
                                        false,
                                        name,
                                            (String? value) {
                                          String pattern = r'^[\u0621-\u064A\u0660-\u0669 ]+$';
                                          RegExp regExp =  RegExp(pattern);
                                          if (value == null || value.isEmpty) {
                                            return 'حقل اجباري';
                                          }else{
                                            if (regExp.hasMatch(value)==false) {
                                              return "يجب ان يكون الاسم باللغة العربية";
                                            }
                                            if (value.length > 14) {
                                              return "الحد المسموح 14 حرف كجد اقصى";
                                            }
                                          }
                                          return null;
                                        },
                                        false),
                                  ),


                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    textFieldDesc(context, 'الوصف الخاص بالمشهور',
                                        textFieldSize, false, desc, (String? value) {
                                          if (value == null ||
                                              value.isEmpty) {} else {
                                            return value.length > 43
                                                ? 'يجب ان لا يزيد الوصف عن 43 حرف'
                                                : null;
                                          }
                                          return null;
                                        }, counter: (context,
                                            {required currentLength,
                                              required isFocused,
                                              maxLength}) {
                                          return addHeight?Container(
                                              child: Text('${maxLength!}' +
                                                  '/' +
                                                  '${currentLength}')):SizedBox();
                                        }, maxLenth: 43,
                                        onTap: (){setState(() {
                                          addHeight = true;
                                        });},
                                        height:addHeight? 150.h :70.h ),
                                  ),
                                  paddingg(
                                    15,
                                    15,
                                    5,
                                    textFieldNoIcon(
                                        context,
                                        'البريد الالكتروني',
                                        textFieldSize,
                                        false,
                                        email, (String? value) {
                                      if (value == null || value.isEmpty) {} else {
                                        return value.contains('@') &&
                                            value.contains('.com')
                                            ? null
                                            : 'صيغة البريد الالكتروني غير صحيحة ';
                                      }
                                      return null;
                                    },
                                        false, disable: false),
                                  ),
                                  Container(
                                    height: 65.h,
                                    child: paddingg(
                                      15,
                                      15,
                                      12,
                                      textFieldNoIcon(
                                          context,
                                          'كلمة المرور',
                                          textFieldSize,
                                          true,
                                          password, (String? value) {
                                        if (value == null || value.isEmpty) {}
                                        return null;
                                      },
                                          false,
                                          child: IconButton(onPressed: () {
                                            setState(() {
                                              editPassword = !editPassword;
                                            });
                                          }, icon: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.edit, color: black),
                                          ))),
                                    ),
                                  ),

                                  editPassword
                                      ? Form(
                                    key: _formKey2,
                                    child: Column(
                                      children: [
                                        paddingg(
                                          15,
                                          15,
                                          12,
                                          textFieldNoIcon(
                                              context,
                                              'كلمة المرور الحالية',
                                              textFieldSize,
                                              true,
                                              currentPassword,
                                                  (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {}
                                                return null;
                                              },
                                              false),
                                        ),
                                        paddingg(
                                          15,
                                          15,
                                          12,
                                          TextFormField(
                                            obscureText: showText,
                                            validator: (String? value) {
                                              String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                                              RegExp regExp =  RegExp(pattern);
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'حقل اجباري';
                                              }
                                              if (value.length < 8) {
                                                return 'يجب ان تتكون كلمة المرور من 8 احرف على الاقل';
                                              }
                                              if (regExp.hasMatch(value)==false) {
                                                return "يجب ان تحتوي كلمة المرور علي حرف صغير، كبير، رقم ورمز";
                                              }
                                              return null;
                                            },
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            controller: newPassword,
                                            style:
                                            TextStyle(color: black, fontSize: textFieldSize.sp, fontFamily: 'Cairo',),
                                            decoration: InputDecoration(

                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  borderSide: BorderSide(
                                                    color: newGrey,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                isDense: false,
                                                filled: true,
                                                errorStyle: TextStyle(fontSize: 12.sp),
                                                helperStyle: TextStyle(
                                                    color: pink, fontSize: textFieldSize.sp, fontFamily: 'Cairo'),
                                                hintStyle: TextStyle(
                                                    color: grey, fontSize:textFieldSize.sp, fontFamily: 'Cairo', decoration:  TextDecoration.none),
                                                fillColor: lightGrey.withOpacity(0.10),
                                                labelStyle: TextStyle(color: black, fontSize: 14.sp),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: purple, width: 1.w)),
                                                suffixIcon: IconButton(onPressed: (){setState(() {
                                                  showText = !showText;
                                                });},icon:Icon(!showText?Icons.visibility:Icons.visibility_off)),
                                                hintText: 'كلمة المرور الجديدة',
                                                contentPadding: EdgeInsets.all(10.h)),
                                          ),
                                        ),

                                        paddingg(
                                          15,
                                          15,
                                          12,
                                          TextFormField(
                                            obscureText: showText2,
                                            validator: (String? value) {
                                              String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                                              RegExp regExp =  RegExp(pattern);
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'حقل اجباري';
                                              }
                                              if (value.length < 8) {
                                                return 'يجب ان تتكون كلمة المرور من 8 احرف على الاقل';
                                              }
                                              if (regExp.hasMatch(value)==false) {
                                                return "يجب ان تحتوي كلمة المرور علي حرف صغير، كبير، رقم ورمز";
                                              }
                                              return null;
                                            },
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            controller: confirmPassword,
                                            style:
                                            TextStyle(color: black, fontSize: textFieldSize.sp, fontFamily: 'Cairo',),
                                            decoration: InputDecoration(

                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  borderSide: BorderSide(
                                                    color: newGrey,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                isDense: false,
                                                filled: true,
                                                errorStyle: TextStyle(fontSize: 12.sp),
                                                helperStyle: TextStyle(
                                                    color: pink, fontSize: textFieldSize.sp, fontFamily: 'Cairo'),
                                                hintStyle: TextStyle(
                                                    color: grey, fontSize: textFieldSize.sp, fontFamily: 'Cairo', decoration:  TextDecoration.none),
                                                fillColor: lightGrey.withOpacity(0.10),
                                                labelStyle: TextStyle(color: black, fontSize: 14.sp),
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: purple, width: 1.w)),
                                                suffixIcon:  IconButton(onPressed: (){setState(() {
                                                  showText2 = !showText2;
                                                });},icon:Icon(!showText2?Icons.visibility:Icons.visibility_off)),
                                                hintText: 'تاكيد كلمة المرور',
                                                contentPadding: EdgeInsets.all(10.h)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      : const SizedBox(
                                    height: 0,
                                  ),
                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    TextFormField(
                                      validator: (value){},
                                      controller: TextEditingController(text: 'السعودية'),
                                      enabled: false,
                                      style:
                                      TextStyle(color: black, fontSize: textFieldSize.sp, fontFamily: 'Cairo',),
                                      decoration: InputDecoration(

                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                            borderSide: BorderSide(
                                              color: newGrey,
                                              width: 0.5,
                                            ),
                                          ),
                                          isDense: false,
                                          filled: true,
                                          errorStyle: TextStyle(fontSize: textFieldSize.sp),
                                          helperStyle: TextStyle(
                                              color: pink, fontSize: 15.sp, fontFamily: 'Cairo'),
                                          hintStyle: TextStyle(
                                              color: grey, fontSize: textFieldSize.sp, fontFamily: 'Cairo', decoration:  TextDecoration.none),
                                          fillColor: lightGrey.withOpacity(0.10),
                                          labelStyle: TextStyle(color: black, fontSize: 15.sp),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: purple, width: 1.w)),
                                          contentPadding: EdgeInsets.all(10.h)),
                                    ),
                                  ),
                                  Visibility(
                                      visible: areadone,child: Column(children: [
                                    FutureBuilder(
                                        future: areas,
                                        builder: ((context,
                                            AsyncSnapshot<CityL> snapshot) {
                                          print(countrylist.indexOf(_selectedTest3).toString()+'*************************************************************************************');
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center();
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.active ||
                                              snapshot.connectionState ==
                                                  ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Center(
                                              );
                                              //---------------------------------------------------------------------------
                                            } else if (snapshot.hasData) {
                                              return paddingg(
                                                15,
                                                15,
                                                12,
                                                DropdownBelow(
                                                  dropdownColor: white,
                                                  itemWidth: 370.w,

                                                  ///text style inside the menu
                                                  itemTextstyle: TextStyle(
                                                    fontSize: textFieldSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: black,
                                                    fontFamily: 'Cairo',
                                                  ),

                                                  ///hint style
                                                  boxTextstyle: TextStyle(
                                                      fontSize: textFieldSize.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: black,
                                                      fontFamily: 'Cairo'),

                                                  ///box style
                                                  boxPadding: EdgeInsets.fromLTRB(
                                                      13.w, 10.h, 13.w, 12.h),
                                                  boxWidth: 500.w,
                                                  boxHeight: 45.h,
                                                  boxDecoration: BoxDecoration(
                                                      border:  Border.all(color: newGrey, width: 0.5),
                                                      color: lightGrey.withOpacity(0.10),
                                                      borderRadius:
                                                      BorderRadius.circular(8.r)),

                                                  ///Icons
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.grey,
                                                  ),
                                                  hint: Text(
                                                    area,
                                                    textDirection: TextDirection.rtl,
                                                  ),
                                                  value: _selectedTest5,
                                                  items: _dropdownTestItems5,
                                                  onChanged: onChangeDropdownTests5,
                                                ),
                                              );

                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      'لايوجد لينك لعرضهم حاليا'));
                                            }
                                          } else {
                                            return Center();
                                            //   child: Text(
                                            // 'State: ${snapshot.connectionState}'));
                                          }
                                        })),
                                    areawarn != null?
                                    areawarn? paddingg(
                                        0,
                                        22.w,
                                        5.h, Container(alignment: Alignment.topRight,child: text(context, 'الرجاء اختيار المنطقة', textError, red!))):SizedBox()
                                        :SizedBox(),
                                  ])),

                                  Visibility(visible: areadone && citydone,child: Column(children: [
                                    FutureBuilder(
                                        future: cities,
                                        builder: ((context,
                                            AsyncSnapshot<CityL> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return paddingg(
                                              15,
                                              15,
                                              12,
                                              DropdownBelow(
                                                itemWidth: 370.w,
                                                dropdownColor: white,
                                                ///text style inside the menu
                                                itemTextstyle: TextStyle(
                                                  fontSize: textFieldSize.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: black,
                                                  fontFamily: 'Cairo',
                                                ),

                                                ///hint style
                                                boxTextstyle: TextStyle(
                                                    fontSize: textFieldSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: black,
                                                    fontFamily: 'Cairo'),

                                                ///box style
                                                boxPadding: EdgeInsets.fromLTRB(
                                                    13.w, 10.h, 13.w, 12.h),
                                                boxWidth: 500.w,
                                                boxHeight: 45.h,
                                                boxDecoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: newGrey,
                                                        width: 0.5),
                                                    color: lightGrey.withOpacity(
                                                        0.10),
                                                    borderRadius:
                                                    BorderRadius.circular(8.r)),

                                                ///Icons
                                                icon:  const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.grey,
                                                ),
                                                hint: Text(
                                                  city,
                                                  textDirection: TextDirection
                                                      .rtl,
                                                ),
                                                value: _selectedTest,
                                                items: _dropdownTestItems,
                                                onChanged: onChangeDropdownTests,
                                              ),
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.active ||
                                              snapshot.connectionState ==
                                                  ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Center();
                                              //---------------------------------------------------------------------------
                                            } else if (snapshot.hasData) {

                                              return paddingg(
                                                15,
                                                15,
                                                12,
                                                DropdownBelow(
                                                  itemWidth: 350.w,
                                                  dropdownColor: white,

                                                  ///text style inside the menu
                                                  itemTextstyle: TextStyle(
                                                    fontSize: textFieldSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: black,
                                                    fontFamily: 'Cairo',
                                                  ),

                                                  ///hint style
                                                  boxTextstyle: TextStyle(
                                                      fontSize: textFieldSize.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: black,
                                                      fontFamily: 'Cairo'),

                                                  ///box style
                                                  boxPadding: EdgeInsets.fromLTRB(
                                                      13.w, 10.h, 13.w, 12.h),
                                                  boxWidth: 450.w,
                                                  boxHeight: 45.h,
                                                  boxDecoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: newGrey,
                                                          width: 0.5),
                                                      color: lightGrey.withOpacity(
                                                          0.10),
                                                      borderRadius:
                                                      BorderRadius.circular(8.r)),

                                                  ///Icons
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.grey,
                                                  ),
                                                  hint: Text(
                                                    city,
                                                    textDirection: TextDirection
                                                        .rtl,
                                                  ),
                                                  value: _selectedTest,
                                                  items: _dropdownTestItems,
                                                  onChanged: onChangeDropdownTests,
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      'لايوجد لينك لعرضهم حاليا'));
                                            }
                                          } else {
                                            return Center(
                                                child: Text(
                                                    ''));
                                          }
                                        })) ,

                                    areaId != null && areaId != 0?
                                    citychosen == false && (cityi == null || cityi == 0) ?
                                    Padding(
                                        padding:  EdgeInsets.only(right:22.w, top: 5.h),
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: text(
                                              context, 'الرجاء تحديد المدينة', textError, red!),
                                        ))
                                        : SizedBox():SizedBox(),
                                  ],),),


                                  Visibility(visible: nationalitydone,child: Column(children: [
                                    isConnectSection ?

                                    FutureBuilder(
                                        future: countries,
                                        builder: ((context,
                                            AsyncSnapshot<Nationality> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return paddingg(
                                              15,
                                              15,
                                              12,
                                              DropdownBelow(
                                                itemWidth: 370.w,
                                                dropdownColor: white,
                                                ///text style inside the menu
                                                itemTextstyle: TextStyle(
                                                  fontSize: textFieldSize.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: black,
                                                  fontFamily: 'Cairo',
                                                ),

                                                ///hint style
                                                boxTextstyle: TextStyle(
                                                    fontSize: textFieldSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: black,
                                                    fontFamily: 'Cairo'),

                                                ///box style
                                                boxPadding: EdgeInsets.fromLTRB(
                                                    13.w, 10.h, 13.w, 12.h),
                                                boxWidth: 500.w,
                                                boxHeight: 45.h,
                                                boxDecoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: newGrey,
                                                        width: 0.5),
                                                    color: lightGrey.withOpacity(
                                                        0.10),
                                                    borderRadius:
                                                    BorderRadius.circular(8.r)),

                                                ///Icons
                                                icon:  const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.grey,
                                                ),
                                                hint: Text(
                                                  country,
                                                  textDirection: TextDirection
                                                      .rtl,
                                                ),
                                                value: _selectedTest4,
                                                items: _dropdownTestItems4,
                                                onChanged: onChangeDropdownTests4,
                                              ),
                                            );;
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.active ||
                                              snapshot.connectionState ==
                                                  ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Center();
                                              //---------------------------------------------------------------------------
                                            } else if (snapshot.hasData) {
                                              return paddingg(
                                                15,
                                                15,
                                                12,
                                                DropdownBelow(
                                                  itemWidth: 370.w,
                                                  dropdownColor: white,
                                                  ///text style inside the menu
                                                  itemTextstyle: TextStyle(
                                                    fontSize: textFieldSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: black,
                                                    fontFamily: 'Cairo',
                                                  ),

                                                  ///hint style
                                                  boxTextstyle: TextStyle(
                                                      fontSize: textFieldSize.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: black,
                                                      fontFamily: 'Cairo'),

                                                  ///box style
                                                  boxPadding: EdgeInsets.fromLTRB(
                                                      13.w, 10.h, 13.w, 12.h),
                                                  boxWidth: 500.w,
                                                  boxHeight: 45.h,
                                                  boxDecoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: newGrey,
                                                          width: 0.5),
                                                      color: lightGrey.withOpacity(
                                                          0.10),
                                                      borderRadius:
                                                      BorderRadius.circular(8.r)),

                                                  ///Icons
                                                  icon: const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.grey,
                                                  ),
                                                  hint: Text(
                                                    country,
                                                    textDirection: TextDirection
                                                        .rtl,
                                                  ),
                                                  value: _selectedTest3,
                                                  items: _dropdownTestItems3,
                                                  onChanged: onChangeDropdownTests3,
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      'لايوجد لينك لعرضهم حاليا'));
                                            }
                                          } else {
                                            return Center(
                                                child: Text(
                                                    'State: ${snapshot
                                                        .connectionState}'));
                                          }
                                        })) : SizedBox(),

                                    nationalityWarn ? Padding(
                                      padding:  EdgeInsets.only(right: 22.w, top: 5.h),
                                      child: Container(
                                        alignment: Alignment.topRight,
                                        child: text(
                                            context, 'الرجاء تحديد الجنسية', textError,
                                            red!),
                                      ),
                                    ) : SizedBox(),

                                  ],)),



                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    textFieldNoIcon(context, 'رقم الجوال', textFieldSize,
                                      false, phone, (String? value) {
                                        RegExp regExp = new RegExp(
                                            r'(^(?:[+0]9)?[0-9]{10,12}$)');
                                        if (value == null || value.isEmpty) {
                                          return 'حقل اجباري';
                                        } else{
                                        if (value != null) {
                                          if (value.isNotEmpty) {
                                            if (value.length != 9) {
                                              return "رقم الجوال يجب ان يتكون من 9 ارقام  ";
                                            }
                                            if (value.startsWith('0')) {
                                              return 'رقم الجوال يجب ان لا يبدا ب 0 ';
                                            }

                                          }
                                        }
                                        }

                                        return null;
                                      }, false, child:  Container(
                                        width: 20.w,
                                        height: 32.h,
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: CountryCodePicker(
                                            padding: EdgeInsets.all(0),
                                            onChanged: print,
                                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                            initialSelection: country == 'السعودية'
                                                ? 'SA'
                                                : 'SA',
                                            countryFilter: const [
                                              'SA',
                                            ],
                                            showFlag: false,
                                            enabled: false,
                                            // optional. Shows only country name and flag
                                            showCountryOnly: false,
                                            showFlagDialog: true,
                                            textStyle:  TextStyle(color: black, fontSize: textFieldSize.sp),
                                            // optional. Shows only country name and flag when popup is closed.
                                            showOnlyCountryWhenClosed: false,
                                            // optional. aligns the flag and the Text left
                                            alignLeft: true,
                                          ),
                                        ),
                                      ), ),
                                  ),

                                  // ===========dropdown lists ==================


                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    DropdownBelow(
                                      itemWidth: 350.w,
                                      dropdownColor: white,

                                      ///text style inside the menu
                                      itemTextstyle: TextStyle(
                                        fontSize: textFieldSize.sp,
                                        fontWeight: FontWeight.w400,
                                        color: black,
                                        fontFamily: 'Cairo',
                                      ),

                                      ///hint style
                                      boxTextstyle: TextStyle(
                                          fontSize: textFieldSize.sp,
                                          fontWeight: FontWeight.w400,
                                          color: black,
                                          fontFamily: 'Cairo'),

                                      ///box style
                                      boxPadding: EdgeInsets.fromLTRB(
                                          13.w, 10.h, 13.w, 12.h),
                                      boxWidth: 500.w,
                                      boxHeight: 45.h,
                                      boxDecoration: BoxDecoration(
                                          border: Border.all(
                                              color: newGrey, width: 0.5),
                                          color: lightGrey.withOpacity(0.10),
                                          borderRadius: BorderRadius.circular(8.r)),

                                      ///Icons
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                                      hint: Text(
                                        gender,
                                        textDirection: TextDirection.rtl,
                                      ),
                                      value: _selectedTest4,
                                      items: _dropdownTestItems4,
                                      onChanged: onChangeDropdownTests4,
                                    ),
                                  ),

                                  genderChosen != null?
                                  genderChosen == false
                                      ? paddingg(
                                      10,
                                      20,
                                      3,
                                      text(
                                          context,
                                          'الرجاء تحديد نوع الجنس ',
                                          textError,
                                          red!)):SizedBox(): SizedBox(),

                                  Visibility(visible: categorydone,child:FutureBuilder(
                                      future: categories,
                                      builder: ((context,
                                          AsyncSnapshot<CategoryL> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center();
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.active ||
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return SizedBox();
                                            //---------------------------------------------------------------------------
                                          } else if (snapshot.hasData) {


                                            return paddingg(
                                              15,
                                              15,
                                              12,
                                              DropdownBelow(
                                                itemWidth: 350.w,
                                                dropdownColor: white,

                                                ///text style inside the menu
                                                itemTextstyle: TextStyle(
                                                  fontSize: textFieldSize.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: black,
                                                  fontFamily: 'Cairo',
                                                ),

                                                ///hint style
                                                boxTextstyle: TextStyle(
                                                    fontSize: textFieldSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: black,
                                                    fontFamily: 'Cairo'),

                                                ///box style
                                                boxPadding: EdgeInsets.fromLTRB(
                                                    13.w, 10.h, 13.w, 12.h),
                                                boxWidth: 500.w,
                                                boxHeight: 45.h,
                                                boxDecoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: newGrey, width: 0.5),
                                                    color: lightGrey.withOpacity(
                                                        0.10),

                                                    borderRadius:
                                                    BorderRadius.circular(8.r)),

                                                ///Icons
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.grey,
                                                ),
                                                hint: Text(
                                                  category,
                                                  textDirection: TextDirection.rtl,
                                                ),
                                                value: _selectedTest2,
                                                items: _dropdownTestItems2,
                                                onChanged: onChangeDropdownTests2,
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                                child: Text(
                                                    'لايوجد لينك لعرضهم حاليا'));
                                          }
                                        } else {
                                          return Center(
                                              child: Text(
                                                  'State: ${snapshot
                                                      .connectionState}'));
                                        }
                                      })), ),


                                  //=========== end dropdown ==================================

                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    textFieldNoIcon(
                                        context,
                                        'الرابط الخاص بصفحتك',
                                        textFieldSize,
                                        false,
                                        pageLink,
                                            (String? value) {
                                          if (value == null || value.isEmpty) {}
                                          return null;
                                        },
                                        false, underline: true, child: IconButton(onPressed: (){
                                      Clipboard.setData(ClipboardData(text: snapshot.data!.data!.celebrity!.fullPageUrl));

                                      var snackBar = SnackBar(content: text(context,'تم النسخ', 15, white, align: TextAlign.center),
                                          shape: StadiumBorder(),
                                        behavior: SnackBarBehavior.floating,
                                        margin: EdgeInsets.only(bottom: getSize(context).height/2.h, right: 130.w, left: 130.w),
                                        backgroundColor: deepgrey,
                                        elevation: 20,
                                        duration: Duration(milliseconds: 100),

                                      );
                                      // Step 3
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                    }, icon: Icon(copy)),onTap: (String v){setState(() {
                                      pageLink.text = snapshot.data!.data!.celebrity!.pageUrl!;
                                    });}),
                                  ),


                                  //===================== button ================================

                                  const SizedBox(
                                    height: 30,
                                  ),
                                  padding(
                                    15,
                                    15,
                                    gradientContainerNoborder(
                                        getSize(context).width,
                                        buttoms(context, 'حفظ', largeButtonSize, white, () {
                                          if (currentPassword.text.isNotEmpty &&
                                              newPassword.text.isNotEmpty) {
                                            _formKey2.currentState == null
                                                ? null
                                                : _formKey2.currentState!
                                                .validate()
                                                ? {
                                              newPassword.text ==
                                                  confirmPassword
                                                      .text
                                                  ? {
                                                changePassword().then((value) =>
                                                {
                                                  value == 'SocketException' ||
                                                      value == 'TimeoutException' ||
                                                      value == 'ServerException' ? {
                                                    Navigator.pop(context),
                                                    showMassage(context,
                                                        'فشل الاتصال بالانترنت',
                                                        socketException)
                                                  } :
                                                  value.contains('false')
                                                      ? showMassage(context, 'خطا',
                                                      value.replaceAll('false', ''))
                                                      : showMassage(
                                                      context, 'تم بنجاح',
                                                      "تم التغيير بنجاح",
                                                      done: done),
                                                  currentPassword.clear(),
                                                  newPassword.clear(),
                                                  confirmPassword.clear(),
                                                  setState(() {
                                                    editPassword =false;
                                                  })
                                                })
                                              }
                                                  : setState(() {
                                                noMatch =
                                                true;
                                              })
                                            }
                                                : null;
                                          }
                                          else {
                                            genderChosen == null || genderChosen == false
                                                ? setState(() {
                                              genderChosen = false;
                                            })
                                                : setState(() {
                                              genderChosen = true;
                                            });
                                            _formKey.currentState!.validate() &&
                                                _formKey2.currentState == null &&
                                                genderChosen == true &&
                                                (_selectedTest3 != null || nationalityId != null) && (_selectedTest5 != null || (areaId != null && areaId != 0)) && (_selectedTest != null || cityi != null)
                                                ?
                                            { loadingDialogue(context),
                                              updateInformation().then((value) =>
                                              {
                                                value.contains('true')?{
                                                  Navigator.pop(context),
                                                  countryChanged
                                                      ? setState(() {
                                                    helper = 0;
                                                    countryChanged = false;
                                                    celebrities =
                                                        fetchCelebrities(
                                                            userToken!);
                                                  })
                                                      : Navigator.pop(context),
                                                  showMassage(
                                                      context, 'تم ', value.replaceAll('true', ''),
                                                      done: done)
                                                }:{
                                                  value == 'SocketException'?{
                                                    Navigator.pop(context),
                                                    showMassage(context,'فشل الاتصال بالانترنت', socketException)
                                                  }: {

                                                    value == 'serverException'? {
                                                      Navigator.pop(context),
                                                        showMassage(
                                                          context, 'خطا', 'تاكد من البيانات المدخلة',)

                                                    }:{
                                                      Navigator.pop(context),
                                                      if(value.contains('The selected city id is invalid.')){
                                              showMassage(
                                              context, 'خطا', 'الرجاء اختيار المدينة ',)
                                              }else
                                                        { if(value.contains('The phonenumber has already been taken.')){
                                                          showMassage(
                                                            context, 'خطا', 'رقم الجوال مستخدم مسبقا ',)
                                                        }else{ showMassage(
                                                          context,
                                                          'خطا',
                                                          'تاكد من البيانات المدخلة',
                                                        )}

                                                        }
                                                    }


                                                  }
                                                }
                                              })}
                                                : setState(() {
                                              nationalityId == null? nationalityWarn = true:null;
                                              _selectedTest5 == null &&(areaId == null || areaId == 0)? areawarn = true:null;
                                              _selectedTest == null && cityi == null? citychosen = false:null;
                                            },);
                                          }
                                        })),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ]),
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: Text('Empty data'));
                    }
                  } else {
                    return Center(
                        child: Text('State: ${snapshot.connectionState}'));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMDAzNzUwY2MyNjFjNDY1NjY2YjcwODJlYjgzYmFmYzA0ZjQzMGRlYzEyMzAwYTY5NTE1ZDNlZTYwYWYzYjc0Y2IxMmJiYzA3ZTYzODAwMWYiLCJpYXQiOjE2NTMxMTY4MjcuMTk0MDc3OTY4NTk3NDEyMTA5Mzc1LCJuYmYiOjE2NTMxMTY4MjcuMTk0MDg0ODgyNzM2MjA2MDU0Njg3NSwiZXhwIjoxNjg0NjUyODI3LjE5MDA0ODkzMzAyOTE3NDgwNDY4NzUsInN1YiI6IjExIiwic2NvcGVzIjpbXX0.GUQgvMFS-0VA9wOAhHf7UaX41lo7m8hRm0y4mI70eeAZ0Y9p2CB5613svXrrYJX74SfdUM4y2q48DD-IeT67uydUP3QS9inIyRVTDcEqNPd3i54YplpfP8uSyOCGehmtl5aKKEVAvZLOZS8C-aLIEgEWC2ixwRKwr89K0G70eQ7wHYYHQ3NOruxrpc_izZ5awskVSKwbDVnn9L9-HbE86uP4Y8B5Cjy9tZBGJ-6gJtj3KYP89-YiDlWj6GWs52ShPwXlbMNFVDzPa3oz44eKZ5wNnJJBiky7paAb1hUNq9Q012vJrtazHq5ENGrkQ23LL0n61ITCZ8da1RhUx_g6BYJBvc_10nMuwWxRKCr9l5wygmIItHAGXxB8f8ypQ0vLfTeDUAZa_Wrc_BJwiZU8jSdvPZuoUH937_KcwFQScKoL7VuwbbmskFHrkGZMxMnbDrEedl0TefFQpqUAs9jK4ngiaJgerJJ9qpoCCn4xMSGl_ZJmeQTQzMwcLYdjI0txbSFIieSl6M2muHedWhWscXpzzBhdMOM87cCZYuAP4Gml80jywHCUeyN9ORVkG_hji588pvW5Ur8ZzRitlqJoYtztU3Gq2n6sOn0sRShjTHQGPWWyj5fluqsok3gxpeux5esjG_uLCpJaekrfK3ji2DYp-wB-OBjTGPUqlG9W_fs
  Future<String> updateInformation() async {
    categoriesId.forEach((key, value) {
      if (value == category) {
        print(key);
        print(key.toString() +
            '---------------------------------------------');
        catId = key + 1;
      }
    });
    print(countryi.toString()+ '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    try {
    final response = await http.post(

      Uri.parse(
        'https://mobile.celebrityads.net/api/celebrity/profile/update',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $userToken'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name.text,
        'email': email.text,
        'password': password.text,
        'phonenumber': phone.text.isEmpty?'' :'+966'+phone.text,
        'nationality_id':  nationalityId,
        'city_id': _selectedTest == null ? cityi : _selectedTest['no'],
        'area_id': _selectedTest5 ==null? areaId : _selectedTest5['no'],
        'country_id':1,
        'category_id': _selectedTest2 == null || _selectedTest2['no'] == 0? catId : categorylist.indexOf(_selectedTest2),
        'description': desc.text,
        'gender_id': _selectedTest4 == null ? genderi : _selectedTest4['no'],
        'store': '',
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      if(jsonDecode(response.body)['success'] == true){
        return jsonDecode(response.body)['message']['ar'] +  jsonDecode(response.body)['success'].toString();

      }else{
        return jsonDecode(response.body)['message']['en']['phonenumber'][0] +  jsonDecode(response.body)['success'].toString();
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }catch(e) {
  if (e is SocketException) {
  return 'SocketException';
  } else if(e is TimeoutException) {
  return 'TimeoutException';
  } else {
  return 'serverException';

  }
  }
}


  Future<String> changePassword() async {

    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/password/change',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
        body: jsonEncode(<String, dynamic>{
          'current_password': currentPassword.text,
          'new_password': newPassword.text,
          'confirm_password': confirmPassword.text,
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        return jsonDecode(response.body)['success'].toString();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if(e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';

      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

//getCountries--------------------------------------------------------------------

  Future<Nationality> fetCountries() async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/countries'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        _dropdownTestItems3.isEmpty?{
          _dropdownTestItems3.add(buildDropdownTestItems2({
            'no': 0,
            'keyword':
            'اختيار الجنسية'
          })),
          for (int i = 0; i < jsonDecode(response.body)['data'].length; i++) {
            // print(jsonDecode(response.body)['data'][i]['country_arNationality']);
            setState(() {
              // nationalitylist.add({
              //   'no': i,
              //   'keyword':jsonDecode(response.body)['data'][i]['country_arNationality'],
              // });
              _dropdownTestItems3.add(buildDropdownTestItems2({
                'no': jsonDecode(response.body)['data'][i]['id'],
                'keyword': jsonDecode(
                    response.body)['data'][i]['country_arNationality'],
              }));
              idsnationality.add(jsonDecode(response.body)['data'][i]['id']);
              // getid.putIfAbsent(
              //     i, () => jsonDecode(response.body)['data'][i]['country_arNationality']);
            }),
          }
        }:null;
        setState(() {
          nationalitydone = true;
        });
        return Nationality.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch (e) {
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
  }
  Future<CityL> fetAreas(int countryId) async {
    // try {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/areas/1'),
    );

    if (response.statusCode == 200) {
      _dropdownTestItems5.isEmpty
          ? {
        setState(() {
          areaslist.add({
            'no': 0,
            'keyword':
            'اختيار المنطقة'
          });
          for (int i = 0;
          i <
              jsonDecode(response.body)['data'].length;
          i++)
          {
            areaslist.add({
              'no': jsonDecode(response.body)['data'][i]['id'],
              'keyword':
              '${jsonDecode(response.body)['data'][i]['name']}'
            });
          };
          _dropdownTestItems5 =
              buildDropdownTestItems(
                  areaslist);
          print(areaslist.length.toString() + '==================================================================');
        }),
      }
          : null;
      setState(() {
        areadone = true;
      });
      return CityL.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load activity');
    }
    // }catch(e){
    //   if (e is SocketException) {
    //     setState(() {
    //       noint = true;
    //     });
    //     return Future.error('SocketException');
    //   }else {
    //     print(areaslist.length.toString() + '==================================================================');
    //     return Future.error('serverExceptions');
    //   }
    // }
  }
  Future<CityL> fetCities(int areaIdd) async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/cities/$areaIdd'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        _dropdownTestItems.isEmpty
            ? {
          citilist.add({
            'no': 0,
            'keyword':
            'اختيار المدينة'
          }),
          for (int i = 0;
          i <
              jsonDecode(response.body)['data'].length;
          i++)
            {
              citilist.add({
                'no': jsonDecode(response.body)['data'][i]['id'],
                'keyword':
                '${ jsonDecode(response.body)['data'][i]['name']}'
              }),
            },
          _dropdownTestItems =
              buildDropdownTestItems(
                  citilist)
        }
            : null;
        setState(() {
          citydone = true;
        });
        return CityL.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (e) {
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
  }

//   //get celebrity Categories--------------------------------------------------------------------
  Future<CategoryL> fetCategories() async {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/categories'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      for (int i = 0; i < jsonDecode(response.body)['data'].length; i++) {
        setState(() {
          print(jsonDecode(response.body)['data'][i]['name']);
          categoriesId.putIfAbsent(
              i, () => jsonDecode(response.body)['data'][i]['name']);
        });
      }
      _dropdownTestItems2.isEmpty
          ? {
        categorylist.add({
          'no': 0,
          'keyword': 'التصنيف'
        }),
        for (int i = 0;
        i <
            jsonDecode(response.body)['data'].length;
        i++)
          {
            categorylist.add({
              'no': i+1,
              'keyword':
              '${jsonDecode(response.body)['data'][i]['name']}'
            }),
          },
        _dropdownTestItems2 =
            buildDropdownTestItems(
                categorylist)
      }
          : null;
      setState(() {
        categorydone = true;
      });
      return CategoryL.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  Future<CelebrityInformation> fetchCelebrities(String tokenn) async {
    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/celebrity/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenn'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        return CelebrityInformation.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }
    catch (e) {
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
  }

}
// @override
// TODO: implement wantKeepAlive
// bool get wantKeepAlive => true;

class CelebrityInformation {
  bool? success;
  Data? data;
  Message? message;

  CelebrityInformation({this.success, this.data, this.message});

  CelebrityInformation.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  Celebrity? celebrity;
  int? status;

  Data({this.celebrity, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.celebrity != null) {
      data['celebrity'] = this.celebrity!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Celebrity {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? type;
  String? phonenumber;
  Country? country;
  Nationality? nationality;
  City? city;
  City? area;
  City? gender;
  String? description;
  String? pageUrl;
  String? fullPageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  String? store;
  Category? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;
  int? availableBalance;
  int? outstandingBalance;
  City? verified;
  String? verifiedRejectReson;
  String? celebrityType;
  String? verifiedFile;
  DataBudget? snapchatnum, tiktoknum, youtubenum, instagramnum, twitternum, facebooknum;

  Celebrity(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.type,
        this.area,
        this.phonenumber,
        this.country,
        this.nationality,
        this.city,
        this.facebooknum,
        this.snapchatnum,
        this.tiktoknum,
        this.youtubenum,
        this.twitternum,
        this.instagramnum,
        this.gender,
        this.description,
        this.pageUrl,
        this.fullPageUrl,
        this.snapchat,
        this.tiktok,
        this.youtube,
        this.instagram,
        this.twitter,
        this.facebook,
        this.store,
        this.category,
        this.brand,
        this.advertisingPolicy,
        this.giftingPolicy,
        this.adSpacePolicy,
        this.availableBalance,
        this.outstandingBalance,
        this.verified,
        this.verifiedRejectReson,
        this.celebrityType,
        this.verifiedFile});

  Celebrity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    type = json['type'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    nationality = json['nationality'] != null
        ? new Nationality.fromJson(json['nationality'])
        : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    area = json['area'] != null ? new City.fromJson(json['area']) : null;
    gender = json['gender'] != null ? new City.fromJson(json['gender']) : null;
    description = json['description'];
    pageUrl = json['page_url'];
    fullPageUrl = json['full_page_url'];
    snapchat = json['snapchat'];
    snapchatnum = json['snapchat_number'] != null ? new DataBudget.fromJson(json['snapchat_number']) : null;
    tiktok = json['tiktok'];
    tiktoknum = json['tiktok_number'] != null ? new DataBudget.fromJson(json['tiktok_number']) : null;
    youtube = json['youtube'];
    youtubenum = json['youtube_number'] != null ? new DataBudget.fromJson(json['youtube_number']) : null;
    instagram = json['instagram'];
    instagramnum = json['instagram_number'] != null ? new DataBudget.fromJson(json['instagram_number']) : null;
    twitter = json['twitter'];
    twitternum = json['twitter_number'] != null ? new DataBudget.fromJson(json['twitter_number']) : null;
    facebook = json['facebook'];
    facebooknum = json['facebook_number'] != null ? new DataBudget.fromJson(json['facebook_number']) : null;
    store = json['store'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    brand = json['brand'];
    advertisingPolicy = json['advertising_policy'];
    giftingPolicy = json['gifting_policy'];
    adSpacePolicy = json['ad_space_policy'];
    availableBalance = json['available_balance'];
    outstandingBalance = json['outstanding_balance'];
    verified =
    json['verified'] != null ? new City.fromJson(json['verified']) : null;
    verifiedRejectReson = json['verified_reject_reson'];
    celebrityType = json['celebrity_type'];
    verifiedFile = json['verified_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['type'] = this.type;
    data['facebook_number'] = this.facebooknum;
    data['twitter_number'] = this.twitternum;
    data['instagram_number'] = this.instagramnum;
    data['youtube_number'] = this.youtubenum;
    data['tiktok_number'] = this.tiktoknum;
    data['snapchat_number'] = this.snapchatnum;
    data['phonenumber'] = this.phonenumber;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.nationality != null) {
      data['nationality'] = this.nationality!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.area != null) {
      data['area'] = this.area!.toJson();
    }

    if (this.gender != null) {
      data['gender'] = this.gender!.toJson();
    }
    data['description'] = this.description;
    data['page_url'] = this.pageUrl;
    data['full_page_url'] = this.fullPageUrl;
    data['snapchat'] = this.snapchat;
    data['tiktok'] = this.tiktok;
    data['youtube'] = this.youtube;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    data['store'] = this.store;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['brand'] = this.brand;
    data['advertising_policy'] = this.advertisingPolicy;
    data['gifting_policy'] = this.giftingPolicy;
    data['ad_space_policy'] = this.adSpacePolicy;
    data['available_balance'] = this.availableBalance;
    data['outstanding_balance'] = this.outstandingBalance;
    if (this.verified != null) {
      data['verified'] = this.verified!.toJson();
    }
    data['verified_reject_reson'] = this.verifiedRejectReson;
    data['celebrity_type'] = this.celebrityType;
    data['verified_file'] = this.verifiedFile;
    return data;
  }
}

class City {
  String? name;
  String? nameEn;

  int? id;
  City({this.name, this.nameEn, this.id});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    id =json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['id'] = this.id;
    return data;
  }
}

class Country {
  String? name;
  String? nameEn;
  String? flag;

  Country({this.name, this.nameEn, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['flag'] = this.flag;
    return data;
  }
}

class Nationality {
  int? id;
  String? name;
  String? nameEn;
  String? flag;
  String? nationalityy;
  String? nationalityy_ar;
  // "country_enNationality": "Costa Rican",
  // "country_arNationality": "كوستاريكي",
  Nationality({this.name, this.nameEn,this.id, this.flag, this.nationalityy, this.nationalityy_ar});

  Nationality.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    nationalityy =  json['country_enNationality'];
    nationalityy_ar =  json['country_arNationality'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['country_enNationality'] = this.nationalityy;
    data['country_arNationality'] = this.nationalityy_ar;
    data['flag'] = this.flag;
    return data;
  }
}
class Category {
  String? name;
  String? nameEn;

  Category({this.name, this.nameEn});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

class CountryL {
  bool? success;
  List<DataCountry>? data;
  MessageCountry? message;

  CountryL({this.success, this.data, this.message});

  CountryL.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataCountry>[];
      json['data'].forEach((v) {
        data!.add(new DataCountry.fromJson(v));
      });
    }
    message = json['message'] != null
        ? new MessageCountry.fromJson(json['message'])
        : null;
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

class DataCountry {
  String? name;
  String? nameEn;
  String? flag;

  DataCountry({this.name, this.nameEn, this.flag});

  DataCountry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['flag'] = this.flag;
    return data;
  }
}

class MessageCountry {
  String? en;
  String? ar;

  MessageCountry({this.en, this.ar});

  MessageCountry.fromJson(Map<String, dynamic> json) {
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

class CityL {
  bool? success;
  List<Datacity>? data;
  Message? message;

  CityL({this.success, this.data, this.message});

  CityL.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Datacity>[];
      json['data'].forEach((v) {
        data!.add(new Datacity.fromJson(v));
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

class Gender {
  int? id;
  String? name;
  String? nameEn;
  Gender({this.name, this.nameEn, this.id});
  Gender.fromJson(Map<String, dynamic> json) {
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

class Datacity {
  String? name;
  String? nameEn;
  int? id;
  Datacity({this.name, this.nameEn, this.id});

  Datacity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['id'] = this.id;
    return data;
  }
}

class CategoryL {
  bool? success;
  List<DataCategory>? data;
  Message? message;

  CategoryL({this.success, this.data, this.message});

  CategoryL.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataCategory>[];
      json['data'].forEach((v) {
        data!.add(new DataCategory.fromJson(v));
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

class DataCategory {
  String? name;
  String? nameEn;

  DataCategory({this.name, this.nameEn});

  DataCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class MessageCategory {
  String? en;
  String? ar;

  MessageCategory({this.en, this.ar});

  MessageCategory.fromJson(Map<String, dynamic> json) {
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
