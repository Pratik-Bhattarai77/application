import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SearchPage());
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<dynamic>>? _data;

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=isbn&printType=books&filter=partial&key=AIzaSyD9TlgcPpKR3vBii-SXwWGoRzbsp6M41ug'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return List<dynamic>.from(data['items'].map((item) => {
              ...item,
              'hasPdfView': item['accessInfo']?['pdf']?['isAvailable'] ?? false,
            }));
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load data');
    }
  }

  void _openPreviewLink(String? previewLink) {
    if (previewLink != null && previewLink.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Book Preview'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: WebViewWidget(
              controller: WebViewController()
                ..loadRequest(Uri.parse(previewLink)),
            ),
          ),
        ),
      );
    } else {
      print('No preview link available for this book.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: FutureBuilder<List<dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                var volumeInfo = item['volumeInfo'];
                var title = volumeInfo['title'];
                var authors =
                    volumeInfo['authors']?.join(', ') ?? 'Unknown Author';
                var imageUrl = volumeInfo['imageLinks']?['thumbnail'];
                var previewLink = volumeInfo['previewLink'];
                var hasPdfView =
                    item['hasPdfView']; // Extract the hasPdfView field

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: imageUrl != null
                        ? Container(
                            width: 50,
                            height: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : null,
                    title: Text(title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(authors),
                        Text(hasPdfView
                            ? 'PDF View Available'
                            : 'PDF View Not Available'),
                      ],
                    ),
                    onTap: () {
                      _openPreviewLink(previewLink);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
