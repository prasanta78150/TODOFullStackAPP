import 'package:dio/dio.dart';
import '../models/todo_models.dart';

class ToDoApiService {
  late final Dio _dio;

  ToDoApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'http://127.0.0.1:8000',

          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ),
      );

  Future<List<todoModel>> getTasks() async {
    final response = await _dio.get('/tasks');

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (json) => todoModel.fromMap(Map<String, dynamic>.from(json as Map)),
        )
        .toList();
  }

  Future<todoModel> addTask(String task) async {
    final response = await _dio.post('/tasks', data: {"title": task});

    return todoModel.fromMap(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> deleteTask(int id) async {
    await _dio.delete("/tasks/${id}");
  }

  Future<todoModel> updateTask(String title , int id, {bool? isComplete}) async{
    final data = < String , dynamic > {
      "title" : title
    };

    if(isComplete != null){
      data["is_completed"] = isComplete;
    }

    final response = await _dio.put(
        "/tasks/${id}" ,
        data: data
    );

    return todoModel.fromMap(
      Map<String , dynamic>.from(response.data as Map)
    );
  }
}
