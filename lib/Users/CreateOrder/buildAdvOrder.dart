import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:celepraty/MainScreen/main_screen_navigation.dart';
import 'package:celepraty/celebrity/setting/profileInformation.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:celepraty/Models/Methods/method.dart';
import 'package:celepraty/Models/Variables/Variables.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Account/LoggingSingUpAPI.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import '../UserRequests/UserReguistMainPage.dart';



class buildAdvOrder extends StatefulWidget {
  _buildAdvOrderState createState() => _buildAdvOrderState();
}

class _buildAdvOrderState extends State<buildAdvOrder> {
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  bool ActiveConnection = false;
  String T = "";
  String? pp;
  bool isConnectSection = true;
  bool timeoutException = true;
  bool serverExceptions = true;
  bool dateInvalid = false;
  String city = 'اختيار المنطقة';
  bool file2Warn = false;
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

  List<Widget> terms = [];
  List<String> termsToApi=[];
  int i = -1;
  bool adding = true;
  TextEditingController termController = TextEditingController();
  // باقي كود ال كونترولر في ال initState
  ScrollController? _controller;


  TextEditingController balanceFrom = TextEditingController();
  TextEditingController balanceTo = TextEditingController();

  bool isLoading = false;
  int? celebrityId;
  String? cname, cimage, advPP = '';
  int current = 0;
  bool isCompleted = false;
  bool platformChosen = true;
  Future<CityL>? cities;
  final TextEditingController subject =  TextEditingController();
  final TextEditingController desc =  TextEditingController();
  final TextEditingController pageLink =  TextEditingController();
  final TextEditingController coupon =  TextEditingController();
  final TextEditingController name =  TextEditingController();
  final TextEditingController email =  TextEditingController();
  final TextEditingController description =  TextEditingController();
  final TextEditingController couponcode =  TextEditingController();

  Future<Platform>? platforms;
  Future<Budget>? budgets;
  int? _value = 1;
  bool isValue1 = false;
  int? _value5 = 1;
  int? _value6 = 1;
  int? _value2 = 1;
  int? _value3 = 1;
  int? _value4 = 1;

  bool warnimage = false;
  var citilist = [];
  static double ww = 0.0;
  List sampleData = [];
  DateTime currentt = DateTime.now();
  static List<int> selectedIndex = [];
  String budgetn = 'الميزانية ';
  String countryn = 'الدولة';
  String categoryn = 'التصنيف';
  String followers = 'عدد المتابعين';
  Future<CountryL>? countries;
  Future<CategoryL>? categories;
Future<Filter>? filter;
  File? file, file2;
  bool checkit = false;
  bool checkit2 = false;
  File? img;
  DateTime date = DateTime.now();
  bool warn2 = false;
  bool datewarn2 = false;
  int? gender;
  int? status;
  String? userToken;
  String? showFile;
  int help=0;
  var platformlist =[];
  var budgetlist = [];
  var countrylist = [];
  var categorylist = [];
  var followerslist = [];
  String platform = 'اختر منصة العرض';
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems2 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems3 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems4 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems5 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems6 = [];
  List<DropdownMenuItem<Object?>> _dropdownTestItems7 = [];
  ///_value
  var _selectedTest;

  Timer? _timer;

  onChangeDropdownTests(selectedTest) {

    setState(() {
      print(_selectedTest);
      _selectedTest = selectedTest;
    });
  }

  var _selectedTest2;

  onChangeDropdownTests2(selectedTest) {
    print(selectedTest);
    print(categorylist.indexOf(selectedTest).toString());
    setState(() {

      _selectedTest2 = selectedTest;
    });
  }

  var _selectedTest3;

  onChangeDropdownTests3(selectedTest) {
    print(selectedTest);
    setState(() {
      _selectedTest3 = selectedTest;
    });
  }

  var _selectedTest4;

  onChangeDropdownTests4(selectedTest) {
    setState(() {

      print(selectedTest);
      _selectedTest4 = selectedTest;
      if(selectedTest['no'] == 0){
        _selectedTest4 =null;
      }
    });
  }

  var _selectedTest5;

