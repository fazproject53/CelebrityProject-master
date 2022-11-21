import 'package:celepraty/Account/ResetPassword/SendEmailGUI.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import "package:flutter/material.dart";
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'LoggingSingUpAPI.dart';
import 'Singup.dart';
import 'TheUser.dart';
import 'UserForm.dart';
import 'VerifyUser.dart';

class Logging extends StatefulWidget {
  static TheUser? theUser;
  Logging({Key? key}) : super(key: key);

  @override
  State<Logging> createState() => _LoggingState();
}

class _LoggingState extends State<Logging> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool isChckid = true;
  late Image image1;
  String isFoundEmail = '';
  String facebookEmail = '';
  String googleEmail = '';
  String getEmail = '';
  bool isVisibility = true;
  bool isVisibilityNew = true;
  TextEditingController lgoingEmailConttroller = TextEditingController();
  final TextEditingController lgoingPassConttroller = TextEditingController();
  GlobalKey<FormState> logKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    image1 = Image.asset("assets/image/singup.jpg");
    DatabaseHelper.getRememberUserEmail().then((email) {
      setState(() {
        isFoundEmail = email;
        lgoingEmailConttroller =
            TextEditingController(text: isFoundEmail == '' ? '' : isFoundEmail);
      });
    });

    DatabaseHelper.getFacebookAccessUserEmail().then((email) {
      setState(() {
        facebookEmail = email;
      });
    });

    DatabaseHelper.getGoogleAccessUserEmail().then((email) {
      setState(() {
        googleEmail = email;
      });
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //print('facebook email is $facebookEmail');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
//main container--------------------------------------------------
          body: Container(
        height: double.infinity,
        width: double.infinity,
        // decoration: BoxDecoration(
        //     color: Colors.white,
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
              Image.asset(
                logo,
                fit: BoxFit.cover,
                height: 120.h,
                width: 300.w,
              ),

//مرحبا بك مره اخري--------------------------------------------------
              //   text(context, "مرحبا بك مرة اخري", 20, Colors.black87),
//تسجيل الدخول--------------------------------------------------
              text(context, "تسجيل الدخول", textHeadSize, Colors.black87),
              SizedBox(
                height: 40.h,
              ),

//=============================================================================================
              padding(
                  20,
                  20,
                  Form(
                    key: logKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
//====================================TextFields=========================================================

//email------------------------------------------
                        textField(
                            context,
                            emailIcon,
                            "البريد الالكتروني او اسم المستخدم",
                            textFieldSize,
                            false,
                            lgoingEmailConttroller,
                            empty),
                        SizedBox(
                          height: 15.h,
                        ),
//pass------------------------------------------
//                         textField(context, passIcon, "كلمة المرور", 14, true,
//                             lgoingPassConttroller, empty),

                        textField3(context, Icons.lock, "كلمة المرور", textFieldSize,
                            isVisibilityNew, lgoingPassConttroller, empty,
                            keyboardType: TextInputType.text,
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

                        SizedBox(
                          height: 15.h,
                        ),
//remember me && forget pass------------------------------------------
                        rememberMe(),
                        SizedBox(
                          height: 15.h,
                        ),
//logging buttom-----------------------------------------------------------------------------
                        gradientContainer(
                            347,
                            buttoms(context, 'تسجيل الدخول', SmallbuttomSize, white, () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (logKey.currentState?.validate() == true) {
                                loadingDialogue(context);
                                databaseHelper
                                    .loggingMethod(lgoingEmailConttroller.text,
                                        lgoingPassConttroller.text)
                                    .then((result) {
//if user select remember me----------------------------------------------------------------------------

                                  if (isChckid) {
                                    if (result == "user") {
                                      DatabaseHelper.saveRememberToken(result);
                                      DatabaseHelper.saveRememberUserEmail(
                                          lgoingEmailConttroller.text);
                                      Navigator.pop(context);
                                      DatabaseHelper.saveRememberUser("user");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result == "celebrity") {
                                      DatabaseHelper.saveRememberToken(result);
                                      DatabaseHelper.saveRememberUserEmail(
                                          lgoingEmailConttroller.text);
                                      Navigator.pop(context);
                                      DatabaseHelper.saveRememberUser(
                                          "celebrity");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result ==
                                        "Invalid Credentials") {
                                      Navigator.pop(context);
                                      showMassage(context, 'بيانات غير صحيحة',
                                          'خطأ في كلمة المرور او اسم المستخدم');
                                    } else if (result == "SocketException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الانترنت',
                                          socketException);
                                    } else if (result == "TimeoutException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          timeoutException);
                                    } else if (result == "User not verified") {
                                      Navigator.pop(context);

                                      failureDialog(
                                        context,
                                        'التحقق من البريد الالكتروني',
                                        'ادخل الرمز المرسل إليك',
                                        "assets/lottie/Failuer.json",
                                        'تحقق',
                                        () {
                                          Navigator.pop(context);
                                          goTopagepush(
                                              context,
                                              VerifyUser(
                                                  username:
                                                      lgoingEmailConttroller
                                                          .text
                                                          .trim()));
                                        },
                                      );

                                      //showMassage(context, 'لم يتم التحقق من البريد الالكتروني بعد, لقد تم ارسال رمز التحقق الي البريد المدخل', 'اكمال اجراء');
                                    } else {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          serverException);
                                    }
//if user not select remember me----------------------------------------------------------------------------
                                  } else {
                                    if (result == "user") {
                                      DatabaseHelper.saveRememberUser("user");
                                      Navigator.pop(context);
                                      DatabaseHelper.removeRememberUserEmail();
                                      print('remove user email');
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result == "celebrity") {
                                      DatabaseHelper.saveRememberUser(
                                          "celebrity");
                                      Navigator.pop(context);
                                      DatabaseHelper.removeRememberUserEmail();
                                      print('remove celebrity email');
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const MainScreen()));
                                    } else if (result == "SocketException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الانترنت',
                                          socketException);
                                    } else if (result == "TimeoutException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          timeoutException);
                                    } else if (result ==
                                        "Invalid Credentials") {
                                      Navigator.pop(context);
                                      showMassage(context, 'بيانات غير صحيحة',
                                          'خطأ في كلمة المرور او اسم المستخدم');
                                    } else if (result == "serverException") {
                                      Navigator.pop(context);
                                      showMassage(context, 'مشكلة في الخادم',
                                          serverException);
                                    } else if (result == "User not verified") {
                                      Navigator.pop(context);

                                      failureDialog(
                                        context,
                                        'التحقق من البريد الالكتروني',
                                        'ادخل الرمز المرسل إليك',
                                        "assets/lottie/Failuer.json",
                                        'تحقق',
                                        () {
                                          Navigator.pop(context);
                                          goTopagepush(
                                              context,
                                              VerifyUser(
                                                  username:
                                                      lgoingEmailConttroller
                                                          .text
                                                          .trim()));
                                        },
                                      );
                                      //showMassage(context, 'لم يتم التحقق من البريد الالكتروني بعد, لقد تم ارسال رمز التحقق الي البريد المدخل', 'اكمال اجراء');
                                    } else {
                                      Navigator.pop(context);
                                      showMassage(
                                          context,
                                          'حقول فارغة او غير صحيحة',
                                          'تاكد من تعبئة كل الحقول بصورة صحيحة');
                                    }
                                  }
                                });
                              } else {
                                // showMassage(context, 'حقول فارغة او غير صحيحة',
                                //     'تاكد من تعبئة كل الحقول بصورة صحيحة',done: done);
                              }
                            }),
                            color: Colors.transparent),
                        SizedBox(
                          height: 34.h,
                        ),
