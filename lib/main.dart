import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: const TaskApp(),
    );
  }
}

class TaskApp extends StatefulWidget {
  const TaskApp({super.key});

  @override
  State<TaskApp> createState() => _TaskAppState();
}

class _TaskAppState extends State<TaskApp> {
  List<Map<String, dynamic>> tasks = [];
  TextEditingController controller = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void addTask() {
    if (controller.text.isEmpty) return;

    setState(() {
      tasks.add({
        "title": controller.text,
        "done": false,
        "date": selectedDate,
        "time": selectedTime,
      });
    });

    controller.clear();
    selectedDate = null;
    selectedTime = null;
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index]["done"] = !tasks[index]["done"];
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  String formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return "No deadline";

    String d = "${date.day}/${date.month}/${date.year}";

    if (time == null) return d;

    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);

    String t = TimeOfDay.fromDateTime(dt).format(context);

    return "$d • $t";
  }

  @override
  Widget build(BuildContext context) {
    int completed = tasks.where((t) => t["done"]).length;
    double progress = tasks.isEmpty ? 0 : completed / tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Goals Manager",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(value: progress, minHeight: 8),
          ),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Enter your goal...",
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: addTask,
                      child: const Text("Add"),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: pickDate,
                        child: Text(
                          selectedDate == null
                              ? "Pick Date"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: pickTime,
                        child: Text(
                          selectedTime == null
                              ? "Pick Time"
                              : selectedTime!.format(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text("No goals added yet 🚀"))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(
                              tasks[index]["title"],
                              style: TextStyle(
                                decoration: tasks[index]["done"]
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              formatDateTime(
                                tasks[index]["date"],
                                tasks[index]["time"],
                              ),
                            ),
                            leading: Checkbox(
                              value: tasks[index]["done"],
                              onChanged: (_) => toggleTask(index),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteTask(index),
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
