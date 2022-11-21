import '../ModelAPI/ModelsAPI.dart';

class NotificationModel {
  bool? success;
  Data? data;
  Message? message;

  NotificationModel({this.success, this.data, this.message});

  NotificationModel.fromJson(Map<String, dynamic> json) {
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
  List<Notifications>? notifications;
  int? status;

  Data({this.pageCount, this.notifications, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    pageCount = json['page_count'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_count'] = this.pageCount;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Notifications {
  int? id;
  User? user;
  User? sendUser;
  String? title;
  String? body;
  String? type;
  int? read;
  String? createdAt;
  int? notificationId;
  Notification? notification;

  Notifications(
      {this.id,
        this.user,
        this.sendUser,
        this.title,
        this.body,
        this.type,
        this.read,
        this.createdAt,
        this.notificationId,
        this.notification});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    sendUser =
    json['send_user'] != null ? new User.fromJson(json['send_user']) : null;
    title = json['title'];
    body = json['body'];
    type = json['type'];
    read = json['read'];
    createdAt = json['created_at'];
    notificationId = json['notification_id'];
    notification = json['notification'] != null
        ? new Notification.fromJson(json['notification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.sendUser != null) {
      data['send_user'] = this.sendUser!.toJson();
    }
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['read'] = this.read;
    data['created_at'] = this.createdAt;
    data['notification_id'] = this.notificationId;
    if (this.notification != null) {
      data['notification'] = this.notification!.toJson();
    }
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
  City? gender;
  City? accountStatus;
  String? type;
  int? availableBalance;
  int? outstandingBalance;

  User(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.phonenumber,
        this.country,
        this.city,
        this.gender,
        this.accountStatus,
        this.type,
        this.availableBalance,
        this.outstandingBalance});

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
    type = json['type'];
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
    if (this.accountStatus != null) {
      data['account_status'] = this.accountStatus!.toJson();
    }
    data['type'] = this.type;
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

class Notification {
  int? id;
  Celebrity? celebrity;
  User? user;
  String? date;
  City? adType;
  City? status;
  int? price;
  String? description;
  Null? celebrityPromoCode;
  City? adOwner;
  City? advertisingAdType;
  City? adFeature;
  City? adTiming;
  String? file;
  String? commercialRecord;
  String? advertisingName;
  String? advertisingLink;
  City? platform;
  City? rejectReson;
  Occasion? occasion;
  City? giftType;
  String? from;
  String? to;
  User? secoundUser;
  LastMessage? lastMessage;
  int? countNotRead;
  String? image;
  String? link;

  Notification(
      {this.id,
        this.celebrity,
        this.user,
        this.date,
        this.adType,
        this.status,
        this.price,
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
        this.occasion,
        this.giftType,
        this.from,
        this.to,
        this.secoundUser,
        this.lastMessage,
        this.countNotRead,
        this.image,
        this.link});

  Notification.fromJson(Map<String, dynamic> json) {
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
    celebrityPromoCode = json['celebrity_promo_code'];
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
    commercialRecord = json['commercial_record'];
    advertisingName = json['advertising_name'];
    advertisingLink = json['advertising_link'];
    platform =
    json['platform'] != null ? new City.fromJson(json['platform']) : null;
    rejectReson = json['reject_reson'] != null
        ? new City.fromJson(json['reject_reson'])
        : null;
    occasion = json['occasion'] != null
        ? new Occasion.fromJson(json['occasion'])
        : null;
    giftType =
    json['gift_type'] != null ? new City.fromJson(json['gift_type']) : null;
    from = json['from'];
    to = json['to'];
    secoundUser = json['secound_user'] != null
        ? new User.fromJson(json['secound_user'])
        : null;
    lastMessage = json['last_message'] != null
        ? new LastMessage.fromJson(json['last_message'])
        : null;
    countNotRead = json['count_not_read'];
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
    if (this.rejectReson != null) {
      data['reject_reson'] = this.rejectReson!.toJson();
    }
    if (this.occasion != null) {
      data['occasion'] = this.occasion!.toJson();
    }
    if (this.giftType != null) {
      data['gift_type'] = this.giftType!.toJson();
    }
    data['from'] = this.from;
    data['to'] = this.to;
    if (this.secoundUser != null) {
      data['secound_user'] = this.secoundUser!.toJson();
    }
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage!.toJson();
    }
    data['count_not_read'] = this.countNotRead;
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
  Category? category;
  String? brand;
  String? advertisingPolicy;
  String? giftingPolicy;
  String? adSpacePolicy;
  int? availableBalance;
  int? outstandingBalance;

  Celebrity(
      {this.id,
        this.username,
        this.name,
        this.image,
        this.email,
        this.type,
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
        ? new Category.fromJson(json['category'])
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
    data['type'] = this.type;
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

class Occasion {
  int? id;
  String? name;
  String? nameEn;
  String? image;

  Occasion({this.id, this.name, this.nameEn, this.image});

  Occasion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['image'] = this.image;
    return data;
  }
}

class LastMessage {
  int? id;
  String? body;
  String? messageType;
  int? readStatus;
  int? conversationId;
  User? sender;
  String? date;

  LastMessage(
      {this.id,
        this.body,
        this.messageType,
        this.readStatus,
        this.conversationId,
        this.sender,
        this.date});

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    messageType = json['message_type'];
    readStatus = json['read_status'];
    conversationId = json['conversation_id'];
    sender = json['sender'] != null ? new User.fromJson(json['sender']) : null;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['body'] = this.body;
    data['message_type'] = this.messageType;
    data['read_status'] = this.readStatus;
    data['conversation_id'] = this.conversationId;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    data['date'] = this.date;
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