import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sipaksi/Module/PenelitianInternal/Form/Share/FetchStrategy.dart';
import 'package:sipaksi/Module/PenelitianInternal/List/Post.dart';

class LuaranTambahanFetchStrategy implements FetchStrategy<Post> {
  final Dio _dio;

  LuaranTambahanFetchStrategy()
      : _dio = Dio(BaseOptions(
          baseUrl: "https://jsonplaceholder.typicode.com",
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        ));

  @override
  Future<List<Post>> fetchData() async {
    try {
      final response = await _dio.get("/albums/1/photos");
      final List body = response.data;
      return body.map((e) => Post.fromJson(e)).toList();
    } on DioException catch (e) {
      print("Error fetching posts: ${e.message}");
      rethrow;
    } catch (e) {
      print("Unexpected error: $e");
      rethrow;
    }
  }
}
