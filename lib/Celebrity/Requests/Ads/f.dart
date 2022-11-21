// class Celebrity {
//   int? id;
//   String? username;
//   String? name;
//   String? image;
//   String? email;
//   String? type;
//   String? phonenumber;
//   Country? country;
//   Country? nationality;
//   Area? area;
//   Area? city;
//   Area? gender;
//   String? description;
//   String? pageUrl;
//   String? fullPageUrl;
//   String? snapchat;
//   String? tiktok;
//   String? youtube;
//   String? instagram;
//   String? twitter;
//   String? facebook;
//   SnapchatNumber? snapchatNumber;
//   SnapchatNumber? tiktokNumber;
//   Null? youtubeNumber;
//   Null? instagramNumber;
//   Null? twitterNumber;
//   Null? facebookNumber;
//   String? store;
//   Category? category;
//   String? brand;
//   String? advertisingPolicy;
//   String? giftingPolicy;
//   String? adSpacePolicy;
//   int? availableBalance;
//   int? outstandingBalance;
//   Area? accountStatus;
//   Null? verifiedStatus;
//   String? verifiedRejectReson;
//   String? celebrityType;
//   String? verifiedFile;
//   String? commercialRegistrationNumber;
//   String? idNumber;
//
//   Celebrity(
//       {this.id,
//         this.username,
//         this.name,
//         this.image,
//         this.email,
//         this.type,
//         this.phonenumber,
//         this.country,
//         this.nationality,
//         this.area,
//         this.city,
//         this.gender,
//         this.description,
//         this.pageUrl,
//         this.fullPageUrl,
//         this.snapchat,
//         this.tiktok,
//         this.youtube,
//         this.instagram,
//         this.twitter,
//         this.facebook,
//         this.snapchatNumber,
//         this.tiktokNumber,
//         this.youtubeNumber,
//         this.instagramNumber,
//         this.twitterNumber,
//         this.facebookNumber,
//         this.store,
//         this.category,
//         this.brand,
//         this.advertisingPolicy,
//         this.giftingPolicy,
//         this.adSpacePolicy,
//         this.availableBalance,
//         this.outstandingBalance,
//         this.accountStatus,
//         this.verifiedStatus,
//         this.verifiedRejectReson,
//         this.celebrityType,
//         this.verifiedFile,
//         this.commercialRegistrationNumber,
//         this.idNumber});
//
//   Celebrity.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     name = json['name'];
//     image = json['image'];
//     email = json['email'];
//     type = json['type'];
//     phonenumber = json['phonenumber'];
//     country =
//     json['country'] != null ? new Country.fromJson(json['country']) : null;
//     nationality = json['nationality'] != null
//         ? new Country.fromJson(json['nationality'])
//         : null;
//     area = json['area'] != null ? new Area.fromJson(json['area']) : null;
//     city = json['city'] != null ? new Area.fromJson(json['city']) : null;
//     gender = json['gender'] != null ? new Area.fromJson(json['gender']) : null;
//     description = json['description'];
//     pageUrl = json['page_url'];
//     fullPageUrl = json['full_page_url'];
//     snapchat = json['snapchat'];
//     tiktok = json['tiktok'];
//     youtube = json['youtube'];
//     instagram = json['instagram'];
//     twitter = json['twitter'];
//     facebook = json['facebook'];
//     snapchatNumber = json['snapchat_number'] != null
//         ? new SnapchatNumber.fromJson(json['snapchat_number'])
//         : null;
//     tiktokNumber = json['tiktok_number'] != null
//         ? new SnapchatNumber.fromJson(json['tiktok_number'])
//         : null;
//     youtubeNumber = json['youtube_number'];
//     instagramNumber = json['instagram_number'];
//     twitterNumber = json['twitter_number'];
//     facebookNumber = json['facebook_number'];
//     store = json['store'];
//     category = json['category'] != null
//         ? new Category.fromJson(json['category'])
//         : null;
//     brand = json['brand'];
//     advertisingPolicy = json['advertising_policy'];
//     giftingPolicy = json['gifting_policy'];
//     adSpacePolicy = json['ad_space_policy'];
//     availableBalance = json['available_balance'];
//     outstandingBalance = json['outstanding_balance'];
//     accountStatus = json['account_status'] != null
//         ? new Area.fromJson(json['account_status'])
//         : null;
//     verifiedStatus = json['verified_status'];
//     verifiedRejectReson = json['verified_reject_reson'];
//     celebrityType = json['celebrity_type'];
//     verifiedFile = json['verified_file'];
//     commercialRegistrationNumber = json['commercial_registration_number'];
//     idNumber = json['id_number'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['name'] = this.name;
//     data['image'] = this.image;
//     data['email'] = this.email;
//     data['type'] = this.type;
//     data['phonenumber'] = this.phonenumber;
//     if (this.country != null) {
//       data['country'] = this.country!.toJson();
//     }
//     if (this.nationality != null) {
//       data['nationality'] = this.nationality!.toJson();
//     }
//     if (this.area != null) {
//       data['area'] = this.area!.toJson();
//     }
//     if (this.city != null) {
//       data['city'] = this.city!.toJson();
//     }
//     if (this.gender != null) {
//       data['gender'] = this.gender!.toJson();
//     }
//     data['description'] = this.description;
//     data['page_url'] = this.pageUrl;
//     data['full_page_url'] = this.fullPageUrl;
//     data['snapchat'] = this.snapchat;
//     data['tiktok'] = this.tiktok;
//     data['youtube'] = this.youtube;
//     data['instagram'] = this.instagram;
//     data['twitter'] = this.twitter;
//     data['facebook'] = this.facebook;
//     if (this.snapchatNumber != null) {
//       data['snapchat_number'] = this.snapchatNumber!.toJson();
//     }
//     if (this.tiktokNumber != null) {
//       data['tiktok_number'] = this.tiktokNumber!.toJson();
//     }
//     data['youtube_number'] = this.youtubeNumber;
//     data['instagram_number'] = this.instagramNumber;
//     data['twitter_number'] = this.twitterNumber;
//     data['facebook_number'] = this.facebookNumber;
//     data['store'] = this.store;
//     if (this.category != null) {
//       data['category'] = this.category!.toJson();
//     }
//     data['brand'] = this.brand;
//     data['advertising_policy'] = this.advertisingPolicy;
//     data['gifting_policy'] = this.giftingPolicy;
//     data['ad_space_policy'] = this.adSpacePolicy;
//     data['available_balance'] = this.availableBalance;
//     data['outstanding_balance'] = this.outstandingBalance;
//     if (this.accountStatus != null) {
//       data['account_status'] = this.accountStatus!.toJson();
//     }
//     data['verified_status'] = this.verifiedStatus;
//     data['verified_reject_reson'] = this.verifiedRejectReson;
//     data['celebrity_type'] = this.celebrityType;
//     data['verified_file'] = this.verifiedFile;
//     data['commercial_registration_number'] = this.commercialRegistrationNumber;
//     data['id_number'] = this.idNumber;
//     return data;
//   }
// }
//
// class Country {
//   int? id;
//   String? countryCode;
//   String? name;
//   String? nameEn;
//   String? countryEnNationality;
//   String? countryArNationality;
//   String? flag;
//
//   Country(
//       {this.id,
//         this.countryCode,
//         this.name,
//         this.nameEn,
//         this.countryEnNationality,
//         this.countryArNationality,
//         this.flag});
//
//   Country.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     countryCode = json['country_code'];
//     name = json['name'];
//     nameEn = json['name_en'];
//     countryEnNationality = json['country_enNationality'];
//     countryArNationality = json['country_arNationality'];
//     flag = json['flag'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['country_code'] = this.countryCode;
//     data['name'] = this.name;
//     data['name_en'] = this.nameEn;
//     data['country_enNationality'] = this.countryEnNationality;
//     data['country_arNationality'] = this.countryArNationality;
//     data['flag'] = this.flag;
//     return data;
//   }
// }
//
// class Area {
//   int? id;
//   String? name;
//   String? nameEn;
//
//   Area({this.id, this.name, this.nameEn});
//
//   Area.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     nameEn = json['name_en'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['name_en'] = this.nameEn;
//     return data;
//   }
// }
//
// class SnapchatNumber {
//   int? id;
//   int? from;
//   int? to;
//   String? fromTo;
//
//   SnapchatNumber({this.id, this.from, this.to, this.fromTo});
//
//   SnapchatNumber.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     from = json['from'];
//     to = json['to'];
//     fromTo = json['from_to'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['from'] = this.from;
//     data['to'] = this.to;
//     data['from_to'] = this.fromTo;
//     return data;
//   }
// }
//
// class Category {
//   String? name;
//   String? nameEn;
//
//   Category({this.name, this.nameEn});
//
//   Category.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     nameEn = json['name_en'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['name_en'] = this.nameEn;
//     return data;
//   }
// }

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
  Null? gender;
  String? type;
  String? celebrityType;
  int? availableBalance;
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
    gender = json['gender'];
    type = json['type'];
    celebrityType = json['celebrity_type'];
    availableBalance = json['available_balance'];
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
    data['gender'] = this.gender;
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

