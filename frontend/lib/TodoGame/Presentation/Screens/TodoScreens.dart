// This is the with out using API for CRUD operation


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class TodoScrren extends StatefulWidget {
//   const TodoScrren({super.key});
//
//   @override
//   State<TodoScrren> createState() => _TodoScrrenState();
// }
//
// class _TodoScrrenState extends State<TodoScrren> {
//   TextEditingController _todoControler = TextEditingController();
//   List<String> TaskList = [];
//   List<bool> isComplete = [];
//   int? editIndex;
//
//   final ValueNotifier<List<String>> tasks = ValueNotifier([]);
//
//   void _isTaskComplete(int index) {
//     setState(() {
//       isComplete[index] = !isComplete[index];
//     });
//   }
//
//   void _deleteTask(int index) {
//     print(index);
//     setState(() {
//       TaskList.removeAt(index);
//       isComplete.removeAt(index);
//     });
//   }
//
//   void _editTask(int index, String title) {
//     setState(() {
//       _todoControler.text = title;
//       editIndex = index;
//     });
//   }
//
//   void _updateTask(String task) {
//     if (task.isEmpty) return;
//     setState(() {
//       if (editIndex != null) {
//         TaskList[editIndex!] = task;
//         editIndex = null;
//       } else {
//         TaskList.add(task.trim());
//         isComplete.add(false);
//       }
//     });
//
//     _todoControler.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Title(
//           color: Colors.black,
//           child: Text(
//             "TODO - GAME",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           //TextField
//           TextField(
//             controller: _todoControler,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 30,
//               fontWeight: FontWeight.w600,
//             ),
//             decoration: InputDecoration(
//               hintText: "Enter Your Task",
//               labelText: "Enter Your Task",
//               labelStyle: TextStyle(color: Colors.orange),
//               hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.white, width: 1.5),
//               ),
//               // Background color
//               filled: true,
//               fillColor: Colors.orange.withValues(alpha: 0.08),
//
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 vertical: 10,
//               ),
//               // Border when not focused
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: const BorderSide(color: Colors.white, width: 2),
//               ),
//
//               // Border when focused
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.white, width: 3),
//               ),
//
//               prefixIcon: Icon(Icons.edit, color: Colors.white),
//
//               suffixIcon: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: () => _updateTask(_todoControler.text.trim()),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.zero,
//                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     visualDensity: VisualDensity.compact,
//                     backgroundColor: Colors.blueAccent,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text("Add", style: TextStyle(fontSize: 15)),
//                 ),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 15),
//           // List of Items
//           Expanded(
//             child: ListView.builder(
//               itemCount: TaskList.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () => _isTaskComplete(index),
//                   child: Card(
//                     color: Colors.grey[800],
//                     child: ListTile(
//                       leading: Icon(
//                         isComplete[index]
//                             ? Icons.task_alt
//                             : Icons.radio_button_unchecked,
//                         color: isComplete[index] ? Colors.orange : Colors.white,
//                       ),
//                       title: Text(
//                         TaskList[index],
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w800,
//                           decoration: isComplete[index]
//                               ? TextDecoration.lineThrough
//                               : TextDecoration.none,
//                           decorationColor: Colors.black,
//                           decorationThickness: 2,
//                         ),
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           GestureDetector(
//                             onTap: () => _editTask(index, TaskList[index]),
//                             child: Icon(
//                               Icons.edit,
//                               size: 28,
//                               color: Colors.lightBlue,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => _deleteTask(index),
//                             child: Icon(
//                               Icons.delete,
//                               size: 28,
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
