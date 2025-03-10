class Task {
  String name, details, status, date, list;
  int id;

  Task({
    required this.id,
    required this.name,
    required this.status,
    this.details = "",
    this.date = "",
    this.list = "",
  });
}