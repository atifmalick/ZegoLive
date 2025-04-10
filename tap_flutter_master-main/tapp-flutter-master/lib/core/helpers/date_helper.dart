import 'package:intl/intl.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';

/// Helper for common date conversions
class DateHelper {
  /// Get current UNIX timestamp (10 digits)
  static int currentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// Convert a DateTime to UNIX timestamp (10 digits)
  static int dateTimeToTimestamp(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  /// Long date with time in hours and seconds (31 de mar. de 1995 8:15 p.m.)
  static String longDateWithTime(int timestamp) {
    var locale = getIt<AuthCubit>().deviceLocale;
    var value =
        "${locale?.languageCode ?? 'en'}_${locale?.countryCode ?? 'US'}";
    if (value == 'en_US') {
      return timestampToFormattedString(
        timestamp: timestamp,
        format: "MMM/dd/yy h:mm a",
      );
    }
    return timestampToFormattedString(
      timestamp: timestamp,
      format: "d 'de' MMM 'de' y h:mm a",
    );
  }

  /// Short date with time in hours and seconds (31/03/1995 8:15 p.m.)
  static String shortDateWithTime(int timestamp) {
    return timestampToFormattedString(
      timestamp: timestamp,
      format: "d/M/yy h:mm a",
    );
  }

  /// Only long date (31 de mar. de 1995)
  static String longDate(int timestamp) {
    var locale = getIt<AuthCubit>().deviceLocale;
    var value =
        "${locale?.languageCode ?? 'en'}_${locale?.countryCode ?? 'US'}";
    if (value == 'en_US') {
      return timestampToFormattedString(
        timestamp: timestamp,
        format: "MM/dd/yyyy",
      );
    }
    return timestampToFormattedString(
      timestamp: timestamp,
      format: "d 'de' MMMM 'de' y",
    );
  }

  static String longDateBirthDate(int timestamp) {
    var locale = getIt<AuthCubit>().deviceLocale;
    var value =
        "${locale?.languageCode ?? 'en'}_${locale?.countryCode ?? 'US'}";
    if (value == 'en_US') {
      return DateFormat("MM/dd/yyyy", value)
          .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
    }
    return DateFormat("d 'de' MMMM 'de' y", value)
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  /// Only short date (31/03/1995)
  static String shortDate(int timestamp) {
    return timestampToFormattedString(
      timestamp: timestamp,
      format: "d/M/y",
    );
  }

  /// Parse int timestamp to formatted string date
  static String timestampToFormattedString({
    required int timestamp,
    required String format,
  }) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var locale = getIt<AuthCubit>().deviceLocale;
    var value =
        "${locale?.languageCode ?? 'en'}_${locale?.countryCode ?? 'US'}";

    switch (differenceInDays(timestamp)) {
      case 0:
        if (value == 'en_US') {
          return DateFormat("'Today' h:mm a", value).format(dateTime);
        }
        return DateFormat("'Hoy' h:mm a", value).format(dateTime);
      case 1:
        if (value == 'en_US') {
          return DateFormat("'Yesterday' h:mm a", value).format(dateTime);
        }
        return DateFormat("'Ayer' h:mm a", value).format(dateTime);
      case 2:
        if (value == 'en_US') {
          return DateFormat("'Antier' h:mm a", value).format(dateTime);
        }
        return DateFormat("'Antier' h:mm a", value).format(dateTime);
      default:
        return DateFormat(format, value).format(dateTime);
    }
  }

  /// Function to get difference in days betwen today and another date
  static int differenceInDays(int timestamp) {
    // Get today's date
    final today = DateTime.now();

    // Parse timestamp to DateTime
    final dateToCompare = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Get the difference in Duration(hours: )
    final difference = today.difference(dateToCompare);

    // Get today's hour
    final todayHour = Duration(hours: today.hour);

    // Get timestamp's hour
    final dateToCompareHour = Duration(hours: dateToCompare.hour);

    // Get the difference in days, example: 0, 1, 23, etc.
    final differenceInDays =
        ((difference - todayHour + dateToCompareHour).inHours / 24).round();

    return differenceInDays;
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
