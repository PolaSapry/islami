import 'package:flutter/material.dart.';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/shared_prefs.dart';

class MostRecentProvider extends ChangeNotifier{
  List<int> mostRecentList = [] ;

  //todo: get last =  read data.

  void readLastSuraList()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> mostRecentIndicesAsString = prefs.getStringList(SharedPrefsKeys.mostRecently)?? [];

    mostRecentList= mostRecentIndicesAsString.map((element) => int.parse(element),).toList();
    //  return mostRecentIndicesAsSInt.reversed.toList();
    notifyListeners();


  }


}