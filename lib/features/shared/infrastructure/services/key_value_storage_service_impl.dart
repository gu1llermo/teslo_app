import 'key_value_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

  @override
  Future<T?> getValue<T>(String key) async {
    try {
      switch (T) {
        case const (int):
          return await _asyncPrefs.getInt(key) as T?;
        case const (String):
          return await _asyncPrefs.getString(key) as T?;
        case const (bool):
          return await _asyncPrefs.getBool(key) as T?;
        case const (List<String>):
          return await _asyncPrefs.getStringList(key) as T?;
        case const (double):
          return await _asyncPrefs.getDouble(key) as T?;
        default:
          throw UnimplementedError(
              'Get not implemented for type ${T.runtimeType}');
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    await _asyncPrefs.remove(key);
    bool isDeleted = await getValue(key) ==
        null; // todo_ validar si efectivamente está borrando
    // ese key

    return isDeleted;
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    switch (T) {
      case const (int):
        await _asyncPrefs.setInt(key, value as int);
        break;
      case const (String):
        await _asyncPrefs.setString(key, value as String);
        break;
      case const (bool):
        await _asyncPrefs.setBool(key, value as bool);
        break;
      case const (List<String>):
        await _asyncPrefs.setStringList(key, value as List<String>);
        break;
      case const (double):
        await _asyncPrefs.setDouble(key, value as double);
        break;
      default:
        throw UnimplementedError(
            'Set not implemented for type ${T.runtimeType}');
    }
  }
}
