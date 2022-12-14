///import section

import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'balance_object.dart';
import 'radioListTile.dart';

class BalanceMain extends StatelessWidget {

  static BalanceObject? balanceObject;

  const BalanceMain({Key? key}) : super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar('الرصيد', context),
        body: const BalanceHome(),
      ),
    );
  }
}

///-------------------------balance section-------------------------
class BalanceHome extends StatefulWidget {
  const BalanceHome({Key? key}) : super(key: key);

  @override
  _BalanceHomeState createState() => _BalanceHomeState();
}

class _BalanceHomeState extends State<BalanceHome> {
  ///Text Field
  final TextEditingController cardHolderName = TextEditingController();
  final TextEditingController ibanNumber = TextEditingController();

  ///formKey
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 20.h, right: 20.w),
              child: text(context, "الرصيد الخاص بك", textHeadSize, ligthtBlack),
            ),
          ),

          ///The Account Balance
          Padding(
            padding: EdgeInsets.only(top: 30.h, right: 20.w, left: 20.w),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.r),
              ),
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 10.h, left: 10.w, right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///Icon
                        GradientIcon(
                            payment,
                            27.w,
                            const LinearGradient(
                              begin: Alignment(0.7, 2.0),
                              end: Alignment(-0.69, -1.0),
                              colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                              stops: [0.0, 1.0],
                            )),
                        SizedBox(
                          width: 2.w,
                        ),

                        ///Text
                        text(
                          context,
                          'رصيد الحساب',
                          textSubHeadSize,
                          black,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: grey,
                    height: 20.h,
                    thickness: 0.5,
                  ),
                  Container(
                    margin:
                    EdgeInsets.only(right: 10.w, left: 10.w, bottom: 10.h),
                    child: text(context, "500 ر.س", textSubHeadSize, ligthtBlack,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          ///The Suspend Balance
          Padding(
            padding: EdgeInsets.only(top: 16.h, right: 20.w, left: 20.w),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.r),
              ),
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 10.h, left: 10.w, right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///Icon
                        GradientIcon(
                            payment,
                            27.w,
                            const LinearGradient(
                              begin: Alignment(0.7, 2.0),
                              end: Alignment(-0.69, -1.0),
                              colors: [Color(0xff0ab3d0), Color(0xffe468ca)],
                              stops: [0.0, 1.0],
                            )),
                        SizedBox(
                          width: 2.w,
                        ),

                        ///Text
                        text(
                          context,
                          'الرصيد المعلق',
                          textSubHeadSize,
                          black,
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: grey,
                    height: 20.h,
                    thickness: 0.5,
                  ),
                  Container(
                    margin:
                    EdgeInsets.only(right: 10.w, left: 10.w, bottom: 10.h),
                    child: text(context, "500 ر.س", textSubHeadSize, ligthtBlack,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 20.h,
          ),

          ///Withdrew Money Button
          padding(
            22,
            22,
            gradientContainerNoborder(
                getSize(context).width,
                buttoms(context, 'سحب الرصيد', largeButtonSize, white, () {
                  ///Bottom sheet
                  showBottomSheetWhite(
                      context, bottomSheetMenuPayments('1', 'rayana', '500'));
                })),
          ),
        ],
      ),
    );
  }

  ///Bottom Sheet for Payments
  Widget bottomSheetMenuPayments(String id, String name, String balance) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text(
                        context,
                        'الحساب البنكي',
                        textSubHeadSize,
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
                      child: Column(
                        children:  [
                          SizedBox(
                            height: 10.h,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SingleChildScrollView(child: RadioWidgetDemo()),
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
                          width: 5.w,
                        ),
                        text(
                          context,
                          'إضافة حساب بنكي جديد',
                          textSubHeadSize,
                          black,
                        ),
                        SizedBox(
                          width: 135.w,
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

                          selectedUser != null ?
                          showMassage(context, 'تم إرسال طلبك بنجاح', 'سوف نقوم بالتواصل معك خلال ٣ ايام',  done: done) :

                          showMassage(context, 'خطأ', 'قم بإختيار بطاقة او ادخال بطاقة جديدة');

                        })),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  ///add new credit card
  Widget bottomSheetCreditCard(String id, String name, String balance) {

    return Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
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
                            'إضافة حساب بنكي جديد',
                            textSubHeadSize,
                            black,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w, left: 10.w, top: 25.h,),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              textFieldIban(
                                  context,
                                  'اسم صاحب الحساب الثلاثي',
                                  'اسم صاحب الحساب ',
                                  textFieldSize,
                                  false,
                                  cardHolderName, (String? value) {
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
                                'SA رقم الايبان',
                                textFieldSize,
                                false,
                                ibanNumber,
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
                            buttoms(context, 'إضافة الحساب الجديد', SmallbuttomSize, white, () {
                              _formKey.currentState!.validate()
                                  ? {
                                //تم إرسال طلبك بنجاح
                                //سوف نقوم بالتواصل معك في مدة لاتزيد عن ٣ ايام
                                showMassage(context, 'تم إرسال طلبك بنجاح', 'سوف نقوم بالتواصل معك خلال ٣ ايام', done: done)
                              }
                                  : null;
                            })),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}