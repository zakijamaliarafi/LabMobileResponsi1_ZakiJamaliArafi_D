class Isbn {
  int? id;
  String? isbnCode;
  String? format;
  int? printLength;
  Isbn({this.id, this.isbnCode, this.format, this.printLength});
  factory Isbn.fromJson(Map<String, dynamic> obj) {
    return Isbn(
        id: obj['id'],
        isbnCode: obj['isbn_code'],
        format: obj['format'],
        printLength: obj['print_length']);
  }
}
