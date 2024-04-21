import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;

  PDFViewerPage({required this.pdfUrl, required this.bookTitle});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? selectedText;
  List<Map<String, dynamic>> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 211, 211),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.network(
              widget.pdfUrl,
              maxZoomLevel: 15.0,
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                setState(() {
                  selectedText = details.selectedText;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]['Hilight Note']),
                  subtitle: Text(notes[index]['content']),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedText != null && selectedText!.isNotEmpty) {
            String formattedText =
                selectedText!.split('\n').map((line) => '- $line').join('\n');
            notes.add({
              'Hilight Note': widget.bookTitle,
              'content': formattedText,
            });
            setState(() {});
          }
          ;
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