//logging vi facebook and google========================================================================================
                        singInVi(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
//google buttom-----------------------------------------------------------
                            singWithsButtom(
                                context, "تسجيل دخول بجوجل", black, white,
                                () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              print('googleEmail: $googleEmail');
                              FocusManager.instance.primaryFocus?.unfocus();
                              loadingDialogue(context);
                              //generate token----------------
                              databaseHelper
                                  .clientTokenSocialMedia()
                                  .then((result) async {
                                if (result == 'done') {
                                  Navigator.pop(context);
                                  print(
                                      'step1: done and token is: $clintGenerateToken');
                                  //login to google ----------------
                                  if (googleEmail == '') {
                                    final user = await GoogleSignIn().signIn();
                                    if (user != null) {
                                      setState(() {
                                        googleEmail = user.email;
                                      });
                                      DatabaseHelper.saveGoogleAccessUserEmail(
                                          user.email);
                                      loadingDialogue(context);
                                      databaseHelper
                                          .loggingWithSocialMediaMethod(
                                              googleEmail, clintGenerateToken)
                                          .then((value) {
                                        print('step2: result is: $value');

                                        if (value == "user") {
                                          DatabaseHelper.saveRememberUser(
                                              "user");
                                          DatabaseHelper.saveRememberUserEmail(
                                              googleEmail);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const MainScreen()));
                                        } else if (value == "celebrity") {
                                          DatabaseHelper.saveRememberUser(
                                              "celebrity");
                                          DatabaseHelper.saveRememberUserEmail(
                                              googleEmail);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const MainScreen()));
                                        } else if (value ==
                                            "Invalid Credentials") {
                                          Navigator.pop(context);
                                          showMassage(context, 'تسجيل الدخول',
                                              'لا يوجد لديك حساب عبر قوقل');
                                          setState(() {
                                            googleEmail='';
                                          });
                                          DatabaseHelper.removeGoogleUserEmail();
                                        } else if (value ==
                                            "User not verified") {
                                          Navigator.pop(context);

                                          failureDialog(
                                            context,
                                            'التحقق من البريد الالكتروني',
                                            'ادخل الرمز المرسل إليك',
                                            "assets/lottie/Failuer.json",
                                            'تحقق',
                                            () {
                                              Navigator.pop(context);
                                              goTopagepush(
                                                  context,
                                                  VerifyUser(
                                                      username:
                                                          googleEmail.trim()));
                                            },
                                          );
                                          //showMassage(context, 'لم يتم التحقق من البريد الالكتروني بعد, لقد تم ارسال رمز التحقق الي البريد المدخل', 'اكمال اجراء');
                                        } else if (value == "SocketException") {
                                          Navigator.pop(context);
                                          showMassage(
                                              context,
                                              'مشكلة في الانترنت',
                                              socketException);
                                        } else if (value ==
                                            "TimeoutException") {
                                          Navigator.pop(context);
                                          showMassage(
                                              context,
                                              'مشكلة في الخادم',
                                              timeoutException);
                                        } else if (value == "serverException") {
                                          Navigator.pop(context);
                                          showMassage(
                                              context,
                                              'مشكلة في الخادم',
                                              serverException);
                                        }
                                      });
                                    }
                                  } else {
                                    loadingDialogue(context);
                                    databaseHelper
                                        .loggingWithSocialMediaMethod(
                                            googleEmail, clintGenerateToken)
                                        .then((value) {
                                      print('step2: result is: $value');

                                      if (value == "user") {
                                        DatabaseHelper.saveRememberUser("user");
                                        DatabaseHelper.saveRememberUserEmail(
                                            googleEmail);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const MainScreen()));
                                      } else if (value == "celebrity") {
                                        DatabaseHelper.saveRememberUser(
                                            "celebrity");
                                        DatabaseHelper.saveRememberUserEmail(
                                            googleEmail);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const MainScreen()));
                                      } else if (value ==
                                          "Invalid Credentials") {
                                        Navigator.pop(context);
                                        showMassage(context, 'تسجيل الدخول',
                                            'لا يوجد لديك حساب عبر قوقل');
                                        setState(() {
                                          googleEmail='';
                                        });
                                        DatabaseHelper.removeGoogleUserEmail();
                                      } else if (value == "User not verified") {
                                        Navigator.pop(context);

                                        failureDialog(
                                          context,
                                          'التحقق من البريد الالكتروني',
                                          'ادخل الرمز المرسل إليك',
                                          "assets/lottie/Failuer.json",
                                          'تحقق',
                                          () {
                                            Navigator.pop(context);
                                            goTopagepush(
                                                context,
                                                VerifyUser(
                                                    username:
                                                        googleEmail.trim()));
                                          },
                                        );
                                        //showMassage(context, 'لم يتم التحقق من البريد الالكتروني بعد, لقد تم ارسال رمز التحقق الي البريد المدخل', 'اكمال اجراء');
                                      } else if (value == "SocketException") {
                                        Navigator.pop(context);
                                        showMassage(
                                            context,
                                            'مشكلة في الانترنت',
                                            socketException);
                                      } else if (value == "TimeoutException") {
                                        Navigator.pop(context);
                                        showMassage(context, 'مشكلة في الخادم',
                                            timeoutException);
                                      } else if (value == "serverException") {
                                        Navigator.pop(context);
                                        showMassage(context, 'مشكلة في الخادم',
                                            serverException);
                                      }
                                    });
                                  }
                                } else if (result == "SocketException") {
                                  Navigator.pop(context);
                                  showMassage(context, 'مشكلة في الانترنت',
                                      socketException);
                                } else if (result == "TimeoutException") {
                                  Navigator.pop(context);
                                  showMassage(context, 'مشكلة في الخادم',
                                      timeoutException );
                                } else if (result == "serverException") {
                                  Navigator.pop(context);
                                  showMassage(context, 'مشكلة في الخادم',
                                      serverException);
                                }
                              });
                            }, googelImage),
                            SizedBox(
                              width: 30.h,
                            ),