  onChangeDropdownTests5(selectedTest) {
    setState(() {
      print(selectedTest);
      _selectedTest5 = selectedTest;
      pp = selectedTest['p'];
      if(selectedTest['no'] == 0){
        _selectedTest5 =null;
      }

      print(pp.toString() + 'ccccccccccccccccccccccccccccccccccccccccccccccccccccc');
    });
  }
  var _selectedTest6;
  onChangeDropdownTests6(selectedTest) {
    print(selectedTest);

    setState(() {
      _selectedTest6 = selectedTest;
      city = selectedTest['keyword'];
    });
  }
  var _selectedTest7;
  onChangeDropdownTests7(selectedTest) {
    print(selectedTest);

    setState(() {
      _selectedTest7 = selectedTest;
      followers = selectedTest['keyword'];
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  Future<Platform> fetchPlatform() async {
    try{
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/platforms'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return Platform.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
    }catch(e){
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

  List<DropdownMenuItem<Object?>> buildDropdownTestItems(List _testList) {
    List<DropdownMenuItem<Object?>> items = [];
    for (var i in _testList) {
      items.add(
        DropdownMenuItem(
          alignment: Alignment.centerRight,
          value: i,
          child: Directionality(
              textDirection: TextDirection.rtl,child: Container( alignment: Alignment.centerRight,child:
          text(context, i['keyword'],14,black, direction: TextDirection.rtl,))),

        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    CheckUserConnection();
    DatabaseHelper.getToken().then((value) {
      setState(() {
        userToken = value;
      });
      _controller = ScrollController();
      selectedIndex.clear();
    });
    budgets = fetchBudget();
    platforms = fetchPlatform();
    countries = fetCountries();
    categories = fetCategories();
    cities = fetCities( 1);
    fetchFolowers();
    _dropdownTestItems = buildDropdownTestItems(budgetlist);
    _dropdownTestItems2 = buildDropdownTestItems(categorylist);
    _dropdownTestItems3 = buildDropdownTestItems(countrylist);
    _dropdownTestItems4 = buildDropdownTestItems(platformlist);
    _dropdownTestItems5 = buildDropdownTestItems(platformlist);
    _dropdownTestItems6 = buildDropdownTestItems(citilist);
    _dropdownTestItems7 = buildDropdownTestItems(followerslist);
    super.initState();
  }
  Future<CityL> fetCities(int countryId) async {
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/areas/1'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        return CityL.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
    } catch (e) {
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
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: isCompleted ? null : drowAppBar('انشاء طلب اعلان', context),
        body:!isConnectSection?Center(
            child: Padding(
              padding:  EdgeInsets.only(top: 0.h),
              child: SizedBox(
                  height: 300.h,
                  width: 250.w,
                  child: internetConnection(
                      context, reload: () {
                    setState(() {
                      budgets = fetchBudget();
                      platforms = fetchPlatform();
                      countries = fetCountries();
                      categories = fetCategories();
                      isConnectSection = true;
                    });
                  })),
            )): !serverExceptions? Container(
          height: getSize(context).height/1.5,
          child: Center(
              child: checkServerException(context)
          ),
        ): !timeoutException? Center(
          child: checkTimeOutException(context, reload: (){ setState(() {
            budgets = fetchBudget();
            platforms = fetchPlatform();
            countries = fetCountries();
            categories = fetCategories();
          });}),
        ): isLoading? Center(child: mainLoad(context),):ActiveConnection?Stepper(
          margin: EdgeInsets.symmetric(horizontal: 24),
          steps: getSteps(),
          type: StepperType.horizontal,
          onStepContinue: () {
            bool isLastStep = current == getSteps().length - 1;
            if (isLastStep) {
              setState(() {
                _formKey3.currentState!.validate()? {
                  checkit2 && date.day != DateTime.now().day && file != null && !date.isBefore(DateTime.now()) && ((file2 !=null &&  _value != 1) || _value ==1)?{

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context2) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        addAdOrder().then((value) => {
                          value.contains('true')
                              ? {
                            gotoPageAndRemovePrevious(context, UserRequestMainPage()),

                            //done
                            showMassage(context2, 'تم بنجاح',
                                value.replaceAll('true', ''),
                                done: done),
                          }
                              :  value == 'SocketException'?
                          { Navigator.pop(context2),
                            showMassage(
                              context2,
                              'خطا',
                              socketException,
                            )}
                              :{
                            value == 'serverException'? {
                              Navigator.pop(context2),
                              showMassage(
                                context2,
                                'خطا',
                                serverException,
                              )
                            }:{

                              value.replaceAll('false', '') ==  'المستخدم محظور'? {
                                Navigator.pop(context),
                                showMassage(
                                  context2,
                                  'خطا',
                                  'لا يمكنك اكمال رفع الطلب',
                                )
                              } :{
                                Navigator.pop(context),
                                showMassage(
                                  context2,
                                  'خطا',
                                    value.replaceAll('false', ''),
                                )}
                            }

                          }

                        });

                        // == First dialog closed
                        return Align(
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            "assets/lottie/loding.json",
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),

                  }
                      : setState((){
                    _selectedTest4 == null? platformChosen= false: platformChosen = true;
                    date.day == DateTime.now().day? datewarn2 = true: false;
                    date.isBefore(DateTime.now())? dateInvalid = true: false;
                    file == null? warnimage =true:false;
                    file2  == null &&  _value != 1? file2Warn = true:false;}),

                }:null;


              });
            }
            setState(() {
              current == 1
                  ? selectedIndex.isEmpty
                  ? null
                  : current += 1
                  : isLastStep?current = current: current += 1;
            });
          },
          onStepCancel: () {
            checkit2 = false;
            current == 0
                ? null
                : setState(() {
                  help = 0;
              current -= 1;
              selectedIndex.clear();
              file =null;
              file2 =null;
              date = DateTime.now();
              checkit2 = false;
              _selectedTest4 = null;
            });
          },
          currentStep: current,
          onStepTapped: (value) => setState(() {
            selectedIndex.isNotEmpty ?
            current = value : current;

          }),
          controlsBuilder: (context, controls) {
            return   Column(
              children: [
                SizedBox(height: 5.h,),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                       children: [
                         Container(
                           width: current == 0? getSize(context).width.w/1.17.w: 115.w,
                              decoration: BoxDecoration(color: purple.withOpacity(0.70),
                              borderRadius: BorderRadius.circular(10.r)),
                              child:   checkit && (current == 0 || (current == 1 && selectedIndex.isNotEmpty))?TextButton(
                                onPressed: controls.onStepContinue,
                                child: (current != getSteps().length - 1 &&
                                    current != getSteps().length - 3)
                                    ?  text(context ,'متابعة', textDetails+1, white)
                                    : current != getSteps().length - 3 && file != null && date.day != DateTime.now().day && _selectedTest4 != null && checkit2
                                    ?text(context ,'تاكيد', textDetails+1, white)
                                    : checkit == true &&
                                    current != getSteps().length - 1
                                    ? text(context ,'متابعة', textDetails+2, white)
                                    : text(context ,'', 13, white)
                              ):SizedBox(width: 0.w,)
                            ),

                         current != getSteps().length - 3 && file != null && date.day != DateTime.now().day && _selectedTest4 != null && checkit2? Container(
                           width: 115.w,
                           decoration: BoxDecoration(color: purple.withOpacity(0.70),
                               borderRadius: BorderRadius.circular(10.r)),
                           child: TextButton(
                               onPressed: controls.onStepContinue,
                               child: current != getSteps().length - 3 && file != null && date.day != DateTime.now().day && _selectedTest4 != null && checkit2
                                   ?text(context ,'تاكيد', textDetails+1, white)
                                   :  text(context ,'', textDetails, white)
                           ),
                         ):SizedBox(),
                       ],
                     ),
                  ),

                      current != getSteps().length - 3 || checkit2 ? Container(
                        width: 115.w,
                        decoration: BoxDecoration(color: purple.withOpacity(0.70),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: TextButton(
                          onPressed: controls.onStepCancel,
                          child: current != getSteps().length - 3
                              ? text(context ,'رجوع', textDetails+1, white)
                              : text(context ,'', textDetails, white)
                        ),
                      ):SizedBox()
                    ],
                  ),
                ),
              ],
            );
          },
        ):Center(
            child:SizedBox(
                height: 300.h,
                width: 250.w,
                child: internetConnection(
                    context, reload: () {
                  CheckUserConnection();
                  budgets = fetchBudget();
                  platforms = fetchPlatform();
                  countries = fetCountries();
                  categories = fetCategories();
                })))
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        state: current > 0 ? StepState.complete : StepState.indexed,
        title: text(context, 'الفرز', textTitleSize, black),
        content: stepOne(),
        isActive: current >= 0,
      ),
      Step(
        state: current > 1 ? StepState.complete : StepState.indexed,
        title: text(context, 'البحث', textTitleSize, black),
        content: stepTwo(),
        isActive: current >= 1,
      ),
      Step(
        state: current > 1 ? StepState.complete : StepState.indexed,
        title: text(context, 'الاعلان', textTitleSize, black),
        content: stepThree(),
        isActive: current >= 2,
      ),
    ];
  }

  Future<CategoryL> fetCategories() async {
    try{
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/categories'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return CategoryL.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
    }catch(e){
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



  Future<CountryL> fetCountries() async {
    try{
    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/countries'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return CountryL.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }
    }catch(e){
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

  Future<Budget> fetchBudget() async {

    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://mobile.celebrityads.net/api/budgets'),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        setState(() {
          isLoading = false;
        });
        return Budget.fromJson(jsonDecode(response.body));
        
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load activity');
      }
      
    }catch(e){
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


  Future<Filter> fetchCelebrity(int? country, int? category, int? budget,int? status, int? gender , String? platform,int? area, int? folowerss) async {

   final response = await http.get(Uri.parse(
          'https://mobile.celebrityads.net/api/celebrity/search?country_id=1&category_id=${category == null || category == 0?'':category}&budget_id=${budget == null  || budget == 0? '':budget}&account_status_id=${status == null?1:status}&'
             'gender_id=${gender == null? '':gender}&platform_id=${platform == null || platform == 0? '':platform},&area_id=${area == null || area == 0? '':area}&folower_number=${folowerss == null || folowerss == 0? '':folowerss}'));
      if (response.statusCode == 200) {
        final body = response.body;
        print('-----------------------------------------------------------');
        print(body);
        print('-----------------------------------------------------------');
        Filter filter = Filter.fromJson(jsonDecode(body));
        return filter;
      } else {
        print(response.statusCode.toString() + '==============================');
        throw Exception('Failed to load Category');
      }

  }

  Future<String> addAdOrder() async {
    var stream2;
    var length2;
    var multipartFile2;
    try {
      var stream;
      var length;
      var uri;
      var request;
      Map<String, String> headers;
      var response;

      stream = await http.ByteStream(DelegatingStream.typed(file!.openRead()));
      // get file length
      length = await file!.length();
      if(file2 != null) {
        stream2 = new http.ByteStream(
            DelegatingStream.typed(file2!.openRead()));
        // get file length
        length2 = await file2!.length();
      }
      // string to uri
      uri = Uri.parse(
          "https://mobile.celebrityads.net/api/order/advertising/add");

      headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $userToken"
      };
      // create multipart request
      request = http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: Path.basename(file!.path));
      if(file2 != null){
        multipartFile2 = http.MultipartFile('commercial_record', stream2, length2,
            filename: Path.basename(file2!.path));}
      // multipart that takes file
      // multipartFile = new http.MultipartFile('file', file!.bytes.toList(), length,
      //     filename: file!.name),
      print('the id is = ' + celebrityId.toString());
      // listen for response
      request.files.add(multipartFile);
      file2 != null? request.files.add(multipartFile2): request.fields["commercial_record"] = '';
      request.headers.addAll(headers);
      request.fields["celebrity_id"] =
      celebrityId != null ? celebrityId.toString() : null;
      request.fields["date"] = date.toString();
      request.fields["description"] = desc.text;
      request.fields[" platform_id"] =
          platformlist.indexOf(_selectedTest4).toString();
      request.fields["celebrity_promo_code_id"] = couponcode.text;
      request.fields["ad_owner_id"] = _value.toString();
      request.fields["ad_feature_id"] = _value2.toString();
      request.fields["ad_timing_id"] = _value4.toString();
      request.fields["advertising_ad_type_id"] = _value3.toString();
      request.fields["advertising_name"] = subject.text;
      request.fields["advertising_link"] = pageLink.text;

      response = await request.send();
      http.Response respo = await http.Response.fromStream(response);
      print(respo.body);
      return jsonDecode(respo.body)['message']['ar'] +
          jsonDecode(respo.body)['success'].toString();
    }catch (e) {
      if (e is SocketException) {
        return 'SocketException';
      } else if (e is TimeoutException) {
        return 'TimeoutException';
      } else {
        return 'serverException';
      }
    }
  }

  stepOne() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey2,
          child: paddingg(
            8,
            8,
            0,
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(
                height: 0.h,
              ),
              padding(
                10,
                12,
                Container(
                    alignment: Alignment.topRight,
                    child: text(
                      context,
                      ' فضلا ادخل البيانات الصحيحة',
                      textHeadSize,
                      textBlack,
                      fontWeight: FontWeight.bold,
                    )),
              ),

              //========================== form ===============================================
              SizedBox(height: 20.h,),
              FutureBuilder(
                  future: cities,
                  builder: ((context,
                      AsyncSnapshot<CityL> snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center();
                    } else if (snapshot.connectionState ==
                        ConnectionState.active ||
                        snapshot.connectionState ==
                            ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center();
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        snapshot.data!.data == null?{
                          citilist.add({
                            'no': 0,
                            'keyword':
                            'اختيار المنطقة'
                          }),
                          _dropdownTestItems6 =
                              buildDropdownTestItems(
                                  citilist)
                        }:
                        _dropdownTestItems6.isEmpty
                            ? {
                          citilist.add({
                            'no': 0,
                            'keyword':
                            'اختيار المنطقة'
                          }),
                           for(int i = 0;
                          i <
                              snapshot
                                  .data!.data!.length;
                          i++)
                            {
                              citilist.add({
                                'no': snapshot.data!.data![i]
                                    .id!,
                                'keyword':
                                '${snapshot.data!.data![i]
                                    .name!}'
                              }),
                            },
                          _dropdownTestItems6 =
                              buildDropdownTestItems(
                                  citilist)
                        }
                            : null;

                        return paddingg(
                          10,
                          15,
                          12,
                          DropdownBelow(
                            itemWidth: 330.w,
                            dropdownColor: white,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: textDetails.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: textDetails.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding: EdgeInsets.fromLTRB(
                                13.w, 5.h, 13.w, 5.h),
                            boxWidth: 500.w,
                            boxHeight: 40.h,
                            boxDecoration: BoxDecoration(
                                border: Border.all(
                                    color: newGrey,
                                    width: 0.5),
                                color: lightGrey.withOpacity(
                                    0.10),
                                borderRadius:
                                BorderRadius.circular(8.r)),

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              city,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: textDetails.sp),
                            ),
                            value: _selectedTest6,
                            items: _dropdownTestItems6,
                            onChanged: onChangeDropdownTests6,
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
                              ''));
                    }
                  })),
              // FutureBuilder(
              //     future: countries,
              //     builder: ((context, AsyncSnapshot<CountryL> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center();
              //       } else if (snapshot.connectionState ==
              //           ConnectionState.active ||
              //           snapshot.connectionState == ConnectionState.done) {
              //         if (snapshot.hasError) {
              //           return Center(child: Text(snapshot.error.toString()));
              //           //---------------------------------------------------------------------------
              //         } else if (snapshot.hasData) {
              //           _dropdownTestItems3.isEmpty
              //               ? {
              //             countrylist.add({'no': 0, 'keyword': 'الدولة'}),
              //             for (int i = 0;
              //             i < snapshot.data!.data!.length;
              //             i++)
              //               {
              //                 countrylist.add({
              //                   'no': i,
              //                   'keyword':
              //                   '${snapshot.data!.data![i].name!}'
              //                 }),
              //               },
              //             _dropdownTestItems3 =
              //                 buildDropdownTestItems(countrylist)
              //           }
              //               : null;
              //
              //           return paddingg(
              //             10,
              //             15,
              //             12,
              //             DropdownBelow(
              //               itemWidth: 330.w,
              //               dropdownColor: white,
              //
              //               ///text style inside the menu
              //               itemTextstyle: TextStyle(
              //                 fontSize: 12.sp,
              //                 fontWeight: FontWeight.w400,
              //                 color: black,
              //                 fontFamily: 'Cairo',
              //               ),
              //
              //               ///hint style
              //               boxTextstyle: TextStyle(
              //                   fontSize: 11.sp,
              //                   fontWeight: FontWeight.w400,
              //                   color: black,
              //                   fontFamily: 'Cairo'),
              //
              //               ///box style
              //               boxPadding:
              //               EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
              //               boxWidth: 500.w,
              //               boxHeight: 40.h,
              //               boxDecoration: BoxDecoration(
              //                   border:  Border.all(color: newGrey, width: 0.5),
              //                   color: lightGrey.withOpacity(0.10),
              //                   borderRadius: BorderRadius.circular(8.r)),
              //
              //
              //               ///Icons
              //               icon: const Icon(
              //                 Icons.arrow_drop_down,
              //                 color: Colors.grey,
              //               ),
              //               hint: Text(
              //                 countryn,
              //                 textDirection: TextDirection.rtl,
              //               ),
              //               value: _selectedTest3,
              //               items: _dropdownTestItems3,
              //               onChanged: onChangeDropdownTests3,
              //             ),
              //           );
              //         } else {
              //           return const Center(
              //               child: Text('لايوجد لينك لعرضهم حاليا'));
              //         }
              //       } else {
              //         return Center(
              //             child: Text('State: ${snapshot.connectionState}'));
              //       }
              //     })),

              FutureBuilder(
                  future: categories,
                  builder: ((context, AsyncSnapshot<CategoryL> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center();
                    } else if (snapshot.connectionState ==
                        ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        _dropdownTestItems2.isEmpty
                            ? {
                          categorylist
                              .add({'no': 0, 'keyword': 'التصنيف'}),
                          for (int i = 0;
                          i < snapshot.data!.data!.length;
                          i++)
                            {
                              categorylist.add({
                                'no': i,
                                'keyword':
                                '${snapshot.data!.data![i].name}'
                              }),
                            },
                          _dropdownTestItems2 =
                              buildDropdownTestItems(categorylist)
                        }
                            : null;

                        return paddingg(
                          10,
                          15,
                          12,
                          DropdownBelow(
                            itemWidth: 330.w,
                            dropdownColor: white,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: textDetails.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: textDetails.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding:
                            EdgeInsets.fromLTRB(13.w, 5.h, 13.w, 5.h),
                            boxWidth: 500.w,
                            boxHeight: 40.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(8.r)),

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              categoryn,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: textDetails.sp)
                            ),
                            value: _selectedTest2,
                            items: _dropdownTestItems2,
                            onChanged: onChangeDropdownTests2,
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text('لايوجد لينك لعرضهم حاليا'));
                      }
                    } else {
                      return Center(
                          child: Text('State: ${snapshot.connectionState}'));
                    }
                  })),

              //--------------------------------------------------------------------------------------------------------------------------------------------

              FutureBuilder(
                  future: platforms,
                  builder: ((context, AsyncSnapshot<Platform> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  paddingg(15, 15, 12,
                        DropdownBelow(
                          itemWidth: 330.w,
                          ///text style inside the menu
                          itemTextstyle: TextStyle(
                            fontSize: textDetails.sp,
                            fontWeight: FontWeight.w400,
                            color: black,
                            fontFamily: 'Cairo',),
                          ///hint style
                          boxTextstyle: TextStyle(
                              fontSize: textDetails.sp,
                              fontWeight: FontWeight.w400,
                              color: grey,
                              fontFamily: 'Cairo'),
                          ///box style
                          boxPadding:
                          EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                          boxWidth: 500.w,
                          boxHeight: 40.h,
                          boxDecoration: BoxDecoration(
                              color: lightGrey.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(8.r)),
                          ///Icons
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white54,
                          ),
                          hint:  Text(
                            platform,
                            textDirection: TextDirection.rtl,
                          ),
                          value: _selectedTest5,
                          items: _dropdownTestItems5,
                          onChanged: onChangeDropdownTests5,
                        ),
                      );
                    } else if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        _dropdownTestItems5.isEmpty?{
                          platformlist.add({'no': 0, 'keyword': 'اختر منصة الاعلان', 'p':''}),
                          for(int i =0; i< snapshot.data!.data!.length; i++) {
                            platformlist.add({'no': snapshot.data!.data![i].id!, 'keyword': '${snapshot.data!.data![i].name!}','p': '${snapshot.data!.data![i].name_en!}'}),
                          },
                          _dropdownTestItems5 = buildDropdownTestItems(platformlist),
                        } : null;

                        return paddingg(10, 15, 12,
                          DropdownBelow(
                            itemWidth: 330.w,
                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: textDetails.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',),
                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: textDetails.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),
                            ///box style
                            dropdownColor: white,
                            boxPadding:
                            EdgeInsets.fromLTRB(13.w,5.h, 13.w, 5.h),
                              boxWidth: 500.w,
                              boxHeight: 40.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(8.r)),
                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint:  Text(
                              platform,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: textDetails.sp),
                            ),
                            value: _selectedTest5,
                            items: _dropdownTestItems5,
                            onChanged: onChangeDropdownTests5,
                          ),
                        );
                      } else {
                        return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
                      }
                    } else {
                      return Center(
                          child: Text('State: ${snapshot.connectionState}'));
                    }
                  })),
              // -------------------------------------------------------------------------------------------------------------------------------------------------------


              // paddingg(10.w, 10.w, 12.h,textFieldNoIcon(context, 'موضوع الاعلان', 12.sp, true, subject,(String? value) {if (value == null || value.isEmpty) {
              //   return 'Please enter some text';} return null;},false),),
              // paddingg(10.w, 10.w, 12.h,textFieldDesc(context, 'وصف الاعلان', 12.sp, true, desc,(String? value) {if (value == null || value.isEmpty) {
              //   return 'Please enter some text';} return null;},),),
              // paddingg(10.w, 10.w, 12.h,textFieldNoIcon(context, 'رابط صفحة الاعلان', 12.sp, true, pageLink,(String? value) {if (value == null || value.isEmpty) {
              //   return 'Please enter some text';} return null;},false),),
          _selectedTest5 == null? SizedBox():paddingg(
                          10,
                          15,
                          12,
                          DropdownBelow(
                            itemWidth: 330.w,
                            dropdownColor: white,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: textDetails.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize:textDetails.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding:
                            EdgeInsets.fromLTRB(13.w, 5.h, 13.w, 5.h),
                            boxWidth: 500.w,
                            boxHeight: 40.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(8.r)),

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              followers,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            value: _selectedTest7,
                            items: _dropdownTestItems7,
                            onChanged: onChangeDropdownTests7,
                          ),
          ),

              FutureBuilder(
                  future: budgets,
                  builder: ((context, AsyncSnapshot<Budget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center();
                    } else if (snapshot.connectionState ==
                        ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                        //---------------------------------------------------------------------------
                      } else if (snapshot.hasData) {
                        _dropdownTestItems.isEmpty
                            ? {
                          budgetlist
                              .add({'no': 0, 'keyword': 'الميزانية'}),
                          for (int i = 0;
                          i < snapshot.data!.data!.length;
                          i++)
                            {
                              budgetlist.add({
                                'no': i,
                                'keyword':
                                'من'+ ' ${snapshot.data!.data![i].from} الى ${snapshot.data!.data![i].to}   '
                              }),
                            },
                          _dropdownTestItems =
                              buildDropdownTestItems(budgetlist)
                        }
                            : null;

                        return paddingg(
                          10,
                          15,
                          12,
                          DropdownBelow(
                            itemWidth: 330.w,
                            dropdownColor: white,

                            ///text style inside the menu
                            itemTextstyle: TextStyle(
                              fontSize: textDetails.sp,
                              fontWeight: FontWeight.w400,
                              color: black,
                              fontFamily: 'Cairo',
                            ),

                            ///hint style
                            boxTextstyle: TextStyle(
                                fontSize: textDetails.sp,
                                fontWeight: FontWeight.w400,
                                color: black,
                                fontFamily: 'Cairo'),

                            ///box style
                            boxPadding:
                            EdgeInsets.fromLTRB(13.w, 5.h, 13.w, 5.h),
                            boxWidth: 500.w,
                            boxHeight: 40.h,
                            boxDecoration: BoxDecoration(
                                border:  Border.all(color: newGrey, width: 0.5),
                                color: lightGrey.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(8.r)),

                            ///Icons
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            hint: Text(
                              budgetn,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: textDetails.sp),
                            ),
                            value: _selectedTest,
                            items: _dropdownTestItems,
                            onChanged: onChangeDropdownTests,
                          ),
                        );} else {
                        return const Center(
                            child: Text('لايوجد لينك لعرضهم حاليا'));
                      }
                    } else {
                      return Center(
                          child: Text('State: ${snapshot.connectionState}'));
                    }
                  })),

              SizedBox(
                height: 20,
              ),
              padding(
                  8,
                  20,
                  text(context, 'حساب المشهور', textTitleSize, black,
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(top: 3.h, right: 2.w),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 1,
                              groupValue: _value5,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value5 = value;
                                  isValue1 = false;
                                  status= 1;
                                });
                              }),
                        ),
                        text(context, "موثق", textTitleSize, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 2,
                              groupValue: _value5,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value5 = value;
                                  isValue1 = true;
                                  status= 2;
                                });
                              }),
                        ),
                        text(context, "غير موثق", textTitleSize, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),
              padding(
                  8,
                  20,
                  text(context, 'الجنس', textTitleSize, black,
                      fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(top: 3.h, right: 2.w),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 1,
                              groupValue: _value6,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value6 = value;
                                  isValue1 = false;
                                  gender=1;
                                });
                              }),
                        ),
                        text(context, "ذكر", textTitleSize, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.8,
                          child: Radio<int>(
                              value: 2,
                              groupValue: _value6,
                              activeColor: blue,
                              onChanged: (value) {
                                setState(() {
                                  _value6 = value;
                                  isValue1 = true;
                                  gender = 2;
                                });
                              }),
                        ),
                        text(context, "انثى", textTitleSize, ligthtBlack,
                            family: 'DINNextLTArabic'),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),


              paddingg(
                0,
                0,
                12,
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                      text:  TextSpan(children: [
                        TextSpan(
                            text:
                            ' عند الطلب ، فإنك توافق على شروط الإستخدام و سياسة الخصوصية الخاصة بـ',
                            style: TextStyle(
                                color: black, fontFamily: 'Cairo', fontSize: textDetails)),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            var url = 'https://mobile.celebrityads.net/policy';
                            await launch(url,
                                forceWebView: true);
                            },
                            text: 'منصة المشاهير',
                            style: TextStyle(
                                color: blue, fontFamily: 'Cairo', fontSize: textDetails))
                      ])),
                  value: checkit,
                  selectedTileColor: black,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        checkit = value!;
                      });
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),

            ]),
          ),
        ),
      ),
    );
  }
  stepTwo() {

    current == 1 && selectedIndex.isEmpty && help == 0? {
    filter = fetchCelebrity(
        1,
        categorylist.indexOf(_selectedTest2) != -1 ? categorylist.indexOf(
            _selectedTest2) : null,
        budgetlist.indexOf(_selectedTest) != -1 ? budgetlist.indexOf(
            _selectedTest) : null,
        status == null ? null : status!
        ,
        _value6,
        _selectedTest5 != null ? _selectedTest5['p'] : '',
        citilist.indexOf(_selectedTest6) != -1 ? citilist.indexOf(
            _selectedTest6) : null,
        followerslist.indexOf(_selectedTest7) != -1 ? followerslist.indexOf(
            _selectedTest7) : null),
      help = 1
  }:null;
    return FutureBuilder<Filter>(
        future: filter,
        builder: ((context, AsyncSnapshot<Filter> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(height: 500.h,child: mainLoad(context)));
          } else if (snapshot.connectionState ==
              ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              if (snapshot.error.toString() == 'socketException') {
                return internetConnection(context);
              } else{ return stepTwo();}
              //---------------------------------------------------------------------------
            } else if (snapshot.hasData) {
              return snapshot.data!.data == null?

                  Center(child: Column(
                    children: [
                      SizedBox(height: 10.h,),
                      Text('لا يوجد نتائج'),
                      SizedBox(height: 20.h,),
                    ],
                  ))
             :snapshot.data!.data!.isEmpty?  Center(child: Column(
               children: [
                 SizedBox(height: 10.h,),
                 Text('لا يوجد نتائج'),
                 SizedBox(height: 20.h,),
               ],
             )):
              Padding(
                padding:  EdgeInsets.only(bottom: 20.h),
                child: SizedBox(
                  height: 500.h,
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    crossAxisCount:2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    childAspectRatio: 0.90
                        .sp,
                    children: List.generate(snapshot.data!.data == null? 0 : snapshot.data!.data!.length, (index) {
                      return InkWell(
                        onTap: () {
                          if (!selectedIndex.contains(index)) {
                            selectedIndex.clear();
                            selectedIndex.add(index);
                          } else {
                            selectedIndex.remove(index);
                          }
                          setState(() {
                            celebrityId = snapshot.data!.data![index].id;
                            cname = snapshot.data!.data![index].name!;
                            cimage = snapshot.data!.data![index].image!;
                            advPP =  snapshot.data!.data![index].advertisingPolicy!;
                          });
                        },
                        child: Container(
                          height: 300.h,
                          width: 200.w,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.data![index].image!,
                                  color: selectedIndex.contains(index)
                                      ? deepBlack.withOpacity(0.90)
                                      : deepwhite.withOpacity(0.60),
                                  colorBlendMode: BlendMode.modulate,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity ,
                                  // placeholder: (context, x){return Container(color: Colors.white38,);},
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: text(context, snapshot.data!.data![index].name! == ""? "اسم المشهور" : snapshot.data!.data![index].name!,
                                              ww > 400 ? 30 : textTitleSize, selectedIndex.contains(index)?white : black,
                                              fontWeight: FontWeight.bold)),
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(right: 8.w),
                                    ),
                                    Container(
                                        child: text(context, snapshot.data!.data![index].category!.name! , textTitleSize+1, selectedIndex.contains(index)? white : black),
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.only(right: 8.w)),

                                    SizedBox(
                                      height: 10.h,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            } else {
              return const Center(
                  child: Text('لايوجد لينك لعرضهم حاليا'));
            }
          } else {
            return Center(
                child: Text('State: ${snapshot.connectionState}'));
          }
        }));
  }

  stepThree() {

    return Container(
      child: SingleChildScrollView(
        child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                      height: 250.h,
                      width: double.infinity,
                      child: cimage == null? Container(color: lightGrey,):CachedNetworkImage(
                        imageUrl:cimage!,
                        color: Colors.white.withOpacity(0.50),
                        colorBlendMode: BlendMode.modulate,
                        fit: BoxFit.fill,
                      )),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.h, right: 10.h),
                    child: cname == null? text(context, 'قم بتعبئة البيانات:', 20, black) :  Text(
                      ' اطلب اعلان \n شخصي من ' + cname!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: ligthtBlack.withOpacity(0.70),),
                    ),
                  )
                ],
              ),
              Container(
                child: Form(
                  key: _formKey3,
                  child: paddingg(
                    10,
                    10,
                    5,
                    Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      padding(
                        10,
                        12,
                        Container(
                            alignment: Alignment.topRight,
                            child: text(
                              context,
                              ' فضلا ادخل البيانات الصحيحة',
                              textSubHeadSize,
                              textBlack,
                              fontWeight: FontWeight.bold,
                            )),
                      ),

                      //========================== form ===============================================

                      SizedBox(
                        height: 10,
                      ),

                      FutureBuilder(
                          future: platforms,
                          builder: ((context, AsyncSnapshot<Platform> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return  paddingg(15, 15, 12,
                                DropdownBelow(
                                  itemWidth: 330.w,
                                  ///text style inside the menu
                                  itemTextstyle: TextStyle(
                                    fontSize: textDetails.sp,
                                    fontWeight: FontWeight.w400,
                                    color: black,
                                    fontFamily: 'Cairo',),
                                  ///hint style
                                  boxTextstyle: TextStyle(
                                      fontSize: textDetails.sp,
                                      fontWeight: FontWeight.w400,
                                      color: grey,
                                      fontFamily: 'Cairo'),
                                  ///box style
                                  boxPadding:
                                  EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                  boxWidth: 500.w,
                                  boxHeight: 45.h,
                                  boxDecoration: BoxDecoration(
                                      color: textFieldBlack2.withOpacity(0.70),
                                      borderRadius: BorderRadius.circular(8.r)),
                                  ///Icons
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white54,
                                  ),
                                  hint:  Text(
                                    platform,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  value: _selectedTest4,
                                  items: _dropdownTestItems4,
                                  onChanged: onChangeDropdownTests4,
                                ),
                              );
                            } else if (snapshot.connectionState == ConnectionState.active ||
                                snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Center(child: Text(snapshot.error.toString()));
                                //---------------------------------------------------------------------------
                              } else if (snapshot.hasData) {
                                _dropdownTestItems4.isEmpty?{
                                  platformlist.clear(),
                                  platformlist.add({'no': 0, 'keyword': 'اختر منصة الاعلان'}),
                                  for(int i =0; i< snapshot.data!.data!.length; i++) {
                                    platformlist.add({'no': snapshot.data!.data![i].id!, 'keyword': '${snapshot.data!.data![i].name!}'}),
                                  },
                                  _dropdownTestItems4 = buildDropdownTestItems(platformlist),
                                } : null;

                                return paddingg(10, 10, 12,
                                  DropdownBelow(
                                    itemWidth: 330.w,
                                    ///text style inside the menu
                                    itemTextstyle: TextStyle(
                                      fontSize: textDetails.sp,
                                      fontWeight: FontWeight.w400,
                                      color: black,
                                      fontFamily: 'Cairo',),
                                    ///hint style
                                    boxTextstyle: TextStyle(
                                        fontSize: textDetails.sp,
                                        fontWeight: FontWeight.w400,
                                        color: grey,
                                        fontFamily: 'Cairo'),
                                    ///box style
                                    dropdownColor: white,
                                    boxPadding:
                                    EdgeInsets.fromLTRB(13.w, 12.h, 13.w, 12.h),
                                    boxWidth: 500.w,
                                    boxHeight: 45.h,
                                    boxDecoration: BoxDecoration(
                                        border:  Border.all(color: newGrey, width: 0.5),
                                        color: lightGrey.withOpacity(0.10),
                                        borderRadius: BorderRadius.circular(8.r)),
                                    ///Icons
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    hint:  Text(
                                      platform,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    value: _selectedTest4,
                                    items: _dropdownTestItems4,
                                    onChanged: onChangeDropdownTests4,
                                  ),
                                );
                              } else {
                                return const Center(child: Text('لايوجد لينك لعرضهم حاليا'));
                              }
                            } else {
                              return Center(
                                  child: Text('State: ${snapshot.connectionState}'));
                            }
                          })),

                      _selectedTest4 == null && checkit2?
                      padding( 10,20, text(context, _selectedTest4 != null  && checkit2 ?'':'الرجاء اختيار منصة الاعلان', 13, _selectedTest4 != null  ?white:red!,)):
                      SizedBox(),

                      paddingg(
                        10.w,
                        10.w,
                        12.h,
                        textFieldNoIcon(
                            context, 'موضوع الاعلان', textDetails.sp, false, subject,
                                (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'حقل اجباري';
                              }
                              return null;
                            }, false),
                      ),
                      paddingg(
                        10.w,
                        10.w,
                        12.h,
                        textFieldDesc(
                          context,
                          'وصف الاعلان',
                          textDetails.sp,
                          true,
                          desc,
                              (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'حقل اجباري';
                            }
                            if (value.length < 80) {
                              return 'الحد الادنى لحروف الوصف 80 حرف';
                            }
                            if (value.length > 200) {
                              return 'الحد الاقصى لحروف الوصف 200 حرف';
                            }
                            return null;
                          },
                        ),
                      ),
                      paddingg(
                        10.w,
                        10.w,
                        12.h,
                        textFieldNoIcon(
                            context, 'اضافة رابط', textDetails.sp, false, pageLink,
                                (String? value) {
                              if (value == null || value.isEmpty) {
                              }
                              return null;
                            }, false),
                      ),

                      paddingg(
                        10.w,
                        10.w,
                        12.h,
                        textFieldNoIcon(
                            context, 'ادخل كود الخصم', textDetails.sp, false, couponcode,
                                (String? value) {
                              if (value == null || value.isEmpty) {

                              }
                              return null;
                            }, false),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      padding(
                          8,
                          20,
                          text(context, 'مالك الاعلان', textTitleSize+1, black,
                              fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(top: 3.h, right: 2.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Radio<int>(
                                          value: 1,
                                          groupValue: _value,
                                          activeColor: blue,
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                              isValue1 = false;
                                            });
                                          }),
                                    ),
                                    text(context, "فرد", textTitleSize+1, ligthtBlack,
                                        family: 'DINNextLTArabic'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Radio<int>(
                                          value: 2,
                                          groupValue: _value,
                                          activeColor: blue,
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                              isValue1 = true;
                                            });
                                          }),
                                    ),
                                    text(context, "مؤسسة/شركة", textTitleSize+1, ligthtBlack,
                                        family: 'DINNextLTArabic'),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Transform.scale(
                                //       scale: 0.8,
                                //       child: Radio<int>(
                                //           value: 3,
                                //           groupValue: _value,
                                //           activeColor: blue,
                                //           onChanged: (value) {
                                //             setState(() {
                                //               _value = value;
                                //               isValue1 = true;
                                //             });
                                //           }),
                                //     ),
                                //     text(context, "شركة", 14, ligthtBlack,
                                //         family: 'DINNextLTArabic'),
                                //   ],
                                // ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(right: 0.0.w),
                                      child: Container(width: double.infinity,child: Row(children: [IconButton(icon: InkWell(
                                          onTap: (){setState(() {
                                          getFile2(context);
                                          });},
                                          child: Icon(Icons.upload_rounded)),onPressed:(){setState(() {
                                        file2 != null? OpenFile.open('$showFile'): getFile2(context);
                                      });},color: purple,), InkWell(
                                          onTap: (){setState(() {
                                            file2 != null? OpenFile.open('$showFile'): getFile2(context);
                                          });},
                                          child: text(context, file2 != null? Path.basename(file2!.path):_value == 1? 'قم بإرفاق وثيقة ( العمل الحر او معروف ) pdf ':'  قم بإرفاق ملف السجل التجاري  pdf', textError, black))])),

                                ),
                                file2Warn && file2 == null? Padding(
                                    padding:  EdgeInsets.only(right: 30.0.w),
                                    child:  text(context, file2Warn && file2 == null? '*يجب رفع السجل التجاري لاكمال الطلب':'', textError, red!,align: TextAlign.right)):
                                SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),

                      padding(
                          8,
                          20,
                          text(context, 'صفة الاعلان', textTitleSize+1, black,
                              fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(top: 3.h, right: 2.w),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Radio<int>(
                                      value: 1,
                                      groupValue: _value2,
                                      activeColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _value2 = value;
                                          isValue1 = false;
                                        });
                                      }),
                                ),
                                text(context, "يلزم الحضور", textTitleSize+1, ligthtBlack,
                                    family: 'DINNextLTArabic'),
                              ],
                            ),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Radio<int>(
                                      value: 2,
                                      groupValue: _value2,
                                      activeColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _value2 = value;
                                          isValue1 = true;
                                        });
                                      }),
                                ),
                                text(context, "لا يلزم الحضور", textTitleSize+1, ligthtBlack,
                                    family: 'DINNextLTArabic'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      padding(
                          8,
                          20,
                          text(context, 'نوع الاعلان', textTitleSize+1, black,
                              fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(top: 3.h, right: 2.w),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Radio<int>(
                                      value: 2,
                                      groupValue: _value3,
                                      activeColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _value3 = value;
                                          isValue1 = false;
                                        });
                                      }),
                                ),
                                text(context, "خدمة", textTitleSize+1, ligthtBlack,
                                    family: 'DINNextLTArabic'),
                              ],
                            ),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Radio<int>(
                                      value: 1,
                                      groupValue: _value3,
                                      activeColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _value3 = value;
                                          isValue1 = true;
                                        });
                                      }),
                                ),
                                text(context, "منتج", textTitleSize+1, ligthtBlack,
                                    family: 'DINNextLTArabic'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      padding(
                          8,
                          20,
                          text(context, 'توقيت الاعلان', textTitleSize+1, black,
                              fontWeight: FontWeight.bold)),
                      Container(
                        margin: EdgeInsets.only(top: 3.h, right: 2.w),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Radio<int>(
                                      value: 1,
                                      groupValue: _value4,
                                      activeColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _value4 = value;
                                          isValue1 = false;
                                        });
                                      }),
                                ),
                                text(context, "صباحا", textTitleSize+1, ligthtBlack,
                                    family: 'DINNextLTArabic'),
                              ],
                            ),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Radio<int>(
                                      value: 2,
                                      groupValue: _value4,
                                      activeColor: blue,
                                      onChanged: (value) {
                                        setState(() {
                                          _value4 = value;
                                          isValue1 = true;
                                        });
                                      }),
                                ),
                                text(context, "مساء", textTitleSize+1, ligthtBlack,
                                    family: 'DINNextLTArabic'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),

                      paddingg(15, 15, 30,InkWell(
                        onTap: (){
                          showTermsDialog(this.context);
                          adding && terms.isEmpty?{terms.add(Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding:  EdgeInsets.only(top:15.h),
                              child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                            ),
                          ),),
                            setState(() {
                              adding= false;
                            })}: null;},
                        child: Container(height: 50.h,
                          decoration: BoxDecoration(color: grey!.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8.r), border: Border.all(color: black,width: 0.5.w)),child: paddingg(15, 15,0, Align(
                            alignment:Alignment.centerLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      text(context,termsToApi.isEmpty ?' اضافة بنود العقد': 'معاينة وتعديل البنود', 17, newGrey),
                                      GestureDetector(
                                        onTap: (){

                                        },
                                        child: IconButton(onPressed:(){
                                          showTermsDialog(this.context);
                                          adding && terms.isEmpty?{terms.add(Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:15.h),
                                              child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                                            ),
                                          ),),
                                            setState(() {
                                              adding= false;
                                            })}: null;

                                          print('when close -----------------------');
                                        },icon: Icon(termsToApi.isEmpty ?add:show, color: newGrey,)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),),
                      )),
                      SizedBox(height: 10.h,),
                      paddingg(3.w, 15.w, 0.h,  text(context, 'ميزانية الاعلان (ر.س)', 17, newGrey)),
                      SizedBox(height: 5.h,),
                      Row(
                        children: [
                          Expanded(
                            child: paddingg(3.w, 15.w, 0.h,textFieldNoIcon(context, 'السعر الادنى للاعلان', textFieldSize, false, balanceFrom,(String? value) {
                              if (value == null || value.isEmpty) {
                                return ;}

                              return null;},false,
                              keyboardType:
                              TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly
                              ],),),),
                          Expanded(
                            child: paddingg(15.w, 3.w, 0.h,textFieldNoIcon(context, 'السعر الاعلى للاعلان', textFieldSize, false, balanceTo,(String? value) {if (value == null || value.isEmpty) {
                              return ;}
                            return null;}, false,
                              keyboardType:
                              TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly
                              ],),),
                          ),

                        ],
                      ),
                      paddingg(
                        15,
                        15,
                        15,
                        uploadImg(
                            50, 45, text(context,file != null? 'تغيير الصورة': 'قم بإرفاق ملف الاعلان', textError, black),
                                () {
                              getFile(context);
                            }),
                      ),
                      InkWell(
                          onTap: (){
                            file != null? showDialog(
                              useSafeArea: true,
                              context: this.context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                _timer = Timer(Duration(seconds: 2), () {
                                  Navigator.of(context).pop();    // == First dialog closed
                                });
                                return
                                  Container(
                                      height: double.infinity,
                                      child: Image.file(file!));},
                            ):null;},
                          child: paddingg(15.w, 30.w, file != null?10.h: 0.h,Row(
                            children: [
                              file != null? Icon(Icons.image, color: newGrey,): SizedBox(),
                              SizedBox(width: file != null?5.w: 0.w),
                              text(context,  file == null && checkit2 ? 'الرجاء اضافة صورة': file != null? 'معاينة الصورة':'' , file != null?textError+1 :textError,file != null?black:red!,),
                            ],
                          ))),

                      paddingg(
                        15,
                        15,
                        15,
                        SizedBox(
                            height: 45.h,
                            child: InkWell(
                              child: gradientContainerNoborder(
                                  97,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        scheduale,
                                        color: white,
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      text(context, date.day != DateTime.now().day ?date.year.toString()+ '/'+date.month.toString()+ '/'+date.day.toString() :'تاريخ الاعلان', textTitleSize.sp, white,
                                          fontWeight: FontWeight.bold),
                                    ],
                                  )),
                              onTap: () async {
                                DateTime? endDate =
                                await showDatePicker(
                                    context: this.context,
                                    builder: (context, child) {
                                      return Theme(
                                          data: ThemeData.light().copyWith(
                                              colorScheme:
                                              const ColorScheme.light(primary: purple, onPrimary: white)),
                                          child: child!);},
                                    initialDate:
                                    date,
                                    firstDate:
                                    DateTime(2000),
                                    lastDate: DateTime(2100));

                                if (endDate == null)
                                  return;
                                setState(() {
                                  date= endDate;
                                  date.isBefore(DateTime.now()) ?{ date.day != DateTime.now().day?dateInvalid= true: dateInvalid= false}:
                                  dateInvalid= false;
                                  FocusManager.instance.primaryFocus
                                      ?.unfocus();
                                });
                              },
                            )),
                      ),

                      paddingg(15.w, 20.w, 2.h,text(context,  checkit2 && date.day == DateTime.now().day ? 'الرجاء اختيار تاريخ النشر':dateInvalid? 'التاريخ غير صالح': '', textError,red!,)),


                      paddingg(
                        0,
                        0,
                        12,
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: RichText(
                              text:  TextSpan(children: [
                                TextSpan(
                                    text:
                                    ' عند الطلب ، فإنك توافق على شروط الإستخدام و سياسة الخصوصيةالخاصة ب  ',
                                    style: TextStyle(
                                        color: black, fontFamily: 'Cairo', fontSize: textError)),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = () async {
                                     showDialogFunc(this.context, '', advPP);
                                    },
                                    text:cname == null? '': cname!,
                                    style: TextStyle(
                                        color: blue, fontFamily: 'Cairo', fontSize: 12))
                              ])),
                          value: checkit2,
                          selectedTileColor: black,
                          onChanged: (value) {
                            setState(() {
                              setState(() {
                                checkit2 = value!;
                                if(_formKey3.currentState!.validate()){
                                  if( date.day == DateTime.now().day || file == null ){
                                    setState(() {
                                      _selectedTest4 == null? platformChosen= false: platformChosen = true;
                                      date.day == DateTime.now().day? datewarn2 = true: false;
                                      file == null? warnimage =true:false;
                                    });
                                  }
                                }
                              });
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ]),
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
            ]),
      ),
    );
  }

  buildCompleted(context) {
    goTopagepush(context, MainScreen());
  }

  Future<File?> getFile(context) async {

    PickedFile? pickedFile =
    await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    final File f = File(pickedFile.path);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.path);
    final String fileExtension = Path.extension(fileName);
    File newImage = await f.copy('$path/$fileName');
    if(fileExtension == ".png" || fileExtension == ".jpg"){
      setState(() {
        file = newImage;
      });
    }else{ showMassage(context, 'عذرا', 'png او jpg صيغة الصورة غير مسموح بها, الرجاء رفع الصورة بصيغة ');}

    // }else{ ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(
    //   content: Text(
    //       "امتداد الصورة غير مسموح به",style: TextStyle(color: Colors.red)),
    // ));}
  }
  showDialogFunc(context, title, areaDes) {
    return showDialog(
      context: context,
      builder: (contextt) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: white,
              ),
              padding: EdgeInsets.only(top: 15.h, right: 20.w, left: 20.w),
              height: 400.h,
              width: 380.w,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  textDirection: TextDirection.rtl,
                  children: [
                    ///Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///text
                        text(contextt, 'تفاصيل سياسة التعامل', 14, grey!),
                      ],
                    ),

                    SizedBox(
                      height: 30.h,
                    ),

                    ///---------------------

                    ///Area Title
                    text(contextt, 'سياسة الاعلان', 16, black,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 5.h,
                    ),

                    ///Area Details
                    text(
                      contextt,
                      areaDes,
                      14,
                      ligthtBlack,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //-----------------------------------------------------------------
  showTermsDialog(context){

    print(termsToApi.length.toString()+'////////////////////////////////////////');
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context2) {
          return StatefulBuilder(
            builder: (context2,sets){
              return Padding(
                padding:  EdgeInsets.only(top: 100.h, bottom: MediaQuery.of(context2).viewInsets.bottom, left: 20.w, right:20.w ),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.transparent,
                    child: Card(
                      child: Padding(
                          padding:  EdgeInsets.only(top: 30.h, bottom: 20.h, left: 10.w, right:10.w ),
                          child: paddingg(15, 15,0, Column(
                            children: [
                              Container(
                                height:425.h,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    SingleChildScrollView(
                                      child: Container(height: 425.h, width: double.infinity,child:
                                      ListView.builder(
                                        shrinkWrap:true,
                                        itemCount: terms.length,
                                        controller: _controller,
                                        itemBuilder: (context, index){
                                          return Directionality(
                                              textDirection: TextDirection.rtl,
                                              child:
                                              Column(children: [
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children:[
                                                      Row(
                                                        children: [
                                                          terms[index],
                                                        ],
                                                      ),

                                                      adding?
                                                      index != 0 && !adding?
                                                      i == index?
                                                      InkWell(onTap:(){sets((){ updateTerm(index);
                                                      i = -1;
                                                      });},child: Icon(done)):Row(children: [
                                                        InkWell(onTap:(){sets((){removeTerm(index);});},child: Icon(remove, color: red,)),SizedBox(width: 13.w,),
                                                        InkWell(onTap: () {
                                                          setState(() {
                                                            i = index;
                                                          });
                                                          sets(() {
                                                            i = index;
                                                            editTerm(index);
                                                            print(i.toString() + '................................');
                                                          });},child: Icon(editDiscount, color: newGrey,))],):
                                                      index != terms.length && adding?
                                                      i != index?
                                                      Row(children: [
                                                        InkWell(onTap:(){sets((){removeTerm(index);});},child: Icon(remove, color: red,)),SizedBox(width: 13.w,),
                                                        InkWell(onTap: (){
                                                          setState(() {
                                                            i = index;
                                                          });
                                                          sets(() {
                                                            i = index;
                                                            print(i.toString() + '................................');
                                                            editTerm(index);
                                                          });},child: Icon(editDiscount, color: newGrey,))],):  InkWell(onTap:(){sets((){ updateTerm(index);
                                                      i = -1;});},child: Icon(done, color: newGrey,)):SizedBox():SizedBox(),


                                                    ]),
                                                index != terms.length && adding?   SizedBox(
                                                  width: 300.w,
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(top: 10.h),
                                                    child: Divider(height: 0.75.h,),
                                                  ),
                                                ):  index != terms.length-1?
                                                SizedBox(
                                                  width: 300.w,
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(top: 10.h),
                                                    child: Divider(height: 0.75.h,),
                                                  ),
                                                )
                                                    : SizedBox()],)

                                          );
                                        },

                                      )),
                                    ),


                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    !adding? IconButton(onPressed: (){
                                      sets(() {
                                        terms.removeAt(0);
                                        termController.clear();
                                        adding = true;
                                      });
                                    },icon: Icon(cancel, color: newGrey,)):SizedBox(),
                                    SizedBox(width: 10.w,),
                                    IconButton(onPressed:  (){
                                      sets(() {
                                        print(adding.toString() +'when open -----------------------');
                                        adding?{
                                          terms.insert(0,Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:20.h),
                                              child: Container(width:300.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
                                            ),
                                          ),),
                                          adding = false}:{
                                          terms.removeAt(0),
                                          termController.text.isEmpty?
                                          null:terms.add(Container(
                                            width:230.w,
                                            child: Padding(
                                              padding:  EdgeInsets.only(top:8.h),
                                              child: SizedBox(width: 230.w,child: text(context, termController.text, 16, black,align: TextAlign.start,)),
                                            ),
                                          )),


                                          termController.text.isEmpty?
                                          null:termsToApi.add(termController.text),
                                          setState(() {

                                          }),
                                          termController.clear(),
                                          adding = true,
                                        };
                                        print('when open -----------------------');
                                        !adding?_animateToIndex(0,50.0.h):_animateToIndex(terms.length,200.0.h);
                                      });
                                    },icon: Icon( !adding?Icons.done:i != -1?null:Icons.add, color: newGrey,size: 35.r,)),

                                  ],
                                ),
                              ),
                            ],
                          ))),
                    ),
                  ),
                ),
              );
            },
          );});
  }
  removeTerm(index){
    print(index.toString()+'the index count');
    setState(() {
      // termsToApi.removeAt(index);
      terms.removeAt(index);
      termsToApi.removeAt(index);
    });

  }
  updateTerm(index){
    setState(() {
      // termsToApi.removeAt(index);
      terms.removeAt(index);
      terms.insert(index, Container(width:200.w,
        child: Padding(
          padding:  EdgeInsets.only(top:8.h),
          child: SizedBox(width: 220.w,child: text(context, termController.text, 16, black,align: TextAlign.start,)),
        ),
      ));
    });
    i =-1;
    termsToApi[index] = termController.text;
    termController.clear();
  }
  editTerm(index){
    setState(() {
      termController.text = termsToApi[index];
      // termsToApi.removeAt(index);
      terms.removeAt(index);
      terms.insert(index, Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding:  EdgeInsets.only(top:20.h),
          child: Row(
            children: [
              //Icon(Icons.done),
              Container(width:270.w,child: textFieldNoIcon(context, 'قم باضافة بند', 18, false, termController, (value){}, false,onTap: (value){} )),
            ],
          ),
        ),
      ),);
      // termsToApi.removeAt(index);
    });

  }
  void _animateToIndex(int index, double height) {
    _controller!.animateTo(
      index * height,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }
  //--------------------------------------------------------

  Future<Budget> fetchFolowers() async {

    final response = await http.get(
      Uri.parse('https://mobile.celebrityads.net/api/follower-number'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      _dropdownTestItems7.isEmpty
          ? {
        setState(() {
          followerslist
              .add({'no': -1, 'keyword': 'عدد المتابعين'});
          for (int i = 0;
          i < jsonDecode(response.body)['data'].length;
          i++)
          {
            followerslist.add({
              'no': i,
              'keyword':
              jsonDecode(response.body)['data'][i]['from_to'].toString()
            });
          };
          _dropdownTestItems7 = buildDropdownTestItems(followerslist);
        }),

      }
          : null;
      return Budget.fromJson(jsonDecode(response.body));

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load activity');
    }



  }
  Future<File?> getFile2(context) async {
    FilePickerResult? pickedFile =
    await FilePicker.platform.pickFiles(type: FileType.any);
    if (pickedFile == null) {
      return null;
    }
    final File f = File(pickedFile.paths[0]!);
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final String fileName = Path.basename(pickedFile.paths[0]!);
    final String fileExtension = Path.extension(fileName);
    File newImage = await f.copy('$path/$fileName');
    if( fileExtension == ".pdf" ) {
      setState(() {
        file2 = newImage;
        showFile = path + '/' +fileName;
      });
    }else{  showMassage(context, 'عذرا', 'pdf صيغة الملف غير مسموح بها, الرجاء رفع ملف بصيغة ');}
  }
}

class Filter {
  bool? success;
  List<Data>? data;

  Filter({this.success, this.data});

  Filter.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  City? city;
  City? gender;
  String? description;
  String? pageUrl;
  String? fullPageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  String? store;
  CategoryFilter? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;
  int? availableBalance;
  int? outstandingBalance;

  Data(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.phonenumber,
        this.country,
        this.city,
        this.gender,
        this.description,
        this.pageUrl,
        this.fullPageUrl,
        this.snapchat,
        this.tiktok,
        this.youtube,
        this.instagram,
        this.twitter,
        this.facebook,
        this.store,
        this.category,
        this.brand,
        this.advertisingPolicy,
        this.giftingPolicy,
        this.adSpacePolicy,
        this.availableBalance,
        this.outstandingBalance});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    gender = json['gender'] != null ? new City.fromJson(json['gender']) : null;
    description = json['description'];
    pageUrl = json['page_url'];
    fullPageUrl = json['full_page_url'];
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    store = json['store'];
    category = json['category'] != null
        ? new CategoryFilter.fromJson(json['category'])
        : null;
    brand = json['brand'];
    advertisingPolicy = json['advertising_policy'];
    giftingPolicy = json['gifting_policy'];
    adSpacePolicy = json['ad_space_policy'];
    availableBalance = json['available_balance'];
    outstandingBalance = json['outstanding_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.gender != null) {
      data['gender'] = this.gender!.toJson();
    }
    data['description'] = this.description;
    data['page_url'] = this.pageUrl;
    data['full_page_url'] = this.fullPageUrl;
    data['snapchat'] = this.snapchat;
    data['tiktok'] = this.tiktok;
    data['youtube'] = this.youtube;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    data['store'] = this.store;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['brand'] = this.brand;
    data['advertising_policy'] = this.advertisingPolicy;
    data['gifting_policy'] = this.giftingPolicy;
    data['ad_space_policy'] = this.adSpacePolicy;
    data['available_balance'] = this.availableBalance;
    data['outstanding_balance'] = this.outstandingBalance;
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
  int? id;
  String? name;
  String? nameEn;

  City({this.id, this.name, this.nameEn});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    return data;
  }
}

