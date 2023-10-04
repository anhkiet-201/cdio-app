import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

void copyToClipboard(String data) async {
  await Clipboard.setData(ClipboardData(text: data));
}

String timeAgo(int? time) {
  return Jiffy.parseFromDateTime(DateTime.fromMillisecondsSinceEpoch(time ?? 0)).toLocal()
      .fromNow();
}
