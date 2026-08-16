import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/notifications_service.dart';
import '../../../models/download_model.dart';
import '../../../models/surah_model.dart';
import 'downloads_state.dart';

class DownloadsCubit extends Cubit<DownloadsState> {
  DownloadsCubit() : super(DownloadsInitial());

  final Dio _dio = Dio();

  final Map<int, double> _progress = {};

  List<DownloadModel> _downloads = [];

  double getProgress(int surahId) {
    return _progress[surahId] ?? 0;
  }

  Future<void> loadDownloads() async {
    emit(DownloadsLoading());

    final box = await Hive.openBox('downloads');

    final data = box.values
        .map(
          (e) => DownloadModel.fromJson(
        Map<String, dynamic>.from(e),
      ),
    )
        .toList();
    print('Loaded downloads: ${data.length}');
    print(data);

    _downloads = data;

    if (_downloads.isEmpty) {
      emit(DownloadsEmpty());
    } else {
      emit(
        DownloadsSuccess(
          _downloads,
        ),
      );
    }
  }

  Future<void> downloadSurah(
      SurahModel surah,
      ) async {
    if (surah.id == null ||
        surah.audioUrl == null) {
      return;
    }

    if (isDownloaded(surah.id!)) {
      return;
    }

    try {
      final appDir =
      await getApplicationDocumentsDirectory();

      final downloadsDir = Directory(
        '${appDir.path}/downloads',
      );

      if (!await downloadsDir.exists()) {
        await downloadsDir.create(
          recursive: true,
        );
      }

      final filePath =
          '${downloadsDir.path}/${surah.id}.mp3';

      await _dio.download(
        surah.audioUrl!,
        filePath,
        onReceiveProgress: (
            received,
            total,
            ) async {
          if (total <= 0) return;

          final progress =
              (received / total) * 100;

          _progress[surah.id!] = progress;

          await NotificationService.showProgress(
            progress: progress.toInt(),
            title:
            'تحميل سورة ${surah.name}',
          );

          emit(
            DownloadsSuccess(
              List.from(_downloads),
            ),
          );
        },
      );

      final download = DownloadModel(
        surahId: surah.id!,
        surahName: surah.name!,
        localPath: filePath,
        duration: surah.duration ?? '00:00:00',
        ayahCount: surah.ayahCount ?? 0,
        isMakki: surah.isMakki ?? true,
      );

      _downloads.add(download);

      final box =
      await Hive.openBox('downloads');

      await box.put(
        surah.id,
        download.toJson(),
      );
      print('Saved download: ${download.surahName}');
      print('Box length: ${box.length}');

      await NotificationService.complete(
        'سورة ${surah.name}',
      );

      emit(
        DownloadsSuccess(
          List.from(_downloads),
        ),
      );
    } catch (e) {
      emit(
        DownloadsError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> removeDownload(
      int surahId,
      ) async {
    try {
      final item = _downloads.firstWhere(
            (e) => e.surahId == surahId,
      );

      final file = File(
        item.localPath,
      );

      if (await file.exists()) {
        await file.delete();
      }

      _downloads.removeWhere(
            (e) => e.surahId == surahId,
      );

      final box =
      await Hive.openBox('downloads');

      await box.delete(surahId);

      if (_downloads.isEmpty) {
        emit(DownloadsEmpty());
      } else {
        emit(
          DownloadsSuccess(
            List.from(_downloads),
          ),
        );
      }
    } catch (e) {
      emit(
        DownloadsError(
          e.toString(),
        ),
      );
    }
  }

  bool isDownloaded(
      int surahId,
      ) {
    return _downloads.any(
          (e) => e.surahId == surahId,
    );
  }

  String? getLocalPath(
      int surahId,
      ) {
    try {
      return _downloads
          .firstWhere(
            (e) => e.surahId == surahId,
      )
          .localPath;
    } catch (_) {
      return null;
    }
  }
}