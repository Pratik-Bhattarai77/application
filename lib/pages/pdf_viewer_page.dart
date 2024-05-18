import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;

  PDFViewerPage({
    required this.pdfUrl,
    required this.bookTitle,
    required Map<String, dynamic> bookData,
  });

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? selectedText;
  List<Map<String, dynamic>> notes = [];
  late FlutterTts flutterTts;
  bool isPlaying = false;
  bool isFullScreen = true;
  bool readEntireBook = false;
  PdfDocument? document;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });
    flutterTts.setCompletionHandler(() async {
      if (readEntireBook) {
        currentPageIndex++;
        if (currentPageIndex < document!.pages.count) {
          await _speak();
        } else {
          setState(() {
            isPlaying = false;
            readEntireBook = false;
          });
        }
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
    });

    loadDocument();
  }

  Future<void> loadDocument() async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(widget.pdfUrl));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      httpClient.close();

      document = PdfDocument(inputBytes: bytes);

      setState(() {});
    } catch (e) {
      print('Error loading document: $e');
    }
  }

  Future _speak() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(1.0);
      await flutterTts.setVolume(1.0);
      await flutterTts.setSpeechRate(Platform.isAndroid ? 0.6 : 0.395);
      await flutterTts.awaitSpeakCompletion(true);

      if (readEntireBook && document != null) {
        final textExtractor = PdfTextExtractor(document!);
        final pageText = textExtractor.extractText(
            startPageIndex: currentPageIndex, endPageIndex: currentPageIndex);

        if (pageText.isNotEmpty) {
          await flutterTts.speak(pageText);
        } else {
          // Handle empty text (page with only images)
          currentPageIndex++;
          if (currentPageIndex < document!.pages.count) {
            await _speak();
          } else {
            setState(() {
              isPlaying = false;
              readEntireBook = false;
            });
          }
        }
      }

      if (!readEntireBook && selectedText != null && selectedText!.isNotEmpty) {
        await flutterTts.speak(selectedText!);
      }
    } catch (e) {
      print('Error setting voice: $e');
      await flutterTts.setVoice({"name": "Default", "locale": "en-US"});
      if (readEntireBook && document != null) {
        final textExtractor = PdfTextExtractor(document!);
        final pageText = textExtractor.extractText(
            startPageIndex: currentPageIndex, endPageIndex: currentPageIndex);

        if (pageText.isNotEmpty) {
          await flutterTts.speak(pageText);
        } else {
          // Handle empty text (page with only images)
          currentPageIndex++;
          if (currentPageIndex < document!.pages.count) {
            await _speak();
          } else {
            setState(() {
              isPlaying = false;
              readEntireBook = false;
            });
          }
        }
      }

      if (!readEntireBook && selectedText != null && selectedText!.isNotEmpty) {
        await flutterTts.speak(selectedText!);
      }
    }
  }

  Future _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      readEntireBook = false;
      currentPageIndex = 0;
    });
  }

  void _saveSelectedText() {
    if (selectedText != null && selectedText!.isNotEmpty) {
      String formattedText = selectedText!;
      notes.add({
        'Highlight Note': widget.bookTitle,
        'content': formattedText,
      });
      setState(() {});
    }
  }

  void _handlePlayButtonTap() {
    setState(() {
      readEntireBook = !readEntireBook;
      currentPageIndex = 0;
    });

    _speak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 211, 211),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: _handlePlayButtonTap,
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: _stop,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isFullScreen = !isFullScreen;
          });
        },
        child: Stack(
          children: [
            Visibility(
              visible: isFullScreen,
              child: document != null
                  ? SfPdfViewer.network(
                      widget.pdfUrl,
                      maxZoomLevel: 15.0,
                      onTextSelectionChanged:
                          (PdfTextSelectionChangedDetails details) {
                        setState(() {
                          selectedText = details.selectedText;
                        });
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveSelectedText,
        child: Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
