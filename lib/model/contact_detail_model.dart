class ContactDetailModel {
  String? contactName;
  String? contactEmail;
  String? contactNumber;

  ContactDetailModel({this.contactName, this.contactEmail, this.contactNumber});

  ContactDetailModel.fromJson(Map<String, dynamic> json){
    contactName = json['contactNumber'];
    contactEmail = json['contactEmail'];
    contactNumber = json['contactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contactNumber'] = contactNumber;
    data['contactEmail'] = contactEmail;
    data['contactName'] = contactName;
    return data;
  }
}
