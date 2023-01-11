//================ convert hex colors to rgb colors================
import 'dart:core';
import 'dart:io';
import 'package:celepraty/Models/Methods/classes/GradientIcon.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path/path.dart' as path;

//=============================== check connection===============================
String serverException = 'يوجد خطأ بالخادم سيتم إصلاحه قريبا';
String timeoutException = 'انتهت المدة المحددة لجلب البيانات حاول لاحقا';
String socketException = 'لايوجد اتصال بالانترنت';

//===============================Text===============================
Widget text(context, String key, double fontSize, Color color,
    {family = "Cairo",
    align = TextAlign.right,
    double space = 0,
    FontWeight fontWeight = FontWeight.normal,
    decoration = TextDecoration.none,
    overFlow,
    direction = null}) {
  return Text(
    key,
    textAlign: align,
    //softWrap: false,
    style: TextStyle(
      color: color,
      overflow: overFlow,
      fontFamily: family,
      decoration: decoration,
      fontSize: fontSize.sp,
      letterSpacing: space.sp,
      fontWeight: fontWeight,
    ),
    textDirection: direction,
  );
}

///
///Flushbar
Widget flushBar(context, String title, String message, icon) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Flushbar(
      titleText: Text(
        title,
        style: TextStyle(
          color: purple,
          fontFamily: 'Cairo',
          fontSize: 12.sp,
        ),
      ),
      messageText: Text(message),
      borderRadius: BorderRadius.circular(10.r),
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(5),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(seconds: 5),
      backgroundColor: white,
      icon: icon,
    )..show(context),
  );
}

//===============================container===============================
Widget container(double height, double width, double marginL, double marginR,
    Color color, Widget child,
    {double blur = 0.0,
    Offset offset = Offset.zero,
    double spShadow = 0.0,
    double pL = 0.0,
    double pR = 0.0,
    double pT = 0.0,
    double pB = 0.0,
    double marginT = 0.0,
    double marginB = 0.0,
    double bottomLeft = 0.0,
    double topRight = 0.0,
    double topLeft = 0.0,
    double bottomRight = 0.0}) {
  return Container(
    padding: EdgeInsets.only(left: pL.w, right: pR.w, top: pT.h, bottom: pB.h),
    width: width.w,
    height: height.h,
    margin: EdgeInsets.only(
        left: marginL.w, right: marginR.w, top: marginT.h, bottom: marginB.h),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(bottomLeft),
            topRight: Radius.circular(topRight),
            topLeft: Radius.circular(topLeft),
            bottomRight: Radius.circular(bottomRight)),
        color: color,
        boxShadow: [
          BoxShadow(blurRadius: blur, offset: offset, spreadRadius: spShadow)
        ]),
    child: child,
  );
}

//gradient contaner------------------------------------------------------------------
Widget gradientContainer(double width, Widget child,
    {bool gradient = false,
    double height = 45,
    Color color = deepBlack,
    double bottomLeft = 4.0,
    double topRight = 4.0,
    double topLeft = 4.0,
    double bottomRight = 4.0}) {
  return Container(
    width: width.w,
    height: height.h,
    child: child,
    decoration: BoxDecoration(
      border: Border.all(color: color, width: 0.92.r),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeft.r),
          topRight: Radius.circular(topRight.r),
          topLeft: Radius.circular(topLeft),
          bottomRight: Radius.circular(bottomRight.r)),
      gradient: gradient == false
          ? const LinearGradient(
              begin: Alignment(0.5, 2.0),
              end: Alignment(-0.69, -1.0),
              colors: [
                Color(0xffe468ca),
                Color(0xff0ab3d0),
              ],
              stops: [0.0, 1.0],
            )
          : null,
    ),
  );
}

Widget gradientContainerNoborder(double width, Widget child,
    {height = 40.0, double reids = 4.0, double blurRadius = 5}) {
  return Container(
    width: width.w,
    child: child,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: darkWhite, blurRadius: blurRadius, offset: Offset(2, 3))
      ],
      borderRadius: BorderRadius.circular(reids.r),
      gradient: const LinearGradient(
        begin: Alignment(0.5, 2.0),
        end: Alignment(-0.69, -1.0),
        colors: [
          Color(0xffe468ca),
          Color(0xff0ab3d0),
        ],
        stops: [0.0, 1.0],
      ),
    ),
  );
}
//==================== container with no shadow ===========================

Widget gradientContainerNoborder2(double width, double height, Widget child) {
  return Container(
    width: width.w,
    child: child,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      gradient: const LinearGradient(
        begin: Alignment(0.5, 2.0),
        end: Alignment(-0.69, -1.0),
        colors: [
          Color(0xffe468ca),
          Color(0xff0ab3d0),
        ],
        stops: [0.0, 1.0],
      ),
    ),
  );
}

