import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import "package:flutter/material.dart";
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hand_signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import '../Celebrity/Requests/GenerateContract.dart';
import 'LoggingSingUpAPI.dart';
import 'UserForm.dart';
import 'VerifyUser.dart';
import 'dart:io';
import 'dart:typed_data';

class SingUp extends StatefulWidget {
  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  TextEditingController flutterPwValidatorController = TextEditingController();
  Uint8List? bytes;
  bool showPwValidator = false;
  bool isSusses=false;
  bool isChckid = false;
  ByteData? png;
  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  int help = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  GlobalKey<FormState> singUpKey = GlobalKey();
  GlobalKey<FormState> userKey = GlobalKey();
  GlobalKey<FormState> celebratyKey = GlobalKey();
  TextEditingController phoneController = TextEditingController();
  TextEditingController celPhoneController = TextEditingController();

  int userContry = 0,
      celNationality = 0,
      celNationalityId = 0,
      celArea = 0,
      celAreaId = 0,
      celCity = 0,
      celCityId = 0,
      celCatogary = 0;

  int userNationality = 0,
      userNationalityId = 0,
      userArea = 0,
      userAreaId = 0,
      userCity = 0,
      userCityId = 0,
      userCatogary = 0;

  bool isVisibility = true;
  bool isVisibilityNew = true;
  bool? isChang = false;
  String? facebookUserId;
  List<String> nationality = [];
  List<String> areas = [];
  List<int> areasId = [];
  List<String> cities = [];
  List<int> citiesId = [];
  List<String> celebrityCategories = [];
  List<int> nationalityId = [];
  late Image image1;
  String? getEmail;
  bool celShowCity = false;
  bool userShowCity = false;
  String? celCityNameValue;
  String? userCityNameValue;
  Map<String, dynamic>? _userData;
  bool _checking = false;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    image1 = Image.asset("assets/image/singup.jpg");
    celArea = 1;
    fetCelebrityCategories();
    fetNationality();
    fetAreas();
    fetCities(celArea);

    //_checkIfIsLoggedInFacebook();
  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

//getNationality--------------------------------------------------------------------
  fetNationality() async {
    String serverUrl = 'https://mobile.celebrityads.net/api';
    String url = "$serverUrl/countries";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (int i = 0; i < body['data'].length; i++) {
        if (mounted) {
          setState(() {
            nationality.add(body['data'][i]['country_arNationality']);
            nationalityId.add(body['data'][i]['id']);
          });
        }
      }
      print('name Nationality: ${nationality[3]}');
      print('nationality id is:${nationalityId[3]}');
      return nationality;
    } else {
      throw Exception('Failed to load  nationality');
    }
  }

//getAreas--------------------------------------------------------------------
  fetAreas() async {
    String serverUrl = 'https://mobile.celebrityads.net/api/areas/1';
    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (int i = 0; i < body['data'].length; i++) {
        if (mounted) {
          setState(() {
            areas.add(body['data'][i]['name']);
            areasId.add(body['data'][i]['id']);
          });
        }
      }
      print(
          '**************************************************************************************');
      print('Areas name: ${areas}');
      print('Areas id: ${areasId}');
      print(
          '**************************************************************************************');

      return areas;
    } else {
      throw Exception('Failed to load  areas');
    }
  }

//getCities--------------------------------------------------------------------
  fetCities(celArea) async {
    String serverUrl = 'https://mobile.celebrityads.net/api/cities/$celArea';
    final response = await http.get(Uri.parse(serverUrl));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (int i = 0; i < body['data'].length; i++) {
        if (mounted) {
          setState(() {
            cities.add(body['data'][i]['name']);
            citiesId.add(body['data'][i]['id']);
          });
        }
      }
      // print('Cities area: ${cities[3]}');
      print('Cities id is: ${citiesId}');
      return cities;
    } else {
      throw Exception('Failed to load  Cities');
    }
  }

  //get celebrity Categories--------------------------------------------------------------------
  fetCelebrityCategories() async {
    String serverUrl = 'https://mobile.celebrityads.net/api';
    String url = "$serverUrl/categories";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      for (int i = 0; i < body['data'].length; i++) {
        if (mounted) {
          setState(() {
            celebrityCategories.add(body['data'][i]['name']);
          });
        }
      }
      // print(celebrityCategories);

      return celebrityCategories;
    } else {
      throw Exception('Failed to load celebrity catogary');
    }
  }

