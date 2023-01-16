import 'package:flutter/material.dart';
import 'task.dart';
import 'detailpage.dart';
import 'addpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'todo',
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailPage(delete, update, index,
                        currenttask: list[index], restorationId: 'main');
                  }));
                },
                child: Card(
                  color: Colors.blue[200],
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          list[index].title,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Palatino',
                            color: Colors.white,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              list.removeAt(index);
                            });
                          },
                          child: const Text('Delete task'),
                        )
                      ],
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPage(add, 'main')));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void add(Task t) {
    setState(() {
      list.add(t);
    });
  }

  void delete(int i) {
    setState(() {
      list.removeAt(i);
    });
  }

  void update(int i, String s, String attribute) {
    switch (attribute) {
      case "title":
        {
          setState(() {
            list[i].editTitle(s);
          });
        }
        break;
      case "desc":
        {
          setState(() {
            list[i].editDescrip(s);
          });
        }
        break;
      case "day":
        {
          setState(() {
            list[i].editDay(s);
          });
        }
        break;
      case "time":
        {
          setState(() {
            list[i].editTime(s);
          });
        }
    }
  }
}
