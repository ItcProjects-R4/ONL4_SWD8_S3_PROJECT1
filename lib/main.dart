import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskUIScreen(),
    );
  }
}

class TaskUIScreen extends StatefulWidget {
  const TaskUIScreen({super.key});

  @override
  State<TaskUIScreen> createState() => _TaskUIScreenState();
}

class _TaskUIScreenState extends State<TaskUIScreen> {

  int currentIndex = 0;

  List<Map<String, dynamic>> demoTasks = [
    {"title": "Finish Flutter Task", "done": false},
    {"title": "Study Bloc vs Provider", "done": true},
    {"title": "Workout", "done": false},
    {"title": "Read 10 pages", "done": true},
  ];

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> filteredTasks = demoTasks.where((task) {

      if (currentIndex == 0) {
        return true;
      }

      if (currentIndex == 1) {
        return task["done"] == true;
      }

      return task["done"] == false;

    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: const Text(
          "Task Manager",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                hintText: "Add a new task...",
                prefixIcon: const Icon(Icons.task),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {

                  var task = filteredTasks[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: ListTile(

                      leading: Checkbox(
                        value: task["done"],
                        onChanged: null,
                        activeColor: Colors.deepPurple,
                      ),

                      title: Text(
                        task["title"],
                        style: TextStyle(
                          fontSize: 16,
                          decoration: task["done"]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
               
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white,),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepPurple,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "All",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: "Completed",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.pending),
            label: "Pending",
          ),

        ],
      ),
    );
  }
}