Widget gradientContainerWithHeight(double width, double height, Widget child) {
  return Container(
    width: width.w,
    height: height.h,
    child: child,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0.r),
          topLeft: Radius.circular(10.0.r),
        ),
        color: lightGrey),
  );
}
//solid: contaner------------------------------------------------------------------

Widget solidContainer(double width, Color color, Widget child) {
  return Container(
    width: width.w,
    // height: height.h,

    child: child,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
//============================profile buttons for listView ========================

Widget addListViewButton(String text, IconData icon, int index, {bool? done}) {
  return Row(children: [
    padding(
      0,
      5,
      SizedBox(
          child: Icon(
        icon,
        color: purple,
      )),
    ),
    const SizedBox(
      width: 10,
    ),
    Expanded(
      flex: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: black, fontSize: textTitleSize.sp),
          ),
          done != null
              ? done == false
                  ? Padding(
                      padding: EdgeInsets.only(right: 0.w),
                      child: SizedBox(
                          height: 33.h,
                          width: 33.w,
                          child: Lottie.asset('assets/lottie/requerd.json')),
                    )
                  : SizedBox()
              : SizedBox()
        ],
      ),
    ),
  ]);
}
//=============================Padding Widget=================================

Widget padding(double left, double right, Widget child) {
  return Padding(
    padding: EdgeInsets.only(left: left.w, right: right.w),
    child: child,
  );
}

Widget paddingg(double pL, double pR, double pT, Widget child,
    {double pB = 0.0}) {
  return Padding(
    padding: EdgeInsets.only(left: pL.w, right: pR.w, top: pT.h, bottom: pB.h),
    child: child,
  );
}

//=================================Buttoms=============================
Widget buttoms(context, String key, double fontSize, Color textColor, onPressed,
    {Color backgrounColor = transparent,
    double horizontal = 0.0,
    double vertical = 0.0,
    double evaluation = 0.0}) {
  return TextButton(
    onPressed: onPressed,
    child: text(context, key, fontSize, textColor),
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(evaluation),
      backgroundColor: MaterialStateProperty.all(backgrounColor),
      foregroundColor: MaterialStateProperty.all(textColor),
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.h)),
    ),
  );
}

//===============================Go To page(push)===============================
goTopagepush(context, pageName) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => pageName));
}

//===============================Go To page(restor data)===============================
goToPageRestore(
  context,
  pageFunction,
) {
  return Navigator.restorablePush(
      context, (context, arguments) => pageFunction());
}

//===============================Go To page(pushReplacement)===============================
goTopageReplacement(BuildContext context, pageName) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => pageName));
}

//===============================Go To page(push)===============================
goToPagePushRefresh(context, pageName, {then}) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => pageName)).then(then);
}

//get heghit and width===============================================================
Size getSize(context) {
  return MediaQuery.of(context).size;
}

//=============================TextFields=================================
Widget textField(context, icons, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: mycontroller,
    style: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
    decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
        fillColor: textGray,
        labelStyle: TextStyle(color: Colors.black87, fontSize: 15.0.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        prefixIcon: Icon(icons, color: newGrey, size: 25.sp),
        labelText: key,
        errorStyle: TextStyle(color: Colors.red, fontSize: 13.0.sp),
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//=============================TextFields=================================
Widget textField3(context, icons, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    suffixText,
    void Function()? onTap,
    colorBorder,
    void Function(String s)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    onTap: onTap,
    onChanged: onChanged,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: mycontroller,
    style: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
    decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
        fillColor: textGray,
        labelStyle: TextStyle(color: Colors.black87, fontSize: 15.0.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: colorBorder ?? textGray,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: colorBorder ?? textGray,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(
            color: colorBorder ?? textGray,
            width: 1.0,
          ),
        ),
        prefixIcon: Icon(icons, color: newGrey, size: 25.sp),
        suffixText: suffixText,
        suffixStyle: TextStyle(fontSize: 14.sp),
        labelText: key,
        errorStyle: TextStyle(color: Colors.red, fontSize: 13.0.sp),
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//=============================TextFields price=================================
Widget textField2(context, icons, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    onTap,
    hitText,
    bool isEdit = true,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    enabled: isEdit,
    onTap: onTap,
    validator: myvali,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: mycontroller,
    style: TextStyle(color: deepgrey, fontSize: fontSize.sp),
    decoration: InputDecoration(
        isDense: true,
        filled: true,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: deepgrey, fontSize: 12.0.sp),
        fillColor: white,
        labelStyle: TextStyle(color: deepgrey, fontSize: 12.0.sp),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: pink, width: 1.0.r),
          borderRadius: BorderRadius.circular(10.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: pink, width: 1.0.r),
          borderRadius: BorderRadius.circular(10.r),
        ),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: pink, width: 1.0.r),
            borderRadius: BorderRadius.circular(10.r)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: pink, width: 1.0.r),
            borderRadius: BorderRadius.circular(10.r)),
        prefixIcon: Icon(icons, color: pink, size: 25.sp),
        labelText: key,
        hintText: hitText,
        errorStyle: TextStyle(color: Colors.red, fontSize: 10.0.sp),
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//SingWith bouttom------------------------------------------------------------------
Widget singWithsButtom(
    context, String key, Color textColor, Color backColor, onPressed, image) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      height: 45.h,
      width: 45.w,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
            )
          ],
          color: backColor,
          image: DecorationImage(
              image: AssetImage(
                image,
              ),
              fit: BoxFit.contain),
          borderRadius: BorderRadius.all(Radius.circular(5.r))),
    ),
  );
}

