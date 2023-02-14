class TransactionHistoryModel {
  List<Data>? data;
  String? wallet;

  TransactionHistoryModel({this.data, this.wallet});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['wallet'] = this.wallet;
    return data;
  }
}

class Data {
  String? id;
  String? transactionType;
  String? transactionAmt;
  String? transactionTitle;
  String? createdAt;

  Data(
      {this.id,
        this.transactionType,
        this.transactionAmt,
        this.transactionTitle,
        this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionType = json['transaction_type'];
    transactionAmt = json['transaction_amt'];
    transactionTitle = json['transaction_title'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_type'] = this.transactionType;
    data['transaction_amt'] = this.transactionAmt;
    data['transaction_title'] = this.transactionTitle;
    data['created_at'] = this.createdAt;
    return data;
  }
}