//facebook buttom=====================================================================================================
                            singWithsButtom(
                                context, "تسجيل دخول فيسبوك", white, darkBlue,
                                () {
                              print('facebookEmail: $facebookEmail');

                              FocusManager.instance.primaryFocus?.unfocus();
                              loadingDialogue(context);
                              //generate token----------------
                              databaseHelper
                                  .clientTokenSocialMedia()
                                  .then((result) async {
                                if (result == 'done') {
                                  Navigator.pop(context);
                                  print(
                                      'step1: done and token is: $clintGenerateToken');

                                  //login to facebook ----------------
                                  if (facebookEmail == '') {
                                    final LoginResult result =
                                        await FacebookAuth.instance.login(
                                            permissions: [
                                          'email',
                                          'public_profile'
                                        ]);
                                    if (result.status == LoginStatus.success) {
                                      final userData = await FacebookAuth
                                          .instance
                                          .getUserData();
                                      setState(() {
                                        facebookEmail = userData['email'];
                                      });
                                      DatabaseHelper
                                          .saveFacebookAccessUserEmail(
                                              userData['email']);
                                      loadingDialogue(context);
                                      databaseHelper
                                          .loggingWithSocialMediaMethod(
                                              facebookEmail, clintGenerateToken)
                                          .then((value) {
                                        print('step2: result is: $value');

                                        if (value == "user") {
                                          DatabaseHelper.saveRememberUser(
                                              "user");
                                          DatabaseHelper.saveRememberUserEmail(
                                              facebookEmail);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const MainScreen()));
                                        } else if (value == "celebrity") {
                                          DatabaseHelper.saveRememberUser(
                                              "celebrity");
                                          DatabaseHelper.saveRememberUserEmail(
                                              facebookEmail);
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const MainScreen()));
                                        } else if (value ==
                                            "Invalid Credentials") {
                                          Navigator.pop(context);
                                          showMassage(context, 'تسجيل الدخول',
                                              'لا يوجد لديك حساب عبر فيسبوك');
                                          setState(() {
                                            facebookEmail='';
                                          });
                                          DatabaseHelper.removeFacebookUserEmail();
                                        } else if (value ==
                                            "User not verified") {
                                          Navigator.pop(context);

                                          failureDialog(
                                            context,
                                            'التحقق من البريد الالكتروني',
                                            'ادخل الرمز المرسل إليك',
                                            "assets/lottie/Failuer.json",
                                            'تحقق',
                                            () {
                                              Navigator.pop(context);
                                              goTopagepush(
                                                  context,
                                                  VerifyUser(
                                                      username: facebookEmail
                                                          .trim()));
                                            },
                                          );
                                          //showMassage(context, 'لم يتم التحقق من البريد الالكتروني بعد, لقد تم ارسال رمز التحقق الي البريد المدخل', 'اكمال اجراء');
                                        } else if (value == "SocketException") {
                                          Navigator.pop(context);
                                          showMassage(
                                              context,
                                              'مشكلة في الانترنت',
                                              socketException);
                                        } else if (value ==
                                            "TimeoutException") {
                                          Navigator.pop(context);
                                          showMassage(
                                              context,
                                              'مشكلة في الخادم',
                                              timeoutException );
                                        } else if (value == "serverException") {
                                          Navigator.pop(context);
                                          showMassage(
                                              context,
                                              'مشكلة في الخادم',
                                              serverException);
                                        } else {
                                          //بحصل الخطا ده اذا كان الايميل فاضي يعني نص فاضي كدا ''
                                          Navigator.pop(context);
                                          showMassage(context, 'تسجيل الدخول',
                                              'فشلت عملية تسجيل الدخول');
                                        }
                                      });
                                    }
                                  } else {
                                    loadingDialogue(context);
                                    databaseHelper
                                        .loggingWithSocialMediaMethod(
                                            facebookEmail, clintGenerateToken)
                                        .then((value) {
                                      print('step2: result is: $value');

                                      if (value == "user") {
                                        DatabaseHelper.saveRememberUser("user");
                                        DatabaseHelper.saveRememberUserEmail(
                                            facebookEmail);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const MainScreen()));
                                      } else if (value == "celebrity") {
                                        DatabaseHelper.saveRememberUser(
                                            "celebrity");
                                        DatabaseHelper.saveRememberUserEmail(
                                            facebookEmail);
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const MainScreen()));
                                      } else if (value ==
                                          "Invalid Credentials") {
                                        Navigator.pop(context);
                                        showMassage(context, 'تسجيل الدخول',
                                            'لا يوجد لديك حساب عبر فيسبوك');
                                        setState(() {
                                          facebookEmail='';
                                        });
                                        DatabaseHelper.removeFacebookUserEmail();
                                      } else if (value == "User not verified") {
                                        Navigator.pop(context);

                                        failureDialog(
                                          context,
                                          'التحقق من البريد الالكتروني',
                                          'ادخل الرمز المرسل إليك',
                                          "assets/lottie/Failuer.json",
                                          'تحقق',
                                          () {
                                            Navigator.pop(context);
                                            goTopagepush(
                                                context,
                                                VerifyUser(
                                                    username:
                                                        facebookEmail.trim()));
                                          },
                                        );
                                        //showMassage(context, 'لم يتم التحقق من البريد الالكتروني بعد, لقد تم ارسال رمز التحقق الي البريد المدخل', 'اكمال اجراء');
                                      } else if (value == "SocketException") {
                                        Navigator.pop(context);
                                        showMassage(
                                            context,
                                            'مشكلة في الانترنت',
                                            socketException);
                                      } else if (value == "TimeoutException") {
                                        Navigator.pop(context);
                                        showMassage(context, 'مشكلة في الخادم',
                                            timeoutException );
                                      } else if (value == "serverException") {
                                        Navigator.pop(context);
                                        showMassage(context, 'مشكلة في الخادم',
                                            serverException);
                                      }
                                    });
                                  }

