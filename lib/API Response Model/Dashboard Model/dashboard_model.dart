class DashboardModel {
  bool? status;
  int? statusCode;
  String? message;
  String? upi;
  String? wallet;
  String? date;
  String? time;
  List<GameData>? gameData;

  DashboardModel(
      {this.status,
        this.statusCode,
        this.message,
        this.wallet,
        this.date,
        this.time,
        this.gameData,
        this.upi
      });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    upi = json['upi'];
    wallet = json['wallet'];
    date = json['date'];
    time = json['time'];
    if (json['game_data'] != null) {
      gameData = <GameData>[];
      json['game_data'].forEach((v) {
        gameData!.add(new GameData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['upi'] = this.upi;
    data['wallet'] = this.wallet;
    data['date'] = this.date;
    data['time'] = this.time;
    if (this.gameData != null) {
      data['game_data'] = this.gameData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GameData {
  String? id;
  String? name;
  String? sundayStatus;
  String? sundayOpenTime;
  String? sundayCloseTime;
  String? mondayStatus;
  String? mondayOpenTime;
  String? mondayCloseTime;
  String? tuesdayStatus;
  String? tuesdayOpenTime;
  String? tuesdayCloseTime;
  String? wednesdayStatus;
  String? wednesdayOpenTime;
  String? wednesdayCloseTime;
  String? thursdayStatus;
  String? thursdayOpenTime;
  String? thursdayCloseTime;
  String? fridayStatus;
  String? fridayOpenTime;
  String? fridayCloseTime;
  String? saturdayStatus;
  String? saturdayOpenTime;
  String? saturdayCloseTime;
  String? winningNumber;
  // String? createdAt;
  // String? updatedAt;
  // String? deletedAt;

  GameData(
      {this.id,
        this.name,
        this.sundayStatus,
        this.sundayOpenTime,
        this.sundayCloseTime,
        this.mondayStatus,
        this.mondayOpenTime,
        this.mondayCloseTime,
        this.tuesdayStatus,
        this.tuesdayOpenTime,
        this.tuesdayCloseTime,
        this.wednesdayStatus,
        this.wednesdayOpenTime,
        this.wednesdayCloseTime,
        this.thursdayStatus,
        this.thursdayOpenTime,
        this.thursdayCloseTime,
        this.fridayStatus,
        this.fridayOpenTime,
        this.fridayCloseTime,
        this.saturdayStatus,
        this.saturdayOpenTime,
        this.saturdayCloseTime,
        this.winningNumber
        // this.createdAt,
        // this.updatedAt,
        // this.deletedAt
    });

  GameData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sundayStatus = json['sunday_status'];
    sundayOpenTime = json['sunday_open_time'];
    sundayCloseTime = json['sunday_close_time'];
    mondayStatus = json['monday_status'];
    mondayOpenTime = json['monday_open_time'];
    mondayCloseTime = json['monday_close_time'];
    tuesdayStatus = json['tuesday_status'];
    tuesdayOpenTime = json['tuesday_open_time'];
    tuesdayCloseTime = json['tuesday_close_time'];
    wednesdayStatus = json['wednesday_status'];
    wednesdayOpenTime = json['wednesday_open_time'];
    wednesdayCloseTime = json['wednesday_close_time'];
    thursdayStatus = json['thursday_status'];
    thursdayOpenTime = json['thursday_open_time'];
    thursdayCloseTime = json['thursday_close_time'];
    fridayStatus = json['friday_status'];
    fridayOpenTime = json['friday_open_time'];
    fridayCloseTime = json['friday_close_time'];
    saturdayStatus = json['saturday_status'];
    saturdayOpenTime = json['saturday_open_time'];
    saturdayCloseTime = json['saturday_close_time'];
    winningNumber = json['winning_number'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sunday_status'] = this.sundayStatus;
    data['sunday_open_time'] = this.sundayOpenTime;
    data['sunday_close_time'] = this.sundayCloseTime;
    data['monday_status'] = this.mondayStatus;
    data['monday_open_time'] = this.mondayOpenTime;
    data['monday_close_time'] = this.mondayCloseTime;
    data['tuesday_status'] = this.tuesdayStatus;
    data['tuesday_open_time'] = this.tuesdayOpenTime;
    data['tuesday_close_time'] = this.tuesdayCloseTime;
    data['wednesday_status'] = this.wednesdayStatus;
    data['wednesday_open_time'] = this.wednesdayOpenTime;
    data['wednesday_close_time'] = this.wednesdayCloseTime;
    data['thursday_status'] = this.thursdayStatus;
    data['thursday_open_time'] = this.thursdayOpenTime;
    data['thursday_close_time'] = this.thursdayCloseTime;
    data['friday_status'] = this.fridayStatus;
    data['friday_open_time'] = this.fridayOpenTime;
    data['friday_close_time'] = this.fridayCloseTime;
    data['saturday_status'] = this.saturdayStatus;
    data['saturday_open_time'] = this.saturdayOpenTime;
    data['saturday_close_time'] = this.saturdayCloseTime;
    data['winning_number'] = this.winningNumber;
    // data['created_at'] = this.createdAt;
    // data['updated_at'] = this.updatedAt;
    // data['deleted_at'] = this.deletedAt;
    return data;
  }
}
