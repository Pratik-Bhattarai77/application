import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteEditorScreen extends StatefulWidget {
  final String noteTitle;
  final String creationDate;
  final String noteContent;
  final String noteId;

  const NoteEditorScreen({
    Key? key,
    this.noteTitle = '',
    this.creationDate = '',
    this.noteContent = '',
    this.noteId = '',
  }) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _maincontent = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.noteTitle;
    _maincontent.text = widget.noteContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0xFA, 0xFF, 0xD8, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0xFA, 0xFF, 0xD8, 1),
        elevation: 0.0,
        title: const Text("Edit Note"),
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
              widget.creationDate,
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
          if (widget.noteId.isNotEmpty) {
            await FirebaseFirestore.instance
                .collection("Notes")
                .doc(widget.noteId)
                .update({
              "note_title": _titleController.text,
              "note_content": _maincontent.text,
            });
          } else {
            await FirebaseFirestore.instance.collection("Notes").add({
              "note_title": _titleController.text,
              "creation_date": DateTime.now().toString(),
              "note_content": _maincontent.text,
            });
          }
          Navigator.pop(
              context, 'updated'); // Return a result to indicate success
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
