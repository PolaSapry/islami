import 'package:intl/intl.dart';
import 'package:islami/model/prayer_response_model.dart';

mixin Formatable {
  String? get day;

  Month? get month;

  String? get year;
}

class DateFormater {
  static String formatDate(Formatable formatableMixin) {
    return '${formatableMixin.day} ${formatableMixin.month!.en!.substring(0, 3)}\n ${formatableMixin.year}';
  }
  static final DateTime _now = DateTime.now();
  static Map<String, dynamic> sortPrayerTimes(Map<String, dynamic> prayerTimes) {

    var sortedEntries = prayerTimes.entries.toList()..sort((a, b) {
      //sortedList.sort();
          DateTime timeA = DateFormat("HH:mm").parse(a.value);
          DateTime timeB = DateFormat("HH:mm").parse(a.value);

          DateTime dateTimeA = DateTime(_now.year, _now.month, _now.day, timeA.hour, timeB.minute,);
          DateTime dateTimeB = DateTime(_now.year, _now.month, _now.day, timeA.hour, timeB.minute,);

          if (dateTimeA.isBefore(_now) || dateTimeA.isAtSameMomentAs(_now)) {
            dateTimeA = dateTimeA.add(Duration(days: 1));
          }
          if (dateTimeB.isBefore(_now) || dateTimeB.isAtSameMomentAs(_now)) {
            dateTimeB = dateTimeB.add(Duration(days: 1));
          }
         return dateTimeA.compareTo(dateTimeB);
        });
    return Map<String, dynamic>.fromEntries(sortedEntries);
  }

  static Map<String, dynamic> getNextPrayerCountDown(Map<String, dynamic> prayerTimes) {
    Map<String, dynamic> timeDifference = {};

    prayerTimes.forEach((prayName, prayTimeString) {
        DateTime prayerTime = DateFormat("HH:mm").parse(prayTimeString);
        DateTime prayerDateTime = DateTime(_now.year, _now.month, _now.day,
            prayerTime.hour, prayerTime.minute);

        if (prayerDateTime.isBefore(_now) ||
            prayerDateTime.isAtSameMomentAs(_now)) {
          prayerDateTime = prayerDateTime.add(Duration(days: 1));
        }

        Duration difference = prayerDateTime.difference(_now);
        timeDifference[prayName] = difference;
      },
    );
    return timeDifference;
  }
}

class TimeConverter {
  static String to12Hour(String time) {
    DateTime dateTime = DateFormat("HH:mm").parse(time);
    return DateFormat("hh:mm\na").format(dateTime);
  }
}
