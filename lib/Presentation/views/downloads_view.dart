import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minshawy/Presentation/cubits/downloads_cubit/downloads_cubit.dart';
import 'package:minshawy/Presentation/cubits/downloads_cubit/downloads_state.dart';
import 'package:minshawy/Presentation/widgets/search_field.dart';
import 'package:minshawy/core/constants.dart';

import '../widgets/downloads_surah_item.dart';
import '../widgets/empty_downloads.dart';
import '../widgets/surah_item.dart';

class DownloadsView extends StatefulWidget {
  const DownloadsView({super.key});

  @override
  State<DownloadsView> createState() => _DownloadsViewState();
}

class _DownloadsViewState extends State<DownloadsView> {
  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  @override
  void initState() {
    super.initState();
    context.read<DownloadsCubit>().loadDownloads();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التنزيلات',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: primaryText,
                    ),
                  ),

                  const SizedBox(height: 8),

                  SearchField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),
                  BlocBuilder<DownloadsCubit, DownloadsState>(
                    builder: (context, state) {
                      final downloadsCount = state is DownloadsSuccess
                          ? state.downloads.length
                          : 0;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'قائمة السور التي تم تنزيلها',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'عدد التنزيلات : $downloadsCount',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<DownloadsCubit, DownloadsState>(
                      builder: (context, state) {
                        if (state is DownloadsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is DownloadsEmpty) {
                          return SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .6,
                              child: Center(child: EmptyDownloads()),
                            ),
                          );
                        }

                        if (state is DownloadsSuccess) {
                          final downloads = List.of(state.downloads)
                            ..sort((a, b) => a.surahId.compareTo(b.surahId));

                          final filteredDownloads = searchText.isEmpty
                              ? downloads
                              : downloads.where((item) {
                            return item.surahName
                                .toLowerCase()
                                .contains(searchText.toLowerCase());
                          }).toList();

                          return Column(
                            children: [
                              const SizedBox(height: 24),

                              Expanded(
                                child: filteredDownloads.isEmpty
                                    ? Center(
                                        child: Text(
                                          'لا توجد نتائج',
                                          style: TextStyle(
                                            color: secondaryText,
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                        itemCount: filteredDownloads.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 12),
                                        itemBuilder: (context, index) {
                                       return   DownloadedSurahItem(
                                         download: filteredDownloads[index],
                                         allDownloads: filteredDownloads,
                                       );
                                        },
                                      ),
                              ),
                            ],
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
