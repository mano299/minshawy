import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants.dart';

class EmptyDownloads extends StatelessWidget {
  const EmptyDownloads({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no_downloads.png',
        ),

        const SizedBox(height: 32),

        const Text(
          'لا يوجد لديك تنزيلات',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'قم بتنزيل السور واستمع إليها في أي وقت',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
