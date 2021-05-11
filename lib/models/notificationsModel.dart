// class NotificationsModel {
//   List<Notifications> data;
//   String message;
//   int code;

//   NotificationsModel({this.data, this.message, this.code});

//   NotificationsModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = new List<Notifications>();
//       json['data'].forEach((v) {
//         data.add(new Notifications.fromJson(v));
//       });
//     }
//     message = json['message'];
//     code = json['code'];
//   }
// }

// class Notifications {
//   int id;
//   Notification notification;

//   Notifications({this.id, this.notification});

//   Notifications.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     notification = json['data'] != null ? new Notification.fromJson(json['data']) : null;
//   }
// }

// class Notification {
//   String title;
//   String content;

//   Notification({this.title, this.content});

//   Notification.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     content = json['content'];
//   }
// }


class NotificationModel {
  List<Notifs> data;
  String message;
  int code;

  NotificationModel({this.data, this.message, this.code});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Notifs>();
      json['data'].forEach((v) {
        data.add(new Notifs.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class Notifs {
  int id;
  int userId;
  String title;
  String body;
  String createdAt;
  String updatedAt;

  Notifs(
      {this.id,
      this.userId,
      this.title,
      this.body,
      this.createdAt,
      this.updatedAt});

  Notifs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
