class SupportHistoryIdModel {
  String? id;
  String? supportId;
  String? userId;
  String? subject;
  String? message;
  String? status;
  String? type;
  String? attachment;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  SupportHistoryIdModel(
      {this.id,
        this.supportId,
        this.userId,
        this.subject,
        this.message,
        this.status,
        this.type,
        this.attachment,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  SupportHistoryIdModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supportId = json['support_id'];
    userId = json['user_id'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    type = json['type'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['support_id'] = this.supportId;
    data['user_id'] = this.userId;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['status'] = this.status;
    data['type'] = this.type;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
