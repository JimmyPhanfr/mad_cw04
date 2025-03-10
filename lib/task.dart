class Task {
  String name, details, date, list;
  int id, status;

  Task({
    required this.id,
    required this.name,
    required this.status,
    this.details = "",
    this.date = "",
    this.list = "",
  });

  String getStatus() {
    switch (status) {
      case 0:
        return "Unbegun";
      case 1:
        return "Completed";
      default:
        return "Unbegun";
    } 
  }

  String getDate() {
    return date.substring(0,10);
  }
}