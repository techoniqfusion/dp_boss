class SupportHistoryModel {
  String? id;
  String? userId;
  String? subject;
  String? message;
  String? status;
  String? attachment;
  String? requestNew;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  SupportHistoryModel(
      {this.id,
      this.userId,
      this.subject,
      this.message,
      this.status,
      this.attachment,
      this.requestNew,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  SupportHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    attachment = json['attachment'];
    requestNew = json['request_new'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['subject'] = subject;
    data['message'] = message;
    data['status'] = status;
    data['attachment'] = attachment;
    data['request_new'] = requestNew;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
