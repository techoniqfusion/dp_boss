import 'package:flutter/src/material/dropdown.dart';

class StatesCitiesModel {
  List<States>? states;

  StatesCitiesModel({this.states});

  StatesCitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states!.add(States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (states != null) {
      data['states'] = states!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  map(DropdownMenuItem<String> Function(dynamic item) param0) {}
}

class States {
  String? state;
  List<String>? districts;

  States({this.state, this.districts});

  States.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    if (json['districts'] != null) {
      districts = <String>[];
      json['districts'].forEach((v) {
        districts!.add(v);
      });
    }
    // districts = json['districts'].map((e)=> e.toString()).toList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    data['districts'] = districts;
    return data;
  }
}
