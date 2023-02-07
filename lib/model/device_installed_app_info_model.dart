class DeviceInstalledAppInfoModel {
  var appName;
  var versionName;
  var installTimeMillis;
  var packageName;

  DeviceInstalledAppInfoModel(
      {this.appName, this.versionName, this.installTimeMillis, this.packageName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appName'] = appName;
    data['versionName'] = versionName;
    data['installTimeMillis'] = installTimeMillis;
    data['packageName'] = packageName;
    return data;
  }
}