//--------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
//main container--------------------------------------------------
            body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          // decoration: BoxDecoration(
          //     color: Colors.black,
          //     image: DecorationImage(
          //         image: image1.image,
          //         colorFilter: ColorFilter.mode(
          //             Colors.black.withOpacity(0.7), BlendMode.darken),
          //         fit: BoxFit.cover)),
          child:
//==============================container===============================================================

              SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 80.h),
                //logo---------------------------------------------------------------------------
                SizedBox(
                  height: 140.h,
                  //color: red,
                  child: Image.asset(
                    logo,
                    fit: BoxFit.cover,
                    height: 120.h,
                    width: 300.w,
                  ),
                ),
//استمتع يالتواصل--------------------------------------------------
                // text(context, "مرحبا بك في منصة المشاهير", 20, Colors.black87),
//انشاء حساب--------------------------------------------------
                text(context, "إنشئ حسابك الآن", textHeadSize, Colors.black87),
                SizedBox(
                  height: 22.h,
                ),
//==============================buttoms===============================================================

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
//famous buttom-------------------------------------
                      gradientContainer(
                          140,
                          buttoms(
                            context,
                            'مستخدم',
                            textFieldSize,
                            isChang == false ? Colors.white : Colors.black87,
                            () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                isChang = false;
                              });
                              // print("follower$isChang");
                            },
                          ),
                          gradient: isChang! ? true : false,
                          color: isChang == false
                              ? Colors.transparent
                              : Colors.black87),
                      SizedBox(
                        width: 21.w,
                      ),
//follower buttom-------------------------------------

                      gradientContainer(
                          140,
                          buttoms(
                            context,
                            'مشهور',
                            textFieldSize,
                            isChang! ? Colors.white : Colors.black87,
                            () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                isChang = true;
                              });
                              print("famous$isChang");
                            },
                          ),
                          gradient: isChang! ? false : true,
                          color:
                              isChang! ? Colors.transparent : Colors.black87),
                    ],
                  ),
                ),

                SizedBox(
                  height: 30.h,
                ),
//=============================================================================================
                padding(
                    20,
                    20,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
//====================================TextFields=========================================================
                        isChang!
                            ? celebratyForm(
                                context,
                                nationality,
                                nationalityId,
                                areas,
                                areasId,
                                cities,
                                citiesId,
                                celebrityCategories)
                            : userForm(context, nationality, nationalityId,
                                areas, areasId, cities, citiesId),
                        gradientContainer(
                            347,
                            buttoms(
                              context,
                              'انشاء حساب',
                              SmallbuttomSize,
                              white,
                              () {
                                print('userCity in register: $userCity');
                                FocusManager.instance.primaryFocus?.unfocus();
                                isChang == true
                                    ?
                                    //create famous account------------------------------
                                    celebrityRegister(
                                        userNameCeleController.text,
                                        emailCeleController.text,
                                        passCeleController.text,
                                        '$celNationality',
                                        '$celCatogary',
                                        '$celArea',
                                        '$celCity',
                                        '+966' + celPhoneController.text)
                                    :
                                    //create user account------------------------------
                                    userRegister(
                                        userNameUserController.text,
                                        emailUserController.text,
                                        passUserController.text,
                                        '$userContry',
                                        '$userNationality',
                                        '$userArea',
                                        '$userCity',
                                        '+966' + phoneController.text);
                              },
                            ),
                            color: Colors.transparent),
//signup with text-----------------------------------------------------------
                        SizedBox(
                          height: 14.h,
                        ),
                        registerVi(),
                        //signup with bottom----------------------------------------------------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //google buttom-----------------------------------------------------------
                            singWithsButtom(
                                context, "تسجيل دخول بجوجل", black, white, () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              singViGoogle();
                            }, googelImage),
                            SizedBox(
                              width: 30.h,
                            ),
