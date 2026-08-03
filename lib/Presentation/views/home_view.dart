import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minshawy/core/constants.dart';
import 'package:minshawy/models/surah_model.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../cubits/audio_cubit/audio_cubit.dart';
import '../cubits/suras_cubit/suras_cubit.dart';
import '../widgets/home_head.dart';
import '../widgets/last_listen.dart';
import '../widgets/network_error.dart';
import '../widgets/search_field.dart';
import '../widgets/suras_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription? connectivitySubscription;

  @override
  void initState() {
    super.initState();

    connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      print(result);

      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        print('Internet Connected');

        final cubit = context.read<SurasCubit>();

        if (cubit.state is SurasError) {
          cubit.getSuras();
        }
      }
    });
  }

  bool isSearching = false;

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
              child: BlocBuilder<SurasCubit, SurasState>(
                builder: (context, state) {
                  if (state is SurasLoading) {
                    return Skeletonizer(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeHead(
                              isSearching: isSearching,
                              onSearchPressed: () {
                                setState(() {
                                  isSearching = !isSearching;

                                  if (!isSearching) {
                                    searchController.clear();
                                    searchText = '';
                                  }
                                });
                              },
                            ),
                            if (isSearching) ...[
                              const SizedBox(height: 16),
                              SearchField(
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                },
                              ),
                            ],
                            const SizedBox(height: 8),

                            const Text('آخر استماع'),
                            const SizedBox(height: 8),

                            LastListen(),

                            const SizedBox(height: 16),

                            const Text('المصحف'),
                            const SizedBox(height: 8),

                            SurasListView(
                              suras: List.generate(
                                5,
                                (_) => SurahModel(
                                  id: 0,
                                  name: 'سورة البقرة',
                                  ayahCount: 286,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is SurasSuccess) {
                    context.read<AudioCubit>().surahs = state.suras;
                    final filteredSuras = searchText.isEmpty
                        ? state.suras
                        : state.suras.where((surah) {
                            return (surah.name ?? '').toLowerCase().contains(
                              searchText.toLowerCase(),
                            );
                          }).toList();
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          HomeHead(
                            isSearching: isSearching,
                            onSearchPressed: () {
                              setState(() {
                                isSearching = !isSearching;

                                if (!isSearching) {
                                  searchController.clear();
                                  searchText = '';
                                }
                              });
                            },
                          ),
                          if (isSearching) ...[
                            const SizedBox(height: 16),
                            SearchField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                            ),
                          ],
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -1,
                                  child: child,
                                ),
                              );
                            },
                            child: !isSearching
                                ? Column(
                                    key: const ValueKey('last_listen'),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      Text(
                                        'آخر استماع',
                                        style: TextStyle(
                                          color: primaryText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      LastListen(),
                                      const SizedBox(height: 16),
                                    ],
                                  )
                                : const SizedBox.shrink(key: ValueKey('empty')),
                          ),
                          Text(
                            'المصحف',
                            style: TextStyle(
                              color: primaryText,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 8),

                          SurasListView(suras: filteredSuras),
                          const SizedBox(height: 84),
                        ],
                      ),
                    );
                  } else if (state is SurasError) {
                    return Center(child: NetworkError());
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
