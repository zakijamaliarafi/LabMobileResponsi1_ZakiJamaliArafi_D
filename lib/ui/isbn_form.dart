import 'package:flutter/material.dart';
import 'package:responsi1/widget/success_dialog.dart';
import '../bloc/isbn_bloc.dart';
import '../widget/warning_dialog.dart';
import '../model/isbn.dart';
import 'isbn_page.dart';

// ignore: must_be_immutable
class IsbnForm extends StatefulWidget {
  Isbn? isbn;
  IsbnForm({Key? key, this.isbn}) : super(key: key);
  @override
  _IsbnFormState createState() => _IsbnFormState();
}

class _IsbnFormState extends State<IsbnForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH ISBN";
  String tombolSubmit = "SIMPAN";
  final _kodeIsbnTextboxController = TextEditingController();
  final _formatIsbnTextboxController = TextEditingController();
  final _printLengthIsbnTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.isbn != null) {
      setState(() {
        judul = "UBAH ISBN";
        tombolSubmit = "UBAH";
        _kodeIsbnTextboxController.text = widget.isbn!.isbnCode!;
        _formatIsbnTextboxController.text = widget.isbn!.format!;
        _printLengthIsbnTextboxController.text =
            widget.isbn!.printLength.toString();
      });
    } else {
      judul = "TAMBAH ISBN";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(
            fontFamily: 'ComicSans',
            color: Colors.white, // Warna teks putih
          ),
        ),
        backgroundColor: Colors.orange, // AppBar dengan latar belakang oranye
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeIsbnTextField(),
                const SizedBox(height: 16.0),
                _namaIsbnTextField(),
                const SizedBox(height: 16.0),
                _hargaIsbnTextField(),
                const SizedBox(height: 20.0),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.yellow[100], // Latar belakang Scaffold kuning muda
    );
  }

  // Membuat Textbox Kode Isbn
  Widget _kodeIsbnTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Kode Isbn",
        labelStyle: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange, // Warna label oranye
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange), // Border oranye
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow), // Border kuning saat fokus
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _kodeIsbnTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kode Isbn harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Nama Isbn
  Widget _namaIsbnTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Format",
        labelStyle: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange, // Warna label oranye
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange), // Border oranye
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow), // Border kuning saat fokus
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _formatIsbnTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Format harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Harga Isbn
  Widget _hargaIsbnTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Print Length",
        labelStyle: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange, // Warna label oranye
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange), // Border oranye
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow), // Border kuning saat fokus
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _printLengthIsbnTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Print Length harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.orange), // Border tombol oranye
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      child: Text(
        tombolSubmit,
        style: const TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange, // Teks tombol oranye
        ),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.isbn != null) {
              // kondisi update isbn
              ubah();
            } else {
              // kondisi tambah isbn
              simpan();
            }
          }
        }
      },
    );
  }

  simpan() {
    setState(() {
      _isLoading = true;
    });
    Isbn createIsbn = Isbn(id: null);
    createIsbn.isbnCode = _kodeIsbnTextboxController.text;
    createIsbn.format = _formatIsbnTextboxController.text;
    createIsbn.printLength = int.parse(_printLengthIsbnTextboxController.text);
    IsbnBloc.addIsbn(isbn: createIsbn).then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Isbn berhasil ditambahkan",
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
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  ubah() {
    setState(() {
      _isLoading = true;
    });
    Isbn updateIsbn = Isbn(id: widget.isbn!.id!);
    updateIsbn.isbnCode = _kodeIsbnTextboxController.text;
    updateIsbn.format = _formatIsbnTextboxController.text;
    updateIsbn.printLength = int.parse(_printLengthIsbnTextboxController.text);
    IsbnBloc.updateIsbn(isbn: updateIsbn).then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Isbn berhasil diubah",
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
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}
