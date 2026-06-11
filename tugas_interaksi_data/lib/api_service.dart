import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todo_model.dart';

class ApiService {
  final String url = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode JSON body menjadi List
        List<dynamic> body = jsonDecode(response.body);
        
        // Mapping list dynamic menjadi List<Todo>
        List<Todo> todos = body.map((dynamic item) => Todo.fromJson(item)).toList();
        return todos;
      } else {
        throw Exception("Gagal mengambil data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}