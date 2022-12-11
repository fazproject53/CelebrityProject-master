import 'package:celepraty/Account/logging.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Models/Methods/method.dart';
import '../UserForm.dart';
import 'Reset.dart';
import 'ResetNewPassword.dart';
import 'VerifyToken.dart';

class PasswordCoding extends StatefulWidget {
  final String? userNameEmail;

  const PasswordCoding({Key? key, this.userNameEmail}) : super(key: key);

  @override
  _PasswordCodingState createState() => _PasswordCodingState();
}

class _PasswordCodingState extends State<PasswordCoding> with RestorationMixin {
  GlobalKey<FormState> codeKey = GlobalKey();
  RestorableTextEditingController codeController =
      RestorableTextEditingController();
  late Image image1;

  @override
  void initState() {
    print(widget.userNameEmail!);
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                text(
                  context,
                  'التحقق من الرمز المدخل',
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
                    height: 160.h,
                    margin: EdgeInsets.all(9.w),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/image/code.png')),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
//title---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: text(
                    context,
                    'أدخل رمز التحقق المرسل الي رقم جوالك والمكون من 6 ارقام',
                    17,
                    Colors.black87,
                    //fontWeight: FontWeight.bold,
                    align: TextAlign.right,
                  ),
                ),
//code Text field---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: Form(
                      key: codeKey,
                      child: textField(
                        context,
                        Icons.lock,
                        "رمز التحقق",
                        textFieldSize,
                        false,
                        codeController.value,
                        code,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      )),
                ),
//reSend message ---------------------------------------------------------------
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 20.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        children: [
                          text(context, "لم يصل رمز التحقق؟", textFieldSize,
                              Colors.black87),
                          SizedBox(
                            width: 7.w,
                          ),
                          InkWell(
                              child: text(context, "إعادة ارسال", textFieldSize, pink),
                              onTap: () {
                                forgetPassword(widget.userNameEmail!);
                              }),
                        ],
                      ),

                    ],
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
                      "تحقق",
                      15,
                      white,
                      () {
                        //remove focus from textField when click outside
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (codeKey.currentState?.validate() == true) {
                          verifyCode(widget.userNameEmail!,
                              int.parse(codeController.value.text));
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
  //---------------------------------------------------------------------

  void forgetPassword(String username) async {
    loadingDialogue(context);
    getCreatePassword(username).then((result) {
      if (result == true) {
        Navigator.pop(context);
        showMassage(context, 'استعادة كلمة المرور',
            'تم ارسال رمز التحقق الى رقم الجوال الخاص بك',
            done: done);
      } else {
        Navigator.pop(context);
        showMassage(context, 'بيانات غير صحيحة', 'المستخدم غير موجود');
      }
    });
  }

//-------------------------------------------------------------------------------
  Future<String?> verifyCode(String username, int code) async {
    loadingDialogue(context);
    getVerifyCode(username, code).then((sendCode) async {
      if (sendCode == 'not verified') {
        Navigator.pop(context);
        showMassage(
            context, 'بيانات غير صحيحة', 'رمز التحقق خاطئ او منتهي الصلاحية');
      } else if (sendCode == "SocketException") {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الانترنت', socketException);
      } else if (sendCode == "TimeoutException") {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الخادم', timeoutException);
      } else if (sendCode == 'serverException') {
        Navigator.pop(context);
        showMassage(context, 'مشكلة في الخادم', serverException);
      } else {
        //Navigator.pop(context);
        verifyToken();
      }
    });
  }

//-----------------------------------------------------------------------------------------------
  void verifyToken() async {
    getVerifyToken(forgetToken).then((sendToken) async {
      if (sendToken == true) {
        Navigator.pop(context);
        goTopagepush(
            context,
            ResetNewPassword(
                code: int.parse(codeController.value.text),
                username: widget.userNameEmail));
      } else {
        Navigator.pop(context);

        showMassage(context, 'استعادة كلمة المرور',
            'انتهت المدة الزمنية لصلاحية الدخول');
        goTopageReplacement(context, Logging());
      }
    });
  }

  @override
  // TODO: implement restorationId
  String? get restorationId => 'code';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(codeController, 'codeNumber');
  }
//Edit phone number============================================================================
  void editPhone(String userNameEmail) {


  }

}
/*
*
* */
