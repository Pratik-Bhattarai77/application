import 'package:flutter/material.dart';

class BookInfoPage extends StatefulWidget {
  const BookInfoPage({Key? key}) : super(key: key);

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image of the book cover
          Image.asset(
            'lib/images/Rectangle 62.png',
            width: 200,
            height: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            'The Fantasy world',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Cherry Curtis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star_half, color: Colors.yellow),
            ],
          ),
          SizedBox(height: 40),

          ElevatedButton(
            onPressed: () {
              print('Add to Library button pressed');
            },
            child: Text('Add to Library'),
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
