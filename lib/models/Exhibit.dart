class Exhibit {
  String nfcId;
  String id;
  String title;
  String titleEn;
  String description;
  String descriptionEn;
  String image;
  String audio;
  String audioEn;

  Exhibit({this.nfcId, this.id, this.title,this.titleEn, this.description,this.descriptionEn, this.image, this.audio,this.audioEn});
  factory Exhibit.fromJson(Map<String, dynamic> json) {
    print(json['audio'].toString()+'audio');
    return Exhibit(
      nfcId: json['nfc_id'],
      id: json['id'].toString(),
      title: json['title'],
      titleEn: json['title_en'],
      description: json['description'],
      descriptionEn: json['description_en'],
      image: json['image'],
      audio: json['audio'],
      audioEn: json['audio_en'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nfc_id': nfcId,
      'title': title,
      'title_en': titleEn,
      'description': description,
      'description_en': descriptionEn,
      'image': image,
      'audio': audio,
      'audio_en': audioEn,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

}