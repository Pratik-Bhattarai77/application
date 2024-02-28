import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  String date = DateTime.now().toString();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _maincontent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0xFA, 0xFF, 0xD8, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0xFA, 0xFF, 0xD8, 1),
        elevation: 0.0,
        title: const Text("Add a new Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              date,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 83, 83, 83)),
            ),
            const SizedBox(
              height: 28.0,
            ),
            TextField(
              controller: _maincontent,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: const TextStyle(fontWeight: FontWeight.normal),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Thoughts Here",
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 241, 241, 241),
        onPressed: () async {
          FirebaseFirestore.instance.collection("Notes").add({
            "note_title": _titleController.text,
            "creation_date": date,
            "note_content": _maincontent.text,
          }).then((value) {
            print(value.id);
            Navigator.pop(context);
          }).catchError(
              (error) => print("Faild to add new Thoughts due to $error "));
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
