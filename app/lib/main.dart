import 'package:flutter/material.dart';
import 'joke_service.dart';
import 'joke_cache.dart';
import 'widgets/joke_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: const JokeHomePage(),
    );
  }
}

class JokeHomePage extends StatefulWidget {
  const JokeHomePage({super.key});

  @override
  State<JokeHomePage> createState() => _JokeHomePageState();
}

class _JokeHomePageState extends State<JokeHomePage> {
  late Future<List<Map<String, dynamic>>> _jokes;

  @override
  void initState() {
    super.initState();
    _fetchAndCacheJokes();
  }

  void _fetchAndCacheJokes() {
    setState(() {
      _jokes = fetchAndCacheJokes();
    });
  }

  Future<List<Map<String, dynamic>>> fetchAndCacheJokes() async {
    try {
      final jokes = await fetchJokes();
      await JokeCache.saveJokes(jokes);
      return jokes;
    } catch (e) {
      return await JokeCache.getCachedJokes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jokes App'),
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _jokes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No jokes available. Try again!',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  final jokes = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: jokes.length,
                    itemBuilder: (context, index) {
                      return JokeWidget(
                        setup: jokes[index]['setup'],
                        punchline: jokes[index]['punchline'],
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: _fetchAndCacheJokes,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Fetch New Jokes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
