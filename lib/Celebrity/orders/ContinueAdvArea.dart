import 'dart:io';

import 'package:celepraty/Models/Methods/method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_signature/signature.dart';
import 'package:printing/printing.dart';
import '../../ModelAPI/CelebrityScreenAPI.dart';
import '../../Models/Variables/Variables.dart';
import '../Requests/Ads/AdvDetials.dart';
import '../Requests/Ads/AdvertisinApi.dart' as api;
import '../Requests/GenerateContract.dart';

class ContinueAdvArea extends StatefulWidget {
//foo======================================================================
  final Celebrity? cel;
  final String? desc, pagelink, type, time, date;
  final File? commercialrecord, image;
  final bool? fromOrder;
  final File? file;
  final String? token;
  final orderId;
  final String? priceController;
//alaa=========================================================================
  final String? description;
  final String? advTitle;
  final String? platform;
  final int? state;
  final int? price;
  final String? userName;
  final String? commercialRecord;
  final String? owner;
  final String? avdTime;
  final String? celerityCityName;
  final String? celerityEmail;
  final String? celerityIdNumber;
  final String? celerityName;
  final String? celerityNationality;
  final String? celerityPhone;
  final String? celerityVerifiedNumber;
  final String? celerityVerifiedType;
  final String? userCityName;
  final String? userEmail;
  final String? userIdNumber;
  final String? userNationality;
  final String? userPhone;
  final String? userVerifiedNumber;
  final String? userVerifiedType;
  final String? advLink;
  final String? advOrAdvSpace;
  final String? copun;

//=============================================================================
  const ContinueAdvArea({
    Key? key,
    this.cel,
    this.desc,
    this.pagelink,
    this.type,
    this.time,
    this.date,
    this.image,
    this.commercialrecord,
    this.fromOrder,
    this.file,
    this.token,
    this.orderId,
    this.priceController,
    this.avdTime,
    this.celerityCityName,
    this.celerityEmail,
    this.celerityIdNumber,
    this.celerityName,
    this.celerityNationality,
    this.celerityPhone,
    this.celerityVerifiedNumber,
    this.userCityName,
    this.userEmail,
    this.userIdNumber,
    this.userNationality,
    this.userPhone,
    this.userVerifiedNumber,
    this.userVerifiedType,
    this.celerityVerifiedType,
    this.description,
    this.advTitle,
    this.platform,
    this.state,
    this.price,
    this.userName,
    this.commercialRecord,
    this.owner,
    this.advLink,
    this.advOrAdvSpace, this.copun,
  }) : super(key: key);

  _ContinueAdvAreaState createState() => _ContinueAdvAreaState();
}

class _ContinueAdvAreaState extends State<ContinueAdvArea> {
  ByteData? png;
  final control = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  bool check2 = false;
  int help = 0;
  @override
  Widget build(BuildContext context) {
    //coment
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: drowAppBar("معاينة العقد والقبول", context),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(8.0.r),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
//show pdf==============================================================================================
                    Container(
                      decoration: BoxDecoration(
                        color: red,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey, blurRadius: 1, spreadRadius: 1)
                        ],

                      ),
                      margin: EdgeInsets.only(top: 0.h),
                      height: 390.h,
                      child: PdfPreview(
                        build: (format) => GenerateContract.generateContract(
                            advDescription: widget.description!,
                            advLink: widget.advLink!,
                            advOrAdvSpace: widget.advOrAdvSpace!,
                            platform: widget.platform!,
                            advProductOrService: widget.advTitle!,
                            celerityVerifiedType:
                            widget.celerityVerifiedType!,
                            advTime: widget.avdTime!,
                            celerityCityName:
                            widget.celerityCityName!,
                            celerityEmail: widget.celerityEmail!,
                            celerityIdNumber:
                            widget.celerityIdNumber!,
                            celerityName: widget.celerityName!,
                            celerityNationality:
                            widget.celerityNationality!,
                            celerityPhone: widget.celerityPhone!,
                            celerityVerifiedNumber:
                            widget.celerityVerifiedNumber!,
                            userCityName: widget.userCityName!,
                            userEmail: widget.userEmail!,
                            userIdNumber: widget.userIdNumber!,
                            userName: widget.userName!,
                            userNationality:
                            widget.userNationality!,
                            userPhone: widget.userPhone!,
                            userVerifiedNumber:
                            widget.userVerifiedNumber!,
                            userVerifiedType:
                            widget.userVerifiedType!,
                            format: format,
                            advDate: widget.date!),
                        allowSharing: false,
                        canChangeOrientation: false,
                        canDebug: false,
                        allowPrinting: false,
                        canChangePageFormat: false,
                      ),
                      width: double.infinity,
                    ),
