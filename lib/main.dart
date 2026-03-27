import 'package:flutter/material.dart';

void main() {
  runApp(GoalTrackerApp());
}

class GoalTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
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

  TextEditingController goalController = TextEditingController();

  void addGoal() {
    if (goalController.text.isEmpty) return;

    setState(() {
      goals.add({
        "title": goalController.text,
        "count": 0,
        "target": 10,
        "completed": false,
      });
    });

    goalController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Goals"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // INPUT
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: goalController,
                      decoration: InputDecoration(
                        hintText: "Enter goal",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addGoal,
                    child: Text("Add"),
                  ),
                ],
              ),
            ),

            // LIST
            Expanded(
              child: goals.isEmpty
                  ? Center(child: Text("No Goals Yet 😴"))
                  : ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TITLE
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      goals[index]["title"],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: goals[index]["completed"]
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => deleteGoal(index),
                                    )
                                  ],
                                ),

                                SizedBox(height: 5),

                                // PROGRESS TEXT
                                Text(
                                    "Progress: ${goals[index]["count"]}/${goals[index]["target"]}"),

                                SizedBox(height: 5),

                                // PROGRESS BAR
                                LinearProgressIndicator(
                                  value: getProgress(index),
                                  minHeight: 8,
                                ),

                                SizedBox(height: 8),

                                // BUTTON
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: goals[index]["completed"]
                                          ? null
                                          : () => incrementGoal(index),
                                      child: Text("Increase"),
                                    ),
                                    if (goals[index]["completed"])
                                      Text("Completed 🎉",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}