//facebook buttom-----------------------------------------------------------
                            singWithsButtom(
                                context, "تسجيل دخول فيسبوك", white, darkBlue,
                                () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // _checking == false
                              //     ?
                              _login();
                              // : failureDialog(
                              //     context,
                              //     'إنشاء حساب عبر فيسبوك',
                              //     'لقد قمت بتسجيل الدخول مسبقا عن طريق فيسبوك.هل تريد تسجيل الخروج؟',
                              //     "assets/lottie/Failuer.json",
                              //     'تسجيل الخروج', () {
                              //     Navigator.pop(context);
                              //     _logout();
                              //   }, height: 180.h);
                            }, facebookImage),
                          ],
                        ),
                        SizedBox(
                          height: 27.h,
                        ),
//have Account buttom-----------------------------------------------------------
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                text(context, "هل لديك حساب بالفعل؟",
                                    textTitleSize, Colors.black87),
                                SizedBox(
                                  width: 7.w,
                                ),
                                InkWell(
                                  child: text(context, "تسجيل الدخول",
                                      textTitleSize, Colors.grey),
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    goTopageReplacement(context, Logging());
                                    clearUserTextField();
                                    clearCelebrityTextField();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 27.h,
                        ),
//----------------------------------------------------------------------------------------------------------------------
                      ],
                    ))
              ],
            ),
          ),
        )));
  }

  //----------------------------------------------------------------------------------------------------------------------
  celebrityRegister(
      String username,
      String email,
      String pass,
      String nationality,
      String catogary,
      String areaId,
      String cityId,
      String phoneNumber) async {
    if (celebratyKey.currentState?.validate() == true &&
        celCityNameValue != null) {
      print('fffffffffff');
      showContract(username, pass, email, nationality, catogary, areaId, cityId,
          phoneNumber);
    } else {
      if (celCityNameValue == null && celShowCity) {
        showMassage(context, 'بيانات فارغة', 'اختر المدينة');
      }
    }
  }

//------------------------------------------------------------------------------
  userRegister(String username, String email, String pass, String country,
      String nationalityId, String areaId, String cityId, String phoneNumber) {
    if (userKey.currentState?.validate() == true &&
        (userCityNameValue != null)) {
      loadingDialogue(context);
      databaseHelper
          .userRegister(username, pass, email, country, nationalityId, areaId,
              cityId, phoneNumber)
          .then((result) {
        print('///////////////////////////////////////////');
        print('cityId in userRegister: $cityId');
        print(result);
        print('///////////////////////////////////////////');
        if (result == "SocketException") {
          Navigator.pop(context);
          showMassage(context, 'مشكلة في الانترنت', socketException);
        } else if (result == "TimeoutException") {
          Navigator.pop(context);
          showMassage(context, 'مشكلة في الخادم', timeoutException);
        } else if (result == "user") {
          Navigator.pop(context);
          FocusManager.instance.primaryFocus?.unfocus();
          DatabaseHelper.saveRememberUserEmail(email);
          DatabaseHelper.saveRememberUser("user");
          goTopagepush(
              context,
              VerifyUser(
                username: email.trim(),
              ));
          setState(() {
            clearCelebrityTextField();
            clearUserTextField();
            isChang = !isChang!;
          });
          // clearUserTextField();
        } else if (result == "email and username found") {
          Navigator.pop(context);
          showMassage(context, 'بيانات مكررة',
              'البريد الالكتروني واسم المستخدم موجود مسبقا');
        } else if (result == "username found") {
          Navigator.pop(context);
          showMassage(context, 'بيانات مكررة', 'اسم المستخدم موجود مسبقا');
        } else if (result == 'email found') {
          Navigator.pop(context);
          showMassage(context, 'بيانات مكررة', 'البريد الالكتروني موجود مسبقا');
        } else if (result == "The phonenumber has already been taken.") {
          Navigator.pop(context);
          showMassage(context, 'بيانات مكررة', 'رقم الجوال مستخدم مسبقا');
        } else if (result.contains("The email format is incorrect.")) {
          Navigator.pop(context);
          showMassage(
              context, 'بيانات خاطئة', 'فضلا تاكد من صحة البريد الالكتروني');
        } else {
          Navigator.pop(context);
          showMassage(context, 'مشكلة في الخادم', serverException);
        }
      });
    } else {
      if (userCityNameValue == null && userShowCity) {
        showMassage(context, 'بيانات فارغة', 'اختر المدينة');
      }
    }
  }

