class Exhibit {
  final String nfcId;
  final String id;
  final String title;
  final String description;
  final String image;

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
}