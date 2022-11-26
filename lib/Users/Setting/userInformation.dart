import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/celebrity/setting/celebratyProfile.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Account/TheUser.dart';
import '../../Celebrity/setting/profileInformation.dart';
import 'userProfile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
bool changed = false;
List<DropdownMenuItem<Object?>> _dropdownTestItems4 = [];
List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
List<int> idsnationality = [];
class userInformation extends StatefulWidget {
  _userInformationState createState() => _userInformationState();
}

class _userInformationState extends State<userInformation> {

  bool isConnectSection = true;
  bool timeoutExceptionn = true;
  bool serverExceptions = true;
  bool noint = false;
  int? areaId;
  bool? noAccType;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController name =  TextEditingController();
  final TextEditingController email =  TextEditingController();
  final TextEditingController password =  TextEditingController();
  final TextEditingController newPassword =  TextEditingController();
  final TextEditingController currentPassword =  TextEditingController();
  final TextEditingController confirmPassword =  TextEditingController();
  final TextEditingController phone =  TextEditingController();
  String userToken ="";
  Future<Nationality>? nationalities;
  Future<CityL>? cities;
  Future<CityL>? areas;
  bool noMatch =false;
  bool editPassword = false;
  String? userType;
  bool nationalityWarn = false;
  bool areawarn = false;
  bool citychosen = true;
  Map<int, String> getid = HashMap();
  Map<int, String> cid = HashMap();
  bool showText = true;
  bool showText2 = true;
  int helper =0;
  bool hidden = true;
  bool hidden2 = true;
  String country = 'الدولة';
  String area = 'اختيار المنطقة';
  String city = 'اختيار المدينة';
  String  accType= 'اختيار نوع الحساب';
  String? countrycode;
  bool countryChanged = false;
  bool cityChanged = false;
  int? cityi;
  int? countryId;
  int? nationalityId;
  Future<UserProfile>? getUser;
  var currentFocus;
  var citilist = [];
  var areaslist = [];
  String nationality = 'الجنيسة';
  int? countryi, genderi,categoryi;
  var countrylist = [];
  bool typedone = true, areadone = false, citydone = false, nationalitydone = false;
  var accTpeList = [{
    'no': 0,
    'keyword':
    'اختيار نوع الحساب'
  }, {'no':1,'keyword':'فرد','keyword2':'person'},{'no':2,'keyword':'مؤسسة/ شركة','keyword2':'company'}];

