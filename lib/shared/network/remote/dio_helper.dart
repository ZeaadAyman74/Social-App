import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',   //https://student.valuxapps.com/api/

      receiveDataWhenStatusError: true,
        receiveTimeout: 20 * 1000,
        connectTimeout: 20 * 1000,
      ));
  }

  static Future<Response> getData({
    required String path,
    required Map<String, dynamic>? query,
    String lang='en',
    String? token,
  }) async {
    dio.options.headers={
      'lang':lang,
      'Authorization':token,
      'Content-Type': 'application/json'
    };
    return await dio.get(
      path,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
    String lang='en',
    String? token,
  }) async{

    dio.options.headers={
      'lang':lang,
      'Authorization':token,
      'Content-Type': 'application/json'
    };
   return await dio.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
  required String? token,
    required String path,
    String lang='en',
    Map<String, dynamic>? query,
    required String name,
    required String email,
    required String phone,
  })async{
    dio.options.headers={
      'lang':lang,
      'Content-Type':'application/json',
      'Authorization':token,
    };
  return await  dio.put(
    path,
    data: {
      "name":name ,
      "phone": phone,
      "email": email,
    }
  );

  }
}
