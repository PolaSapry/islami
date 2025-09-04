
//todo: save last = write data
import 'package:shared_preferences/shared_preferences.dart';
class SharedPrefsKeys{
  static const String mostRecently = 'most_recently';
}
void saveLastSuraIndex(int newSuraIndex)async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //todo: get sura list from  shared prefs.
  List<String> mostRecentIndicesList = prefs.getStringList(SharedPrefsKeys.mostRecently)?? [];
//todo: add new sura index.
  //mostRecentIndicesList.add('$newSuraIndex');
  
  if(mostRecentIndicesList.contains('$newSuraIndex')){
    mostRecentIndicesList.remove('$newSuraIndex');
    mostRecentIndicesList.insert(0,'$newSuraIndex');

  }else{
    mostRecentIndicesList.insert(0,'$newSuraIndex');
  }
  if(mostRecentIndicesList.length > 5){
    mostRecentIndicesList.removeLast();

  }

  //todo: saved new sura index in shared prefs.
  await prefs.setStringList(SharedPrefsKeys.mostRecently,mostRecentIndicesList);

}



