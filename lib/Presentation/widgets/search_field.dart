import 'package:flutter/material.dart';

import '../../core/constants.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
      controller: controller,
      onChanged: onChanged,
      cursorColor: darkBlue,
      cursorRadius: Radius.circular(16),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: primaryColor),
        hint: Text('ابحث عن سورة', style: TextStyle(color: secondaryText)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
