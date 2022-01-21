import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  static SharedPreferences? preferences;
 static void initialize()async{
    preferences=await SharedPreferences.getInstance();
  }
}