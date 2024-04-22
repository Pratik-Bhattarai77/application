import 'package:application/pages/book_info.dart';
import 'package:application/pages/libary_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:application/pages/help_page.dart';
import 'package:application/pages/notes_page.dart';
import 'package:application/pages/profile_page.dart';
import 'package:application/pages/search_page.dart';
import 'package:application/pages/setting_page.dart';
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
  HomeContent({Key? key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final myitems = [
    'lib/images/slide2.png',
    'lib/images/slide3.png',
    'lib/images/slide1.png',
  ];

  int myCurrentIndex = 0;

  final List<String> yourImageList = [
    'lib/images/Rectangle 60.png',
    'lib/images/Rectangle 61.png',
    'lib/images/Rectangle 62.png',
    // Add more image paths as needed
  ];
  final List<String> ImageList = [
    'lib/images/Rectangle 63.png',
    'lib/images/Rectangle 64.png',
    'lib/images/Rectangle 65.png',
    // Add more image paths as needed
  ];

  final List<String> yourTitles = [
    'The Exorcist',
    'Jungle book',
    'Moon Love',
    'The Girl who Drank The Moon',
    'The Physcholgy of Money',
    'John Wick',
    // Add more titles as needed
  ];

  final List<String> Titles = [
    'The Girl..',
    'The Physcholgy..',
    'John Wick',
    // Add more titles as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  height: 250,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayInterval: const Duration(seconds: 2),
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      myCurrentIndex = index;
                    });
                  },
                ),
                items: myitems.map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => BookInfoPage()),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                15.0), // Adjust the radius as needed
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
              SizedBox(
                height: 20.0,
              ),
              AnimatedSmoothIndicator(
                activeIndex: myCurrentIndex,
                count: myitems.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 10,
                  dotColor: Colors.grey.shade200,
                  activeDotColor: Color.fromARGB(255, 0, 0, 0),
                  paintStyle: PaintingStyle.fill,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Top Picks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: yourImageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          Image.asset(
                            yourImageList[index],
                            height: 120,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 8),
                          Text(
                            yourTitles[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 1.0),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ImageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Column(
                        children: [
                          Image.asset(
                            ImageList[index],
                            height: 120,
                            width: 120,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 8),
                          Text(
                            Titles[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
