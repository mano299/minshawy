import 'package:flutter/material.dart';
import 'package:minshawy/Presentation/widgets/surah_item.dart';
import 'package:minshawy/models/surah_model.dart';

class SurasListView extends StatelessWidget {
  const SurasListView({super.key, required this.suras});

  final List<SurahModel> suras;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: suras.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: SurahItem(
         surah: suras[index],
        ),
      ),
    );
  }
}
