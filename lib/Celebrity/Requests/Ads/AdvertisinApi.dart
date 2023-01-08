import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

//accept Advertising Order--------------------------------------------------------------------------------------
Future acceptAdvertisingOrder(String token, int orderId, int price,
    {File? signature}) async {
  Map<String, dynamic> data = {
    "price": '$price',
  };
  String url =
      "https://mobile.celebrityads.net/api/celebrity/order/accept/$orderId";
  try {
    final respons = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: data);

    if (respons.statusCode == 200) {
      var success = jsonDecode(respons.body)["success"];
      var message = jsonDecode(respons.body)["message"]["en"];

      print('------------------------------------');
      print('message is: $message');
      print(respons.body);
      print('------------------------------------');

      if (success == true) {
        return true;
      } else if (message == 'User is banned!') {
        return 'User is banned!';
      } else {
        return false;
      }
    }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if (e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';
    }
  }
  return false;
}

//=====================================================================================
Future acceptAdvertisingOrder2(String token, int orderId, int price,
    {ByteData? signature}) async {
  try {
    final directory = await getTemporaryDirectory();
    final filepath = directory.path + '/' + "signature.png";
    File imgFile =
        await File(filepath).writeAsBytes(signature!.buffer.asUint8List());
    var stream = http.ByteStream(DelegatingStream.typed(imgFile.openRead()));
    var length = await imgFile.length();
    var uri = Uri.parse(
        "https://mobile.celebrityads.net/api/celebrity/order/accept/$orderId");

    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile(
        'celebrity_signature', stream, length,
        filename: path.basename(imgFile.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    request.fields["price"] = '$price';
    var response = await request.send();
    http.Response respons = await http.Response.fromStream(response);
    print('respons.statusCode:${respons.statusCode}');
    if (respons.statusCode == 200) {
      var success = jsonDecode(respons.body)["success"];
      var message = jsonDecode(respons.body)["message"]["en"];

      print('------------------------------------');
      print('message is: $message');
      print(message);
      print('------------------------------------');

      if (success == true) {
        return true;
      } else if (message == 'User is banned!') {
        return 'User is banned!';
      } else {
        return false;
      }
    }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if (e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';
    }
  }
  return false;
}

//Delivery order===============================================================================
Future deliveryOrder(String token, int orderId, File video) async {
 try {
  var stream = http.ByteStream(DelegatingStream.typed(video.openRead()));
  // get file length
  var length = await video.length();
  var uri = Uri.parse(
      "https://mobile.celebrityads.net/api/celebrity/order/delivary/$orderId");

  Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };

  var request = http.MultipartRequest("POST", uri);
  var multipartFile = http.MultipartFile('delivary_file', stream, length,
      filename: path.basename(video.path));

  request.files.add(multipartFile);
  request.headers.addAll(headers);
  // request.fields["price"] = '$price';
  var response = await request.send();
  http.Response respons = await http.Response.fromStream(response);
  print('respons.statusCode:${respons.statusCode}');
  if (respons.statusCode == 200) {
    var success = jsonDecode(respons.body)["success"];
    var message = jsonDecode(respons.body)["message"]["en"];
    print('------------------------------------');
    print('message is: $message');
    print(message);
    print('------------------------------------');
    if (success == true) {
      return true;
    } else if (message == 'User is banned!') {
      return 'User is banned!';
    } else {
      return false;
    }
  }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if (e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';
    }
  }
  return false;
}

//reject Advertising Order--------------------------------------------------------------------------------------
Future rejectAdvertisingOrder(
    String token, int orderId, String reson, int resonId) async {
  Map<String, dynamic> data = {
    "reject_reson": reson,
    "reject_reson_id": '$resonId'
  };
  String url =
      "https://mobile.celebrityads.net/api/celebrity/order/reject/$orderId";
  try {
    final respons = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: data);

    if (respons.statusCode == 200) {
      print(respons.body);
      var success = jsonDecode(respons.body)["success"];

      print('------------------------------------');
      print(success);
      print('------------------------------------');

      if (success == true) {
        return true;
      } else {
        return false;
      }
    }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if (e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';
    }
  }
  return false;
}

//create Conversation--------------------------------------------------------------------------------------
Future createConversation(
    int userId, String token, String type, String body) async {
  Map<String, dynamic> data = {
    "user_id": '$userId',
    "message_type": type,
    "body": body,
  };
  String url =
      "https://mobile.celebrityads.net/api/celebrity/conversation/create";
  try {
    final respons = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: data);

    if (respons.statusCode == 200) {
      print(respons.body);
      var success = jsonDecode(respons.body)["success"];
      print('------------------------------------');
      print(success);
      print('------------------------------------');

      if (success == true) {
        return true;
      } else {
        return false;
      }
    }
  } catch (e) {
    if (e is SocketException) {
      return 'SocketException';
    } else if (e is TimeoutException) {
      return 'TimeoutException';
    } else {
      return 'serverException';
    }
  }
  return false;
}

