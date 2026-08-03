import 'package:flutter/material.dart';

import '../../core/constants.dart';

class FavoriteMenuHeader extends StatelessWidget {
  const FavoriteMenuHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          'قائمة السور المفضلة',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),Text(
          'عدد المفضلة : 15',
          style: TextStyle(
            color: secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
