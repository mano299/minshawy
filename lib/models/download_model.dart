class DownloadModel {
  final int surahId;
  final String surahName;
  final String localPath;
  final String duration;
  final int ayahCount;
  final bool isMakki;

  DownloadModel({
    required this.surahId,
    required this.surahName,
    required this.localPath,
    required this.duration,
    required this.ayahCount,
    required this.isMakki,
  });

  Map<String, dynamic> toJson() {
    return {
      'surahId': surahId,
      'surahName': surahName,
      'localPath': localPath,
      'duration': duration,
      'ayahCount': ayahCount,
      'isMakki': isMakki,
    };
  }

  factory DownloadModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DownloadModel(
      surahId: json['surahId'],
      surahName: json['surahName'],
      localPath: json['localPath'],
      duration: json['duration'] ?? '00:00:00',
      ayahCount: json['ayahCount'] ?? 0,
      isMakki: json['isMakki'] ?? true,
    );
  }
}