import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayingHead extends StatelessWidget {
  const PlayingHead({
    super.key,
    required this.onMinimize,
  });

  final VoidCallback onMinimize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,

      children: [
        // IconButton(
        //   onPressed: () {},
        //   icon: const FaIcon(
        //     FontAwesomeIcons.ellipsisVertical,
        //     size: 28,
        //     color: Colors.white,
        //   ),
        // ),

        IconButton(
          onPressed: onMinimize,
          icon: const FaIcon(
            FontAwesomeIcons.angleDown,
            size: 28,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
