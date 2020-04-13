class Exhibit {
  String nfcId;
  String id;
  String title;
  String description;
  String image;

  Exhibit({this.nfcId, this.id, this.title, this.description, this.image});
  factory Exhibit.fromJson(Map<String, dynamic> json) {
    return Exhibit(
      nfcId: json['nfc_id'],
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nfc_id': nfcId,
      'title': title,
      'description': description,
      'image': image,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

}