import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';

import '../screens/profile_screen.dart';

const webScreenSize = 600;
const String logoAppSvg = 'assets/ic_instagram.svg';
const String avatarBlankUrl =
    'https://apsec.iafor.org/wp-content/uploads/sites/37/2017/02/IAFOR-Blank-Avatar-Image.jpg';
const String imageDemoUrl =
    'https://images.unsplash.com/photo-1505744386214-51dba16a26fc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YmxhbmslMjBhbnZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=400&q=60';
List<Widget> homeScreenItems = const [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('Notify'),
  ProfileScreen(),
];
