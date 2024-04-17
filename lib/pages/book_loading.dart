import 'dart:convert';
import 'package:application/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookLoading extends StatefulWidget {
  final String c;
  BookLoading({required this.c});

  @override
  _BookLoadingState createState() => _BookLoadingState();
}

class _BookLoadingState extends State<BookLoading> {
  dynamic bookData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://www.googleapis.com/books/v1/volumes?q=isbn:${widget.c}&key=YOUR_API_KEY_HERE"));
      if (response.statusCode == 200) {
        setState(() {
          bookData = jsonDecode(response.body);
          navigateToSearchPage();
        });
      } else {
        throw Exception('Failed to load book data');
      }
    } catch (e) {
      print("Error fetching book data: $e");
      // Optionally, show a snackbar or dialog to inform the user about the error
    }
  }

  void navigateToSearchPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchPage(d: bookData);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
