import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MinshawySlider extends StatelessWidget {
  const MinshawySlider({
    super.key,
  });


  final List<Widget> items = const [
    Image(
      image: AssetImage('assets/images/minshawy_card.png'),
      fit: BoxFit.contain,
    ),
    Image(
      image: AssetImage('assets/images/Elminshwey.jpg'),
      fit: BoxFit.contain,
    ),
    Image(
      image: AssetImage('assets/images/minshawy_old.jpg'),
      fit: BoxFit.contain,
    ),
    Image(
      image: AssetImage('assets/images/big_minshawy.jpg'),
      fit: BoxFit.contain,
    ),
    Image(
      image: AssetImage('assets/images/minshawy_in_youth.jpg'),
      fit: BoxFit.contain,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: items.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: item,
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.4,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
