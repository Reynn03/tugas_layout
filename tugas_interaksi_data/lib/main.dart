import 'package:flutter/material.dart';
import 'api_service.dart';
import 'todo_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fetch Data JSON',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final ApiService apiService = ApiService();
  late Future<List<Todo>> futureTodos;

  @override
  void initState() {
    super.initState();
   
    futureTodos = apiService.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lentera Todo List API'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Todo>>(
        future: futureTodos,
        builder: (context, snapshot) {
         
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
       
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

         
          if (snapshot.hasData) {
            List<Todo> todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: todo.completed ? Colors.green : Colors.amber,
                      child: Text(
                        todo.id.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        
                        decoration: todo.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Icon(
                      todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: todo.completed ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Tidak ada data.'));
        },
      ),
    );
  }
}