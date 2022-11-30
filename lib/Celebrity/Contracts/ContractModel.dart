import '../verifyAccount/VerificationModel.dart';

class Contract {
  bool? success;
  Data? data;
  Message? message;

  Contract({this.success, this.data, this.message});

  Contract.fromJson(Map<String, dynamic> json) {
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
  List<Orders>? orders;
  int? status;

  Data({this.pageCount, this.orders, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    pageCount = json['page_count'];
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_count'] = this.pageCount;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Orders {
  int? id;
  Celebrity? celebrity;
  User? user;
  String? date;
  Area? adType;
  Area? status;
  int? price;
  String? priceAfterDeduction;
  String? description;
  Null? celebrityPromoCode;
  Area? adOwner;
  Area? advertisingAdType;
  Area? adFeature;
  Area? adTiming;
  String? file;
  String? commercialRecord;
  String? advertisingName;
  String? advertisingLink;
  Area? platform;
  Null? rejectReson;
  String? rejectResonAdmin;
  contact? contract;
  String? image;
  String? link;

  Orders(
      {this.id,
        this.celebrity,
        this.user,
        this.date,
        this.adType,
        this.status,
        this.price,
        this.priceAfterDeduction,
        this.description,
        this.celebrityPromoCode,
        this.adOwner,
        this.advertisingAdType,
        this.adFeature,
        this.adTiming,
        this.file,
        this.commercialRecord,
        this.advertisingName,
        this.advertisingLink,
        this.platform,
        this.rejectReson,
        this.rejectResonAdmin,
        this.contract,
        this.image,
        this.link});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    celebrity = json['celebrity'] != null
        ? new Celebrity.fromJson(json['celebrity'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    date = json['date'];
    adType =
    json['ad_type'] != null ? new Area.fromJson(json['ad_type']) : null;
    status = json['status'] != null ? new Area.fromJson(json['status']) : null;
    price = json['price'];
    priceAfterDeduction = json['price_after_deduction'];
    description = json['description'];
    celebrityPromoCode = json['celebrity_promo_code'];
    adOwner =
    json['ad_owner'] != null ? new Area.fromJson(json['ad_owner']) : null;
    advertisingAdType = json['advertising_ad_type'] != null
        ? new Area.fromJson(json['advertising_ad_type'])
        : null;
    adFeature = json['ad_feature'] != null
        ? new Area.fromJson(json['ad_feature'])
        : null;
    adTiming =
    json['ad_timing'] != null ? new Area.fromJson(json['ad_timing']) : null;
    file = json['file'];
    commercialRecord = json['commercial_record'];
    advertisingName = json['advertising_name'];
    advertisingLink = json['advertising_link'];
    platform =
    json['platform'] != null ? new Area.fromJson(json['platform']) : null;
    rejectReson = json['reject_reson'];
    rejectResonAdmin = json['reject_reson_admin'];
    contract = json['contract'] != null
        ? new contact.fromJson(json['contract'])
        : null;
    image = json['image'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['price_after_deduction'] = this.priceAfterDeduction;
    data['description'] = this.description;
    data['celebrity_promo_code'] = this.celebrityPromoCode;
    if (this.adOwner != null) {
      data['ad_owner'] = this.adOwner!.toJson();
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
    data['commercial_record'] = this.commercialRecord;
    data['advertising_name'] = this.advertisingName;
    data['advertising_link'] = this.advertisingLink;
    if (this.platform != null) {
      data['platform'] = this.platform!.toJson();
    }
    data['reject_reson'] = this.rejectReson;
    data['reject_reson_admin'] = this.rejectResonAdmin;
    if (this.contract != null) {
      data['contract'] = this.contract!.toJson();
    }
    data['image'] = this.image;
    data['link'] = this.link;
    return data;
  }
}

class Celebrity {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? type;
  String? phonenumber;
  Country? country;
  Country? nationality;
  Area? area;
  Area? city;
  Area? gender;
  String? description;
  String? pageUrl;
  String? fullPageUrl;
  String? snapchat;
  String? tiktok;
  String? youtube;
  String? instagram;
  String? twitter;
  String? facebook;
  SnapchatNumber? snapchatNumber;
  SnapchatNumber? tiktokNumber;
  SnapchatNumber? youtubeNumber;
  SnapchatNumber? instagramNumber;
  SnapchatNumber? twitterNumber;
  SnapchatNumber? facebookNumber;
  String? store;
  Category? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;
  int? availableBalance;
  int? outstandingBalance;
  Area? accountStatus;
  City? verifiedStatus;
  String? verifiedRejectReson;
  String? celebrityType;
  String? verifiedFile;
  String? commercialRegistrationNumber;
  String? idNumber;

  Celebrity(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.type,
        this.phonenumber,
        this.country,
        this.nationality,
        this.area,
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
        this.snapchatNumber,
        this.tiktokNumber,
        this.youtubeNumber,
        this.instagramNumber,
        this.twitterNumber,
        this.facebookNumber,
        this.store,
        this.category,
        this.brand,
        this.advertisingPolicy,
        this.giftingPolicy,
        this.adSpacePolicy,
        this.availableBalance,
        this.outstandingBalance,
        this.accountStatus,
        this.verifiedStatus,
        this.verifiedRejectReson,
        this.celebrityType,
        this.verifiedFile,
        this.commercialRegistrationNumber,
        this.idNumber});

  Celebrity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    type = json['type'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    nationality = json['nationality'] != null
        ? new Country.fromJson(json['nationality'])
        : null;
    area = json['area'] != null ? new Area.fromJson(json['area']) : null;
    city = json['city'] != null ? new Area.fromJson(json['city']) : null;
    gender = json['gender'] != null ? new Area.fromJson(json['gender']) : null;
    description = json['description'];
    pageUrl = json['page_url'];
    fullPageUrl = json['full_page_url'];
    snapchat = json['snapchat'];
    tiktok = json['tiktok'];
    youtube = json['youtube'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    snapchatNumber = json['snapchat_number'] != null
        ? new SnapchatNumber.fromJson(json['snapchat_number'])
        : null;
    tiktokNumber = json['tiktok_number'] != null
        ? new SnapchatNumber.fromJson(json['tiktok_number'])
        : null;
    youtubeNumber = json['youtube_number'] != null
        ? new SnapchatNumber.fromJson(json['youtube_number'])
        : null;
    instagramNumber =json['instagram_number'] != null
        ? new SnapchatNumber.fromJson(json['instagram_number'])
        : null;
    twitterNumber = json['twitter_number'] != null
        ? new SnapchatNumber.fromJson(json['twitter_number'])
        : null;
    facebookNumber= json['facebook_number'] != null
    ? new SnapchatNumber.fromJson(json['facebook_number'])
        : null;
    store = json['store'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    brand = json['brand'];
    advertisingPolicy = json['advertising_policy'];
    giftingPolicy = json['gifting_policy'];
    adSpacePolicy = json['ad_space_policy'];
    availableBalance = json['available_balance'];
    outstandingBalance = json['outstanding_balance'];
    accountStatus = json['account_status'] != null
        ? new Area.fromJson(json['account_status'])
        : null;
    verifiedStatus = json['verified_status'] != null? City.fromJson(json['verified_status']): null;
    verifiedRejectReson = json['verified_reject_reson'];
    celebrityType = json['celebrity_type'];
    verifiedFile = json['verified_file'];
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
    data['type'] = this.type;
    data['phonenumber'] = this.phonenumber;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.nationality != null) {
      data['nationality'] = this.nationality!.toJson();
    }
    if (this.area != null) {
      data['area'] = this.area!.toJson();
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
    if (this.snapchatNumber != null) {
      data['snapchat_number'] = this.snapchatNumber!.toJson();
    }
    if (this.tiktokNumber != null) {
      data['tiktok_number'] = this.tiktokNumber!.toJson();
    }
    data['youtube_number'] = this.youtubeNumber;
    data['instagram_number'] = this.instagramNumber;
    data['twitter_number'] = this.twitterNumber;
    data['facebook_number'] = this.facebookNumber;
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
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    data['verified_status'] = this.verifiedStatus;
    data['verified_reject_reson'] = this.verifiedRejectReson;
    data['celebrity_type'] = this.celebrityType;
    data['verified_file'] = this.verifiedFile;
    data['commercial_registration_number'] = this.commercialRegistrationNumber;
    data['id_number'] = this.idNumber;
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

class Area {
  int? id;
  String? name;
  String? nameEn;

  Area({this.id, this.name, this.nameEn});

  Area.fromJson(Map<String, dynamic> json) {
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

class SnapchatNumber {
  int? id;
  int? from;
  int? to;
  String? fromTo;

  SnapchatNumber({this.id, this.from, this.to, this.fromTo});

  SnapchatNumber.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
    fromTo = json['from_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from'] = this.from;
    data['to'] = this.to;
    data['from_to'] = this.fromTo;
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

class User {
  int? id;
  String? username;
  String? name;
  String? image;
  String? email;
  String? phonenumber;
  Country? country;
  Country? nationality;
  Area? area;
  Area? city;
  Area? gender;
  String? type;
  String? celebrityType;
  String? availableBalance;
  int? outstandingBalance;
  Area? accountStatus;
  Area? verifiedStatus;
  String? verifiedRejectReson;
  String? verifiedFile;
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
        this.area,
        this.city,
        this.gender,
        this.type,
        this.celebrityType,
        this.availableBalance,
        this.outstandingBalance,
        this.accountStatus,
        this.verifiedStatus,
        this.verifiedRejectReson,
        this.verifiedFile,
        this.commercialRegistrationNumber,
        this.idNumber});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    image = json['image'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    nationality = json['nationality'] != null
        ? new Country.fromJson(json['nationality'])
        : null;
    area = json['area'] != null ? new Area.fromJson(json['area']) : null;
    city = json['city'] != null ? new Area.fromJson(json['city']) : null;
    gender = json['gender'] != null ? new Area.fromJson(json['gender']) : null;
    type = json['type'];
    celebrityType = json['celebrity_type'];
    availableBalance = json['available_balance'].toString();
    outstandingBalance = json['outstanding_balance'];
    accountStatus = json['account_status'] != null
        ? new Area.fromJson(json['account_status'])
        : null;
    verifiedStatus = json['verified_status'] != null
        ? new Area.fromJson(json['verified_status'])
        : null;
    verifiedRejectReson = json['verified_reject_reson'];
    verifiedFile = json['verified_file'];
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
    if (this.nationality != null) {
      data['nationality'] = this.nationality!.toJson();
    }
    if (this.area != null) {
      data['area'] = this.area!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.gender != null) {
      data['gender'] = this.gender!.toJson();
    }
    data['type'] = this.type;
    data['celebrity_type'] = this.celebrityType;
    data['available_balance'] = this.availableBalance;
    data['outstanding_balance'] = this.outstandingBalance;
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    if (this.verifiedStatus != null) {
      data['verified_status'] = this.verifiedStatus!.toJson();
    }
    data['verified_reject_reson'] = this.verifiedRejectReson;
    data['verified_file'] = this.verifiedFile;
    data['commercial_registration_number'] = this.commercialRegistrationNumber;
    data['id_number'] = this.idNumber;
    return data;
  }
}

class contact {
  String? userName;
  String? celebrityName;
  String? userSignature;
  String? celebritySignature;
  int? celebrityId;
  int? userId;
  int? orderId;
  String? date;
  contact(
      {this.userName,
        this.celebrityName,
        this.userSignature,
        this.date,
        this.celebritySignature,
        this.celebrityId,
        this.userId,
        this.orderId});

  contact.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    celebrityName = json['celebrity_name'];
    date = json['date'];
    userSignature = json['user_signature'];
    celebritySignature = json['celebrity_signature'];
    celebrityId = json['celebrity_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['celebrity_name'] = this.celebrityName;
    data['user_signature'] = this.userSignature;
    data['celebrity_signature'] = this.celebritySignature;
    data['celebrity_id'] = this.celebrityId;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['order_id'] = this.orderId;
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