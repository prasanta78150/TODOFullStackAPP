import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tudifrontend/TodoGame/Data/models/todo_models.dart';
import '../../Data/data_sources/toDoDataSource.dart';

class TodoFullStackScrren extends StatefulWidget {
  const TodoFullStackScrren({super.key});

  @override
  State<TodoFullStackScrren> createState() => _TodoScrrenState();
}

class _TodoScrrenState extends State<TodoFullStackScrren> {
  TextEditingController _todoControler = TextEditingController();
  final ToDoApiService _api = ToDoApiService();
  List<todoModel> TaskList = [];
  List<bool> isComplete = [];
  int? editIndex;
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    try {
      final tasks = await _api.getTasks();

      if (!mounted) return;

      setState(() {
        TaskList = tasks;
        isComplete = List<bool>.filled(tasks.length, false);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading tasks: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addTask() async {
    final title = _todoControler.text.trim();

    if (title.isEmpty || isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      if (editIndex != null) {
        final updatedTask = await _api.updateTask(title, editIndex!);

        if (!mounted) return;

        setState(() {
          final index = TaskList.indexWhere(
            (task) => task.id == updatedTask.id,
          );
          if (index != -1) {
            TaskList[index] = updatedTask;
          }
          isComplete.add(false);
          editIndex = null;
          _todoControler.clear();
        });
      } else {
        final newTask = await _api.addTask(title);
        if (!mounted) return;

        setState(() {
          TaskList.add(newTask);
          isComplete.add(false);
        });
      }
    } catch (e) {
      debugPrint('Error adding task: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
          _todoControler.clear();
        });
      }
    }
  }

  Future<void> _deleteTask(todoModel task) async {
    final id = task.id;
    if (id == null) {
      print("Id is null");
    }
    try {
      await _api.deleteTask(id!);
      if (!mounted) return;

      setState(() {
        TaskList.removeWhere((item) => item.id == task.id);
      });
    } catch (e) {
      print(e);
    }
  }

  void _editTask(todoModel task) {
    setState(() {
      _todoControler.text = task.title!;
      editIndex = task.id;
    });
  }

  Future<void> _toggleIndex(int id) async {
    print(id);
    final task = TaskList[id];
    print(task.isComplete);
    final newTask = !(task.isComplete ?? false);
    try {
      final updatedTask = await _api.updateTask(
        task.title!,
        task.id!,
        isComplete: newTask,
      );

      setState(() {
        TaskList[id] = updatedTask;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Title(
          color: Colors.black,
          child: Text(
            "TODO - GAME",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          //TextField
          TextField(
            controller: _todoControler,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: "Enter Your Task",
              labelText: "Enter Your Task",
              labelStyle: TextStyle(color: Colors.orange),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white, width: 1.5),
              ),
              // Background color
              filled: true,
              fillColor: Colors.orange.withValues(alpha: 0.08),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              // Border when not focused
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),

              // Border when focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 3),
              ),

              prefixIcon: Icon(Icons.edit, color: Colors.white),

              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => _addTask(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Add", style: TextStyle(fontSize: 15)),
                ),
              ),
            ),
          ),

          SizedBox(height: 15),
          // List of Items
          Expanded(
            child: ListView.builder(
              itemCount: TaskList.length,
              itemBuilder: (context, index) {
                final task = TaskList[index];
                print(task.isComplete);
                return GestureDetector(
                  onTap: () {
                    _toggleIndex(index);
                  },
                  child: Card(
                    color: Colors.grey[800],
                    child: ListTile(
                      leading: Icon(
                        (task.isComplete ?? false)
                            ? Icons.task_alt
                            : Icons.radio_button_unchecked,
                        color: (task.isComplete ?? false)
                            ? Colors.orange
                            : Colors.white,
                      ),
                      title: Text(
                        task.title ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          decoration: task.isComplete
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.black,
                          decorationThickness: 2,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _editTask(task),
                            child: Icon(
                              Icons.edit,
                              size: 28,
                              color: Colors.lightBlue,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _deleteTask(task),
                            child: Icon(
                              Icons.delete,
                              size: 28,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
