import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../cubits/states_cubit/states_cubit.dart';
import '../cubits/states_cubit/states_state.dart';
import 'contact_us.dart';

class InfoFooter extends StatelessWidget {
  const InfoFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Container(
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
                'السور المسموعة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              BlocBuilder<StatsCubit, StatsState>(
                builder: (context, state) {
                  if (state is StatsLoaded) {
                    return Text(
                      state.listenedCount.toString(),
                      style: TextStyle(
                        fontFamily: 'Zain',
                        color: gold,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

                  return const Text('0');
                },
              )
            ],
          ),
        ),
        ContactUs(),
      ],
    );
  }
}
