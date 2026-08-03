import 'package:flutter/material.dart';

import '../../core/constants.dart';

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key, required this.title, required this.description,
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: card,
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: primaryText,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          Text(
            description,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: secondaryText,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}