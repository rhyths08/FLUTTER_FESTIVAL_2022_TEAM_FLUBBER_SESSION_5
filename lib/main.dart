import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const NotesApp());
}

class NotesApp extends StatefulWidget {
  const NotesApp({Key? key}) : super(key: key);

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  final _myController = TextEditingController();

  void _addFact() async {
    await FirebaseFirestore.instance
        .collection("Notes")
        .add({'text': _myController.text});
    _myController.clear();
  }

  static const routeName = '/open';

  // void _deleteFact(String docId) async {
  //   FirebaseFirestore.instance.collection("Notes").doc(docId).delete();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Affirmation Dose",
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'LeagueGothic',
            letterSpacing: 2.0,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color.fromARGB(200, 0, 0, 0),
              ),
            ],
          ),
        ),
        elevation: 10,
        backgroundColor: Colors.orange[200],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("image/bg_affirmation.jpg"),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder:
                    (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, pos) => InkWell(
                            onTap: () {
                              //_deleteFact(snapshot.data!.docs.elementAt(pos).id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 20.0),
                              child: Text(
                                (snapshot.data!.docs.elementAt(pos).data()
                                    as Map)['text'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'JosefinSans',
                                ),
                              ),
                            )));
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            TextField(
              controller: _myController,
              decoration: const InputDecoration(
                  labelText: "Type your affirmation here",
                  labelStyle: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addFact();
          },
          child: const Icon(Icons.add)),
    ));
  }
}
