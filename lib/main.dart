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

  List<String> demoTasks = [
    "Finish Flutter Task",
    "Study Bloc vs Provider",
    "Workout",
    "Read 10 pages",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
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
                itemCount: demoTasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: index.isEven,
                        onChanged: (value) {
                          setState(() {});
                        },
                        activeColor: Colors.deepPurple,
                      ),
                      title: Text(
                        demoTasks[index],
                        style: TextStyle(
                          fontSize: 16,
                          decoration: index.isEven
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.delete,
                        color: Colors.red,
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
        onPressed: () {
         
        },
        child: const Icon(Icons.add),
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
              icon: Icon(Icons.list), label: "All"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), label: "Completed"),
          BottomNavigationBarItem(
              icon: Icon(Icons.pending), label: "Pending"),
        ],
      ),
    );
  }
}