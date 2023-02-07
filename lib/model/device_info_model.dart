class DeviceInfoModel {
  String? deviceBrand;
  String? deviceId;
  String? deviceModel;
  String? deviceName;

  DeviceInfoModel(
      {this.deviceBrand, this.deviceId, this.deviceModel, this.deviceName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    data['deviceModel'] = deviceModel;
    data['deviceId'] = deviceId;
    data['deviceBrand'] = deviceBrand;
    return data;
  }
}