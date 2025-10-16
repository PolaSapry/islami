import 'dart:convert';

import 'package:flutter/services.dart';

class AzkarModel {
  AzkarModel({
    this.category,
    this.count,
    this.description,
    this.reference,
    this.content,
  });

  AzkarModel.fromJson(dynamic json) {
    category = json['category'];
    count = json['count'];
    description = json['description'];
    reference = json['reference'];
    content = json['content'];
  }
  String? category;
  String? count;
  String? description;
  String? reference;
  String? content;

  static Future<List<AzkarModel>> loadAzkarContents(String azkarType) async {
    var jsonContent = jsonDecode(
        await rootBundle.loadString("assets/files/azkar/azkar.json"));

    List<AzkarModel> azkar = (jsonContent[azkarType] as List).map((azkarjson) {
        return AzkarModel.fromJson(azkarjson);
      },
    ).toList();
    return azkar;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = category;
    map['count'] = count;
    map['description'] = description;
    map['reference'] = reference;
    map['content'] = content;
    return map;
  }


}
/*static Future<List<AzkarModel>> loadAzkarContent(String azkarType) async {
    var jsonContent = jsonDecode(
        await rootBundle.loadString("assets/files/azkar/azkar.json"));
    List<AzkarModel> azkar = (jsonContent[azkarType] as List)
        .map((azkarModel) => AzkarModel.fromJson(azkarModel))
        .toList();
    return azkar;
  }*/