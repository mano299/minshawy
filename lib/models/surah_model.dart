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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ayahCount'] = this.ayahCount;
    data['isMakki'] = this.isMakki;
    data['audioUrl'] = this.audioUrl;
    data['duration'] = this.duration;
    return data;
  }
}