//--------------------------------------------------------------------------------------
  Widget registerVi() {
    return SizedBox(
        width: double.infinity,
        height: 70.h,
        child: Row(children: <Widget>[
          const Expanded(
              child: Divider(
            color: Colors.grey,
            thickness: 1.3,
          )),
          SizedBox(
            width: 8.w,
          ),
          Center(
            child: text(
              context,
              "او التسجيل من خلال",
              14,
              Colors.black87,
              align: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          const Expanded(
              child: Divider(
            color: Colors.grey,
            thickness: 1.3,
          )),
        ]));
  }

  void clearCelebrityTextField() {
    FocusManager.instance.primaryFocus?.unfocus();
    userNameCeleController.clear();
    emailCeleController.clear();
    passCeleController.clear();
    celPhoneController.clear();
  }

  void clearUserTextField() {
    FocusManager.instance.primaryFocus?.unfocus();
    userNameUserController.clear();
    emailUserController.clear();
    passUserController.clear();
    phoneController.clear();
  }

  Future singViGoogle() async {
    final user = await GoogleSignIn().signIn();

    if (user != null) {
      print('///////////////////////////////////////////////////');
      print(user.email);
      DatabaseHelper.saveGoogleAccessUserEmail(user.email);
      isChang!
          ? emailCeleController.text = user.email
          : emailUserController.text = user.email;
      GoogleSignIn().disconnect();
      print('///////////////////////////////////////////////////');
    }

    //
  }

  _login() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile']);
    print(
        'loging redult ${result.message}-------------------------------------------------');
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      DatabaseHelper.saveFacebookAccessUserEmail(userData['email']);
      _userData = userData;
      isChang!
          ? emailCeleController.text = userData['email']
          : emailUserController.text = userData['email'];
      FacebookAuth.i.logOut();
    } else if (result.status == LoginStatus.cancelled) {
      print('operation cancel');
    } else if (result.status == LoginStatus.failed) {
      print('operation failed');
    }
  }

//=========================================================
  userForm(
      context,
      List<String> nationalityList,
      List<int> nationalityListId,
      List<String> areaList,
      List<int> areaListId,
      List<String> citesList,
      List<int> citesListId) {
    return Form(
      key: userKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//name------------------------------------------
        textField(
          context,
          nameIcon,
          "اسم المستخدم",
          textFieldSize,
          false,
          userNameUserController,
          userName,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[_]|[0-9]'),
                allow: true)
          ],
        ),
        SizedBox(
          height: 15.h,
        ),