Widget textFieldNoIcon(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali, isOptional,
    {List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    onTap,
    onEditCom,
    onTap2,
    Widget? child,
    bool underline = false,
    bool disable = true}) {
  return Container(
    // height: 50.h,
    child: TextFormField(
      onChanged: onTap,
      onTap: onTap2,
      onEditingComplete: onEditCom,
      obscureText: hintPass,
      validator: myvali,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: mycontroller,
      enabled: disable,
      style: TextStyle(
          color: black,
          fontSize: fontSize.sp,
          fontFamily: 'Cairo',
          decoration: underline ? TextDecoration.underline : null),
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
          helperText: isOptional ? 'اختياري' : null,
          helperStyle: TextStyle(
              color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          hintStyle: TextStyle(
              color: grey,
              fontSize: fontSize.sp,
              fontFamily: 'Cairo',
              decoration: TextDecoration.none),
          fillColor: lightGrey.withOpacity(0.10),
          labelStyle: TextStyle(color: black, fontSize: fontSize.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: purple, width: 1.w)),
          suffixIcon: child,
          hintText: key,
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

///text field iban
Widget textFieldIban(
  context,
  String key,
  String label,
  double fontSize,
  bool hintPass,
  TextEditingController mycontroller,
  myvali,
  isOptional, {
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  onChanged,
}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    controller: mycontroller,
    onChanged: onChanged,
    style: TextStyle(
        color: black,
        fontSize: fontSize.sp,
        fontFamily: 'Cairo',
        letterSpacing: 2),
    decoration: InputDecoration(
        isDense: false,
        filled: true,
        errorStyle: TextStyle(fontSize: 12.sp),
        helperText: isOptional ? 'اختياري' : null,
        helperStyle:
            TextStyle(color: pink, fontSize: fontSize.sp, fontFamily: 'Cairo'),
        hintStyle:
            TextStyle(color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
        fillColor: white,
        labelStyle: TextStyle(color: black, fontSize: fontSize.sp),
        hintText: key,
        labelText: label,
        contentPadding: EdgeInsets.all(10.h)),
  );
}

///the long one
Widget textFieldNoIconWhite(context, String key, double fontSize, bool hintPass,
    TextEditingController myController, myValidation,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myValidation,
    onTap: onTap,
    autofocus: false,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    controller: myController,
    style: TextStyle(color: black, fontSize: 14.sp),
    decoration: InputDecoration(
      isDense: true,
      filled: true,
      hintStyle: TextStyle(color: grey, fontSize: 14.sp),
      fillColor: white,
      labelStyle: TextStyle(color: grey, fontSize: 14.sp),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: purple, width: 4.w)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        borderSide: BorderSide(width: 1.w, color: grey!.withOpacity(0.8)),
      ),
      labelText: key,
      hintText: '0000 0000 0000 0000',
    ),
  );
}

///text field with width
Widget textFieldWhiteWidth(context, String key, String hintKey, double fontSize,
    bool hintPass, TextEditingController myController, myValidation,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return SizedBox(
    width: 140.w,
    child: TextFormField(
      obscureText: hintPass,
      validator: myValidation,
      onTap: onTap,
      autofocus: false,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      controller: myController,
      style: TextStyle(color: black, fontSize: 14.sp),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        hintStyle: TextStyle(color: grey, fontSize: 14.sp),
        fillColor: white,
        labelStyle: TextStyle(color: grey, fontSize: 14.sp),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: purple, width: 4.w)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          borderSide: BorderSide(width: 1.w, color: grey!.withOpacity(0.8)),
        ),
        labelText: key,
        hintText: hintKey,
      ),
    ),
  );
}

///Text Field small
Widget textFieldSmall(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    focusNode})

///The icons will be optional

