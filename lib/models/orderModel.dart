import 'package:flutter/material.dart';

class OrdersModel {
  Data data;
  String message;
  int code;

  OrdersModel({this.data, this.message, this.code});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    code = json['code'];
  }
}

class Data {
  List<Orders> orders;

  Data({this.orders});
  
  Data.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
  }
}

class Orders {
  int id;
  int userId;
  String username;
  String userImage;
  String status;
  int availableTime;
  int hours;
  String totalPrice;
  CreatedAt createdAt;
  UpdatedAt updatedAt;
  List<Services> services;

  Orders(
      {this.id,
      this.userId,
      this.username,
      this.userImage,
      this.status,
      this.availableTime,
      this.hours,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.services});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    userId = int.tryParse(json['user_id'].toString());

    username = json['username'];

    userImage = json['userimage'];

    status = json['status'];

    availableTime = json['available_time'] == null
        ? 0
        : int.tryParse(json['available_time'].toString());

    hours = json['hours'] == null ? 0 : int.tryParse(json['hours'].toString());

    totalPrice = json['total_price'];

    createdAt = json['created_at'] != null
        ? new CreatedAt.fromJson(json['created_at'])
        : null;

    updatedAt = json['updated_at'] != null
        ? new UpdatedAt.fromJson(json['updated_at'])
        : null;
    if (json['services'] != null) {
      services = new List<Services>();
      json['services'].forEach((v) {
        services.add(new Services.fromJson(v));
      });
    }
  }
}

class CreatedAt {
  String date;
  int timezoneType;
  String timezone;

  CreatedAt({this.date, this.timezoneType, this.timezone});

  CreatedAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    timezoneType = int.tryParse(json['timezone_type'].toString());
    timezone = json['timezone'];
  }
}

class UpdatedAt {
  String date;
  int timezoneType;
  String timezone;

  UpdatedAt({this.date, this.timezoneType, this.timezone});

  UpdatedAt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    print("1");

    timezoneType = json['timezone_type'];
    print("2");

    timezone = json['timezone'];
    print("3");
  }
}

class Services with ChangeNotifier {
  int id;
  int orderId;
  int userId;
  int serviceId;
  String day;
  String hours;
  UserService userService;

  Services(
      {this.day,this.hours, this.id, this.orderId, this.userId, this.serviceId, this.userService});

  Services.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    day = json['day'];
    hours = json['hours'];
    orderId = int.tryParse(json['order_id'].toString());
    userId = int.tryParse(json['user_id'].toString());
    serviceId = json['service_id'];
    userService = json['user_service'] != null
        ? new UserService.fromJson(json['user_service'])
        : null;
  }
}

class UserService {
  int id;
  int userId;
  int serviceId;
  int adId;
  String desc;
  String price;
  String type;
  int status;
  String offer;
  String availableTime;
  int hours;
  String createdAt;
  String updatedAt;

  UserService(
      {this.id,
      this.userId,
      this.serviceId,
      this.adId,
      this.desc,
      this.price,
      this.type,
      this.status,
      this.offer,
      this.availableTime,
      this.hours,
      this.createdAt,
      this.updatedAt});

  UserService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    print("one");

    userId = json['user_id'];
    print("1");

    serviceId = json['service_id'];
    print("2");

    adId = json['ad_id'];

    desc = json['desc'];
    price = json['price'];
    type = json['type'];

    status = json['status'];
    print("one");

    offer = json['offer'];
    print("last");

    availableTime = json['available_time'];
    print("last");

    hours = json['hours'] == null ? 0 : int.tryParse(json['hours'].toString());
    print("0");

    createdAt = json['created_at'];
    print("one");

    updatedAt = json['updated_at'];
    print("one");
  }
}