class CategoryFilter {
  String? name;
  String? nameEn;

  CategoryFilter({this.name, this.nameEn});

  CategoryFilter.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
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

class Platform {
  bool? success;
  List<DataPlatform>? data;
  Message? message;

  Platform({this.success, this.data, this.message});

  Platform.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataPlatform>[];
      json['data'].forEach((v) {
        data!.add(new DataPlatform.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}
class DataPlatform {
  int? id;
  String ? name;
  String ? name_en;


  DataPlatform({this.id, this.name, this.name_en});

  DataPlatform.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    name_en = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.name_en;
    return data;
  }
}


class Budget {
  bool? success;
  List<DataBudget>? data;
  MessageBudget? message;

  Budget({this.success, this.data, this.message});

  Budget.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataBudget>[];
      json['data'].forEach((v) {
        data!.add(new DataBudget.fromJson(v));
      });
    }
    message =
    json['message'] != null ? new MessageBudget.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    return data;
  }
}

class DataBudget {
  int? id;
  int? from;
  int? to;
  String? fromto;

  DataBudget({this.id, this.from ,this.fromto, this.to});

  DataBudget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
    fromto = json['from_to'] == null? null: json['from_to'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from'] = this.from;
    data['to'] = this.to;
    this.fromto == null? null: data['from_to'] = this.fromto;
    return data;
  }
}

class MessageBudget {
  String? en;
  String? ar;

  MessageBudget({this.en, this.ar});

  MessageBudget.fromJson(Map<String, dynamic> json) {
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