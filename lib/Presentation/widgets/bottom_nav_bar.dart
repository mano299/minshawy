import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minshawy/core/constants.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final titles = ['عن التطبيق', 'التنزيلات', 'المفضلة', 'الرئيسية'];

    final icons = [
      FontAwesomeIcons.circleInfo,
      FontAwesomeIcons.download,
      FontAwesomeIcons.bookmark,
      FontAwesomeIcons.house,
    ];
    final selectedIcons = [
      FontAwesomeIcons.circleInfo,
      FontAwesomeIcons.download,
      FontAwesomeIcons.solidBookmark,
      FontAwesomeIcons.solidHouse,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: darkBlue, width: 2),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            offset: Offset(0, 4),
            color: Colors.black12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          icons.length,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onTap(index),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: currentIndex == index ? 1.1 : 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      currentIndex == index ? selectedIcons[index] : icons[index],
                      size: currentIndex == index ? 26 : 22,
                      color: currentIndex == index ? darkBlue : primaryColor,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      titles[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: currentIndex == index
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: currentIndex == index ? darkBlue : primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
