import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minshawy/Presentation/widgets/network_error.dart';
import 'package:minshawy/core/constants.dart';

import '../cubits/favorites_cubit/favorites_cubit.dart';
import '../cubits/favorites_cubit/favorites_state.dart';
import '../cubits/suras_cubit/suras_cubit.dart';
import '../widgets/favorite_menu_header.dart';
import '../widgets/search_field.dart';
import '../widgets/surah_item.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final searchController = TextEditingController();
  String searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'المفضلة',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: primaryText,
                    ),
                  ),
                  SizedBox(height: 24),
                  SearchField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final favoritesCount = state is FavoritesLoaded
                          ? state.favoriteIds.length
                          : 0;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'قائمة السور المفضلة',
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'عدد المفضلة : $favoritesCount',
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
                  SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<SurasCubit, SurasState>(
                      builder: (context, surasState) {

                        if (surasState is! SurasSuccess) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, state) {

                            if (state is FavoritesLoaded) {

                              if (state.favoriteIds.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        size: 100,
                                        color: primaryColor,
                                      ),
                                      SizedBox(height: 24),
                                      Text(
                                        'لا توجد سور مفضلة',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'أضف السور التي تحبها للوصول إليها بسرعة',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: secondaryText,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final favoriteSuras = surasState.suras
                                  .where(
                                    (surah) => state.favoriteIds.contains(surah.id),
                              )
                                  .toList();

                              final filteredSuras = searchText.isEmpty
                                  ? favoriteSuras
                                  : favoriteSuras.where((surah) {
                                return (surah.name ?? '')
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase());
                              }).toList();

                              return ListView.separated(
                                itemCount: filteredSuras.length,
                                separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  if (index == filteredSuras.length) {
                                    return const SizedBox(height: 84);
                                  }
                                  return SurahItem(
                                    surah: filteredSuras[index],

                                  );

                                },
                              );
                            }
                            if (surasState is SurasLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (surasState is SurasError) {
                              return NetworkError();
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      },
                    ),
                  )                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
