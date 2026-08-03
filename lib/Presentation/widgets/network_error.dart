import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        SvgPicture.asset('assets/images/network_error.svg'),
        SizedBox(height: 48),
        Text(
          "لا يوجد اتصال بالإنترنت \n حاول الاتصال لاحقاً",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
