import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final picker = ImagePicker();

  Future<void> uploadPhoto() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_photos/${currentUser.uid}');

      try {
        // Upload the image to Firebase Storage
        await storageRef.putFile(File(pickedImage.path));
        final imageUrl = await storageRef.getDownloadURL();

        // Get the user document reference
        final userDocRef =
            FirebaseFirestore.instance.collection('User').doc(currentUser.uid);

        // Check if the user document exists
        final userDocSnapshot = await userDocRef.get();

        if (userDocSnapshot.exists) {
          // Update the photoUrl field in the existing document
          await userDocRef.update({'photoUrl': imageUrl});
        } else {
          // Create a new document with the photoUrl field
          await userDocRef.set({'photoUrl': imageUrl});
        }

        // Clear the cache for the new image URL
        final cacheManager = CacheManager(Config(
          'cacheKey',
          stalePeriod: const Duration(days: 1),
        ));
        await cacheManager.removeFile(imageUrl);

        // Show a SnackBar to indicate successful upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture uploaded successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        // Handle any errors that occurred during upload
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload profile picture'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>?;
                  final photoUrl = userData?['photoUrl'];
                  final fullName = userData?['Full name'];

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: uploadPhoto,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: photoUrl != null
                              ? CachedNetworkImageProvider(photoUrl)
                              : const AssetImage('lib/images/immmm.png')
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        fullName ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('User')
                            .doc(currentUser.uid)
                            .collection('readBooks')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final books = snapshot.data!.docs;
                            return Column(
                              children: [
                                Text(
                                  'My Books',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  margin: EdgeInsets.only(
                                      top:
                                          10), // Adjust the spacing above the divider
                                  width: double
                                      .infinity, // Make the container span the full width
                                  height: 1, // Set the height of the line
                                  color: Colors
                                      .grey[300], // Choose a color for the line
                                ),
                                SizedBox(height: 30),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: books.length,
                                    itemBuilder: (context, index) {
                                      final bookData = books[index].data()
                                          as Map<String, dynamic>;
                                      final imageUrl = bookData['image'];
                                      return imageUrl != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                height: 70,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