//------------------------------------------------------------------
class Advertising {
  bool? success;
  Data? data;
  Message? message;

  Advertising({this.success, this.data, this.message});

  Advertising.fromJson(Map<String, dynamic> json) {
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
  int? pageCount;
  List<AdvertisingOrders>? advertisingOrders;
  int? status;

  Data({this.pageCount, this.advertisingOrders, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    pageCount = json['page_count'];
    if (json['advertisingOrders'] != null) {
      advertisingOrders = <AdvertisingOrders>[];
      json['advertisingOrders'].forEach((v) {
        advertisingOrders!.add(new AdvertisingOrders.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_count'] = this.pageCount;
    if (this.advertisingOrders != null) {
      data['advertisingOrders'] =
          this.advertisingOrders!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class AdvertisingOrders {
  int? id;
  Celebrity? celebrity;
  User? user;
  String? date;
  City? adType;
  City? status;
  int? price;
  String? description;
  City? adOwner;
  City? advertisingAdType;
  City? adFeature;
  City? adTiming;
  String? file;
  String? advertisingName;
  String? advertisingLink;
  String? commercialRecord;
  City? platform;
  City? rejectReson;
  Contract? contract;

  AdvertisingOrders(
      {this.id,
      this.contract,
      this.celebrity,
      this.user,
      this.date,
      this.adType,
      this.status,
      this.price,
      this.description,
      this.adOwner,
      this.advertisingAdType,
      this.adFeature,
      this.adTiming,
      this.file,
      this.advertisingName,
      this.advertisingLink,
      this.platform,
      this.commercialRecord,
      this.rejectReson});

  AdvertisingOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    adType =
        json['ad_type'] != null ? new City.fromJson(json['ad_type']) : null;
    status = json['status'] != null ? new City.fromJson(json['status']) : null;
    price = json['price'];
    description = json['description'];
    adOwner =
        json['ad_owner'] != null ? new City.fromJson(json['ad_owner']) : null;
    advertisingAdType = json['advertising_ad_type'] != null
        ? new City.fromJson(json['advertising_ad_type'])
        : null;
    adFeature = json['ad_feature'] != null
        ? new City.fromJson(json['ad_feature'])
        : null;
    adTiming =
        json['ad_timing'] != null ? new City.fromJson(json['ad_timing']) : null;
    file = json['file'];
    advertisingName = json['advertising_name'];
    advertisingLink = json['advertising_link'];
    commercialRecord = json['commercial_record'];
    platform =
        json['platform'] != null ? new City.fromJson(json['platform']) : null;
    rejectReson = json['reject_reson'] != null
        ? new City.fromJson(json['reject_reson'])
        : null;
    contract = json['contract'] != null
        ? new Contract.fromJson(json['contract'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['commercial_record'] = this.commercialRecord;
    if (this.celebrity != null) {
      data['celebrity'] = this.celebrity!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['date'] = this.date;
    if (this.adType != null) {
      data['ad_type'] = this.adType!.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    data['price'] = this.price;
    data['description'] = this.description;
    if (this.adOwner != null) {
      data['ad_owner'] = this.adOwner!.toJson();
    }
    if (this.contract != null) {
      data['contract'] = this.contract!.toJson();
    }
    if (this.advertisingAdType != null) {
      data['advertising_ad_type'] = this.advertisingAdType!.toJson();
    }
    if (this.adFeature != null) {
      data['ad_feature'] = this.adFeature!.toJson();
    }
    if (this.adTiming != null) {
      data['ad_timing'] = this.adTiming!.toJson();
    }
    data['file'] = this.file;
    data['advertising_name'] = this.advertisingName;
    data['advertising_link'] = this.advertisingLink;
    if (this.platform != null) {
      data['platform'] = this.platform!.toJson();
    }
    if (this.rejectReson != null) {
      data['reject_reson'] = this.rejectReson!.toJson();
    }
    return data;
  }
}

class Celebrity {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? nationality;
  Country? country;
  City? city;
  City? gender;
  String? description;
  String? pageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  Category? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;
  String? commercialRegistrationNumber;
  String? idNumber;
  String? celebrityType;
  Celebrity(
      {this.id,
      this.username,
      this.name,
      this.image,
      this.email,
      this.phonenumber,
      this.country,
      this.celebrityType,
      this.city,
      this.gender,
      this.nationality,
      this.description,
      this.pageUrl,
      this.snapchat,
      this.tiktok,
      this.youtube,
      this.instagram,
      this.twitter,
      this.facebook,
      this.category,
      this.brand,
      this.advertisingPolicy,
      this.giftingPolicy,
      this.adSpacePolicy,
      this.commercialRegistrationNumber,
      this.idNumber});

  Celebrity.fromJson(Map<String, dynamic> json) {
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
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    celebrityType = json['celebrity_type'];
    facebook = json['facebook'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    nationality = json['nationality'] != null
        ? new Country.fromJson(json['nationality'])
        : null;
    brand = json['brand'];
    advertisingPolicy = json['advertising_policy'];
    giftingPolicy = json['gifting_policy'];
    adSpacePolicy = json['ad_space_policy'];
    commercialRegistrationNumber = json['commercial_registration_number'];
    idNumber = json['id_number'];
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
    if (this.nationality != null) {
      data['nationality'] = this.nationality!.toJson();
    }
    data['description'] = this.description;
    data['celebrity_type'] = this.celebrityType;
    data['page_url'] = this.pageUrl;
    data['snapchat'] = this.snapchat;
    data['tiktok'] = this.tiktok;
    data['youtube'] = this.youtube;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['brand'] = this.brand;
    data['advertising_policy'] = this.advertisingPolicy;
    data['gifting_policy'] = this.giftingPolicy;
    data['ad_space_policy'] = this.adSpacePolicy;
    data['commercial_registration_number'] = this.commercialRegistrationNumber;
    data['id_number'] = this.idNumber;
    return data;
  }
}

class Contract {
  String? userName;
  String? celebrityName;
  String? userSignature;
  String? celebritySignature;
  int? celebrityId;
  int? userId;
  int? orderId;
  String? pdf;
  String? date;

  Contract(
      {this.userName,
      this.date,
      this.celebrityName,
      this.userSignature,
      this.celebritySignature,
      this.celebrityId,
      this.userId,
      this.orderId,
      this.pdf});

  Contract.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    celebrityName = json['celebrity_name'];
    userSignature = json['user_signature'];
    celebritySignature = json['celebrity_signature'];
    celebrityId = json['celebrity_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    pdf = json['pdf'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['celebrity_name'] = this.celebrityName;
    data['user_signature'] = this.userSignature;
    data['celebrity_signature'] = this.celebritySignature;
    data['celebrity_id'] = this.celebrityId;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['pdf'] = this.pdf;
    data['date'] = this.date;
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
  Country? nationality;
  Country? country;
  City? city;
  City? gender;
  City? accountStatus;
  String? type;
  String? commercialRegistrationNumber;
  String? idNumber;

  User(
      {this.id,
      this.username,
      this.name,
      this.image,
      this.email,
      this.phonenumber,
      this.country,
      this.nationality,
      this.city,
      this.gender,
      this.accountStatus,
      this.commercialRegistrationNumber,
      this.idNumber,
      this.type});

  User.fromJson(Map<String, dynamic> json) {
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
    accountStatus = json['account_status'] != null
        ? new City.fromJson(json['account_status'])
        : null;
    nationality = json['nationality'] != null
        ? new Country.fromJson(json['nationality'])
        : null;
    commercialRegistrationNumber = json['commercial_registration_number'];
    idNumber = json['id_number'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['name'] = this.name;
    data['image'] = this.image;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['commercial_registration_number'] = this.commercialRegistrationNumber;
    data['id_number'] = this.idNumber;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.nationality != null) {
      data['nationality'] = this.nationality!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.gender != null) {
      data['gender'] = this.gender!.toJson();
    }
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    data['type'] = this.type;
    return data;
  }
}

class Country {
  int? id;
  String? countryCode;
  String? name;
  String? nameEn;
  String? countryEnNationality;
  String? countryArNationality;
  String? flag;

  Country(
      {this.id,
      this.countryCode,
      this.name,
      this.nameEn,
      this.countryEnNationality,
      this.countryArNationality,
      this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['country_code'];
    name = json['name'];
    nameEn = json['name_en'];
    countryEnNationality = json['country_enNationality'];
    countryArNationality = json['country_arNationality'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_code'] = this.countryCode;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['country_enNationality'] = this.countryEnNationality;
    data['country_arNationality'] = this.countryArNationality;
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

class Category {
  String? name;
  String? nameEn;

  Category({this.name, this.nameEn});

  Category.fromJson(Map<String, dynamic> json) {
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
