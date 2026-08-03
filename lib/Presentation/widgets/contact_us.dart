import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants.dart';
import '../../data/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: card,
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Text(
            'تواصل معنا',
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  launchUrlLink(
                    'https://www.linkedin.com/in/muhammedahmedabdelhadi',
                  );
                },
                icon: FaIcon(
                  FontAwesomeIcons.squareLinkedin,
                  color: Color(0xff0A66C2),
                  size: 32,
                ),
              ),
              SizedBox(width: 4),
              InkWell(
                onTap: () {
                  launchUrlLink(
                    'mailto:muhammed.abdelhadi9@gmail.com',
                  );
                },
                splashColor: primaryColor,
                child: SvgPicture.asset(
                  'assets/images/google.svg',
                  height: 36,
                  width: 36,
                ),
              ),
              SizedBox(width: 4),
              IconButton(
                onPressed: () {
                  launchUrlLink(
                    'https://wa.me/201090820457',
                  );
                },
                icon: FaIcon(
                  FontAwesomeIcons.squareWhatsapp,
                  color: Colors.green,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