//email------------------------------------------
        textField(
          context,
          emailIcon,
          "البريد الالكتروني",
          textFieldSize,
          false,
          emailUserController,
          valedEmile,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [
            FilteringTextInputFormatter(
                RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]|[-]'),
                allow: true)
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
//pass------------------------------------------
        FocusScope(
          child: Focus(
            onFocusChange: (focus) {
              setState(() {
                showPwValidator = false;
              });
              print('--------------------------------');
              print('focus:$focus');
              print('--------------------------------');
              if (focus && isSusses == false) {
                setState(() {
                  showPwValidator = true;
                });
              } else if (focus == false && isSusses == true) {
                setState(() {
                  showPwValidator = false;
                });
              } else if (focus == false) {
                setState(() {
                  showPwValidator = false;
                });
              }else{
                setState(() {
                  showPwValidator = false;
                });
              }
            },
            child: textField3(
              context,
              Icons.lock,
              "كلمة المرور",
              textFieldSize,
              isVisibilityNew,
              passUserController,
              (s) {
                if (s.isEmpty) {
                  return 'حقل اجباري';
                }
                if (isSusses == false) {
                  return 'عليك اختيار كلمة مرور مطابقة للشروط';
                } else {
                  return null;
                }
              },
              // colorBorder: isSusses == false &&
              //         passUserController.text.isNotEmpty &&
              //         showPwValidator
              //     ? red!
              //     : null,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter(
                    RegExp(r'[a-zA-Z]|[0-9]|[-_!%*&^$#?@]'),
                    allow: true)
              ],
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isVisibilityNew = !isVisibilityNew;
                  });
                },
                icon: Icon(
                    isVisibilityNew ? Icons.visibility : Icons.visibility_off,
                    color: newGrey,
                    size: 25.sp),
              ),
            ),
          ),
        ),
        Visibility(
          visible: showPwValidator,
          child: SizedBox(
            height: 10.h,
          ),
        ),
        Visibility(
          visible: showPwValidator,
          child: FlutterPwValidator(
            controller: passUserController,
           // defaultColor: textGray,
            minLength: 8,
            uppercaseCharCount: 1,
            numericCharCount: 1,
            specialCharCount: 1,
            normalCharCount: 5,
            failureColor: red!,
            successColor: green,
            width: 400.w,
            height: 200.h,
            onSuccess: () {
              setState(() {
                showPwValidator = false;
                isSusses = true;
              });
            },
            onFail: () {
              setState(() {
                showPwValidator = true;
                isSusses = false;
              });
            },
            strings: PasswordValidatorStrings(),
          ),
        ),

        SizedBox(
          height: 15.h,
        ),

//phone number==================================================================================
        textField3(context, Icons.phone_android_rounded, "رقم الجوال",
            textFieldSize, false, phoneController, valedphone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true)
            ],
            suffixText: '966+'),

        // textField3(context, passIcon, "كلمة المرور", 14, true, passUserController,
        //     valedpass,),
        SizedBox(
          height: 15.h,
        ),

//Area------------------------------------------
        drowMenu("المنطقة", Icons.home_work_rounded, textFieldSize, areaList,
            (va) {
          userAreaId = areaList.indexOf(va!);
          userArea = areaListId.elementAt(userAreaId);
          citesList.clear();
          citesListId.clear();
          fetCities(userArea);
          setState(() {
            userShowCity = true;
            userCityNameValue = null;
            celCityNameValue = null;
          });
          print('Area name: $va');
          print('id: $userArea');
        }, (val) {
          if (val == null) {
            return "اختر المنطقة";
          } else {
            return null;
          }
        }),
        SizedBox(
          height: 15.h,
        ),
//city------------------------------------------
        Visibility(
          visible: userShowCity,
          child: drowMenu(
              "المدينة", Icons.location_city_sharp, textFieldSize, citesList,
              (va) {
            userCityId = citesList.indexOf(va!);
            userCity = citesListId.elementAt(userCityId);
            setState(() {
              userCityNameValue = va;
            });
            print('city name: $userCityNameValue');
            print('id: $userCity');
          }, (val) {
            // if (val == null) {
            //   return "اختر المدينة";
            // } else {
            //   return null;
            // }
          }, valueItem: userCityNameValue),
        ),
        Visibility(
          visible: userShowCity,
          child: SizedBox(
            height: 15.h,
          ),
        ),
