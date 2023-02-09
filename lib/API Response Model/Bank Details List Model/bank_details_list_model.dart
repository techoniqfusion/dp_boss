class BankDetailsListModel {
  String? id;
  String? accountHolderName;
  String? accountNumber;
  String? accountIfscCode;
  String? bankName;
  String? bankBranchName;
  String? status;

  BankDetailsListModel(
      {this.id,
        this.accountHolderName,
        this.accountNumber,
        this.accountIfscCode,
        this.bankName,
        this.bankBranchName,
        this.status});

  BankDetailsListModel.fromJson(Map<String, dynamic> json) {
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