{
  return SizedBox(
    width: 140.w,
    child: TextFormField(
      validator: myvali,
      controller: mycontroller,
      textAlign: TextAlign.center,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      focusNode: focusNode,
      style:
          TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: textColor,
          labelStyle: TextStyle(
            color: white,
            fontSize: fontSize.sp,
          ),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: key,
          errorStyle: TextStyle(
            color: red!,
            fontSize: 10.sp,
            fontFamily: 'Cairo',
          ),
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

///Text Field small
Widget textFieldSmallRE(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {Widget? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    focusNode}) {
  ///The icons will be optional
  return SizedBox(
    height: 100.h,
    width: 130.w,
    child: TextFormField(
      validator: myvali,
      controller: mycontroller,
      textAlign: TextAlign.center,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofocus: false,
      focusNode: focusNode,
      style:
          TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
      decoration: InputDecoration(
          isDense: false,
          filled: true,
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: textColor,
          labelStyle: TextStyle(
            color: white,
            fontSize: fontSize.sp,
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none),
          hintText: key,
          errorStyle: TextStyle(
            color: red!,
            fontSize: 10.sp,
            fontFamily: 'Cairo',
          ),
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

//======================== for description multiline ====================
Widget textFieldDesc(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali,
    {InputCounterWidgetBuilder? counter,
    focusnode,
    double height = 200,
    onTap,
    int? maxLenth,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType}) {
  return SizedBox(
    height: height,
    child: TextFormField(
      buildCounter: counter,
      controller: mycontroller,
      keyboardType: TextInputType.multiline,
      validator: myvali,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: null,
      minLines: 10,
      onTap: onTap,
      maxLength: maxLenth,
      focusNode: focusnode,
      textAlignVertical: TextAlignVertical.top,
      style:
          TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
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
          hintStyle: TextStyle(
              color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
          fillColor: lightGrey.withOpacity(0.10),
          labelStyle: TextStyle(
            color: white,
            fontSize: fontSize.sp,
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: purple, width: 1)),
          hintText: key,
          contentPadding: EdgeInsets.all(10.h)),
    ),
  );
}

//============================ text feild curved from one side ==================================

Widget textFieldNoIcon2(context, String key, double fontSize, bool hintPass,
    TextEditingController mycontroller, myvali, onchanged,
    {String labelText = '', disable = true, onTap, inputf}) {
  return TextFormField(
    obscureText: hintPass,
    validator: myvali,
    onChanged: onchanged,
    controller: mycontroller,
    inputFormatters: inputf,
    enabled: disable,
    onTap: onTap,
    style: TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: newGrey,
            width: 0.5,
          ),
        ),
        isDense: false,
        filled: true,
        errorStyle: TextStyle(fontSize: 10.sp),
        hintStyle:
            TextStyle(color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
        fillColor: lightGrey.withOpacity(0.10),
        labelStyle: TextStyle(color: grey, fontSize: fontSize.sp),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        )),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: purple, width: 1)),
        hintText: key,
        labelText: labelText,
        contentPadding: EdgeInsets.all(10.h)),
  );
}

Widget textFeildWithButton(context, child1, child2, {child3}) {
  return paddingg(
    15,
    15,
    0,
    SizedBox(
      width: getSize(context).width,
      height: child3 != null ? 65.h : 63.h,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 4,
            child: paddingg(
              0,
              0,
              0,
              Container(width: getSize(context).width / 1.2, child: child1),
            ),
          ),
          Expanded(
            flex: 1,
            child: paddingg(
                0,
                0,
                0,
                child3 != null
                    ? Column(
                        children: [child2, child3],
                      )
                    : child2),
          ),
        ],
      ),
    ),
  );
}
//============================ show bottomsheet takes a column ==============================

void showBottomSheetWhite(context, bottomMenu) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 350.h,
            child: bottomMenu,
          ),
        );
      });
}

void showBottomSheetWhite2(context, bottomMenu) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 400.h,
            child: bottomMenu,
          ),
        );
      });
}

Widget uploadImg(double width, double hight, child, onTap) {
  return InkWell(
    child: Container(
      width: width.w,
      height: hight.h,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientIcon(attach, 30.w,
                const LinearGradient(colors: <Color>[pink, blue])),
            child
          ]),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          border: Border.all(color: black)),
    ),
    onTap: onTap,
  );
}

//============================== Calendar ===========================================

Future<void> tableCalendar(context, dateTime) async {
  final DateTime picked = showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2025, 1, 1),
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
                colorScheme:
                    const ColorScheme.light(primary: purple, onPrimary: white)),
            child: child!);
      }) as DateTime;
  if (picked != null && picked != dateTime) {
    dateTime = picked;
  }
}

//====================== image file picker ===================================
Future pickImage(imagee) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final temp = File(image.path);
    imagee = temp;
  } on PlatformException catch (e) {
    print('could not pick image $e');
  }
}

Widget buildCkechboxList22(list) {
  List<Widget> w = [];
  Widget cb;
  for (var i = 0; i < list.length; i++) {
    cb = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            Checkbox(value: false, onChanged: (value) {}),
            Text(list[i])
          ],
        ),
      ),
    );
    w.add(cb);
  }

  return Row(mainAxisAlignment: MainAxisAlignment.start, children: w);
}

