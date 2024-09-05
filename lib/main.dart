import 'package:concert_ticket_local/pages/add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'components/ticketList.dart';
import 'model/spotify_repo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'lib/.env');
  await SpotifyRepo.initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tickets'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: const ConcertComponent()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //navigate to add page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Add()),
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
