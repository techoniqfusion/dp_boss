class BankDetailsListModel {
  bool? status;
  int? statusCode;
  List<Data>? data;
  PhoneData? phoneData;

  BankDetailsListModel(
      {this.status, this.statusCode, this.data, this.phoneData});

  BankDetailsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    phoneData = json['phone_data'] != null
        ? new PhoneData.fromJson(json['phone_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.phoneData != null) {
      data['phone_data'] = this.phoneData!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? accountHolderName;
  String? accountNumber;
  String? accountIfscCode;
  String? bankName;
  String? bankBranchName;
  String? status;
  bool? isSelected;

  Data(
      {this.id,
        this.accountHolderName,
        this.accountNumber,
        this.accountIfscCode,
        this.bankName,
        this.bankBranchName,
        this.status,
        this.isSelected = false
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountHolderName = json['account_holder_name'];
    accountNumber = json['account_number'];
    accountIfscCode = json['account_ifsc_code'];
    bankName = json['bank_name'];
    bankBranchName = json['bank_branch_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account_holder_name'] = this.accountHolderName;
    data['account_number'] = this.accountNumber;
    data['account_ifsc_code'] = this.accountIfscCode;
    data['bank_name'] = this.bankName;
    data['bank_branch_name'] = this.bankBranchName;
    data['status'] = this.status;
    return data;
  }
}

class PhoneData {
  String? paytm;
  String? phonepe;
  String? gpay;
  String? upiId;

  PhoneData({this.paytm, this.phonepe, this.gpay, this.upiId});

  PhoneData.fromJson(Map<String, dynamic> json) {
    paytm = json['paytm'];
    phonepe = json['phonepe'];
    gpay = json['gpay'];
    upiId = json['upi_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paytm'] = this.paytm;
    data['phonepe'] = this.phonepe;
    data['gpay'] = this.gpay;
    data['upi_id'] = this.upiId;
    return data;
  }
}
