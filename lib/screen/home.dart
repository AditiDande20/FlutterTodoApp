import 'package:flutter/material.dart';
import 'package:todo/database/dbHelper.dart';
import 'package:todo/models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: const Text('TODO',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold)),
            ),
            body: FutureBuilder(
              future: getAllTask(),
              builder: (context, snapshot) {
                return snapshot.data != null && snapshot.data!.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.only(bottom: 56),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      updateTask(snapshot.data![index]);
                                    },
                                    icon: Icon(
                                      snapshot.data![index].taskStatus
                                                  .toString() ==
                                              "YES"
                                          ? Icons.check_circle_outline
                                          : Icons.circle_outlined,
                                      color: snapshot.data![index].taskStatus
                                                  .toString() ==
                                              "YES"
                                          ? Colors.grey
                                          : Colors.indigo,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data![index].taskName
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 18,
                                              height: 1.5,
                                              color: snapshot.data![index]
                                                          .taskStatus
                                                          .toString() ==
                                                      "YES"
                                                  ? Colors.grey
                                                  : Colors.black,
                                              decoration: snapshot.data![index]
                                                          .taskStatus
                                                          .toString() ==
                                                      "YES"
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        snapshot.data![index].taskDate
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.5,
                                          color: snapshot
                                                      .data![index].taskStatus
                                                      .toString() ==
                                                  "YES"
                                              ? Colors.grey.shade500
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      deleteTask(
                                          snapshot.data![index].taskName);
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: snapshot.data![index].taskStatus
                                                  .toString() ==
                                              "YES"
                                          ? Colors.grey
                                          : Colors.indigo,
                                    ))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: Colors.indigo.shade50,
                              thickness: 0.5,
                            ),
                          );
                        },
                        itemCount:
                            snapshot.data != null && snapshot.data!.isNotEmpty
                                ? snapshot.data!.length
                                : 0)
                    : const Center(
                        child: Text(
                          'Everything is completed !',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  selectedDate = DateTime.now();
                  dateController.clear();
                  taskController.clear();
                });
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return showAddTaskUI();
                  },
                );
              },
              backgroundColor: Colors.indigo,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  showAddTaskUI() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: const Text(
                'Create New Task',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Enter Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
              child: TextField(
                maxLines: 1,
                controller: taskController,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 10)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Select Task Date',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
              child: TextField(
                maxLines: 1,
                readOnly: true,
                showCursor: false,
                autofocus: false,
                controller: dateController,
                decoration: const InputDecoration(
                    border: null, contentPadding: EdgeInsets.only(bottom: 10)),
                onTap: () => _selectDate(context),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      if (taskController.text.trim().isEmpty ||
                          dateController.text.trim().isEmpty) {
                        return;
                      }
                      Navigator.pop(context);
                      addTask();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        'Add Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void addTask() {
    setState(() {
      isLoading = true;
      var dbHelper = DBHelper();
      var task =
          Task(taskController.text.trim(), dateController.text.trim(), "NO");
      dbHelper.createTask(task);
      taskController.clear();
      dateController.clear();
      isLoading = false;
    });
  }

  void updateTask(Task taskObj) {
    setState(() {
      isLoading = true;
      var dbHelper = DBHelper();
      var task = Task(taskObj.taskName, taskObj.taskDate, "YES");
      dbHelper.updateTask(task);
      isLoading = false;
    });
  }

  void deleteTask(String name) {
    setState(() {
      isLoading = true;
      var dbHelper = DBHelper();
      dbHelper.deleteTask(name);
      isLoading = false;
    });
  }

  Future<List<Task>> getAllTask() {
    var dbHelper = DBHelper();
    Future<List<Task>> tasks = dbHelper.readAllTask();
    return tasks;
  }
}
