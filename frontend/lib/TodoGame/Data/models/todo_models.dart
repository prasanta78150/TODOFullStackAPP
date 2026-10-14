class todoModel {
  final int? id;
  final String? title;
  final bool isComplete;

  todoModel({this.id, this.title, this.isComplete = false});
  factory todoModel.fromMap(Map<String, dynamic> json) => todoModel(
    id: json["id"],
    title: json["title"],
    isComplete: json["is_completed"] as bool ?? false,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "isComplete": isComplete as bool,
  };
}