//Nationality------------------------------------------
        drowMenu("الجنسية", nationalityIcon, textFieldSize, nationalityList,
            (va) {
          userNationalityId = nationalityList.indexOf(va!);
          userNationality = nationalityListId.elementAt(userNationalityId);
          print('Nationality name: $va');
          print('id: $userNationality');
        }, (val) {
          if (val == null) {
            return "اختر الجنسية";
          } else {
            return null;
          }
        }),
        SizedBox(
          height: 15.h,
        ),
      ]),
    );
  }
//=========================================================

  celebratyForm(
      context,
      List<String> nationalityList,
      List<int> nationalityListId,
      List<String> areaList,
      List<int> areaListId,
      List<String> citesList,
      List<int> citesListId,
      List<String> catogary) {
    return Form(
      key: celebratyKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//name------------------------------------------
        textField(
          context,
          nameIcon,
          "اسم المستخدم",
          textFieldSize,
          false,
          userNameCeleController,
          userName,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[_]|[0-9]'),
                allow: true)
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        //email------------------------------------------
        textField(
          context,
          emailIcon,
          "البريد الالكتروني",
          textFieldSize,
          false,
          emailCeleController,
          valedEmile,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [
            FilteringTextInputFormatter(
                RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]|[-]'),
                allow: true)
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        //pass------------------------------------------
        textField3(
          context,
          Icons.lock,
          "كلمة المرور",
          textFieldSize,
          isVisibilityNew,
          passCeleController,
          valedpass,
          keyboardType: TextInputType.text,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisibilityNew = !isVisibilityNew;
              });
            },
            icon: Icon(
                isVisibilityNew ? Icons.visibility : Icons.visibility_off,
                color: newGrey,
                size: 25.sp),
          ),
          inputFormatters: [
            FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[0-9]|[-_!%*&^$#?@]'),
                allow: true)
          ],
        ),
//       textField(context, passIcon, "كلمة المرور", 14, true, passCeleController,
//           valedpass),
        SizedBox(
          height: 15.h,
        ),
//phone number==================================================================================
        textField3(context, Icons.phone_android_rounded, "رقم الجوال",
            textFieldSize, false, celPhoneController, valedphone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp(r'[0-9]'), allow: true)
            ],
            suffixText: '966+'),

        // textField3(context, passIcon, "كلمة المرور", 14, true, passUserController,
        //     valedpass,),
        SizedBox(
          height: 15.h,
        ),
//Area------------------------------------------
        drowMenu("المنطقة", Icons.home_work_rounded, textFieldSize, areaList,
            (va) {
          celAreaId = areaList.indexOf(va!);
          celArea = areaListId.elementAt(celAreaId);
          citesList.clear();
          citesListId.clear();
          fetCities(celArea);
          setState(() {
            celShowCity = true;
            celCityNameValue = null;
            userCityNameValue = null;
          });
          print('Area name: $va');
          print('id: $celArea');
        }, (val) {
          if (val == null) {
            return "اختر المنطقة";
          } else {
            return null;
          }
        }),
        SizedBox(
          height: 15.h,
        ),
//city------------------------------------------
        Visibility(
          visible: celShowCity,
          child: drowMenu(
              "المدينة", Icons.location_city_sharp, textFieldSize, citesList,
              (va) {
            celCityId = citesList.indexOf(va!);
            celCity = citesListId.elementAt(celCityId);
            setState(() {
              celCityNameValue = va;
            });
            print('city name: $celCityNameValue');
            print('id: $celCity');
          }, (val) {
            // if (val == null) {
            //   return "اختر المدينة";
            // } else {
            //   return null;
            // }
          }, valueItem: celCityNameValue),
        ),
        Visibility(
          visible: celShowCity,
          child: SizedBox(
            height: 15.h,
          ),
        ),
