import 'package:flutter/material.dart';
import 'package:responsi1/widget/success_dialog.dart';
import '../bloc/isbn_bloc.dart';
import '../widget/warning_dialog.dart';
import '../model/isbn.dart';
import 'isbn_form.dart';
import 'isbn_page.dart';

// ignore: must_be_immutable
class IsbnDetail extends StatefulWidget {
  Isbn? isbn;

  IsbnDetail({Key? key, this.isbn}) : super(key: key);

  @override
  _IsbnDetailState createState() => _IsbnDetailState();
}

class _IsbnDetailState extends State<IsbnDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Isbn',
          style: TextStyle(fontFamily: 'ComicSans'), // Font ComicSans di AppBar
        ),
        backgroundColor: Colors.orange, // Warna AppBar oranye
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kode : ${widget.isbn!.isbnCode}",
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'ComicSans',
                color: Colors.orange, // Warna teks oranye
              ),
            ),
            Text(
              "Format : ${widget.isbn!.format}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'ComicSans',
                color: Colors.orange, // Warna teks kuning
              ),
            ),
            Text(
              "Print Length : ${widget.isbn!.printLength}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'ComicSans',
                color: Colors.orange, // Warna teks oranye
              ),
            ),
            const SizedBox(height: 20.0),
            _tombolHapusEdit()
          ],
        ),
      ),
      backgroundColor: Colors.yellow[100], // Latar belakang Scaffold kuning muda
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.orange), // Garis tombol oranye
          ),
          child: const Text(
            "EDIT",
            style: TextStyle(
              fontFamily: 'ComicSans',
              color: Colors.orange, // Teks tombol oranye
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IsbnForm(
                  isbn: widget.isbn!,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10.0),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red), // Garis tombol merah
          ),
          child: const Text(
            "DELETE",
            style: TextStyle(
              fontFamily: 'ComicSans',
              color: Colors.red, // Teks tombol merah
            ),
          ),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange, // Warna teks dialog oranye
        ),
      ),
      actions: [
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red), // Garis tombol merah
          ),
          child: const Text(
            "Ya",
            style: TextStyle(
              fontFamily: 'ComicSans',
              color: Colors.red, // Teks tombol merah
            ),
          ),
          onPressed: () {
            IsbnBloc.deleteIsbn(id: widget.isbn!.id!).then(
                (value) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => SuccessDialog(
                        description: "Isbn berhasil dihapus",
                        okClick: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) => const IsbnPage(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    );
                    }, onError: (error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ));
            });
          },
        ),
        // Tombol Batal
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.orange), // Garis tombol oranye
          ),
          child: const Text(
            "Batal",
            style: TextStyle(
              fontFamily: 'ComicSans',
              color: Colors.orange, // Teks tombol oranye
            ),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
