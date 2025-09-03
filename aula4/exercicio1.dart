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
      home: Scaffold(
        appBar: AppBar(title: const Text("Flashcards de Verbos")),
        body: Center(
          child: Column(
            children: <Widget>[
              // Card 1 - Passado
              Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.history, size: 40, color: Colors.red),
                      title: const Text("I walked to school yesterday."),
                      subtitle: Image.network(
                        "https://cdn.pixabay.com/photo/2016/11/23/14/45/walk-1850024_640.jpg",
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print("Memorizado: Walk - passado");
                      },
                      child: const Text("Memorizado"),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 1),

              // Card 2 - Presente
              Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
                      title: const Text("He runs every morning."),
                      subtitle: Image.network(
                        "https://cdn.pixabay.com/photo/2016/11/23/00/41/sport-1851036_640.jpg",
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print("Memorizado: Run - presente");
                      },
                      child: const Text("Memorizado"),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 1),

              // Card 3 - Futuro
              Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.event, size: 40, color: Colors.blue),
                      title: const Text("They will travel next summer."),
                      subtitle: Image.network(
                        "https://cdn.pixabay.com/photo/2017/01/20/00/30/travel-1995854_640.jpg",
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print("Memorizado: Travel - futuro");
                      },
                      child: const Text("Memorizado"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
