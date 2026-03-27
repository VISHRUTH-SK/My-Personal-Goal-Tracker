import 'package:flutter/material.dart';

void main() {
  runApp(GoalTrackerApp());
}

class GoalTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Tracker 2.0',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: GoalHomePage(),
    );
  }
}

class GoalHomePage extends StatefulWidget {
  @override
  _GoalHomePageState createState() => _GoalHomePageState();
}

class _GoalHomePageState extends State<GoalHomePage> {
  List<Map<String, dynamic>> goals = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  String category = "Personal";
  String priority = "Medium";

  void addGoal() {
    if (titleController.text.isEmpty || targetController.text.isEmpty)
      return;

    setState(() {
      goals.add({
        "title": titleController.text,
        "count": 0,
        "target": int.tryParse(targetController.text) ?? 10,
        "completed": false,
        "category": category,
        "priority": priority,
      });
    });

    titleController.clear();
    targetController.clear();
  }

  void incrementGoal(int index) {
    setState(() {
      goals[index]["count"]++;
      if (goals[index]["count"] >= goals[index]["target"]) {
        goals[index]["completed"] = true;
      }
    });
  }

  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  double getProgress(int index) {
    return goals[index]["count"] / goals[index]["target"];
  }

  Color getProgressColor(double progress) {
    if (progress < 0.5) return Colors.redAccent;
    if (progress < 0.8) return Colors.orangeAccent;
    return Colors.green;
  }

  Color getPriorityColor(String p) {
    switch (p) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🎯 Goal Tracker 2.0"), centerTitle: true),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Goal Title",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 6),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Target Count",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: category,
                      items: ["Personal", "Work", "Health"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => category = val!);
                      },
                    ),
                    SizedBox(width: 20),
                    DropdownButton<String>(
                      value: priority,
                      items: ["Low", "Medium", "High"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() => priority = val!);
                      },
                    ),
                    Spacer(),
                    ElevatedButton(onPressed: addGoal, child: Text("Add")),
                  ],
                )
              ],
            ),
          ),

          // Goals List
          Expanded(
            child: goals.isEmpty
                ? Center(child: Text("No Goals Yet 😴"))
                : ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      var goal = goals[index];
                      double progress = getProgress(index);

                      return Dismissible(
                        key: Key(goal["title"] + index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => deleteGoal(index),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(goal["title"],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          decoration: goal["completed"]
                                              ? TextDecoration.lineThrough
                                              : null,
                                        )),
                                    Chip(
                                      label: Text(goal["priority"]),
                                      backgroundColor:
                                          getPriorityColor(goal["priority"]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text("Category: ${goal["category"]}"),
                                SizedBox(height: 4),
                                Text(
                                    "Progress: ${goal["count"]}/${goal["target"]}"),
                                SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 8,
                                  color: getProgressColor(progress),
                                  backgroundColor: Colors.grey[300],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: goal["completed"]
                                          ? null
                                          : () => incrementGoal(index),
                                      child: Text("Increase"),
                                    ),
                                    if (goal["completed"])
                                      Text("🎉 Completed",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}