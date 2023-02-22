class SupportModel {
  String? telegram;
  String? whatsapp;
  String? callOne;
  String? callTwo;
  String? facebook;
  String? twitter;
  String? youtube;
  String? googlePlus;
  String? instagram;

  SupportModel(
      {this.telegram,
        this.whatsapp,
        this.callOne,
        this.callTwo,
        this.facebook,
        this.twitter,
        this.youtube,
        this.googlePlus,
        this.instagram});

  SupportModel.fromJson(Map<String, dynamic> json) {
    telegram = json['telegram'];
    whatsapp = json['whatsapp'];
    callOne = json['call_one'];
    callTwo = json['call_two'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    youtube = json['youtube'];
    googlePlus = json['google_plus'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['telegram'] = this.telegram;
    data['whatsapp'] = this.whatsapp;
    data['call_one'] = this.callOne;
    data['call_two'] = this.callTwo;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['youtube'] = this.youtube;
    data['google_plus'] = this.googlePlus;
    data['instagram'] = this.instagram;
    return data;
  }
}
