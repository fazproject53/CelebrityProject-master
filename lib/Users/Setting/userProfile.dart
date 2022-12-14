import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/Users/verifyAccount/verify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:celepraty/Users/Setting/userInformation.dart';
import 'package:celepraty/Users/Setting/user_balance.dart';
import 'package:celepraty/Users/UserRequests/UserReguistMainPage.dart';
import 'package:celepraty/Users/invoice/invoice.dart';
import 'package:celepraty/celebrity/TechincalSupport/contact_with_us.dart';
import 'package:path/path.dart' as Path;
import 'package:celepraty/celebrity/setting/profileInformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:celepraty/Account/logging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Account/LoggingSingUpAPI.dart';
import '../../Account/TheUser.dart';
import '../../Celebrity/setting/MediaAccounts.dart';

int? cityIdfrom;

class userProfile extends StatefulWidget {
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> with AutomaticKeepAliveClientMixin
    //with AutomaticKeepAliveClientMixin
{

  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool ActiveConnection = false;
  String T = "";
  Future<UserProfile>? getUsers;
  String userToken = "";
  List<Data>? data;
  Future<Media>? mediaAccounts;
  bool down = false;

  final labels = [
    'المعلومات الشخصية',
    'توثيق صفحة التاجر',
    'الفوترة',
    'الرصيد',
    'الطلبات',
   'طلب مساعدة',
    'تسجيل الخروج'
  ];
  final List<IconData> icons = [
    nameIcon,
    verifyIcon,
    invoice,
    money,
    orders,
    support,
    logout
  ];
  final List<Widget> page = [
    userInformation(),
    verify(),
    Invoice(),
    const UserBalance(),
    UserRequestMainPage(),
    const ContactWithUsHome(),
    Logging()
  ];

  File? userImage;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
        getUsers = fetchUsers(userToken);
        mediaAccounts = getAccounts();
      });
    });
    super.initState();
  }
  Future<Media> getAccounts() async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/social-media'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        return Media.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch (e) {
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
        });
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
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

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }
  Future<UserProfile> fetchUsers(String token) async {

    try {
      final response = await http.get(
          Uri.parse('https://mobile.celebrityads.net/api/user/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $userToken '
          });
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        cityIdfrom = jsonDecode(response.body)["data"]?["user"]['area'] == null
            ? null
            : jsonDecode(response.body)["data"]?["user"]['area']['id'];
        Logging.theUser = new TheUser();
        Logging.theUser!.name =
        jsonDecode(response.body)["data"]?["user"]['name'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['name'];
        Logging.theUser!.email =
        jsonDecode(response.body)["data"]?["user"]['email'];
        Logging.theUser!.id =
            jsonDecode(response.body)["data"]?["user"]['id'].toString();
        Logging.theUser!.phone =
        jsonDecode(response.body)["data"]?["user"]['phonenumber'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['phonenumber'].toString();
        Logging.theUser!.image =
        jsonDecode(response.body)["data"]?["user"]['image'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['image'];
        Logging.theUser!.country =
        jsonDecode(response.body)["data"]?["user"]['country'] == null
            ? ''
            : jsonDecode(response.body)["data"]?["user"]['country']['name'];
        print(response.body);
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    }catch(e){
      if (e is SocketException) {
        setState(() {
          isConnectSection = false;
          down = true;
        });
        return Future.error('SocketException');
      } else if (e is TimeoutException) {
        setState(() {
          timeoutException = false;
          down = true;
        });
        return Future.error('TimeoutException');
      } else {
        setState(() {
          serverExceptions = false;
          down = true;
        });
        return Future.error('serverExceptions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBarNoIcon("حسابي"),
        body: SingleChildScrollView(
            child: Column(children: [
              //======================== profile header ===============================

              Column(
                children:[ FutureBuilder<UserProfile>(
                  future: getUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child:mainLoad(context)
                      );;
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        if (!isConnectSection) {
                          return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/4.h),
                                    child: Center(
                                      child: SizedBox(
                                          height: 300.h,
                                          width: 250.w,
                                          child: internetConnection(context, reload: () {
                                            setState(() {
                                              getUsers = fetchUsers(userToken);
                                              mediaAccounts = getAccounts();
                                            });
                                          })),
                                    ),
                                  ),
                                ],
                              ),
                          );
                        } else {
                          if (!serverExceptions) {
                            return Container(
                              height: getSize(context).height/1.5,
                              child: Center(
                                  child: checkServerException(context,reload: (){setState(() {
                                    getUsers = fetchUsers(userToken);
                                  });})
                              ),
                            );}else{
                            if (!timeoutException) {
                              return Center(
                                child: checkTimeOutException(context, reload: (){ setState(() {
                                  getUsers = fetchUsers(userToken);});}),
                              );}
                          }
                          return  SizedBox(
                            height: getSize(context).height/1.5,
                            child: Center(
                                child: checkServerException(context)
                            ),
                          );
                        }
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 50.h,
                            ),
                            InkWell(
                              child: padding(
                                8,
                                8,
                                CircleAvatar(
                                  backgroundColor: lightGrey.withOpacity(0.30),
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100.r),
                                        child: userImage != null? Image.file(userImage!,fit: BoxFit.fill,
                                          height: double.infinity, width: double.infinity,):snapshot.data!.data!.user!.image == null? Container(color: lightGrey.withOpacity(0.30)):
                                        CachedNetworkImage(
                                          imageUrl: snapshot.data!.data!.user!.image!,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                          progressIndicatorBuilder:
                                              (context, child, loadingProgress) {
                                            return  Container(
                                              color: lightGrey.withOpacity(0.10),
                                            );
                                          },
                                          errorWidget: (context, exception, stackTrace) {
                                            return Icon(Icons.error, size: 30.h, color: red,);},
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(top:55.h, right: 65.w),
                                        child: Icon(Icons.add_circle, color: pink, size: 40.r),
                                      )
                                    ],
                                  ),
                                  radius: 55.r,
                                ),
                              ),
                              onTap: () {
                                getImage().whenComplete(() => {
                                  if(userImage != null){
                                      updateImageUser(),
                                        showMassage(context, 'تم بنجاح', "تم تغيير الصورة بنجاح",done: done)}

                                });



                              },
                            ),
                            SizedBox(height: 10.h),
                            padding(
                              8,
                              8,
                              text(context, snapshot.data!.data!.user!.name!, textHeadSize, black,
                                  fontWeight: FontWeight.bold, family: 'Cairo'),),

                                SingleChildScrollView(
                                  child: Container(
                                    child: paddingg(
                                      8,
                                      0,
                                      35,
                                      ListView.separated(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return MaterialButton(
                                              onPressed: index == labels.length - 1
                                                  ? () {
                                                singOut(context, userToken);
                                              }
                                                  : () {
                                                index == 0 ?goToPagePushRefresh(context, page[index], then: (value){
                                                  print(changed.toString()+"::::::::::::::");
                                                  changed?  setState(() {
                                                   getUsers = fetchUsers(userToken);
                                                   changed = false;
                                                  }): null;
                                                }): goTopagepush(context, page[index]);
                                              },
                                              child: addListViewButton(
                                                labels[index],
                                                icons[index],
                                                index
                                              ));
                                        },
                                        separatorBuilder: (context, index) => const Divider(),
                                        itemCount: labels.length,
                                      ),
                                    ),
                                  ),
                                ),

                                //========================== social media icons row =======================================

                                // SizedBox(
                                //   height: 15.h,
                                // ),

                          ],
                        );
                      } else {
                        return const Center(child: Text('Empty data'));
                      }
                    } else {
                      return Center(
                          child: Text(''));
                    }
                  },
                ),

                down? SizedBox():  FutureBuilder<Media>(
                    future: mediaAccounts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(children: [
                          Center(child: text(context, 'تسعدنا متابعتك على حسابات التواصل الخاصة بمنصتنا', textTitleSize, black)),
                          SizedBox(height: 10.h,),
                          //========================== social media icons row =======================================
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(

                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          'assets/image/icon- faceboock.png',
                                        )),
                                  ),
                                ),
                                InkWell(
                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                        'assets/image/icon- insta.png',
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(

                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                        'assets/image/icon- snapchat.png',
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(

                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: Image.asset(
                                        'assets/image/icon- twitter.png',
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(

                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset('assets/Svg/ttt.svg',width: 30,
                                        height: 30,),
                                    ),
                                  ),
                                ),
                                InkWell(

                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child:  SvgPicture.asset(
                                        'assets/Svg/icon-21-youtube.svg',

                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(

                                  child: padding(
                                    8,
                                    8,
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: SvgPicture.asset(
                                        'assets/Svg/icon-24-linkedin.svg',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                          paddingg(
                            8,
                            8,
                            12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  copyRight,
                                  size: 14,
                                ),
                                text(
                                    context, 'حقوق الطبع والنشر محفوظة', textTitleSize, black),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80.h,
                          )
                        ],);
                      } else if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {

                          return const Center(
                              child: Text(
                                  ''));
                          //---------------------------------------------------------------------------
                        } else if (snapshot.hasData) { return Column(
                          children: [
                            Center(child: text(context, 'تسعدنا متابعتك على حسابات التواصل الخاصة بمنصتنا', textTitleSize, black)),
                            SizedBox(height: 10.h,),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      var url = snapshot.data!.data!.facebook;
                                      await launch(url!, forceWebView: true);
                                    },
                                    child: padding(
                                      8,
                                      8,
                                      Container(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                            'assets/image/icon- faceboock.png',
                                          )),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var url = snapshot.data!.data!.instagram;
                                      await launch(url!, forceWebView: true);
                                    },
                                    child: padding(
                                      8,
                                      8,
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          'assets/image/icon- insta.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var url = snapshot.data!.data!.snapchat;
                                      await launch(url!, forceWebView: true);
                                    },
                                    child: padding(
                                      8,
                                      8,
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          'assets/image/icon- snapchat.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var url = snapshot.data!.data!.twitter;
                                      await launch(url!, forceWebView: true);
                                    },
                                    child: padding(
                                      8,
                                      8,
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset(
                                          'assets/image/icon- twitter.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var url = snapshot.data!.data!.tiktok;
                                      await launch(url!);
                                    },
                                    child: padding(
                                      8,
                                      8,
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: SvgPicture.asset('assets/Svg/ttt.svg',width: 30,
                                          height: 30,),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var url = snapshot.data!.data!.youtube;
                                      await launch(url!);
                                    },
                                    child: padding(
                                      8,
                                      8,
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child:  SvgPicture.asset(
                                          'assets/Svg/icon-21-youtube.svg',

                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var url = snapshot.data!.data!.linkedin;
                                      await launch(url!,
                                          forceWebView: true);
                                    },
                                    child: padding(
                                      8,
                                      8,
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: SvgPicture.asset(
                                          'assets/Svg/icon-24-linkedin.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),

                            paddingg(
                              8,
                              8,
                              12,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    copyRight,
                                    size: 14,
                                  ),
                                  text(
                                      context, 'حقوق الطبع والنشر محفوظة', textTitleSize, black),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100.h,
                            ),],
                        );
                        } else {
                          return const Center(child: Text('Empty data'));
                        }
                      } else {
                        return Center(
                            child: Text(''));
                      }
                    },
                  ),
          ]
              ),
              //profile image

              //=========================== buttons listView =============================


            ]),
          ),

      ),
    );
  }

  updateImageUser() async {
    var stream = http.ByteStream(DelegatingStream.typed(userImage!.openRead()));
    // get file length
    var length = await userImage!.length();

    // string to uri
    var uri =
        Uri.parse("https://mobile.celebrityads.net/api/user/image/update");

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $userToken"
    };
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(userImage!.path));

    // add file to multipart
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<File?> getImage() async {
    PickedFile? pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File file = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
// final String fileExtension = extension(image.path);
    File newImage = await file.copy('$path/$fileName');
    setState(() {
      userImage = newImage;
    });
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
//==================================================================================
  void singOut(context, String token) async {
    loadingDialogue(context);
    const url = 'https://mobile.celebrityads.net/api/logout';
    final respons = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (respons.statusCode == 200) {
     setState(() {
       Logging.theUser!.clear();
     });
      Navigator.pop(context);
      String massage = jsonDecode(respons.body)['message']['ar'];
     print('============================================');
     print(massage);
     print('============================================');
      DatabaseHelper.removeRememberToken();
      DatabaseHelper.removeFacebookUserEmail();
      DatabaseHelper. removeGoogleUserEmail();
      DatabaseHelper. removeUser();
      DatabaseHelper.removeDeviceToken();
      goTopageReplacement(context, Logging());
    } else {
      Navigator.pop(context);
      throw Exception('statusCode: ${respons.statusCode}');
    }
  }
}