Widget buildCkechboxList2(list) {
  List<Widget> w = [];
  Widget cb;
  for (var i = 0; i < list.length; i++) {
    cb = Expanded(
      child: Row(
        children: [
          Checkbox(value: false, onChanged: (value) {}),
          Text(list[i])
        ],
      ),
    );
    w.add(cb);
  }

  return Row(mainAxisAlignment: MainAxisAlignment.start, children: w);
}

divider({
  double thickness = 2,
  double indent = 15,
  double endIndent = 15,
}) {
  return Align(
    alignment: Alignment.topCenter,
    child: VerticalDivider(
      color: Colors.grey[400],
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      //width: 12,
    ),
  );
}
//===============================Container===============================

//gradient color---------------------------------------------------------------------
LinearGradient gradient() {
  return const LinearGradient(
    begin: Alignment(0.5, 2.0),
    end: Alignment(-0.69, -1.0),
    colors: [
      Color(0xffe468ca),
      Color(0xff0ab3d0),
    ],
    stops: [0.0, 1.0],
  );
}

///on change text filed
Widget textFieldDescOnChange(context, String key, double fontSize,
    bool hintPass, TextEditingController mycontroller, myvali,
    {InputCounterWidgetBuilder? counter, int? maxLenth}) {
  return TextFormField(
    controller: mycontroller,
    buildCounter: counter,
    keyboardType: TextInputType.multiline,
    validator: myvali,
    maxLines: null,
    minLines: 3,
    maxLength: maxLenth,
    textAlignVertical: TextAlignVertical.top,
    style: TextStyle(color: black, fontSize: fontSize.sp, fontFamily: 'Cairo'),
    decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: newGrey,
            width: 0.5,
          ),
        ),
        isDense: false,
        filled: true,
        hintStyle:
            TextStyle(color: grey, fontSize: fontSize.sp, fontFamily: 'Cairo'),
        fillColor: lightGrey.withOpacity(0.10),
        labelStyle: TextStyle(
          color: white,
          fontSize: fontSize.sp,
        ),
        alignLabelWithHint: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: purple, width: 1)),
        hintText: key,
        contentPadding: EdgeInsets.all(10.h)),
  );
}

//============================ text field curved from one side ==================================

//Drow app bar----------------------------------------------------

drowAppBar(String title, BuildContext context,
    {color = white,
    IconData? download,
    onPressed,
    iconColor = Colors.black,
    bool? fromDevice}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
          fontSize: appbarText - 5.sp, fontFamily: 'Cairo', color: black),
    ),
    centerTitle: true,
    leading: IconButton(
      padding: EdgeInsets.only(right: 20.w),
      icon: const Icon(Icons.arrow_back_ios),
      color: iconColor,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: fromDevice == true
        ? []
        : [
            download != null
                ? Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: IconButton(
                      padding: EdgeInsets.only(right: 20.w),
                      icon: Icon(download),
                      color: Colors.black,
                      onPressed: onPressed,
                    ),
                  )
                : const Icon(
                    Icons.download,
                    size: 0,
                  ),
          ],
    backgroundColor: color,
    elevation: 0,
  );
}

appBarNoIcon(
  String title,
  BuildContext context, {
  color = deepwhite,
}) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontSize: 22.sp, fontFamily: 'Cairo', color: black),
    ),
    centerTitle: true,
    backgroundColor: color,
    elevation: 0,
  );
}

drawAppBar(Widget title, BuildContext context,
    {Color color = deepwhite, onPressedd, iconColor}) {
  return AppBar(
    title: title,
    centerTitle: true,
    leading: IconButton(
      padding: EdgeInsets.only(right: 20.w),
      icon: const Icon(Icons.arrow_back_ios),
      color: iconColor == null ? Colors.black : iconColor,
      onPressed: onPressedd != null
          ? onPressedd
          : () {
              Navigator.pop(context);
            },
    ),
    backgroundColor: color,
    elevation: 0,
  );
}

///app bar without back icon
AppBarNoIcon(String title, {Color color = white}) {
  return AppBar(
    title: Text(
      title,
      style:
          TextStyle(fontSize: appbarText.sp, fontFamily: 'Cairo', color: black),
    ),
    centerTitle: true,
    backgroundColor: color,
    elevation: 0,
  );
}

///
///
class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      textStyle: TextStyle(
        color: white,
        fontSize: 12.sp,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}

void showBottomSheettInvoice(context, buttomMenue) {
  showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Container(
          height: 670.h,
          child: buttomMenue,
        );
      });
}

void showBottomSheett2(context, buttomMenue) {
  showModalBottomSheet(
      isScrollControlled: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          // margin: EdgeInsets.only(right: 10, left: 10),
          // color: Colors.transparent.withOpacity(0.5),
          height: 250.h,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                height: 180.h,
                child: buttomMenue,
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(8)),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: 45.h,
                    width: 400.w,
                    child: text(context, 'الغاء', 20, purple,
                        align: TextAlign.center),
                    decoration: BoxDecoration(
                        color: fillWhite,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      });
}

