import 'package:dio/dio.dart';
import 'package:teslo_app/config/config.dart';
import 'package:teslo_app/features/auth/domain/domain.dart';
import 'package:teslo_app/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      // if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
        // throw ConnectionTimeout();
      }
      //debugPrint(e.toString());
      throw CustomError(e.message ?? 'Something wrong happend');
      // throw CustomError(e.message ?? 'Something wrong happend', 1);
      // el 1
      // es un número inventado
    } catch (e) {
      throw CustomError('Something wrong happend');
      // throw CustomError('Something wrong happend', 1);
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      // if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
        // throw ConnectionTimeout();
      }
      //debugPrint(e.toString());
      throw CustomError(e.message ?? 'Something wrong happend');
      // throw CustomError(e.message ?? 'Something wrong happend', 1);
      // el 1
      // es un número inventado
    } catch (e) {
      throw CustomError('Something wrong happend');
      // throw CustomError('Something wrong happend', 1);
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'fullName': fullName,
      });
      final user = UserMapper.userJsonToEntity(response.data);
      // yo creo que regresa un user
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // no creo que pueda entrar aquí
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      // if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
        // throw ConnectionTimeout();
      }
      //debugPrint(e.toString());
      throw CustomError(e.message ?? 'Something wrong happend');
      // throw CustomError(e.message ?? 'Something wrong happend', 1);
      // el 1
      // es un número inventado
    } catch (e) {
      throw CustomError('Something wrong happend');
      // throw CustomError('Something wrong happend', 1);
    }
  }
}
