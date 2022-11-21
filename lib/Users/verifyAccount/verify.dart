
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:celepraty/Users/verifyAccount/continueVerifyUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../../Account/LoggingSingUpAPI.dart';
import '../../Celebrity/verifyAccount/VerificationModel.dart';
import '../../Models/Methods/method.dart';
import '../../Models/Variables/Variables.dart';
import 'checkVerificationUser.dart';

class verify extends StatefulWidget {
  _verifyState createState() => _verifyState();
}

class _verifyState extends State<verify> {


  String? accountType;
  String? userToken;
  bool selected = false;
  bool selected2 = false;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool? chose;
  Future<Verification>? verifyInfoUser;
  @override
  void initState() {

    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        verifyInfoUser = getVerificationUser(userToken!);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
    child:
        FutureBuilder<Verification>(
        future: verifyInfoUser,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(body: Center(child: mainLoad(context)));
      } else if (snapshot.connectionState ==
          ConnectionState.active ||
          snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          if (!isConnectSection) {
            return Scaffold(body:  Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 0.h),
                  child: SizedBox(
                      height: 300.h,
                      width: 250.w,
                      child: internetConnection(
                          context, reload: () {
                        setState(() {
                          verifyInfoUser =
                              getVerificationUser(userToken!);
                          isConnectSection = true;
                        });
                      })),
                )),
            );
          } else {

            if (!serverExceptions) {
              return Scaffold(body:  Container(
                // height: getSize(context).height / 1.5,
                child: Center(
                    child: checkServerException(context)
                ),
              ),
              );
            } else {
              if (!timeoutException) {
                return Scaffold(body:  Center(
                  child: checkTimeOutException(
                      context, reload: () {
                    setState(() {
                      verifyInfoUser =
                          getVerificationUser(userToken!);
                    });
                  }),
                ),
                );
              }
            }
            return Scaffold(body:  Center(
              child: Text(
                snapshot.error.toString()
                  // child: checkServerException(context)),
              ),
            ));
          }
        }
        //---------------------------------------------------------------------------
        else if (snapshot.hasData) {
          return snapshot.data!.data!.user!.verifiedStatus != null
              ? Scaffold(body: checkVerificationUser()): Scaffold(
                      appBar: drowAppBar('توثيق الحساب', context),
                      body: padding(30, 30, SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 30.h,),
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: text(context, 'اختر نوع الحساب', textHeadSize, black),
                            ),
                            SizedBox(height: 80.h,),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  accountType = 'فرد';
                                  selected= !selected;
                                  selected2 =false;
                                  chose = false;
                                });
                              },
                              child: Container(
                                width: 200.w,
                                height: 160.h,
                                decoration: BoxDecoration(color:selected? selectblue: blue , borderRadius: BorderRadius.circular(10.r)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/image/ind2.png', height: 45.h,),
                                    SizedBox(height: 10.h),
                                    text(
                                        context, snapshot.data!.data!.comments![2].value!, textSubHeadSize, white, fontWeight: FontWeight.bold)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h,),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  accountType = 'شركة او مؤسسة';
                                  selected2= !selected2;
                                  selected = false;
                                  chose = false;
                                });
                              },
                              child: Container(
                                width: 200.w,
                                height: 160.h,
                                decoration: BoxDecoration(color:  selected2? selectpink: pink, borderRadius: BorderRadius.circular(10.r)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Image.asset(
                                      'assets/image/Group 17382.png', height: 50.h,),
                                  SizedBox(height: 10.h),
                                  text(
                                      context, snapshot.data!.data!.comments![3].value!, textSubHeadSize, white, fontWeight: FontWeight.bold),
                                ],),
                              ),
                            ),
                            SizedBox(height:chose == null? 65.h: 65.h,),
                           chose == null?SizedBox():
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               text(context, chose!? '* الرجاء اختيار نوع الحساب':'', textError, chose!? red! :white, align: TextAlign.right),
                               SizedBox(height: 10.h,),
                             ],
                           ),
                            selected == true || selected2 == true? Container(
                             height: 45.h,
                             child: gradientContainer(
                               double.infinity,
                               buttoms(
                                    context, 'التالي', largeButtonSize, textColor, () {
                                 goTopagepush(context, continueVerifyUser(
                                   accountType: accountType,
                                   verifyInfo: verifyInfoUser,));
                                }),
                             ),
                           ):SizedBox(),
                            SizedBox(height: 40.h,),
                          ],),
                      ),
                      ),
                    );
        } else {
          return const Center(child: Text('Empty data'));
        }
      } else {
        return Center(
            child: Text('State: ${snapshot.connectionState}'));
      }
        }
        ));

  }

  Future<Verification> getVerificationUser(String tokenn) async {
    //try{
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/user/verified-account'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenn'
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        return Verification.fromJson(jsonDecode(response.body));
      } else {
        // print(userToken);
        return Future.error('fetchCelebrities error ${response.statusCode}');
      }
    // }catch(e){
    //   if (e is SocketException) {
    //     setState(() {
    //       isConnectSection = false;
    //     });
    //     return Future.error('SocketException');
    //   } else if (e is TimeoutException) {
    //     setState(() {
    //       timeoutException = false;
    //     });
    //     return Future.error('TimeoutException');
    //   } else {
    //     setState(() {
    //       serverExceptions = false;
    //     });
    //     return Future.error('serverExceptions');
    //   }
    // }
  }}
