import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/export.dart';

class AppSettings extends ChangeNotifier{
  late SharedPreferences _prefs;
  String acess = '';

  AppSettings(){
    _startSettings();
  }
  _startSettings()async{
   await _startPreferences();
   await _readIdUsuario();
  }

  Future<void> _startPreferences()async{
    _prefs = await SharedPreferences.getInstance();
  }
  _readIdUsuario(){
    final start = _prefs.getString('start') ?? '';
    acess = start;
    notifyListeners();
  }
  setString(String start)async{
    await _prefs.setString('start', start);
    await _readIdUsuario();
  }
}