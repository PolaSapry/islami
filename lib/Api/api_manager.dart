import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:islami/model/RadioResponseModel.dart';
import 'package:islami/model/RecitersResponseModel.dart';
import 'package:islami/model/radio_reciters_models.dart';

import '../model/prayer_response_model.dart';

class ApiManager{
static  Future<RadioResponseModel> getRadioData()async{
    try{
      Uri uri = Uri.parse("https://mp3quran.net/api/v3/radios?language=ar");
      var response = await http.get(uri);
      var json = jsonDecode(response.body);
      return RadioResponseModel.fromJson(json);
    }catch (e){
      throw e ;
    }
  }

 static Future<RecitersResponseModel> getReciterData()async{
    try{
      Uri uri = Uri.parse("https://www.mp3quran.net/api/v3/reciters?language=ar");
      var response = await http.get(uri);
      var json = jsonDecode(response.body);
      return RecitersResponseModel.fromJson(json);
    }catch (e){
      throw e ;
    }
  }

 static Future<RadioRecitersModel> getAllData()async{
    try{
      final result = await Future.wait([
        ApiManager.getRadioData(),
        ApiManager.getReciterData()
      ]);
      return RadioRecitersModel(radioResponseModel: result[0] as RadioResponseModel, recitersResponseModel: result[1] as RecitersResponseModel);
    }catch (e){
      throw e ;
    }
  }

static Future<PrayerResponseModel> getPrayingData()async{
  //mm minute
  // MM month
  // hh 12h
  // HH 24h


  String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
  try{
      Uri uri = Uri.parse("https://api.aladhan.com/v1/timingsByCity/$date?city=alexandria&country=egypt");
      var response = await http.get(uri);
      var json = jsonDecode(response.body);
      return PrayerResponseModel.fromJson(json);
    }catch (e){
      throw e ;
    }
  }


}