//nationality------------------------------------------
        drowMenu("الجنسية", nationalityIcon, textFieldSize, nationalityList,
            (va) {
          celNationalityId = nationalityList.indexOf(va!);
          celNationality = nationalityListId.elementAt(celNationalityId);
          print('Nationality name: $va');
          print('id: $celNationality');
        }, (val) {
          if (val == null) {
            return "اختر الجنسية";
          } else {
            return null;
          }
        }),

        SizedBox(
          height: 15.h,
        ),
//catogary------------------------------------------

        drowMenu("التصنيف", catogaryIcon, textFieldSize, catogary, (va) {
          celCatogary = catogary.indexOf(va!) + 1;
        }, (val) {
          if (val == null) {
            return "اختر التصنيف";
          } else {
            return null;
          }
        }),

        SizedBox(
          height: 15.h,
        ),
      ]),
    );
  }

//===========================================================================
  showContract(String username, String pass, String email, String nationality,
      String catogary, String areaId, String cityId, String phoneNumber) {
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
                      flex: 7,
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
                    SizedBox(height: 10.h),
//confirm============================================================================
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          text(context, 'قرات العقد واوافق عليه', 17.sp,
                              Colors.black87),
                          SizedBox(
                            width: 4.w,
                          ),
                          InkWell(
                              child: Icon(Icons.check_box_rounded,
                                  color: isChckid ? blue : Colors.grey,
                                  size: 26.sp),
                              onTap: () {
                                setState2(() {
                                  isChckid = !isChckid;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
//Signtuer==================================================================================
                    Expanded(
                        flex: 2,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: png != null && help == 1
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
                                          help = 1;
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
                                'انشاء حساب',
                                18,
                                white,
                                isChckid == false
                                    ? null
                                    : () {
                                        loadingDialogue(context);
                                        databaseHelper
                                            .celebrityRegister(
                                                username,
                                                pass,
                                                email,
                                                nationality,
                                                catogary,
                                                areaId,
                                                cityId,
                                                phoneNumber,
                                                png)
                                            .then((result) {
                                          print(
                                              '--------------------result:$result');
                                          if (result == "celebrity") {
                                            Navigator.pop(context);
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            DatabaseHelper
                                                .saveRememberUserEmail(email);
                                            DatabaseHelper.saveRememberUser(
                                                "celebrity");

                                            setState(() {
                                              clearUserTextField();
                                              clearCelebrityTextField();
                                              isChang = !isChang!;
                                            });
                                            Navigator.pop(context2);
                                            goTopagepush(
                                                context,
                                                VerifyUser(
                                                  username: email.trim(),
                                                ));

                                            print(
                                                '-----------------$isChang---------------------------');
                                          } else if (result ==
                                              "email and username found") {
                                            Navigator.pop(context);
                                            showMassage(context, 'بيانات مكررة',
                                                'البريد الالكتروني واسم المستخدم موجود مسبقا');
                                          } else if (result ==
                                              "username found") {
                                            Navigator.pop(context);
                                            showMassage(context, 'بيانات مكررة',
                                                'اسم المستخدم موجود مسبقا');
                                          } else if (result == 'email found') {
                                            Navigator.pop(context);
                                            showMassage(context, 'بيانات مكررة',
                                                'البريد الالكتروني موجود مسبقا');
                                          } else if (result ==
                                              'The phonenumber has already been taken.') {
                                            Navigator.pop(context);
                                            showMassage(context, 'بيانات مكررة',
                                                'رقم الجوال مستخدم مسبقا ');
                                          } else if (result ==
                                              "SocketException") {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الانترنت',
                                                socketException);
                                          } else if (result ==
                                              "TimeoutException") {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الخادم',
                                                timeoutException);
                                          } else if (result.contains(
                                              "The email format is incorrect.")) {
                                            Navigator.pop(context);
                                            showMassage(context, 'بيانات خاطئة',
                                                'فضلا تاكد من صحة البريد الالكتروني');
                                          } else {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الخادم',
                                                serverException);
                                          }
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
}
