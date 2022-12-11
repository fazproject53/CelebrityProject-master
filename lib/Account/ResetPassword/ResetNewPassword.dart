import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';
import '../UserForm.dart';
import '../logging.dart';
import 'Reset.dart';

class ResetNewPassword extends StatefulWidget {
  final int? code;
  final String? username;
  const ResetNewPassword({
    Key? key,
    this.code,
    this.username,
  }) : super(key: key);

  @override
  _ResetNewPasswordState createState() => _ResetNewPasswordState();
}

class _ResetNewPasswordState extends State<ResetNewPassword>
    with RestorationMixin {
  bool showPwValidatorUser = false;
  bool isSussesUser = false;

  bool isVisibility = true;
  bool isVisibilityNew = true;
  GlobalKey<FormState> resetNewKey = GlobalKey();
  RestorableTextEditingController passController =
  RestorableTextEditingController();
  RestorableTextEditingController newPassController =
  RestorableTextEditingController();
  late Image image1;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    image1 = Image.asset("assets/image/singup.jpg");
  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          // decoration: BoxDecoration(
          //     color: Colors.black,
          //     image: DecorationImage(
          //         image: image1.image,
          //         colorFilter: ColorFilter.mode(
          //             Colors.black.withOpacity(0.7), BlendMode.darken),
          //         fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                text(
                  context,
                  'تاكيد كلمة المرور الجديدة',
                  textHeadSize,
                  Colors.black87,
                  fontWeight: FontWeight.bold,
                  align: TextAlign.right,
                ),
                SizedBox(
                  height: 70.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.w),
//image---------------------------------------------------------------

                  child: Container(
                    width: double.infinity,
                    height: 150.h,
                    margin: EdgeInsets.all(9.w),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/image/reset.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: Form(
                    key: resetNewKey,
                    child: Column(
                      children: [
//title---------------------------------------------------------------
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0.h, horizontal: 8.w),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: text(
                              context,
                              ' قم باعادة تعين كلمة المرور الجديدة',
                              17,
                              Colors.black87,
                              //fontWeight: FontWeight.bold,
                              align: TextAlign.right,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
// new password Text field---------------------------------------------------------------
                        FocusScope(
                          child: Focus(
                            onFocusChange: (focus) {
                              setState(() {
                                showPwValidatorUser = false;
                              });
                              print('--------------------------------');
                              print('focus:$focus');
                              print('--------------------------------');
                              if (focus && isSussesUser == false) {
                                setState(() {
                                  showPwValidatorUser = true;
                                });
                              } else if (focus == false &&
                                  isSussesUser == true) {
                                setState(() {
                                  showPwValidatorUser = false;
                                });
                              } else if (focus == false) {
                                setState(() {
                                  showPwValidatorUser = false;
                                });
                              } else {
                                setState(() {
                                  showPwValidatorUser = false;
                                });
                              }
                            },
                            child: textField3(
                                context,
                                Icons.lock,
                                "كلمة المرور الجديدة",
                                textFieldSize,
                                isVisibility,
                                passController.value, (s) {
                              if (s.isEmpty) {
                                return 'حقل اجباري';
                              }
                              if (isSussesUser == false) {
                                return 'عليك اختيار كلمة مرور مطابقة للشروط';
                              } else {
                                return null;
                              }
                            },
                                keyboardType: TextInputType.text,
                                inputFormatters: [
                                  FilteringTextInputFormatter(
                                      RegExp(r'[a-zA-Z]|[0-9]|[-_!%*&^$#?@]'),
                                      allow: true)
                                ],
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisibility = !isVisibility;
                                    });
                                  },
                                  icon: Icon(
                                      isVisibility
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: newGrey,
                                      size: 25.sp),
                                )),
                          ),
                        ),
                        Visibility(
                          visible: showPwValidatorUser,
                          child: SizedBox(
                            height: 10.h,
                          ),
                        ),
                        Visibility(
                          visible: showPwValidatorUser,
                          child: FlutterPwValidator(
                            controller: passController.value,
                            // defaultColor: textGray,
                            minLength: 8,
                            uppercaseCharCount: 1,
                            numericCharCount: 1,
                            specialCharCount: 1,
                            //normalCharCount: 5,
                            failureColor: red!,
                            successColor: green,
                            width: 400.w,
                            height: 200.h,
                            onSuccess: () {
                              setState(() {
                                showPwValidatorUser = false;
                                isSussesUser = true;
                              });
                            },
                            onFail: () {
                              setState(() {
                                showPwValidatorUser = true;
                                isSussesUser = false;
                              });
                            },
                            strings: PasswordValidatorStrings(),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
//confirm new password Text field---------------------------------------------------------------
                        textField3(
                            context,
                            Icons.lock,
                            "تاكيد كلمة المرور",
                            textFieldSize,
                            isVisibilityNew,
                            newPassController.value,
                            confirm,
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
                                  isVisibilityNew
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: newGrey,
                                  size: 25.sp),
                            )),
                      ],
                    ),
                  ),
                ),
//send bottom ---------------------------------------------------------------
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: gradientContainer(
                    double.infinity,
                    buttoms(
                      context,
                      "ارسال",
                      15,
                      white,
                          () {
                        //remove focus from textField when click outside
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (resetNewKey.currentState?.validate() == true) {
                          resetNewPasswordMethod(
                              widget.username!,
                              passController.value.text,
                              newPassController.value.text);
                        }
                      },
                      evaluation: 0,
                    ),
                    height: 50,
                    color: Colors.transparent,
                    gradient: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void resetNewPasswordMethod(
      String username, String password, String newPassword) {
    loadingDialogue(context);
    getResetPassword(username, password, newPassword, forgetToken)
        .then((value) {
      if (value == true) {
        Navigator.pop(context);

        successfullyDialog(context, 'تمت استعادة كلمة المرور بنجاح',
            "assets/lottie/SuccessfulCheck.json", 'تسجيل الدخول', () {
              gotoPageAndRemovePrevious(context, Logging());
            });
      } else if (value == false || value == 'serverException') {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الخادم', serverException);
      } else if (value == 'TimeoutException') {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الخادم', timeoutException);
      } else if (value == 'SocketException') {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الانترنت', socketException);
      }
    });
  }

  String? confirm(value) {
    if (value.isEmpty) {
      return 'حقل اجباري';
    }
    if (value != passController.value.text) {
      return "كلمة المرور غير متطابقة";
    }
    return null;
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => 'reset_pass';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(passController, 'reset_pass_textField');
    registerForRestoration(newPassController, 'reset_new_pass_textField');
  }
}