// combo box============================================================abstract
Widget drowMenu(
    String inisValue,
    IconData prefixIcon,
    double fontSize,
    List<String> item,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    {double width = double.infinity,
    valueItem}) {
  return DropdownButtonFormField2<String>(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
    hint: Text(
      inisValue,
      style: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
    ),
    //dropdownColor: black,
    items: item
        .map((type) => DropdownMenuItem(
              alignment: Alignment.centerRight,
              value: type,
              child: Text(
                type,
                style: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
                textAlign: TextAlign.right,
              ),
            ))
        .toList(),
    value: valueItem,
    decoration: InputDecoration(
        isDense: false,
        filled: true,
        prefixIcon: Icon(
          prefixIcon,
          color: newGrey,
        ),
        fillColor: textGray,
        alignLabelWithHint: true,
        errorStyle: TextStyle(color: Colors.red, fontSize: 14.0.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.all(10.h)),
    onChanged: onChanged,
    dropdownMaxHeight: 300.h,
    // dropdownWidth: 300.w,
    dropdownDecoration: BoxDecoration(
        color: white, borderRadius: BorderRadius.all(Radius.circular(4.r))),
    iconDisabledColor: newGrey,
    iconEnabledColor: newGrey,
    scrollbarAlwaysShow: true,
  );
}

// combo box============================================================abstract
Widget drowMenu2(
    String inisValue,
    IconData prefixIcon,
    double fontSize,
    List<String> item,
    void Function(String?)? onChanged,
    String? Function(String?)? validator,
    {double width = double.infinity,
    valueItem}) {
  return DropdownButtonFormField2<String>(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: validator,
    hint: Text(
      inisValue,
      style: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
    ),
    //dropdownColor: black,
    items: item
        .map((type) => DropdownMenuItem(
              alignment: Alignment.centerRight,
              value: type,
              child: Text(
                type,
                style: TextStyle(color: Colors.black87, fontSize: fontSize.sp),
                textAlign: TextAlign.right,
              ),
            ))
        .toList(),
    value: valueItem,
    decoration: InputDecoration(
        isDense: false,
        filled: true,
        prefixIcon: Icon(
          prefixIcon,
          color: newGrey,
        ),
        fillColor: textGray,
        alignLabelWithHint: true,
        errorStyle: TextStyle(color: Colors.red, fontSize: 14.0.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: const BorderSide(
            color: textGray,
            width: 1.0,
          ),
        ),
        contentPadding: EdgeInsets.all(10.h)),
    onChanged: onChanged,
    dropdownMaxHeight: 300.h,
    // dropdownWidth: 300.w,
    dropdownDecoration: BoxDecoration(
        color: white, borderRadius: BorderRadius.all(Radius.circular(4.r))),
    iconDisabledColor: newGrey,
    iconEnabledColor: newGrey,
    scrollbarAlwaysShow: true,
  );
}

//--------------------------------------------------------------
loadingDialogue(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
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
          ),
        );
      });
}

loadingRequestDialogue(context) {
  return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Center(
          child: WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              titlePadding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.only(top: 170.h),
              content: SizedBox(
                width: double.infinity,
                height: 150.h,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Lottie.asset("assets/lottie/grey.json",
                      fit: BoxFit.contain, height: 90.h),
                ),
              ),
            ),
          ),
        );
      });
}

//lode one card----------------------------------------------------------------------------
Widget lodeOneData({double height = 200, double width = 200}) {
  return Container(
    margin: EdgeInsets.only(left: 18.w, right: 18.w, bottom: 18.h),
    height: height.h,
    width: width.w,
    child: Shimmer(
        enabled: true,
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          // begin: Alignment(0.7, 2.0),
          //end: Alignment(-0.69, -1.0),
          colors: [mainGrey, Colors.white],
          stops: const [0.1, 0.88],
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.h),
            ),
          ),
        )),
  );
}

//----------------------------------------------------------------------------
Widget lodeManyCards() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Center(child: CircularProgressIndicator()),
  );
  // return GridView.builder(
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2, //عدد العناصر في كل صف
  //         crossAxisSpacing: 8.r, // المسافات الراسية
  //         childAspectRatio: 0.90.sp, //حجم العناصر
  //         mainAxisSpacing: 11.r //المسافات الافقية
  //
  //         ),
  //     itemCount: 10,
  //     itemBuilder: (context, i) {
  //       return SizedBox(
  //         width: 190.w,
  //         height: 200.h,
  //         child: Shimmer(
  //             enabled: true,
  //             gradient: LinearGradient(
  //               tileMode: TileMode.mirror,
  //               // begin: Alignment(0.7, 2.0),
  //               //end: Alignment(-0.69, -1.0),
  //               colors: [mainGrey, Colors.white],
  //               stops: const [0.1, 0.88],
  //             ),
  //             child: Card()),
  //       );
  //     });
}

