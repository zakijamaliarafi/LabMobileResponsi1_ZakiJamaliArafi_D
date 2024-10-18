import 'package:flutter/material.dart';
import '../bloc/registrasi_bloc.dart';
import '../widget/success_dialog.dart';
import '../widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  final _passwordKonfirmasiTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _namaTextField(),
                _emailTextField(),
                _passwordTextField(),
                _passwordKonfirmasiTextField(),
                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.yellow[100],
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama",
        labelStyle: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
      style: const TextStyle(
        fontFamily: 'ComicSans',
        color: Colors.orange,
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern.toString());
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
      style: const TextStyle(
        fontFamily: 'ComicSans',
        color: Colors.orange,
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
      style: const TextStyle(
        fontFamily: 'ComicSans',
        color: Colors.orange,
      ),
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Konfirmasi Password",
        labelStyle: TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.orange,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      obscureText: true,
      controller: _passwordKonfirmasiTextboxController,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
      style: const TextStyle(
        fontFamily: 'ComicSans',
        color: Colors.orange,
      ),
    );
  }

  Widget _buttonRegistrasi() {
    return ElevatedButton(
      child: const Text("Registrasi"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        textStyle: const TextStyle(
          fontFamily: 'ComicSans',
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
            nama: _namaTextboxController.text,
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
                description: "Registrasi berhasil, silahkan login",
                okClick: () {
                  Navigator.pop(context);
                },
              ));
    }, onError: (error) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Registrasi gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }
}