//show pdf==============================================================================================
                    SizedBox(
                      // color: red,
                      height: 250.h,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: text(
                              context,
                              'قرات العقد واوافق عليه',
                              textTitleSize - 1,
                              black,
                            ),
                            value: check2,
                            selectedTileColor: black,
                            onChanged: (value) {
                              setState(() {
                                check2 = value!;
                              });
                            },
                          ),
//Signature==============================================================================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 20.w),
                                    child: text(context, 'التوقيع', 20, black),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10.w, top: 10.h, right: 10.w),
                                    height: 130.h,
                                    width: MediaQuery.of(context).size.width - 35,
                                    color: lightGrey.withOpacity(0.50),
                                    child: png != null && help == 1
                                        ? Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              SizedBox(
                                                  width: double.infinity,
                                                  child: Image.memory(
                                                    png!.buffer.asUint8List(),
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.all(5.0.w),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.redo,
                                                    size: 35.r,
                                                  ),
                                                  color: black,
                                                  onPressed: () {
                                                    setState(() {
                                                      png = null;
                                                      control.clear();
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        : HandSignature(
                                            control: control,
                                            color: Colors.blueGrey,
                                            width: 0.5,
                                            maxWidth: 3.0,
                                            type: SignatureDrawType.shape,
                                            onPointerUp: () async {
                                              png = await control
                                                  .toImage()
                                                  .whenComplete(() {
                                                setState(() {
                                                  help = 1;
                                                });
                                              });

                                              // showDialog(context: context, builder: (contextt){
                                              //   return Image.memory(png!.buffer.asUint8List());

                                              //   });
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
//order==============================================================================================
                    check2 && png != null
                        ? padding(
                            15,
                            15,
                            gradientContainerNoborder(
                                getSize(context).width,
                                widget.fromOrder == null
                                    ? buttoms(
                                        context, 'رفع الطلب', 15, white, () {})

//adv accept==============================================================================================
                                    : buttoms(context, 'قبول', 15, white, () {
                                        loadingDialogue(context);
                                        api
                                            .acceptAdvertisingOrder(
                                                widget.token!,
                                                widget.orderId!,
                                                int.parse(
                                                    widget.priceController!))
                                            .then((value) {
                                          print('n is : $value');
                                          if (value == true) {
                                            Navigator.pop(context);
                                            setState(() {
                                              clickAdv = true;
                                            });
                                            successfullyDialog(
                                                context,
                                                'تم قبول الطلب بنجاح',
                                                "assets/lottie/SuccessfulCheck.json",
                                                'حسناً', () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          } else if (value == "SocketException") {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الانترنت',
                                                socketException);
                                          } else if (value == "User is banned!") {
                                            Navigator.pop(context);
                                            showMassage(context, 'المستخدم محظور',
                                                'لقد قمت بحظر هذا المستخدم');
                                          } else if (value ==
                                              "TimeoutException") {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الخادم',
                                                timeoutException);
                                          } else if (value == 'serverException') {
                                            Navigator.pop(context);
                                            showMassage(
                                                context,
                                                'مشكلة في الخادم',
                                                serverException);
                                          } else {
                                            Navigator.pop(context);
                                            print('n is : $value');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar(
                                                    context,
                                                    'تم قبول الطلب مسبقا',
                                                    red,
                                                    error));
                                          }
                                        });
                                      })))
                        : SizedBox(),
                    SizedBox(
                      height: check2 && png != null ? 55.h : 0,
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
