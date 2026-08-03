import 'package:flutter/material.dart';
import 'package:minshawy/Presentation/views/info_view.dart';
import 'package:minshawy/Presentation/views/downloads_view.dart';
import 'package:minshawy/Presentation/views/favorite_view.dart';
import 'package:minshawy/Presentation/views/home_view.dart';

import '../widgets/bottom_nav_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 3;

  final List<Widget> pages = const [
    InfoView(),
    DownloadsView(),
    FavoriteScreen(),
    HomeView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: pages,
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: BottomNavBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}