//show no data----------------------------------------------------------------------
Widget noData(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.height / 4,
          child: Lottie.asset('assets/lottie/order.json')),
      Center(child: text(context, "لاتوجد طلبات لعرضها حاليا", 15, Colors.grey))
    ],
  );
}

Widget noExplorer(context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.height / 4,
          child: Lottie.asset('assets/lottie/noExplorer.json')),
      Center(
          child: text(context, "لاتوجد فيديوهات حاليا لعرضها", 15, Colors.grey))
    ],
  );
}

//showErrorMassage----------------------------------------------------------------------
showMassage(context, String titleText, String messageText, {IconData? done}) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: white,
    margin: EdgeInsets.symmetric(horizontal: 4.w),
    padding: const EdgeInsets.all(10),
    flushbarStyle: FlushbarStyle.FLOATING,
    borderRadius: BorderRadius.circular(5.r),
    forwardAnimationCurve: Curves.linearToEaseOut,
    reverseAnimationCurve: Curves.easeInOutCubicEmphasized,
    duration: const Duration(seconds: 6),
    leftBarIndicatorColor: done == null ? red : green,
    onTap: (bar) {
      bar.dismiss();
      //-----------------
    },
    icon: Icon(
      done ?? error,
      color: done == null ? red : green,
      size: 30,
    ),
    titleText: text(context, titleText, 16, done == null ? red! : green),
    messageText:
        text(context, messageText, 14, black, fontWeight: FontWeight.w200),
  ).show(context);
}
//----------------------------------------------------------------------

Widget firstLode(double width, double height,
    {double paddingT = 10,
    double paddingR = 10,
    double paddingL = 10,
    double paddingB = 10}) {
  return Padding(
    padding: EdgeInsets.only(
        top: paddingT, bottom: paddingB, right: paddingR, left: paddingL),
    child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) {
          return SizedBox(
            width: width.w,
            height: height.h,
            child: Shimmer(
                enabled: true,
                gradient: LinearGradient(
                  tileMode: TileMode.mirror,
                  // begin: Alignment(0.7, 2.0),
                  //end: Alignment(-0.69, -1.0),
                  colors: [mainGrey, Colors.white],
                  stops: const [0.1, 0.88],
                ),
                child: Card()),
          );
        }),
  );
}

//----------------------------------------------------------------------
successfullyDialog(
    context, String massage, String lottie, String bottomName, action,
    {double? height}) {
  return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.70),
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            elevation: 5,
            backgroundColor: white,
            contentPadding: EdgeInsets.only(top: 30.h, right: 10.w, left: 10.w),
            actionsPadding: EdgeInsets.zero,
            content: SizedBox(
              height: height ?? 200.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    lottie,
                    fit: BoxFit.cover,
                    //height: 90.h
                  ),
                  text(context, massage, 16, black, align: TextAlign.center),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Center(
                    child: buttoms(context, bottomName, 18, Colors.grey, action,
                        backgrounColor: white)),
              )
            ],
          ),
        );
      });
}
//------------------------------------------------------------------------

editPhoneDialog(
    context, String massage, String bottomName, action, action2, Widget body,
    {double? height}) {
  return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.70),
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              titlePadding: EdgeInsets.zero,
              elevation: 5,
              backgroundColor: white,
              contentPadding: EdgeInsets.only(top: 30.h, right: 10.w, left: 10.w),
              actionsPadding: EdgeInsets.zero,
              title: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Center(child: text(context, massage, 15, black)),
              ),
              content: SizedBox(
                height: height ?? 120.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    body,
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buttoms(context, bottomName, 18, Colors.white, action,
                          backgrounColor: pink),
                      SizedBox(width: 20.w),
                      buttoms(context, 'الغاء', 18, Colors.white, action2,
                          backgrounColor: Colors.grey)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}

//-------------------------------------------------------------------------

failureDialog(context, String massage, String subMassage, String lottie,
    String bottomName, action,
    {double? height, String title = 'الغاء', bottomColor}) {
  return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.70),
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            elevation: 5,
            backgroundColor: white,
            contentPadding: EdgeInsets.only(right: 11.w, left: 11.w),
            actionsPadding: EdgeInsets.zero,
            content: SizedBox(
              height: height ?? 160.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(lottie, height: 100.h, width: 100.h),
                  text(context, massage, 16, black, align: TextAlign.center),
                  text(context, subMassage, 14, black, align: TextAlign.center),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.h, left: 10.w, right: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///in case delete
                    buttoms(context, title, 16, white, () {
                      Navigator.pop(context);
                    }, backgrounColor: grey!.withOpacity(0.6)),
                    SizedBox(
                      width: 10.w,
                    ),

                    ///in case cancel
                    title == 'الغاء'
                        ? buttoms(context, bottomName, 16, white, action,
                            backgrounColor: bottomColor ?? red!.withOpacity(0.8))
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
        );
      });
}

