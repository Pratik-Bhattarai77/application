import 'package:application/components/note_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteReaderScreen extends StatefulWidget {
  final QueryDocumentSnapshot doc;

  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0xFA, 0xFF, 0xD8, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0xFA, 0xFF, 0xD8, 1),
        elevation: 0.0,
        title: Text(widget.doc['note_title']),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _updateNote,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc['note_title'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              widget.doc['creation_date'],
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 83, 83, 83)),
            ),
            const SizedBox(
              height: 28.0,
            ),
            Text(
              widget.doc['note_content'],
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  void _updateNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          noteTitle: widget.doc['note_title'],
          creationDate: widget.doc['creation_date'],
          noteContent: widget.doc['note_content'],
          noteId: widget.doc.id,
        ),
      ),
    );
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete this note?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("Notes")
                    .doc(widget.doc.id)
                    .delete()
                    .then((value) {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                }).catchError((error) {
                  print("Failed to delete note: $error");
                });
              },
            ),
          ],
        );
      },
    );
  }
}
