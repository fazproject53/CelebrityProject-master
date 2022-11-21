///import section
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Setting/user_recharge_balance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import '../../Account/LoggingSingUpAPI.dart';
import '../../Celebrity/Balance/radioListTile.dart';
import '../BalanceModels/get_card.dart';

class UserBalance extends StatelessWidget {
  const UserBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: drowAppBar('الرصيد', context),
          body: const UserBalanceHome(),
        ));
  }
}

///Balance home page
class UserBalanceHome extends StatefulWidget {
  const UserBalanceHome({Key? key}) : super(key: key);

  @override
  _UserBalanceHomeState createState() => _UserBalanceHomeState();
}

class _UserBalanceHomeState extends State<UserBalanceHome> {
  Future<GetCard>? getCards;

  ///Text Field
  final TextEditingController userCardHolderName = TextEditingController();
  final TextEditingController userIbanNumber = TextEditingController();
  String T = "";
  String? userToken;

  ///formKey
  final _formKey = GlobalKey<FormState>();

  bool isVisible = true;

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;

  bool activeConnection = true;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getCards = getAllCardInfo(userToken!);
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: activeConnection ? SafeArea(
        child: FutureBuilder<GetCard>(
          future: getCards,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: mainLoad(context));
            }else if(snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done){
              if (snapshot.hasError) {
                if (snapshot.error.toString() == 'SocketException') {
                  return Center(
                      child: SizedBox(
                          height: 500.h,
                          width: 250.w,
                          child: internetConnection(context, reload: () {
                            setState(() {
                              getCards = getAllCardInfo(userToken!);
                              isConnectSection = true;
                            });
                          })));
                } else {
                  return const Center(
                      child: Text('حدث خطا ما اثناء استرجاع البيانات'));
                }
                //---------------------------------------------------------------------------
              } else if(snapshot.hasData){

                var availableBalance = snapshot.data!.data!.user!.availableBalance!;
                var outstandingBalance = snapshot.data!.data!.user!.outstandingBalance!;

                var totalBalance = availableBalance + outstandingBalance ;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40.h, right: 20.w, left: 20.w),
                      child: gradientContainerNoborder(
                        390,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///The Total Title
                            Padding(
                              padding: EdgeInsets.only(top: 10.h, right: 20.w),
                              child: Row(
                                children: [
                                  text(context, 'الإجمالي', textSubHeadSize, white),
                                ],
                              ),
                            ),

                            ///The Total Balance
                            Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Row(
                                children: [
                                  text(context, totalBalance.toString(), textTitleSize, white,
                                      fontWeight: FontWeight.bold),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  text(context, 'ر.س', textTitleSize, white,
                                      fontWeight: FontWeight.w200),
                                ],
                              ),
                            ),

                            ///SizedBox
                            SizedBox(
                              height: 30.h,
                            ),

                            Padding(
                              padding:  EdgeInsets.only(right: 15.w, left: 10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          text(context, 'الرصيد المتاح', textSubHeadSize, white)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          text(context, availableBalance.toString(), 14, white,
                                              fontWeight: FontWeight.bold),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          text(context, 'ر.س', textTitleSize, white,
                                              fontWeight: FontWeight.w200),
                                        ],
                                      ),
                                    ],
                                  ),

                                  ///Suspend Balance
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          text(context, 'الرصيد المعلق', textSubHeadSize, white)
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          text(context, outstandingBalance.toString(), 14, white,
                                              fontWeight: FontWeight.bold),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          text(context, 'ر.س', textTitleSize, white,
                                              fontWeight: FontWeight.w200),
                                        ],
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ),

                            ///SizedBox
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///SizedBox
                    SizedBox(
                      height: 50.h,
                    ),

                    ///Withdrawable Balance
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20.h, right: 20.w, left: 20.w, bottom: 15.h),
                        child: text(context, "رصيد السحب", textTitleSize, ligthtBlack),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 34.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 150.w,
                                height: 64.5.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: blue),
                                child: text(context, availableBalance.toString(), 24, white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),

                          ///SizedBox
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40.h,
                              ),
                              text(context, 'ر.س', textTitleSize, black),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ///SizedBox
                    SizedBox(
                      height: 100.h,
                    ),
                    Column(
                      children: [
                        ///Withdrew Balance button
                        padding(
                          22,
                          22,
                          gradientContainerNoborder(
                              getSize(context).width,
                              buttoms(context, 'سحب الرصيد', largeButtonSize-1, white, () {
                                ///Bottom sheet
                                showBottomSheetWhite(context,
                                    bottomSheetMenuPayments(availableBalance.toString()));
                              })),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        padding(
                            22,
                            22,

                            ///Recharge The Balance Button
                            gradientContainer(
                              getSize(context).width,
                              buttoms(
                                context,
                                'شحن الحساب',
                                largeButtonSize-1,
                                black,
                                    () {
                                  ///determine the amount of money
                                  goTopagepush(context, const UserRechargeBalance());
                                },
                              ),
                              gradient: true,
                              color: grey!,
                              height: 40,
                            ))
                      ],
                    ),
                  ],
                );

              }else{
                return const Center(child: Text('Empty data'));
              }
            }else {
              return Center(
                  child: Text('State: ${snapshot.connectionState}'));
            }
          },
        ),
      ) :  Center(
          child: SizedBox(
              height: 300.h,
              width: 250.w,
              child: internetConnection(
                  context, reload: () {
                checkUserConnection();
                getCards = getAllCardInfo(userToken!);
              }))),
    );
  }

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
        print(response.body);
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

  ///Bottom Sheet for Payments
  Widget bottomSheetMenuPayments(String balance) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 18.w, left: 20.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text(
                          context,
                          'الحساب البنكي',
                          textTitleSize,
                          black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),

                    ///--------------------------
                    Visibility(
                        visible: true,

                        ///true
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            SingleChildScrollView(child: RadioWidgetDemo()),
                          ],
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Divider(
                      thickness: 1,
                    ),

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
                            'إضافة حساب بنكي جديد',
                            textTitleSize+1,
                            black,
                          ),
                          SizedBox(
                            width: 140.w,
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
                        ///Go To New Bottom Sheet To Add New Credit Card
                        ///Bottom sheet
                        showBottomSheetWhite2(context,
                            bottomSheetCreditCard('1', 'rayana', '500'));
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        text(context, 'الإجمالي المستحق', textTitleSize, black,
                            fontWeight: FontWeight.bold),
                        text(context, '140' + ' ريال', textTitleSize, black,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),

                    ///bottom to withdraw balance
                    padding(
                      22,
                      22,
                      gradientContainerNoborder(
                          150.w,
                          buttoms(context, 'إسحب الرصيد', SmallbuttomSize, white, () {
                            selectedUser != null
                                ? showMassage(context, 'تم إرسال طلبك بنجاح',
                                    'سوف نقوم بالتواصل معك في مدة لاتزيد عن ٣ ايام',
                                    done: done)
                                : showMassage(context, 'خطأ',
                                    'قم بإختيار بطاقة او ادخال بطاقة جديدة');
                          })),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetCreditCard(String id, String name, String balance) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20.w, left: 20.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          text(
                            context,
                            'إضافة الحساب الجديد',
                            textSubHeadSize,
                            black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: 10.w, left: 10.w, top: 25.h),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              textFieldIban(
                                  context,
                                  'اسم صاحب الحساب',
                                  'اسم صاحب الحساب الثلاثي',
                                  textFieldSize,
                                  false,
                                  userCardHolderName, (String? value) {
                                /// Validation text field
                                if (value == null || value.isEmpty) {
                                  return 'حقل اجباري';
                                }
                                if (value.startsWith('0')) {
                                  return 'يجب ان لا يبدا بصفر';
                                }
                                if (value.startsWith(RegExp(r'[0-9]'))) {
                                  return 'يجب ان لا يبدا برقم';
                                }
                                if (value.startsWith(RegExp(r'[a-z]'))) {
                                  return 'يجب ان يبدا بأحرف كبيرة';
                                }
                                return null;
                              }, false, inputFormatters: [
                                ///letters only
                                FilteringTextInputFormatter(
                                    RegExp(r'[a-zA-Z]|[\s]'),
                                    allow: true)
                              ]),
                              SizedBox(
                                height: 15.h,
                              ),

                              ///Iban number
                              textFieldIban(
                                context,
                                'SA00 0000 0000 0000 0000 0000',
                                'رقم الايبان SA',
                                textFieldSize,
                                false,
                                userIbanNumber,
                                (String? value) {
                                  /// Validation text field
                                  if (value == null || value.isEmpty) {
                                    return 'حقل اجباري';
                                  }
                                  if (value.startsWith(RegExp(r'[0-9]'))) {
                                    return 'يجب ان يبدا ب SA';
                                  }
                                  if (value.length > 24) {
                                    return 'رقم الايبان يجب ان يكون مكون من ٢٤ أحرف';
                                  }
                                  return null;
                                },
                                false,
                                inputFormatters: [
                                  ///letters only
                                  FilteringTextInputFormatter(
                                      RegExp(r'[A-Z]|[0-9]'),
                                      allow: true)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      const Divider(
                        thickness: 1,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(context, 'الإجمالي المستحق', textTitleSize, black,
                              fontWeight: FontWeight.bold),
                          text(context, '140' + ' ريال', textTitleSize, black,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),

                      ///bottom to withdraw balance
                      padding(
                        22,
                        22,
                        gradientContainerNoborder(
                            200.w,
                            buttoms(context, 'إضافة الحساب البنكي', SmallbuttomSize, white,
                                () {
                              _formKey.currentState!.validate()
                                  ? {
                                      showMassage(
                                          context,
                                          'تم إضافة بطاقة جديدة بنجاح',
                                          'سوف نقوم بالتواصل معك في مدة لاتزيد عن ٣ ايام',
                                          done: done)
                                    }
                                  : null;
                            })),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
