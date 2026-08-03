import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minshawy/core/constants.dart';

class HomeHead extends StatelessWidget {
  const HomeHead({
    super.key,
    required this.onSearchPressed, required this.isSearching,
  });
  final bool isSearching;

  final VoidCallback onSearchPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السلام عليكم',
              style: TextStyle(
                color: primaryText,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              'استمع بخشوع',
              style: TextStyle(
                color: secondaryText,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: onSearchPressed,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    RotationTransition(
                      turns: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    ),
                child: FaIcon(
                  color: primaryColor,
                  isSearching ? FontAwesomeIcons.x : FontAwesomeIcons.magnifyingGlass,
                  key: ValueKey(isSearching),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
            ),
          ],
        ),
      ],
    );
  }
}
