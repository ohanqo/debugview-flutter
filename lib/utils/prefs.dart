import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs _singleton = Prefs._internal();

  factory Prefs() => _singleton;

  Prefs._internal();

  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool getBool(String label) {
    return prefs.getBool(label) ?? false;
  }

  setBool({required String label, required bool value}) async {
    await prefs.setBool(label, value);
  }
}
