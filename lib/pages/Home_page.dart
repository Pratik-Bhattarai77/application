import 'dart:io';

import 'package:application/pages/book_info.dart';
import 'package:application/pages/libary_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application/pages/help_page.dart';
import 'package:application/pages/notes_page.dart';
import 'package:application/pages/profile_page.dart';
import 'package:application/pages/search_page.dart';
import 'package:application/pages/setting_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;

  // sign out user method
  void signUserout() {
    FirebaseAuth.instance.signOut();
  }

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 11, 11, 11),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: GNav(
            backgroundColor: const Color.fromARGB(255, 15, 15, 15),
            color: const Color.fromARGB(255, 238, 236, 236),
            activeColor: const Color.fromARGB(255, 238, 236, 236),
            tabBackgroundColor: const Color.fromARGB(255, 52, 52, 52),
            padding: EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.pages,
                text: "Library",
              ),
              GButton(
                icon: Icons.note,
                text: "Note",
              ),
              GButton(
                icon: Icons.search,
                text: "Search",
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
          ),
        ),
      ),
      //App bar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        title: Text(
          "E-Book",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.white, size: 30), // Set icon color to white
      ),
      //Drawer
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        child: Column(
          children: [
            DrawerHeader(
              child: Icon(
                Icons.tag_faces_sharp,
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(Icons.face, color: Colors.white),
              title: Text('PROFILE', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.white),
              title: Text(
                'HELP',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('LOGOUT', style: TextStyle(color: Colors.white)),
              onTap: () {
                signUserout();
              },
            )
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomeContent(),
          LibraryPage(),
          NotePage(),
          SearchPage(),
        ],
      ),
    );
  }
}

// Home page extended to mkae UI more efficent
class HomeContent extends StatefulWidget {
  HomeContent({Key? key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final myitems = [
    'lib/images/slide2.png',
    'lib/images/slide3.png',
    'lib/images/slide1.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc('pOUxhmtf3E6I0e3jM0vG') // Use the actual document ID
            .collection('books')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No books found'),
            );
          }

          // Split the books into two sections
          List<DocumentSnapshot> firstHalf = snapshot.data!.docs
              .take(snapshot.data!.docs.length ~/ 2)
              .toList();
          List<DocumentSnapshot> secondHalf = snapshot.data!.docs
              .skip(snapshot.data!.docs.length ~/ 2)
              .toList();

          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {},
                ),
                items: myitems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => BookInfoPage(
                                      bookId: null,
                                    )),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                              image: AssetImage(item),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Top Picks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: firstHalf.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        firstHalf[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookInfoPage(bookId: data['bookId']),
                                  ),
                                );
                              },
                              child: Card(
                                color: Color.fromARGB(255, 30, 30, 30),
                                margin: const EdgeInsets.all(16.0),
                                child: CachedNetworkImage(
                                  imageUrl: data['image'] ?? '',
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  height: 140,
                                  width: 100,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['tittle'] ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'For you ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: secondHalf.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        secondHalf[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BookInfoPage(
                                        bookId: data[
                                            'bookId']), // Pass the book's ID or any other necessary data
                                  ),
                                );
                              },
                              child: Card(
                                color: Color.fromARGB(255, 30, 30, 30),
                                margin: const EdgeInsets.all(10.0),
                                child: CachedNetworkImage(
                                  imageUrl: data['image'] ?? '',
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  height: 140,
                                  width: 100,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['tittle'] ?? '',
                                style: TextStyle(
                                  fontSize:
                                      12, // Adjust the font size as needed
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<String?> _fetchPdfUrl(String pdfName) async {
  try {
    final ref = FirebaseStorage.instance.ref();
    var childref = ref.child('book1/I Will Kill The Author c1-141.pdf');
    return await childref.getDownloadURL();
  } on FirebaseException catch (e) {
    print("Failed with error '${e.code}': ${e.message}");
    return null;
  }
}

Future<String?> _downloadPDF(String pdfUrl) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/book.pdf');
    await FirebaseStorage.instance.refFromURL(pdfUrl).writeToFile(file);
    print('PDF downloaded to ${file.path}');
    return file.path;
  } catch (e) {
    print('Error downloading PDF: $e');
    return null;
  }
}
