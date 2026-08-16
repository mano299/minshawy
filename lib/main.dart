import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:minshawy/Presentation/cubits/audio_cubit/audio_cubit.dart';
import 'package:minshawy/Presentation/cubits/suras_cubit/suras_cubit.dart';
import 'package:minshawy/core/constants.dart';
import 'Presentation/cubits/downloads_cubit/downloads_cubit.dart';
import 'Presentation/cubits/favorites_cubit/favorites_cubit.dart';
import 'Presentation/cubits/states_cubit/states_cubit.dart';
import 'Presentation/views/splash_view.dart';
import 'data/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.minshawy.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter();
  await Hive.openBox('stats');
  await Hive.openBox('settings');
  await Hive.openBox<int>('favorites');
  await Hive.openBox('downloads');  await NotificationService.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SurasCubit()..getSuras()),
        BlocProvider(create: (_) => StatsCubit()..loadStats()),
        BlocProvider(create: (context) => DownloadsCubit()..loadDownloads()),
        BlocProvider(create: (_) => FavoritesCubit()..loadFavorites()),
        BlocProvider(create: (_) => AudioCubit()),
      ],
      child: const MinshawyApp(),
    ),
  );
}

class MinshawyApp extends StatelessWidget {
  const MinshawyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Madika',
        scaffoldBackgroundColor: background,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
