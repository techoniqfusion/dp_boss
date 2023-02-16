class WithdrawalAllDataModel {
  String? withdrawalId;
  String? payoutId;
  String? withdrawalAmount;
  String? withdrawalFinalAmount;
  String? withdrawalCharges;
  String? withdrawalStatus;
  String? withdrawalBankDetails;
  String? utrNo;
  String? createdAt;
  String? comment;
  String? accountNumber;
  String? accountIfscCode;
  String? bankName;

  WithdrawalAllDataModel(
      {this.withdrawalId,
        this.payoutId,
        this.withdrawalAmount,
        this.withdrawalFinalAmount,
        this.withdrawalCharges,
        this.withdrawalStatus,
        this.withdrawalBankDetails,
        this.utrNo,
        this.createdAt,
        this.comment,
        this.accountNumber,
        this.accountIfscCode,
        this.bankName});

  WithdrawalAllDataModel.fromJson(Map<String, dynamic> json) {
    withdrawalId = json['Withdrawal_id'];
    payoutId = json['payout_id'];
    withdrawalAmount = json['withdrawal_amount'];
    withdrawalFinalAmount = json['withdrawal_final_amount'];
    withdrawalCharges = json['withdrawal_charges'];
    withdrawalStatus = json['withdrawal_status'];
    withdrawalBankDetails = json['withdrawal_bank_details'];
    utrNo = json['utr_no'];
    comment = json['comment'];
    accountNumber = json['account_number'];
    accountIfscCode = json['account_ifsc_code'];
    bankName = json['bank_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Withdrawal_id'] = this.withdrawalId;
    data['payout_id'] = this.payoutId;
    data['withdrawal_amount'] = this.withdrawalAmount;
    data['withdrawal_final_amount'] = this.withdrawalFinalAmount;
    data['withdrawal_charges'] = this.withdrawalCharges;
    data['withdrawal_status'] = this.withdrawalStatus;
    data['withdrawal_bank_details'] = this.withdrawalBankDetails;
    data['utr_no'] = this.utrNo;
    data['comment'] = this.comment;
    data['account_number'] = this.accountNumber;
    data['account_ifsc_code'] = this.accountIfscCode;
    data['bank_name'] = this.bankName;
    data['created_at'] = this.createdAt;
    return data;
  }
}
