import 'package:flutter/material.dart';
import 'package:responsi1/widget/success_dialog.dart';
import '../bloc/login_bloc.dart';
import '../helpers/user_info.dart';
import '../widget/warning_dialog.dart';
import '/ui/registrasi_page.dart';
import 'isbn_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.orange,  
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                _buttonLogin(),
                const SizedBox(
                  height: 30,
                ),
                _menuRegistrasi()
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.yellow[100],  
    );
  }

  // Membuat Textbox email
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
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
      style: const TextStyle(
        fontFamily: 'ComicSans',
        color: Colors.orange, 
      ),
    );
  }

  // Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      child: const Text("Login"),
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
    LoginBloc.login(
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) async {
      if (value.code == 200) {
        print(value.userID);
        await UserInfo().setToken(value.token!);
        await UserInfo().setUserID(value.userID!);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Login berhasil",
            okClick: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const IsbnPage(),
                ),
              );
            },
          ),
        );
  
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Login gagal, silahkan coba lagi",
                ));
      }
    }, onError: (error) {
      print(error);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
              ));
    });
    setState(() {
      _isLoading = false;
    });
  }

  
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(
            fontFamily: 'ComicSans',
            color: Colors.orange,
          ),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegistrasiPage()));
        },
      ),
    );
  }
}
