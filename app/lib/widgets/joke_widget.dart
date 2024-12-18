import 'package:flutter/material.dart';

class JokeWidget extends StatelessWidget {
  final String setup;
  final String punchline;

  const JokeWidget({
    Key? key,
    required this.setup,
    required this.punchline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        title: Text(
          setup,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          punchline,
          style: const TextStyle(fontSize: 16),
        ),
        leading: const Icon(
          Icons.sentiment_very_satisfied,
          color: Colors.orange,
        ),
      ),
    );
  }
}
