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

// Her Pazartesi belirlenen saatte
  tz.TZDateTime nextInstanceOfMondayTenAM(int hour) {
    tz.TZDateTime scheduledDate = nextInstanceOfTime(hour);
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
