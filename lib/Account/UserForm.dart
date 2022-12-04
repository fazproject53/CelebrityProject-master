import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Singup.dart';
import 'package:email_validator/email_validator.dart';

//
class PasswordValidatorStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = ' 8 احرف علي الاقل ';
  @override
  final String uppercaseLetters = ' حرف كبير واحد على الاقل  ';
  @override
  final String numericCharacters = ' رقم واحد على الاقل ';
  @override
  final String specialCharacters = ' رمز واحد على الاقل ';
  @override
  final String normalLetters = ' حرف صغير واحد على الاقل ';

}



// GlobalKey<FormState> userKey = GlobalKey();
// GlobalKey<FormState> celebratyKey = GlobalKey();
// int userContry = 0, celContry = 0, celCatogary = 0;
// bool isVisibility = true;
// bool isVisibilityNew = true;
String? emptyPrice(value) {
  if (value.isEmpty) {
    return "حقل اجباري";
  }
  if (int.parse(value) <= 0) {
    return "سعر الاعلان يجب ان يكون اكبر من ال 0";
  }
  return null;
}

String? empty(value) {
  if (value.isEmpty) {
    return "حقل اجباري";
  }
  return null;
}

String? code(value) {
  if (value.isEmpty) {
    return "حقل اجباري";
  }
  if (value.length != 6) {
    return "عليك ادخال 6 ارقام";
  }
  return null;
}

String? userName(value) {
  if (value.isEmpty) {
    return "حقل اجباري";
  }
  if (value.length < 4) {
    return "يجب ان يكون اسم المستخدم علي الاقل 4 خانات";
  }
  return null;
}

String? valedEmile(value) {
  if (value.trim().isEmpty) {
    return "حقل اجباري";
  }

  if (EmailValidator.validate(value.trim()) == false) {
    return "البريد الالكتروني غير صالح";
  }
  return null;
}

String? valedpass(value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-_!%*&^$#?@]).{0,}$';
  RegExp regExp = RegExp(pattern);
  if (value.trim().isEmpty) {
    return "حقل اجباري";
  }
  if (regExp.hasMatch(value) == false) {
    return "لحماية حسابك اختر حرف صغير، كبير، رقم ورمز";
  }

  if (value.length < 8) {
    return "كلمة المرور يجب ان تكون 8 خانات على الاقل";
  }


  return null;
}

String? valedphone(value) {
  if (value.trim().isEmpty) {
    return "حقل اجباري";
  }
  if (value.startsWith('0')) {
    return 'رقم الجوال يجب ان لا يبدا بالرقم 0';
  }
  if (!value.startsWith('5')) {
    return 'رقم الجوال يجب ان  يبدا بالرقم 5';
  }
  if (value.length != 9) {
    return "رقم الجوال يجب ان يتكون من 9 ارقام";
  }

  return null;
}

//------------------------------------------------------------------------------------------
// userForm(context, List<String> countries) {
//   return Form(
//     key: userKey,
//     child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
// //name------------------------------------------
//       textField(
//         context,
//         nameIcon,
//         "اسم المستخدم",
//         14,
//         false,
//         userNameUserController,
//         empty,
//         keyboardType: TextInputType.text,
//         inputFormatters: [
//           FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]'),
//               allow: true)
//         ],
//       ),
//       SizedBox(
//         height: 15.h,
//       ),
//
// //email------------------------------------------
//       textField(
//         context,
//         emailIcon,
//         "البريد الالكتروني",
//         14,
//         false,
//         emailUserController,
//         valedEmile,
//         keyboardType: TextInputType.emailAddress,
//         inputFormatters: [
//           FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]|[-]'),
//               allow: true)
//         ],
//       ),
//       SizedBox(
//         height: 15.h,
//       ),
//       //pass------------------------------------------
//       textField3(context, Icons.lock,  "كلمة المرور", 14,
//           isVisibilityNew, passUserController, valedpass,
//           keyboardType: TextInputType.text,
//           suffixIcon: IconButton(
//             onPressed: () {
//               setState(() {
//                 isVisibilityNew = !isVisibilityNew;
//               });
//             },
//             icon: Icon(
//                 isVisibilityNew
//                     ? Icons.visibility
//                     : Icons.visibility_off,
//                 color: newGrey,
//                 size: 25.sp),
//           )),
//
//
//
//       // textField3(context, passIcon, "كلمة المرور", 14, true, passUserController,
//       //     valedpass,),
//       SizedBox(
//         height: 15.h,
//       ),
// //country------------------------------------------
//       drowMenu("الدولة", countryIcon, 14, countries, (va) {
//         userContry = countries.indexOf(va!) + 1;
//       }, (val) {
//         if (val == null) {
//           return "اختر الدولة";
//         } else {
//           return null;
//         }
//       }),
//       //getMen(),
//       SizedBox(
//         height: 15.h,
//       ),
//     ]),
//   );
// }

//CELEBRITY FORM-----------------------------------------------------------
// celebratyForm(context, List<String> countries, List<String> catogary) {
//   return Form(
//     key: celebratyKey,
//     child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
// //name------------------------------------------
//       textField(
//         context,
//         nameIcon,
//         "اسم المستخدم",
//         14,
//         false,
//         userNameCeleController,
//         empty,
//         keyboardType: TextInputType.text,
//         inputFormatters: [
//           FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]'),
//               allow: true)
//         ],
//       ),
//       SizedBox(
//         height: 15.h,
//       ),
//       //email------------------------------------------
//       textField(
//         context,
//         emailIcon,
//         "البريد الالكتروني",
//         14,
//         false,
//         emailCeleController,
//         valedEmile,
//         keyboardType: TextInputType.emailAddress,
//         inputFormatters: [
//           FilteringTextInputFormatter(RegExp(r'[a-zA-Z]|[@]|[_]|[0-9]|[.]|[-]'),
//               allow: true)
//         ],
//       ),
//       SizedBox(
//         height: 15.h,
//       ),
//       //pass------------------------------------------
//     textField3(context, Icons.lock,  "كلمة المرور", 14,
//           isVisibilityNew, passCeleController, valedpass,
//           keyboardType: TextInputType.text,
//           suffixIcon: IconButton(
//             onPressed: () {
//               setState(() {
//                 isVisibilityNew = !isVisibilityNew;
//               });
//             },
//             icon: Icon(
//                 isVisibilityNew
//                     ? Icons.visibility
//                     : Icons.visibility_off,
//                 color: newGrey,
//                 size: 25.sp),
//            )),
// //       textField(context, passIcon, "كلمة المرور", 14, true, passCeleController,
// //           valedpass),
//       SizedBox(
//         height: 15.h,
//       ),
// //country------------------------------------------
//       drowMenu("الدولة", countryIcon, 14, countries, (va) {
//         celContry = countries.indexOf(va!) + 1;
//       }, (val) {
//         if (val == null) {
//           return "اختر الدولة";
//         } else {
//           return null;
//         }
//       }),
//
// //catogary------------------------------------------
//
//       SizedBox(
//         height: 15.h,
//       ),
//
//       drowMenu("التصنيف", catogaryIcon, 14, catogary, (va) {
//         celCatogary = catogary.indexOf(va!) + 1;
//       }, (val) {
//         if (val == null) {
//           return "اختر التصنيف";
//         } else {
//           return null;
//         }
//       }),
//
//       SizedBox(
//         height: 15.h,
//       ),
//     ]),
//   );
// }
