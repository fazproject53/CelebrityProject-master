class CheckUserData {
  bool? success;
  Data? data;
  Message? message;

  CheckUserData({this.success, this.data, this.message});

  CheckUserData.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? userType;
  bool? profile;
  bool? price;
  bool? contract;
  bool? verified;
  int? status;

  Data(
      {this.name,
        this.userType,
        this.profile,
        this.price,
        this.contract,
        this.verified,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userType = json['user_type'];
    profile = json['profile'];
    price = json['price'];
    contract = json['contract'];
    verified = json['verified'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user_type'] = this.userType;
    data['profile'] = this.profile;
    data['price'] = this.price;
    data['contract'] = this.contract;
    data['verified'] = this.verified;
    data['status'] = this.status;
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