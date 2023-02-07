class UserData {
  String? email;
  String? name;
  String? mobile;
  String? address;
  String? gender;
  String? dob;
  String? state;
  String? city;
  String? myRefer;
  String? accountVerify;
  String? wallet;
  String? createdAt;

  UserData(
      {this.email,
        this.name,
        this.mobile,
        this.address,
        this.gender,
        this.dob,
        this.state,
        this.city,
        this.myRefer,
        this.accountVerify,
        this.wallet,
        this.createdAt});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    mobile = json['mobile '];
    address = json['address'];
    gender = json['gender'];
    dob = json['dob'];
    state = json['state'];
    city = json['city'];
    myRefer = json['my_refer'];
    accountVerify = json['account_verify'];
    wallet = json['wallet'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['mobile '] = mobile;
    data['address'] = address;
    data['gender'] = gender;
    data['dob'] = dob;
    data['state'] = state;
    data['city'] = city;
    data['my_refer'] = myRefer;
    data['account_verify'] = accountVerify;
    data['wallet'] = wallet;
    data['created_at'] = createdAt;
    return data;
  }
}