//snackBar------------------------------------------------------------------------------------
SnackBar snackBar(context, String title, Color? color, IconData? icon) {
    return SnackBar(
      content: text(context,title, 15, white,
          align: TextAlign.center, fontWeight: FontWeight.bold),
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: getSize(context).height / 3, right: 100.w, left: 100.w),
      backgroundColor: Colors.black38,
      elevation: 20,
      duration: const Duration(milliseconds: 2500),
    );

}

//  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (BuildContext context) =>  ActivityScreen(move: 'nn',)),  (route) => route.isFirst),

gotoPageAndRemovePrevious(context, page) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => page),
      (route) => route.isFirst);
}

Widget mainLoad(context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height,
    width: 100.w,
    child: Padding(
      padding: EdgeInsets.only(bottom: 50.h),
      child: Lottie.asset('assets/lottie/grey.json', height: 200.h),
    ),
  );
}

//--------------------------------------------------------------------------
BoxDecoration decoration(String famusImage) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4.r)),
    image: DecorationImage(
      image: NetworkImage(famusImage),
      colorFilter: ColorFilter.mode(black.withOpacity(0.4), BlendMode.darken),
      fit: BoxFit.cover,
    ),
  );
}

//--------------------------------------------------------------------------
BoxDecoration decoration2() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4.r)),
  );
}

//check internet Connection--------------------------------------------------------------------------
Widget internetConnection(context, {reload}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.height / 6,
          child: Lottie.asset('assets/lottie/internetConection.json')),
      SizedBox(
        height: 10.h,
      ),
      text(context, socketException, 16, black, align: TextAlign.center),
      SizedBox(
        height: 25.h,
      ),
      buttoms(context, 'إعادة تحميل', 14, black, reload,
          backgrounColor: grey!, horizontal: 20),
      Spacer(),
    ],
  );
}

Widget serverError(context, {reload}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      SizedBox(
        // height: MediaQuery.of(context).size.height / 5,
        // width: MediaQuery.of(context).size.height / 6,
        child: Lottie.asset('assets/lottie/srver.json'), height: 200.h,
        width: 500.w,
      ),
      SizedBox(
        height: 10.h,
      ),
      text(context, serverException, 16, black, align: TextAlign.center),
      SizedBox(
        height: 15.h,
      ),
      Spacer(),
    ],
  );
}

//check server Exception--------------------------------------------------------------------------
Widget checkServerException(context, {reload}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      SizedBox(
          // height: MediaQuery.of(context).size.height / 5,
          // width: MediaQuery.of(context).size.height / 5,
          child: Lottie.asset('assets/lottie/server.json',
              height: 300.h, width: 300.w)),
      // SizedBox(
      //   height: 10.h,
      // )
      text(context, serverException, 18, black, align: TextAlign.center),
      SizedBox(
        height: 5.h,
      ),
      buttoms(context, 'إعادة تحميل', 14, black, reload,
          backgrounColor: grey!, horizontal: 20),
      Spacer(),
    ],
  );
}

//check timeOut Exception--------------------------------------------------------------------------
Widget checkTimeOutException(context, {reload}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Spacer(),
      SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.height / 5,
          child: Lottie.asset('assets/lottie/timeout1.json')),
      SizedBox(
        height: 10.h,
      ),
      text(context, timeoutException, 20, black, align: TextAlign.center),
      SizedBox(
        height: 5.h,
      ),
      buttoms(context, 'إعادة تحميل', 14, black, reload,
          backgrounColor: grey!, horizontal: 20),
      Spacer(),
    ],
  );
}

//show waitingData-------------------------------------------------------------
Widget waitingData(double height, double width) {
  return SizedBox(
    height: height.h,
    width: width.w,
    child: Shimmer(
        enabled: true,
        gradient: LinearGradient(
          tileMode: TileMode.mirror,
          // begin: Alignment(0.7, 2.0),
          //end: Alignment(-0.69, -1.0),
          colors: [mainGrey, Colors.white],
          stops: const [0.1, 0.88],
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5.h),
            ),
          ),
        )),
  );
}

//===========================================================================
snack(context, String text2) {
  return SnackBar(
    content: text(context, text2, 15, white,
        align: TextAlign.center, fontWeight: FontWeight.bold),
    shape: const StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
        bottom: getSize(context).height / 3, right: 100.w, left: 100.w),
    backgroundColor: Colors.black38,
    elevation: 20,
    duration: const Duration(milliseconds: 2500),
  );
}

//=============================================================================
Directory? directory;
Future getExistImage(imageUrl) async {
  directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  File f = Platform.isAndroid
      ? File(directory!.path + '/منصات المشاهير/' + path.basename(imageUrl))
      : File(directory!.path +'/'+ path.basename(imageUrl));
  if (f.existsSync()) {
    return f.path;
  } else {
    return false;
  }
}
