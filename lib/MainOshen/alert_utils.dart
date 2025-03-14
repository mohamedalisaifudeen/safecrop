import 'dart:math';
import 'package:intl/intl.dart';

class AlertUtils {
  static String generateRandomID() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  static String getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }
}
