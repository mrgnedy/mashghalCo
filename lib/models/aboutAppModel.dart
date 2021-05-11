class AboutApp {
  Data data;
  String message;
  int code;

  AboutApp({this.data, this.message, this.code});

  AboutApp.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    code = json['code'];
  }
}

class Data {
  Info info;

  Data({this.info});

  Data.fromJson(Map<String, dynamic> json) {
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }
}

class Info {
  String phone;
  String email;
  String address;
  String about;
  String privacy;
  String role;
  String percent;
  String adrole;

  Info(
      {this.phone,
      this.email,
      this.address,
      this.about,
      this.privacy,
      this.role,
      this.percent,
      this.adrole});

  Info.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
    address = json['address'] == null ? 'data' : json['address'];
    about = json['about'];
    privacy = json['privacy'] == null ? 'data' : json['privacy'];
    role = json['role'];
    percent = json['percent'];
    adrole = json['adrole'];
  }
}
