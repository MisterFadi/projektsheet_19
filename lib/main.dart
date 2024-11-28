import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projektsheet_19/database_repository.dart';
import 'package:projektsheet_19/shared_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final DatabaseRepository repository = SharedPreferencesRepository();
  runApp(MainApp(
    repository: repository,
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.repository});

  final DatabaseRepository repository;
  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  String quote = "Mit großer Kraft wächst auch der Bizeps";
  String author = "Spiderman Teil 1";

  Future<void> getQuote() async {
    final response = await http
        .get(Uri.parse("https://api.api-ninjas.com/v1/quotes"), headers: {
      "X-Api-Key": "TCAAb4cq3cwstW2Uu557Qg==Ze7vbcmWa26QkDNv",
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        quote = data[0]["quote"];
        author = data[0]["author"];
      });
      widget.repository.addItem(quote);
      widget.repository.addItem(author);
    }
  }

  Future<void> deleteQuote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("quote");
    prefs.remove("author");
    setState(() {
      quote = "Mit großer Kraft wächst auch der Bizeps";
      author = "Spiderman Teil 1";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.green.shade300,
        appBar: AppBar(
          title: const Text(
            "Zitat App",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Colors.amber,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Text(
              author,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: getQuote,
              child: const Text(
                "Nächstes Zitat habibi 🔄",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: deleteQuote,
              child: const Text(
                "Letztes Zitat löschen ♻️",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
