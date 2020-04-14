class Exhibit {
  String nfcId;
  String id;
  String title;
  String description;
  String image;
  String audio;

  Exhibit({this.nfcId, this.id, this.title, this.description, this.image, this.audio});
  factory Exhibit.fromJson(Map<String, dynamic> json) {
    print(json['audio'].toString()+'audio');
    return Exhibit(
      nfcId: json['nfc_id'],
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      image: json['image'],
      audio: json['audio'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nfc_id': nfcId,
      'title': title,
      'description': description,
      'image': image,
      'audio': audio,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

}