//----------------------------------

                                } else if (result == "SocketException") {
                                  Navigator.pop(context);
                                  showMassage(context, 'مشكلة في الانترنت',
                                      socketException);
                                } else if (result == "TimeoutException") {
                                  Navigator.pop(context);
                                  showMassage(context, 'مشكلة في الخادم',
                                      timeoutException );
                                } else if (result == "serverException") {
                                  Navigator.pop(context);
                                  showMassage(context, 'مشكلة في الخادم',
                                      serverException);
                                }
                              });
                            }, facebookImage),
                          ],
                        ),
                        SizedBox(
                          height: 34.h,
                        ),
//have Account buttom-----------------------------------------------------------
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                text(context, "ليس لديك حساب بالفعل؟", textTitleSize,
                                    Colors.black87),
                                SizedBox(
                                  width: 7.w,
                                ),
                                InkWell(
                                    child: text(
                                        context, "انشاء حساب", textTitleSize, Colors.grey),
                                    onTap: () {
                                      goTopageReplacement(context, SingUp());
                                    }),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 27.h,
                        ),
//----------------------------------------------------------------------------------------------------------------------
                      ],
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }

//-------------------------------------------------------
  Widget rememberMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // SizedBox(
            //   width: 5.w,
            // ),
            InkWell(
                child: Icon(Icons.check_box_rounded,
                    color: isChckid ? purple.withOpacity(0.5) : Colors.grey,
                    size: 23.sp),
                onTap: () {
                  setState(() {
                    isChckid = !isChckid;
                  });
                }),
            SizedBox(
              width: 4.w,
            ),
            text(context, 'تذكرني', 17.sp, Colors.black87),
          ],
        ),
        // SizedBox(
        //   width: 180.w,
        // ),
        InkWell(
            onTap: () {
              goTopagepush(context, SendEmail());
            },
            child: text(context, 'نسيت كلمة المرور؟', 17.sp, Colors.black87)),
      ],
    );
  }

//==================================
  Widget singInVi() {
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
              "او تسجيل الدخول من خلال",
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

  _login() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      DatabaseHelper.saveFacebookAccessUserEmail(userData['email']);
    } else if (result.status == LoginStatus.cancelled) {
      print('operation cancel');
    } else if (result.status == LoginStatus.failed) {
      print('operation failed');
    }
  }
}
