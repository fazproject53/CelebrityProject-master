import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/SuccessfulAndFailureScreens/splash_screen.dart';
import 'package:celepraty/Users/Setting/radio_list_tile_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Models/Methods/method.dart';
import 'package:http/http.dart' as http;
import '../BalanceModels/get_card.dart';


class UserRechargeBalance extends StatefulWidget {
  const UserRechargeBalance({Key? key}) : super(key: key);

  @override
  _UserRechargeBalanceState createState() => _UserRechargeBalanceState();
}

class _UserRechargeBalanceState extends State<UserRechargeBalance> {
  Future<GetCard>? getCards;
  OutlineInputBorder? border;

  late final TextEditingController amount = TextEditingController();

  String T = "";
  String? userToken;

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool activeConnection = true;

  late Map<dynamic, dynamic> tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String? sdkErrorCode;
  String? sdkErrorMessage;
  String? sdkErrorDescription;
  String? userEmail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isVisable = true;
  bool isVesible2 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: purple.withOpacity(0.6),
        width: 1.0,
      ),
    );

    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getCards = getAllCardInfo(userToken!);
      });
    });
  }

  ///---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('إضافة رصيد', context),
        body: activeConnection ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 140.h,
                  width: 200.w,
                  child:
                      Lottie.asset('assets/lottie/addMoreMoney.json')),
              text(context, 'ادخل المبلغ المراد إضافة للرصيد', 20,
                  black.withOpacity(0.6)),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textFieldSmallRE(
                      context,
                      '0',
                      18,
                      false,
                      amount,
                      (String? value) {
                        if (value!.startsWith('0')) {
                          return 'يجب ان لا يبدا بصفر';
                        }
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 35, right: 10.w),
                    child: text(context, 'ر.س', 14, black.withOpacity(0.8)),
                  )
                ],
              ),

              const Spacer(),

              padding(
                22,
                22,
                gradientContainerNoborder(
                    getSize(context).width,
                    buttoms(context, 'التالي', 16, white, () {
                      ///Bottom sheet
                      if (amount.text.isNotEmpty) {

                        showBottomSheetWhite(context, bottomSheetRechargeMenu('1', 'rayana', amount.text));
                      } else {
                        showMassage(context, 'خطأ', 'أدخل المبلغ المراد إضافة للرصيد');
                      }
                    })),
              ),
              SizedBox(
                height: 37.h,
              ),
            ],
          ),
        ) :  Center(
            child: SizedBox(
                height: 300.h,
                width: 250.w,
                child: internetConnection(
                    context, reload: () {
                  checkUserConnection();
                  getCards = getAllCardInfo(userToken!);
                })))
      ),
    );
  }
  ///------------------------------------
  ///API Section
  ///Get
  Future<GetCard> getAllCardInfo(String token) async {
    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/user/cards'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        //print(response.body);
        if(GetCard.fromJson(jsonDecode(response.body)).data!.user!.email!.isNotEmpty){
          setState(() {
            userEmail = GetCard.fromJson(jsonDecode(response.body)).data!.user!.email!;

          });
        }
        return GetCard.fromJson(jsonDecode(response.body));

      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (error) {
      if (error is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (error is TimeoutException) {
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

  ///Post

  ///------------------------------------

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  Widget bottomSheetRechargeMenu(String id, String name, String balance) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 18.w, left: 20.w),
                child: Column(
                  children: [
                    text(
                      context,
                      'أختر طريقة الشحن',
                      16,
                      black,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    const Divider(
                      thickness: 1,
                    ),

                  ///Apple pay
                  Visibility(
                    visible: Platform.isIOS ? true : false ,
                    child:  InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //applePayIcon.png
                          Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                                width: 30.w,
                                child: Image.asset(
                                    'assets/image/applePayIcon.png'),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          text(
                            context,
                            'Apple Pay',
                            18,
                            black,
                          ),
                          SizedBox(
                            width: 230.w,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Icon(
                              backIcon,
                              size: 20,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {

                      },
                    )
                  ),

                    const Divider(
                      thickness: 1,
                    ),

                    ///credit card
                    Visibility(
                        visible: false,
                        child: Column(
                          children:  const [
                            SingleChildScrollView(
                              child: RadioWidgetUser(),

                            ),
                          ],
                        )),

                    const Divider(
                      thickness: 1,
                    ),

                    ///add new credit card
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            add,
                            size: 23,
                            color: black,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          text(
                            context,
                            'إضافة بطاقة جديدة',
                            18,
                            black,
                          ),
                          SizedBox(
                            width: 170.w,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Icon(
                              backIcon,
                              size: 20,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        ///Go to TapPayment Gateway


                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),

                    ///bottom to withdraw balance
                    Visibility(
                      ///will show when the user choose one of the available credit card
                      visible: isVisable,
                      child: padding(
                        22,
                        22,
                        gradientContainerNoborder(
                          150.w,
                          buttoms(
                            context,
                            'إضافة رصيد',
                            15,
                            white,
                            () {
                              /// If the user select the credit card
                              if(selectedUser != null){
                                ///Make sure the user enter cvv code
                                if(cvvCode1.text.isNotEmpty ){
                                  ///loading Screen the successful animation
                                  goTopagepush(
                                      context,
                                       SplashScreen(
                                        trueOrFalse: 1,amount: amount.text,
                                      ));
                                }else{
                                  showMassage(context, 'خطأ', 'قم بإدخال الرمز الموجود خلف البطاقة');
                                }
                              }else{
                                showMassage(context, 'خطأ', 'قم بإختيار بطاقة او ادخال بطاقة جديدة');
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}


