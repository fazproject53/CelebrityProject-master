import '../blockList.dart';

class ChatRoomModel {
  bool? success;
  Data? data;
  Message? message;

  ChatRoomModel({this.success, this.data, this.message});

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
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
  bool? isBlocked;
  BlackList? ban;
  Conversation? conversation;
  List<Messages>? messages;
  int? pageCount;
  int? status;

  Data({this.conversation, this.messages, this.pageCount, this.status, this.isBlocked, this.ban});

  Data.fromJson(Map<String, dynamic> json) {
    ban =  json['ban'] != null
        ? new BlackList.fromJson(json['ban'])
        : null;
    isBlocked = json['blacklist'];
    conversation = json['conversation'] != null
        ? new Conversation.fromJson(json['conversation'])
        : null;
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    pageCount = json['page_count'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.conversation != null) {
      data['conversation'] = this.conversation!.toJson();
    }
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['page_count'] = this.pageCount;
    data['status'] = this.status;
    data['blacklist'] = this.isBlocked;
    if (this.ban != null) {
      data['ban'] = this.ban!.toJson();
    }
    return data;
  }
}

class Messages {
  int? id;
  String? body;
  String? messageType;
  int? readStatus;
  int? conversationId;
  Sender? sender;
  String? date;
  Time? time;

  Messages(
      {this.id,
        this.body,
        this.messageType,
        this.readStatus,
        this.conversationId,
        this.sender,
        this.date,
        this.time});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    messageType = json['message_type'];
    readStatus = json['read_status'];
    conversationId = json['conversation_id'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    date = json['date'];
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
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
    if (this.time != null) {
      data['time'] = this.time!.toJson();
    }
    return data;
  }
}

class Sender {
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

  Sender(
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
        this.type});

  Sender.fromJson(Map<String, dynamic> json) {
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

class Time {
  int? y;
  int? m;
  int? d;
  int? h;
  int? i;
  int? s;
  int? f;
  int? weekday;
  int? weekdayBehavior;
  int? firstLastDayOf;
  int? invert;
  int? days;
  int? specialType;
  int? specialAmount;
  int? haveWeekdayRelative;
  int? haveSpecialRelative;

  Time(
      {this.y,
        this.m,
        this.d,
        this.h,
        this.i,
        this.s,
        this.f,
        this.weekday,
        this.weekdayBehavior,
        this.firstLastDayOf,
        this.invert,
        this.days,
        this.specialType,
        this.specialAmount,
        this.haveWeekdayRelative,
        this.haveSpecialRelative});

  Time.fromJson(Map<String, dynamic> json) {
    y = json['y'];
    m = json['m'];
    d = json['d'];
    h = json['h'];
    i = json['i'];
    s = json['s'];
    f = json['f'];
    weekday = json['weekday'];
    weekdayBehavior = json['weekday_behavior'];
    firstLastDayOf = json['first_last_day_of'];
    invert = json['invert'];
    days = json['days'];
    specialType = json['special_type'];
    specialAmount = json['special_amount'];
    haveWeekdayRelative = json['have_weekday_relative'];
    haveSpecialRelative = json['have_special_relative'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['y'] = this.y;
    data['m'] = this.m;
    data['d'] = this.d;
    data['h'] = this.h;
    data['i'] = this.i;
    data['s'] = this.s;
    data['f'] = this.f;
    data['weekday'] = this.weekday;
    data['weekday_behavior'] = this.weekdayBehavior;
    data['first_last_day_of'] = this.firstLastDayOf;
    data['invert'] = this.invert;
    data['days'] = this.days;
    data['special_type'] = this.specialType;
    data['special_amount'] = this.specialAmount;
    data['have_weekday_relative'] = this.haveWeekdayRelative;
    data['have_special_relative'] = this.haveSpecialRelative;
    return data;
  }
}

class Conversation {
  int? id;
  User? user;
  User? secoundUser;
  LastMessage? lastMessage;
  int? countNotRead;
  int? countNotReadAnotherUser;

  Conversation(
      {this.id,
        this.user,
        this.secoundUser,
        this.lastMessage,
        this.countNotRead,
      this.countNotReadAnotherUser});

  Conversation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    secoundUser = json['secound_user'] != null
        ? new User.fromJson(json['secound_user'])
        : null;
    lastMessage = json['last_message'] != null
        ? new LastMessage.fromJson(json['last_message'])
        : null;
    countNotRead = json['count_not_read'];
    countNotReadAnotherUser = json['count_not_read_by_another_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.secoundUser != null) {
      data['secound_user'] = this.secoundUser!.toJson();
    }
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage!.toJson();
    }
    data['count_not_read'] = this.countNotRead;
    data['count_not_read_by_another_user'] = this.countNotReadAnotherUser;
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
  Time? time;

  LastMessage(
      {this.id,
        this.body,
        this.messageType,
        this.readStatus,
        this.conversationId,
        this.sender,
        this.date,
        this.time});

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    messageType = json['message_type'];
    readStatus = json['read_status'];
    conversationId = json['conversation_id'];
    sender = json['sender'] != null ? new User.fromJson(json['sender']) : null;
    date = json['date'];
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
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
    if (this.time != null) {
      data['time'] = this.time!.toJson();
    }
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