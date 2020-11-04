import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Repeat {
  // Hergün belirlenen saatte
  static tz.TZDateTime nextInstanceOfTime(int hour,
      [int minite = 0, int second = 0]) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      tz.TZDateTime.from(
              DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, hour),
              tz.local)
          .hour,
      tz.TZDateTime.from(
              DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, hour, minite),
              tz.local)
          .minute,
      tz.TZDateTime.from(
              DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, hour, minite, second),
              tz.local)
          .second,
    );

    print(" First : " + scheduledDate.toString());

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print(" Edit : " + scheduledDate.toString());
    return scheduledDate;
  }

// Her Belirlenen gün belirlenen saatte belirlenen saatte
  static tz.TZDateTime nextInstanceOfTimeWeek(int day, int hour,
      [int minite = 0, int second = 0]) {
    tz.TZDateTime scheduledDate = nextInstanceOfTime(hour, minite, second);
    try {
      // güne bakacaksın
      print(" First Week : " + scheduledDate.toString());
      while (scheduledDate.weekday != day) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      print(" Edit Week : " + scheduledDate.toString());
      return scheduledDate;
    } catch (e) {
      return scheduledDate;
    }
  }
}