  List<DropdownMenuItem<Object?>> _dropdownTestItems3 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems2= [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems5 = [];
  ///_value
  var _selectedTest;
  onChangeDropdownTests(selectedTest) {
    print(selectedTest['no']);
    setState(() {
      city = selectedTest['keyword'];
      _selectedTest = selectedTest;
      cityi = selectedTest['no'];
      selectedTest['no'] == 0? _selectedTest = null:null;
      citychosen = true;
      // cid.forEach((key, value) {
      //   if(value == selectedTest['keyword']){
      //     cityi = key;
      //   }
      // });
      cityChanged = true;
    });
  }
  var _selectedTest2;
  onChangeDropdownTests2(selectedTest) {
    print(selectedTest['keyword2'].toString() + 'llllllllllllllllllllllllllllllllllllllllll');
    setState(() {
      _selectedTest2 = selectedTest;
      noAccType = false;
      selectedTest['no'] == 0?
      userType = null: null;
      accType =selectedTest['keyword'];
    });
  }

  var _selectedTest3;
  onChangeDropdownTests3(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = null;
      cityi = null;
      countryChanged  = true;
      Logging.theUser!.country = selectedTest['keyword'];
      _selectedTest3 = selectedTest;
      city = 'اختيار المدينة';
      _dropdownTestItems.clear();
      citilist.clear();
      getid.forEach((key, value) {
        if(value == Logging.theUser!.country){
          print(key.toString()+ 'first country id');
        }
      });
    });

  }
  var _selectedTest4;

  onChangeDropdownTests4(selectedTest) {
    print(selectedTest);
    setState(() {
      print('the selected nationality number is :' + selectedTest['no'].toString());
      countryChanged = true;
      _selectedTest4 = selectedTest;
      nationality = selectedTest['keyword'];
      selectedTest['no'] == 0?{ _selectedTest4 = null, nationalityId = null}: {
        nationalityId = idsnationality.elementAt(selectedTest['no']-1),
        print('the id nationality number is :' +nationalityId.toString()),
      };
      nationalityWarn = false;

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
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getUser = fetchUsers(userToken);

      });
    });

   // countries = fetCountries();
  //  _dropdownTestItems = buildDropdownTestItems(citilist);
    _dropdownTestItems3 = buildDropdownTestItems(countrylist);
    _dropdownTestItems2 = buildDropdownTestItems(accTpeList);
   // _dropdownTestItems4 = buildDropdownTestItems(nationalitylist);
    _dropdownTestItems5 = buildDropdownTestItems(areaslist);
    areas = fetAreas(194);
    cityIdfrom != null?
    cities = fetCities(cityIdfrom!):null;
    super.initState();
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

    // getid.forEach((key, value) {
    //   if(value == Logging.theUser!.country){
    //     print(key.toString()+ 'country id');
    //     cities = fetCities(key+1);
    //   }
    // });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('المعلومات الشخصية', context),
        body: SingleChildScrollView(
          child: FutureBuilder<UserProfile>(
            future: getUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || nationalitydone == false|| areadone == false) {
                return (!isConnectSection) ?
                Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 150.h),
                      child: SizedBox(
                          height: 300.h,
                          width: 250.w,
                          child: internetConnection(
                              context, reload: () {
                            setState(() {
                              getUser =
                                  fetchUsers(userToken);
                              isConnectSection = true;
                            });
                          })),
                    ))
                    : Center(child: mainLoad(context));
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  if (!isConnectSection) {
                    return Center(
                        child: Padding(
                          padding:  EdgeInsets.only(top: 150.h),
                          child: SizedBox(
                              height: 300.h,
                              width: 250.w,
                              child: internetConnection(
                                  context, reload: () {
                                setState(() {
                                  getUser = fetchUsers(userToken);
                                  isConnectSection = true;
                                });
                              })),
                        ));
                  } else {
                    if (!serverExceptions) {
                      return Container(
                        height: getSize(context).height/1.5,
                        child: Center(
                          child: checkServerException(context)
                        ),
                      );}else{
                      if (!timeoutExceptionn) {
                        return Center(
                          child: checkTimeOutException(context, reload: (){ setState(() {
                            getUser = fetchUsers(userToken);});}),
                        );}
                    }
                    return const Center(
                        child: Text(
                            'حدث خطا ما اثناء استرجاع البيانات'));
                  }
                  //---------------------------------------------------------------------------
                } else if (snapshot.hasData) {
                  int number;
                  helper ==0?{
                    name.text = snapshot.data!.data!.user!.name!,
                    email.text = snapshot.data!.data!.user!.email!,
                    snapshot.data!.data!.user!.phonenumber! != ""?{
                      number =
                          snapshot.data!.data!.user!.phonenumber!.length - 9,
                      phone.text =
                          snapshot.data!.data!.user!.phonenumber!.substring(number),}:
                    phone.text =
                    snapshot.data!.data!.user!.phonenumber!,
                    snapshot.data!.data!.user!.userType != null? {
                      userType =  snapshot.data!.data!.user!.userType!,
                      accType =snapshot.data!.data!.user!.userType! == 'person'? 'فرد': 'مؤسسة/ شركة'
                    }: null,
                    password.text = "********",
                    snapshot.data!.data!.user!.country != null
                        ? { country =snapshot.data!.data!.user!.country!.name!,
                      getid.forEach((key, value) {
                        if (value == snapshot.data!.data!
                            .user!.country!.name!) {
                          countryi =key+1;
                          print('country in build ============================ ' + (key +1).toString());
                        }
                      })
                    } : '',
                  snapshot.data!.data!.user!.city != null? {
                      city = snapshot.data!.data!.user!.city!.name.toString(),
                  citychosen = false,
                    cityi =snapshot.data!.data!.user!.city!.id!}
                        : city = 'اختيار المدينة',
                  snapshot.data!.data!.user!.area != null?{
                      area = snapshot.data!.data!.user!.area!.name!,
                    areaId = snapshot.data!.data!.user!.area!.id,
                  // cities = fetCities(areaId!),
                  }:null,
                    snapshot.data!.data!.user!.nationality != null?{
                      nationality = snapshot.data!.data!.user!.nationality!.nationalityy_ar!,
                      nationalityId = snapshot.data!.data!.user!.nationality!.id,
                    }:null,


                    helper =1,
                  }:null;


                  return Container(
                    child: Form(
                      key: _formKey,
                      child: paddingg(
                        12,
                        12,
                        5,
                        Column(
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
                                    context, 'الاسم', textFieldSize, false, name,
                                        (String? value) {
                                          String pattern = r'^[\u0621-\u064A\u0660-\u0669 ]+$';
                                          RegExp regExp =  RegExp(pattern);
                                          if (value == null || value.isEmpty) {
                                            return 'حقل اجباري';
                                          }else{
                                            if (regExp.hasMatch(value)==false) {
                                              return "يجب ان يكون الاسم باللغة العربية";
                                            }
                                          }
                                          return null;

                                    }, false),
                              ),
                              paddingg(
                                15,
                                15,
                                12,
                                textFieldNoIcon(context, 'البريد الالكتروني',
                                    textFieldSize, false, email, (String? value) {
                                      if (value == null || value.isEmpty) {}
                                      return null;
                                    }, false, disable: false),
                              ),

                              paddingg(
                                15,
                                15,
                                12,
                                textFieldPassword(context, 'كلمة المرور', textFieldSize,
                                    hidden, password, (String? value) {
                                      if (value == null || value.isEmpty) {}
                                      return null;
                                    }, false, child: IconButton(icon: Icon(Icons.edit, color:  black,),onPressed: (){ setState(() {
                                      editPassword = !editPassword;
                                    });},)),
                              ),
                              // paddingg(
                              //   15,
                              //   15,
                              //   12,
                              //   textFieldPassword2(
                              //       context,
                              //       'اعادة ضبط كلمة المرور ',
                              //       14,
                              //       hidden2,
                              //       repassword, (String? value) {
                              //     if (value == null || value.isEmpty) {}
                              //     return null;
                              //   }, false),
                              // ),

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
                                        currentPassword, (String? value) {
                                        if (value == null ||
                                            value.isEmpty) {}
                                        return null;
                                      }, false, ),
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
                                            return "يجب ان تحتوي كلمة المرور علي حرف صغير , كبير، رقم ورمز";
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
                                            errorStyle: TextStyle(fontSize: textFieldSize.sp),
                                            helperStyle: TextStyle(
                                                color: pink, fontSize: textFieldSize.sp, fontFamily: 'Cairo'),
                                            hintStyle: TextStyle(
                                                color: grey, fontSize: textFieldSize.sp, fontFamily: 'Cairo', decoration:  TextDecoration.none),
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
                                            return "يجب ان تحتوي كلمة المرور علي حرف صغير , كبير، رقم ورمز";
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
                                            errorStyle: TextStyle(fontSize: textFieldSize.sp),
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
                                      errorStyle: TextStyle(fontSize: 12.sp),
                                      helperStyle: TextStyle(
                                          color: pink, fontSize: textFieldSize.sp, fontFamily: 'Cairo'),
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

                              //===========dropdown lists ==================

                              // FutureBuilder(
                              //     future: countries,
                              //     builder: ((context,
                              //         AsyncSnapshot<CountryL> snapshot) {
                              //       if (snapshot.connectionState ==
                              //           ConnectionState.waiting) {
                              //         return Center();
                              //       } else if (snapshot.connectionState ==
                              //           ConnectionState.active ||
                              //           snapshot.connectionState ==
                              //               ConnectionState.done) {
                              //         if (snapshot.hasError) {
                              //           return Center();
                              //           //---------------------------------------------------------------------------
                              //         } else if (snapshot.hasData) {
                              //           _dropdownTestItems3.isEmpty
                              //               ? {
                              //             countrylist.add({
                              //               'no': 0,
                              //               'keyword': 'الدولة'
                              //             }),
                              //             for (int i = 0;
                              //             i <
                              //                 snapshot
                              //                     .data!.data!.length;
                              //             i++)
                              //               {
                              //                 countrylist.add({
                              //                   'no': i,
                              //                   'keyword':
                              //                   '${snapshot.data!.data![i].name!}'
                              //                 }),
                              //               },
                              //             _dropdownTestItems3 =
                              //                 buildDropdownTestItems(
                              //                     countrylist),
                              //
                              //             getid.forEach((key, value) {
                              //               if(value == country){cities = fetCities(key);}
                              //             }),
                              //
                              //           }:{};
                              //           return paddingg(
                              //             15,
                              //             15,
                              //             12,
                              //             DropdownBelow(
                              //               dropdownColor: white,
                              //               itemWidth: 370.w,
                              //
                              //               ///text style inside the menu
                              //               itemTextstyle: TextStyle(
                              //                 fontSize: 12.sp,
                              //                 fontWeight: FontWeight.w400,
                              //                 color: black,
                              //                 fontFamily: 'Cairo',
                              //               ),
                              //
                              //               ///hint style
                              //               boxTextstyle: TextStyle(
                              //                   fontSize: 12.sp,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: black,
                              //                   fontFamily: 'Cairo'),
                              //
                              //               ///box style
                              //               boxPadding: EdgeInsets.fromLTRB(
                              //                   13.w, 12.h, 13.w, 12.h),
                              //               boxWidth: 500.w,
                              //               boxHeight: 45.h,
                              //               boxDecoration: BoxDecoration(
                              //                   border:  Border.all(color: newGrey, width: 0.5),
                              //                   color: lightGrey.withOpacity(0.10),
                              //                   borderRadius:
                              //                   BorderRadius.circular(8.r)),
                              //
                              //               ///Icons
                              //               icon: const Icon(
                              //                 Icons.arrow_drop_down,
                              //                 color: Colors.grey,
                              //               ),
                              //               hint: Text(
                              //                 country,
                              //                 textDirection: TextDirection.rtl,
                              //               ),
                              //               value: _selectedTest3,
                              //               items: _dropdownTestItems3,
                              //               onChanged: onChangeDropdownTests3,
                              //             ),
                              //           );
                              //         } else {
                              //           return const Center(
                              //               child: Text(
                              //                   'لايوجد لينك لعرضهم حاليا'));
                              //         }
                              //       } else {
                              //         return Center(
                              //             child: Text(
                              //                 'State: ${snapshot.connectionState}'));
                              //       }
                              //     })),

                              Visibility(visible: areadone,child: Column(children: [
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
                                areawarn !=null?
                                areawarn? paddingg(
                                    0,
                                    22.w,
                                    5.h, Container(alignment: Alignment.topRight,child: text(context, 'الرجاء اختيار المنطقة', textError, red!))):SizedBox()
                                    :SizedBox(),
                              ],)),

                              Visibility(visible: citydone,child: Column(children: [
                                areaId != null ?
                                FutureBuilder(
                                    future: cities,
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
                                                city,
                                                textDirection: TextDirection.rtl,
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
                                        return Center();
                                        //   child: Text(
                                        // 'State: ${snapshot.connectionState}'));
                                      }
                                    })):SizedBox(),

                                areaId != null && areaId != 0?
                                citychosen == true && (cityi == null || cityi == 0)?
                                Padding(
                                    padding:  EdgeInsets.only(right: 22.0.w, top: 5.h),
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: text(
                                          context, 'الرجاء تحديد المدينة', textError, red!),
                                    ))
                                    : SizedBox():SizedBox(),
                              ],)),

                              Visibility( visible:nationalitydone,child: Column(children: [
                                FutureBuilder(
                                    future: nationalities,
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
                                            icon: _dropdownTestItems4.isEmpty?Container(
                                                height: 15.h,width:20.w,child: CircularProgressIndicator(color: grey,strokeWidth: 1.5.w,)): const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.grey,
                                            ),
                                            hint: Text(
                                              nationality,
                                              textDirection: TextDirection
                                                  .rtl,
                                            ),
                                            value: _selectedTest4,
                                            items: _dropdownTestItems4,
                                            onChanged: onChangeDropdownTests4,
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
                                                nationality,
                                                textDirection: TextDirection
                                                    .rtl,
                                              ),
                                              value: _selectedTest4,
                                              items: _dropdownTestItems4,
                                              onChanged: onChangeDropdownTests4,
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
                                    })),
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

                              Visibility(visible:typedone,child: Column(children: [
                                paddingg(
                                            15,
                                            15,
                                            12,
                                            DropdownBelow(
                                              dropdownColor: white,
                                              itemWidth: 370.w,

                                              ///text style inside the menu
                                              itemTextstyle: TextStyle(
                                                fontSize:textFieldSize.sp,
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
                                                  13.w, 12.h, 13.w, 12.h),
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
                                                accType,
                                                textDirection: TextDirection.rtl,
                                              ),
                                              value: _selectedTest2,
                                              items: _dropdownTestItems2,
                                              onChanged: onChangeDropdownTests2,
                                            ),
                                          ),


                                noAccType !=null?
                                noAccType!? paddingg(
                                    0,
                                    22.w,
                                    5.h, Container(alignment: Alignment.topRight,child: text(context, 'يجب تديد نوع الحساب', textError, red!))):SizedBox()
                                    :SizedBox(),
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
                                    }
                                    if (value != null) {
                                      if (value.isNotEmpty) {
                                        if (value.length != 9) {
                                          return "رقم الجوال يجب ان يتكون من 9 ارقام  ";
                                        }
                                        if (value.startsWith('0')) {
                                          return 'رقم الجوال يجب ان لا يبدا ب 0 ';
                                        }
                                        // if(!regExp.hasMatch(value)){
                                        //   return "رقم الجوال غير صالح";
                                        // }
                                      }
                                    }

                                    return null;
                                  }, false, child:  Container(
                                    width: 60.w,
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
                                        textStyle:  TextStyle(color: black, fontSize: textTitleSize.sp),
                                        // optional. Shows only country name and flag when popup is closed.
                                        showOnlyCountryWhenClosed: false,
                                        // optional. aligns the flag and the Text left
                                        alignLeft: true,
                                      ),
                                    ),
                                  ), ),
                              ),


                              //=========== end dropdown ==================================

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
                                      if (( currentPassword.text.isNotEmpty && newPassword.text.isNotEmpty )){
                                        _formKey2.currentState ==null?null:
                                        _formKey2.currentState!.validate()? {
                                          newPassword.text == confirmPassword.text?{ changePassword(userToken).then((value) => {
                                              value == 'SocketException' ? {
                                                Navigator.pop(context),
                                                showMassage(
                                                    context, 'فشل الاتصال بالانترنت',
                                                    socketException)
                                              } :
                                              value == 'serverException' ? {
                                                Navigator.pop(context),
                                                showMassage(
                                                  context, 'خطا', serverException,)
                                              } :
                                              value == 'TimeoutException' ? {
                                                Navigator.pop(context),
                                                showMassage(
                                                    context, 'خطا', timeoutException)
                                            }:
                                          value.contains('false')?showMassage(context, 'خطا',value.replaceAll('false', '')):showMassage(context, 'تم ',"تم التغيير بنجاح", done: done),
                                            currentPassword.clear(),
                                            newPassword.clear(),
                                            confirmPassword.clear(),
                                            setState(() {
                                              editPassword =false;
                                            })
                                          })  , updateUserInformation(userToken).whenComplete(() => fetchUsers(userToken))}: setState((){noMatch = true;})}:null;}
                                      else{
                                        _formKey.currentState!.validate() && _formKey2.currentState == null &&  (_selectedTest2 != null || userType != null
                                            && (_selectedTest4 != null || nationalityId != null))
                                            && (_selectedTest5 != null || (areaId != null && areaId != 0)) && (_selectedTest != null || cityi != null) ?

                                        {
                                          _selectedTest2 != null  && _selectedTest2['no'] != 0 ?{
                                              loadingDialogue(context),
                                          updateUserInformation(userToken)
                                              .then((value) {
                                                value.contains('true')?{
                                                  Navigator.pop(context),
                                                  countryChanged || cityChanged
                                                      ? setState(() {
                                                    helper = 0;
                                                    countryChanged =
                                                    false;
                                                    cityChanged =
                                                    false;
                                                    getUser =
                                                        fetchUsers(userToken);
                                                  })
                                                      : Navigator.pop(context),
                                                  showMassage(context, 'تم ',value.replaceAll('true', ''), done: done),
                                                  changed = true
                                                }:{
                                                  value == 'SocketException'?{
                                                  Navigator.pop(context),
                                                  showMassage(context,'فشل الاتصال بالانترنت', socketException)
                                                }: {

                                                  value == 'serverException'? {
                                                    Navigator.pop(context),
                                                    showMassage(
                                                      context, 'خطا', serverException,)
                                                  }: value == 'TimeOutException'?{
                                                    Navigator.pop(context),
                                                    showMassage(context,'فشل الاتصال بالانترنت', timeoutException)
                                                  }:{
                                        Navigator.pop(context),
                                        if(value.contains('The selected city id is invalid.')){
                                        showMassage(
                                        context, 'خطا', 'الرجاء اختيار المدينة ',)
                                        }else
                                        showMassage(
                                        context,
                                        'خطا',
                                        value.replaceAll('حدث خطا ما', value),
                                        )
                                        }
                                                  }




                                            //   setState(() {
                                            //     helper = 0;
                                            //     celebrities =
                                            //         fetchCelebrities();
                                            //   }),
                                            //   ScaffoldMessenger.of(
                                            //           context)
                                            //       .showSnackBar(
                                            //           const SnackBar(
                                            //     content: Text(
                                            //         "تم تعديل المعلومات بنجاح"),
                                            //   ))

                                          };})}
                                          :{
                                            userType != null ?
                                            {
                                              loadingDialogue(context),
                                              updateUserInformation(userToken)
                                                  .then((value) {
                                                value.contains('true')?{
                                                  Navigator.pop(context),
                                                  countryChanged || cityChanged
                                                      ? setState(() {
                                                    helper = 0;
                                                    countryChanged =
                                                    false;
                                                    cityChanged =
                                                    false;
                                                    getUser =
                                                        fetchUsers(userToken);
                                                  })
                                                      :  Navigator.pop(context),
                                                  changed = true,
                                                  showMassage(context, 'تم ',value.replaceAll('true', ''), done: done)
                                                }:{
                                                  value == 'SocketException'?{
                                                    Navigator.pop(context),
                                                    showMassage(context,'فشل الاتصال بالانترنت', socketException)
                                                  }: {

                                                    value == 'serverException'? {
                                                      Navigator.pop(context),
                                                      showMassage(
                                                        context, 'خطا', 'تاكد من البيانات المدخلة',)
                                                    }: value == 'TimeOutException'?{
                                                      Navigator.pop(context),
                                                      showMassage(context,'فشل الاتصال بالانترنت', timeoutException)
                                                    }:{
                                                      Navigator.pop(context),
                                                      if(value.contains('The selected city id is invalid.')){
                                                        showMassage(
                                                          context, 'خطا', 'الرجاء اختيار المدينة ',)
                                                      }else
                                                        //The phonenumber has already been taken
                                                        if(value.contains('The phonenumber has already been taken.')){
                                                          showMassage(
                                                            context, 'خطا', 'رقم الجوال مستخدم مسبقا ',)
                                                        }else{showMassage(
                                                          context,
                                                          'خطا',
                                                          value.replaceAll('تاكد من البيانات المدخلة', value),
                                                        )}
                                                    }
                                                  }




                                                  //   setState(() {
                                                  //     helper = 0;
                                                  //     celebrities =
                                                  //         fetchCelebrities();
                                                  //   }),
                                                  //   ScaffoldMessenger.of(
                                                  //           context)
                                                  //       .showSnackBar(
                                                  //           const SnackBar(
                                                  //     content: Text(
                                                  //         "تم تعديل المعلومات بنجاح"),
                                                  //   ))

                                                };})}:
                                            setState(() {
                                          noAccType = true;
                                        nationalityId == null? nationalityWarn = true:null;
                                          // citychosen==false? citychosen = true: null;
                                          _selectedTest5 == null &&(areaId == null || areaId == 0)? areawarn = true:null;
                                          _selectedTest == null && cityi == null? citychosen = true:null;
                                        },)}}
                                          : setState(() {
                                          (_selectedTest2 == null  || _selectedTest2['no'] == 0 ) && userType == null? noAccType = true:null;
                                          nationalityId == null? nationalityWarn = true:null;
                                          // citychosen==false? citychosen = true: null;
                                          // noAccType = true;
                                          _selectedTest5 == null &&(areaId == null || areaId == 0)? areawarn = true:null;
                                          _selectedTest == null && cityi == null? citychosen = true:null;
                                        },);};
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
    );
  }

  Future<CountryL> fetCountries() async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/countries'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        for (int i = 0; i < jsonDecode(response.body)['data'].length; i++) {
          setState(() {
            getid.putIfAbsent(
                i, () => jsonDecode(response.body)['data'][i]['name']);
          });
        }

        return CountryL.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          noint = true;
        });
        return Future.error('SocketException');
      }else {
        return Future.error('serverExceptions');
      }
    }
  }

  Future<CityL> fetCities(int areaIdd) async {
    print(areaIdd.toString() + 'in the method .................');
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/cities/$areaIdd'),
      );
      int l;
      if (response.statusCode == 200) {
        _dropdownTestItems.isEmpty
            ? {
          l = citilist.length,
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
        print(countryId.toString() + 'in the city get');
        throw Exception('Failed to load activity');
      }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          noint = true;
        });
        return Future.error('SocketException');
      }else {
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
  Future<UserProfile> fetchUsers(String token) async {

    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/user/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        setState(() {
          nationalities = fetNationalities();
        });
        Logging.theUser = new TheUser();
        Logging.theUser!.name =
        jsonDecode(response.body)["data"]?["user"]['name'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['name'];
        Logging.theUser!.email =
        jsonDecode(response.body)["data"]?["user"]['email'];
        Logging.theUser!.id =
            jsonDecode(response.body)["data"]?["user"]['id'].toString();
        Logging.theUser!.phone =
        jsonDecode(response.body)["data"]?["user"]['phonenumber'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['phonenumber'].toString();
        Logging.theUser!.image =
        jsonDecode(response.body)["data"]?["user"]['image'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['image'];
        Logging.theUser!.country =
        jsonDecode(response.body)["data"]?["user"]['country'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['country']['name'];
        print(response.body);
        return UserProfile.fromJson(jsonDecode(response.body));
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
          timeoutExceptionn = false;
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

  Widget textFieldPassword(
      context,
      String keyy,
      double fontSize,
      bool hintPass,
      TextEditingController mycontroller,
      myvali,
      isOptional,
      {
        IconButton? child
      }) {
    return TextFormField(
      obscureText: hintPass ? true : false,
      validator: myvali,
      controller: mycontroller,
      style:
      TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius:BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: newGrey,
              width: 0.5,
            ),),
          isDense: false,
          filled: true,
          suffixIcon: child,
          helperText: isOptional ? 'اختياري' : null,
          helperStyle: TextStyle(
              color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: lightGrey.withOpacity(0.10),
          labelStyle: TextStyle(color: white, fontSize: fontSize.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: purple, width: 1)),
          // suffixIcon: hidden
          //     ? IconButton(
          //         onPressed: () {
          //           setState(() {
          //             hidden = false;
          //           });
          //         },
          //         icon: Icon(
          //           hide,
          //           color: lightGrey,
          //         ))
          //     : IconButton(
          //         onPressed: () {
          //           setState(() {
          //             hidden = true;
          //           });
          //         },
          //         icon: Icon(show, color: lightGrey)),
          hintText: keyy,
          contentPadding: EdgeInsets.all(10.h)),
    );
  }

  Future<String> updateUserInformation(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/user/profile/update',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken'
        },
        body: jsonEncode(<String, dynamic>{
          'name': name.text,
          'email': email.text,
          'user_type': _selectedTest2 == null? userType: _selectedTest2['keyword2'],
          'password': password.text,
          'phonenumber':phone.text.isEmpty?'' :'+966'+phone.text,
          'country_id':1,
          'city_id': _selectedTest == null ? cityi : _selectedTest['no'],
          'area_id': _selectedTest5 ==null? areaId : _selectedTest5['no'],
          'nationality_id' : nationalityId
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        if(jsonDecode(response.body)['success'] == true){
          return jsonDecode(response.body)['message']['ar'] +  jsonDecode(response.body)['success'].toString()  ;

        }else{
          return jsonDecode(response.body)['message']['en']['phonenumber'][0] +  jsonDecode(response.body)['success'].toString();
        }
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
  Future<Nationality> fetNationalities() async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/countries'),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        // nationalitylist.add({
        //   'no': 0,
        //   'keyword':
        //   'اختيار الجنسية'
        // });
        _dropdownTestItems4.isEmpty?{
        _dropdownTestItems4.add(buildDropdownTestItems2({
          'no': 0,
          'keyword':
          'اختيار الجنسية'
        })),
        for (int i =0; i < jsonDecode(response.body)['data'].length; i++) {
          // print(jsonDecode(response.body)['data'][i]['country_arNationality']);
          setState(() {
              // nationalitylist.add({
              //   'no': i,
              //   'keyword':jsonDecode(response.body)['data'][i]['country_arNationality'],
              // });
              _dropdownTestItems4.add(buildDropdownTestItems2({
                'no':jsonDecode(response.body)['data'][i]['id'],
                'keyword':jsonDecode(response.body)['data'][i]['country_arNationality'],
              }));
            idsnationality.add(jsonDecode(response.body)['data'][i]['id']);
            // getid.putIfAbsent(
            //     i, () => jsonDecode(response.body)['data'][i]['country_arNationality']);
          }),
        }}:null;
        // _dropdownTestItems4 =
        //     buildDropdownTestItems(
        //         nationalitylist);
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
  Future<String> changePassword(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/user/password/change',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
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
        return jsonDecode(response.body)['message']['ar'] + jsonDecode(response.body)['success'].toString();
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
  Widget textFieldPassword2(
      context,
      String key,
      double fontSize,
      bool hintPass,
      TextEditingController mycontroller,
      myvali,
      isOptional,
      ) {
    return TextFormField(
      obscureText: hintPass ? true : false,
      validator: myvali,
      controller: mycontroller,
      style:
      TextStyle(color: white, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          helperText: isOptional ? 'اختياري' : null,
          helperStyle: TextStyle(
              color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: textFieldBlack2.withOpacity(0.70),
          labelStyle: TextStyle(color: white, fontSize: fontSize.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: pink, width: 1)),
          suffixIcon: hidden2
              ? IconButton(
              onPressed: () {
                setState(() {
                  hidden2 = false;
                });
              },
              icon: Icon(
                hide,
                color: lightGrey,
              ))
              : IconButton(
              onPressed: () {
                setState(() {
                  hidden2 = true;
                });
              },
              icon: Icon(show, color: lightGrey)),
          hintText: key,
          contentPadding: EdgeInsets.all(10.h)),
    );
  }
}
