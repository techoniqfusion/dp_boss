class GameRateModel {
  String? id;
  String? singleDigitValue1;
  String? singleDigitValue2;
  String? jodiDigitValue1;
  String? jodiDigitValue2;
  String? singlePanaValue1;
  String? singlePanaValue2;
  String? doublePanaValue1;
  String? doublePanaValue2;
  String? tripplePanaValue1;
  String? tripplePanaValue2;
  String? halfSangamValue1;
  String? halfSangamValue2;
  String? fullSangamValue1;
  String? fullSangamValue2;
  String? createdAt;
  String? updatedAt;

  GameRateModel(
      {this.id,
        this.singleDigitValue1,
        this.singleDigitValue2,
        this.jodiDigitValue1,
        this.jodiDigitValue2,
        this.singlePanaValue1,
        this.singlePanaValue2,
        this.doublePanaValue1,
        this.doublePanaValue2,
        this.tripplePanaValue1,
        this.tripplePanaValue2,
        this.halfSangamValue1,
        this.halfSangamValue2,
        this.fullSangamValue1,
        this.fullSangamValue2,
        this.createdAt,
        this.updatedAt});

  GameRateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    singleDigitValue1 = json['single_digit_value_1'];
    singleDigitValue2 = json['single_digit_value_2'];
    jodiDigitValue1 = json['jodi_digit_value_1'];
    jodiDigitValue2 = json['jodi_digit_value_2'];
    singlePanaValue1 = json['single_pana_value_1'];
    singlePanaValue2 = json['single_pana_value_2'];
    doublePanaValue1 = json['double_pana_value_1'];
    doublePanaValue2 = json['double_pana_value_2'];
    tripplePanaValue1 = json['tripple_pana_value_1'];
    tripplePanaValue2 = json['tripple_pana_value_2'];
    halfSangamValue1 = json['half_sangam_value_1'];
    halfSangamValue2 = json['half_sangam_value_2'];
    fullSangamValue1 = json['full_sangam_value_1'];
    fullSangamValue2 = json['full_sangam_value_2'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['single_digit_value_1'] = this.singleDigitValue1;
    data['single_digit_value_2'] = this.singleDigitValue2;
    data['jodi_digit_value_1'] = this.jodiDigitValue1;
    data['jodi_digit_value_2'] = this.jodiDigitValue2;
    data['single_pana_value_1'] = this.singlePanaValue1;
    data['single_pana_value_2'] = this.singlePanaValue2;
    data['double_pana_value_1'] = this.doublePanaValue1;
    data['double_pana_value_2'] = this.doublePanaValue2;
    data['tripple_pana_value_1'] = this.tripplePanaValue1;
    data['tripple_pana_value_2'] = this.tripplePanaValue2;
    data['half_sangam_value_1'] = this.halfSangamValue1;
    data['half_sangam_value_2'] = this.halfSangamValue2;
    data['full_sangam_value_1'] = this.fullSangamValue1;
    data['full_sangam_value_2'] = this.fullSangamValue2;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
