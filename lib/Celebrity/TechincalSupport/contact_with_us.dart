///import section
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:celepraty/Account/logging.dart' as login;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Account/LoggingSingUpAPI.dart';
import 'ComplaintTypes.dart';

///----------------------------ContactWithUsHome----------------------------
class ContactWithUsHome extends StatefulWidget {
  const ContactWithUsHome({Key? key}) : super(key: key);

  @override
  _ContactWithUsHomeState createState() => _ContactWithUsHomeState();
}

class _ContactWithUsHomeState extends State<ContactWithUsHome> {
  ///Text Field
  final TextEditingController supportTitle = TextEditingController();
  final TextEditingController supportDescription = TextEditingController();

  ///formKey
  final _formKey = GlobalKey<FormState>();

  ///Model Value
  Future<ComplaintTypes>? contactModel;

  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];

  var complaintList = [];

  String complaintText = 'اختر نوع المساعدة';

  ///_value
  var _selectedTest;
  onChangeDropdownTests(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest = selectedTest;
    });
  }

  String? userToken;

  bool activeConnection = true;
  String T = "";

  @override
  void initState() {
    _dropdownTestItems = buildDropdownTestItems(complaintList);
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        contactModel = getComplaintTypes();
      });
    });
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
          value: i,
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(alignment: Alignment.centerRight,child: Text(i['keyword'], textAlign: TextAlign.start,))),

        ),
      );
    }
    return items;
  }

  bool isConnectSection = true;
  bool timeoutException1 = true;
  bool serverExceptions = true;

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: drowAppBar("طلب مساعدة", context),
        body: activeConnection
            ? SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ///Title
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.h, right: 20.w),
                                      child: text(
                                          context,
                                          " ",
                                          20,
                                          ligthtBlack,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  ///--------------------------Text Field Section--------------------------
                                  ///Dropdown Below
                                  FutureBuilder(
                                      future: contactModel,
                                      builder: ((context,
                                          AsyncSnapshot<ComplaintTypes>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return paddingg(
                                            15,
                                            15,
                                            12,
                                            DropdownBelow(
                                              itemWidth: 380.w,

                                              ///text style inside the menu
                                              itemTextstyle: TextStyle(
                                                fontSize: textTitleSize.sp,
                                                fontWeight: FontWeight.w400,
                                                color: black,
                                                fontFamily: 'Cairo',
                                              ),

                                              ///hint style
                                              boxTextstyle: TextStyle(
                                                  fontSize: textTitleSize.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: grey,
                                                  fontFamily: 'Cairo'),

                                              ///box style
                                              boxPadding: EdgeInsets.fromLTRB(
                                                  13.w, 8.h, 13.w, 12.h),
                                              boxWidth: 500.w,
                                              boxHeight: 46.h,
                                              boxDecoration: BoxDecoration(
                                                color:
                                                    lightGrey.withOpacity(0.10),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: newGrey,
                                                  width: 0.5,
                                                ),
                                              ),

                                              ///Icons
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: lightGrey,
                                              ),
                                              hint: Text(
                                                complaintText,
                                                textDirection:
                                                    TextDirection.rtl,
                                              ),
                                              value: _selectedTest,
                                              items: _dropdownTestItems,
                                              onChanged: onChangeDropdownTests,
                                            ),
                                          );
                                        } else if (snapshot.connectionState ==
                                                ConnectionState.active ||
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return paddingg(
                                              15,
                                              15,
                                              12,
                                              DropdownBelow(
                                                itemWidth: 380.w,

                                                ///text style inside the menu
                                                itemTextstyle: TextStyle(
                                                  fontSize: textTitleSize.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: black,
                                                  fontFamily: 'Cairo',
                                                ),

                                                ///hint style
                                                boxTextstyle: TextStyle(
                                                    fontSize: textTitleSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: grey,
                                                    fontFamily: 'Cairo'),

                                                ///box style
                                                boxPadding: EdgeInsets.fromLTRB(
                                                    13.w, 8.h, 13.w, 12.h),
                                                boxWidth: 500.w,
                                                boxHeight: 46.h,
                                                boxDecoration: BoxDecoration(
                                                  color:
                                                  lightGrey.withOpacity(0.10),
                                                  borderRadius:
                                                  BorderRadius.circular(8.r),
                                                  border: Border.all(
                                                    color: newGrey,
                                                    width: 0.5,
                                                  ),
                                                ),

                                                ///Icons
                                                icon: const Icon(
                                                  Icons.priority_high_outlined,
                                                  color: Colors.red,
                                                ),
                                                hint: Text(
                                                  complaintText,
                                                  textDirection:
                                                  TextDirection.rtl,
                                                ),
                                                value: _selectedTest,
                                                items: _dropdownTestItems,
                                                onChanged: onChangeDropdownTests,
                                              ),
                                            );
                                          } else if (snapshot.hasData) {
                                            _dropdownTestItems.isEmpty
                                                ? {
                                                    complaintList.add({
                                                      'no': 0,
                                                      'keyword':
                                                          'اختر نوع المساعدة'
                                                    }),
                                                    for (int i = 0;
                                                        i <
                                                            snapshot.data!.data!
                                                                .length;
                                                        i++)
                                                      {
                                                        complaintList.add({
                                                          'no': snapshot.data!
                                                              .data![i].id!,
                                                          'keyword':
                                                              '${snapshot.data!.data![i].name!}'
                                                        }),

                                                      },
                                                    _dropdownTestItems =
                                                        buildDropdownTestItems(
                                                            complaintList),

                                                  }
                                                : null;

                                            return paddingg(
                                              15,
                                              15,
                                              10,
                                              DropdownBelow(
                                                itemWidth: 380.w,

                                                ///text style inside the menu
                                                itemTextstyle: TextStyle(
                                                  fontSize: textTitleSize.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: black,
                                                  fontFamily: 'Cairo',
                                                ),

                                                ///hint style
                                                boxTextstyle: TextStyle(
                                                    fontSize: textTitleSize.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: grey,
                                                    fontFamily: 'Cairo'),

                                                ///box style
                                                boxPadding: EdgeInsets.fromLTRB(
                                                    13.w, 8.h, 13.w, 12.h),
                                                boxWidth: 500.w,
                                                boxHeight: 46.h,
                                                boxDecoration: BoxDecoration(
                                                  color: lightGrey
                                                      .withOpacity(0.10),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  border: Border.all(
                                                    color: newGrey,
                                                    width: 0.5,
                                                  ),
                                                ),

                                                ///Icons
                                                icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: lightGrey,
                                                ),
                                                hint: Text(
                                                  complaintText,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                ),
                                                value: _selectedTest,
                                                items: _dropdownTestItems,
                                                onChanged:
                                                    onChangeDropdownTests,
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
                                                  'State: ${snapshot.connectionState}'));
                                        }
                                      })),

                                  ///Title
                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    textFieldNoIcon(
                                      context,
                                      'موضوع الرسالة',
                                      textTitleSize,
                                      false,
                                      supportTitle,
                                      (String? value) {
                                        /// Validation text field
                                        if (value == null || value.isEmpty) {
                                          return 'حقل اجباري';
                                        }
                                        if (value.startsWith('0')) {
                                          return 'يجب ان لا يبدا بصفر';
                                        }
                                        if (value
                                            .startsWith(RegExp(r'[0-9]'))) {
                                          return 'يجب ان لا يبدا برقم';
                                        }
                                        return null;
                                      },
                                      false,
                                    ),
                                  ),

                                  ///Description
                                  paddingg(
                                    15,
                                    15,
                                    12,
                                    textFieldDesc(
                                      context,
                                      'تفاصيل الرسالة',
                                      textTitleSize,
                                      false,
                                      supportDescription,
                                      (String? value) {
                                        if (value!.startsWith('0')) {
                                          return 'يجب ان لا يبدا بصفر';
                                        }
                                        if (value.isEmpty) {
                                          return 'حقل اجباري';
                                        }
                                        if (value.startsWith('0')) {
                                          return 'يجب ان لا يبدا بصفر';
                                        }
                                        if (value
                                            .startsWith(RegExp(r'[0-9]'))) {
                                          return 'يجب ان لا يبدا برقم';
                                        } else {
                                          return value.length > 500
                                              ? 'يجب ان لا يزيد الوصف عن 500 حرف'
                                              : null;
                                        }
                                      },
                                      counter: (context,
                                          {required currentLength,
                                          required isFocused,
                                          maxLength}) {
                                        return Text(
                                          '$maxLength'
                                          '/'
                                          '$currentLength',
                                          style: TextStyle(
                                              fontSize: 12.sp, color: grey),
                                        );
                                      },
                                      maxLenth: 500,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ),

                                  ///SizedBox
                                  SizedBox(
                                    height: 15.h,
                                  ),

                                  ///Save box
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 20.h,
                                        right: 20.w,
                                        left: 20.w,
                                        bottom: 20.h),
                                    child: gradientContainerNoborder(
                                        500.w,
                                        buttoms(context, 'إرسال', largeButtonSize, white,
                                            () {
                                          _formKey.currentState!.validate()
                                              ? {
                                                  if (_selectedTest == null && !activeConnection)
                                                    {
                                                      showMassage(
                                                        context,
                                                        'خطأ',
                                                        'قم بإختيار نوع الشكوى',
                                                      )
                                                    }
                                                  else if (_selectedTest !=
                                                      null)
                                                    {
                                                      postContactWithUs(
                                                              userToken!)
                                                          .then((value) {
                                                        if (value == 'true') {
                                                          Navigator.pop(context);
                                                          showMassage(
                                                              context,
                                                              'تم الارسال بنجاح',
                                                              'سوف يتم التواصل معك عبر البريد الالكتروني',
                                                              done: done);

                                                        } else if (value ==
                                                            'SocketException') {
                                                          showMassage(
                                                              context,
                                                              'مشكلة في الانترنت',
                                                              socketException);
                                                        } else if (value ==
                                                            'serverExceptions') {
                                                          showMassage(
                                                              context,
                                                              'مشكلة في الخادم',
                                                              serverException);
                                                        } else {
                                                          ///TimeOut
                                                          showMassage(
                                                              context,
                                                              'مشكلة في الخادم',
                                                              timeoutException);
                                                        }
                                                      }),
                                                    }else{ showMassage(
                                              context,
                                              'مشكلة في الانترنت',
                                              socketException)}
                                                }
                                              : null;
                                        })),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: SizedBox(
                    height: 300.h,
                    width: 250.w,
                    child: internetConnection(context, reload: () {
                      checkUserConnection();
                      contactModel = getComplaintTypes();
                    }))),
      ),
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

  ///Get Complaint Types
  Future<ComplaintTypes> getComplaintTypes() async {
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/complaint-types'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      ComplaintTypes g = ComplaintTypes.fromJson(jsonDecode(response.body));
      return g;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
  }

  ///POST
  Future<String> postContactWithUs(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://mobile.celebrityads.net/api/technical-support',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'name': login.Logging.theUser!.name!,
          'email': login.Logging.theUser!.email!,
          'phonenumber': null,
          'subject': supportTitle.text,
          'details': supportDescription.text,
          'complaint_type_id': _selectedTest == null
              ? complaintList.indexOf(0)
              : complaintList.indexOf(_selectedTest),
        }),
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        print(response.body);
        return 'true';
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        return 'serverExceptions';
      }
    } catch (error) {
      if (error is SocketException) {
        return 'SocketException';
      } else if (error is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverExceptions';
      }
    }
  }
}