//-----------------------------------------------------


//------------------------------------------------------------



class UserProfile {
  bool? success;
  Data? data;
  Message? message;

  UserProfile({this.success, this.data, this.message});

  UserProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message =
        json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  int? status;

  Data({this.user, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  City? city;
  City? area;
  String? idNumber;
  String? commercialNumber;
  Nationality? nationality;
  String? userType;
  String? type;

  User(
      {this.id,
      this.username,
      this.name,
      this.image,
      this.email,
      this.phonenumber,
      this.country,
        this.idNumber,
        this.commercialNumber,
      this.city,
        this.area,
        this.nationality,
        this.userType,
      this.type});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    userType = json['celebrity_type'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    idNumber = json['id_number'];
    commercialNumber = json['commercial_registration_number'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    area = json['area'] != null ? new City.fromJson(json['area']) : null;
    nationality = json['nationality'] != null ? new Nationality.fromJson(json['nationality']) : null;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['celebrity_type'] = this.userType;
    data['image'] = this.image;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['commercial_registration_number'] = this.commercialNumber;
    data['id_number'] = this.idNumber;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.area != null) {
      data['area'] = this.area!.toJson();
    }
    if (this.nationality != null) {
      data['nationality'] = this.nationality!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Country {
  String? name;
  String? nameEn;
  String? flag;

  Country({this.name, this.nameEn, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['flag'] = this.flag;
    return data;
  }
}

class City {
  String? name;
  String? nameEn;

  int? id;
  City({this.name, this.nameEn, this.id});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    id =json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['id'] = this.id;
    return data;
  }
}

class Message {
  String? en;
  String? ar;

  Message({this.en, this.ar});

  Message.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    ar = json['ar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['ar'] = this.ar;
    return data;
  }
}
