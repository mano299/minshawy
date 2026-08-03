class SurahModel {
  int? id;
  String? name;
  int? ayahCount;
  bool? isMakki;
  String? audioUrl;
  String? duration;

  String? localPath;


  SurahModel(
      {this.id,
        this.name,
        this.ayahCount,
        this.isMakki,
        this.audioUrl,
        this.duration,
       this.localPath});

  SurahModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ayahCount = json['ayahCount'];
    isMakki = json['isMakki'];
    audioUrl = json['audioUrl'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ayahCount'] = ayahCount;
    data['isMakki'] = isMakki;
    data['audioUrl'] = audioUrl;
    data['duration'] = duration;
    return data;
  }
}
