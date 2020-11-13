import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepository {
  Future<String> getData(String name) async {
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(name);
    print('getData');
    return data;
  }

  setData(String name, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, value);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

   Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }



  getQuizname() async {
    final prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('data');
    print('getQuizname');
    return data;
  }
}
