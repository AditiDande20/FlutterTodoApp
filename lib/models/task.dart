class Task {
  late String taskName;
  late String taskDate;
  late String taskStatus;

  Task(this.taskName, this.taskDate, this.taskStatus);

  Task.fromMap(Map map) {
    taskName = map["taskName"];
    taskDate = map["taskDate"];
    taskStatus = map["taskStatus"];
  }
}
