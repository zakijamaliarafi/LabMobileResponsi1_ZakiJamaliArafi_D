class ApiUrl {
  static const String baseUrl =
      'http://responsi.webwizards.my.id/api'; //sesuaikan dengan ip laptop / localhost teman teman / url server Codeigniter

  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listIsbn = baseUrl + '/buku/isbn';
  static const String createIsbn = baseUrl + '/buku/isbn';

  static String updateIsbn(int id) {
    return baseUrl +
        '/buku/isbn/' +
        id.toString() + '/update'; //sesuaikan dengan url API yang sudah dibuat
  }

  static String showIsbn(int id) {
    return baseUrl +
        '/buku/isbn/' +
        id.toString(); //sesuaikan dengan url API yang sudah dibuat
  }

  static String deleteIsbn(int id) {
    return baseUrl +
        '/buku/isbn/' +
        id.toString() + '/delete'; //sesuaikan dengan url API yang sudah dibuat
  }
}
