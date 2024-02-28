import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {super.key});
  QueryDocumentSnapshot doc;

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
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
