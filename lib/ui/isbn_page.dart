import 'package:flutter/material.dart';
import '../bloc/logout_bloc.dart';
import '../bloc/isbn_bloc.dart';
import '../model/isbn.dart';
import '/ui/isbn_detail.dart';
import '/ui/isbn_form.dart';
import 'login_page.dart';

class IsbnPage extends StatefulWidget {
  const IsbnPage({Key? key}) : super(key: key);

  @override
  _IsbnPageState createState() => _IsbnPageState();
}

class _IsbnPageState extends State<IsbnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Isbn',
          style: TextStyle(
            fontFamily: 'ComicSans', // Menggunakan font ComicSans
          ),
        ),
        backgroundColor: Colors.orange, // Menggunakan warna oranye untuk AppBar
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                child: const Icon(Icons.add, size: 26.0, color: Colors.yellow),
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IsbnForm()));
                },
              ))
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.yellow[100],
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'ComicSans',
                  color: Colors.orange,
                ),
              ),
              trailing: const Icon(Icons.logout, color: Colors.yellow),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false)
                    });
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List>(
        future: IsbnBloc.getIsbns(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print("error: ${snapshot.error}");
          return snapshot.hasData
              ? ListIsbn(
                  list: snapshot.data,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      backgroundColor: Colors.yellow[100], // Latar belakang Scaffold warna kuning muda
    );
  }
}

class ListIsbn extends StatelessWidget {
  final List? list;

  const ListIsbn({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list!.length,
        itemBuilder: (context, i) {
          return ItemIsbn(
            isbn: list![i],
          );
        });
  }
}

class ItemIsbn extends StatelessWidget {
  final Isbn isbn;

  const ItemIsbn({Key? key, required this.isbn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IsbnDetail(
                      isbn: isbn,
                    )));
      },
      child: Card(
        color: Colors.orange,
        child: ListTile(
          title: Text(
            isbn.isbnCode!,
            style: const TextStyle(
              fontFamily: 'ComicSans',
              color: Colors.yellow,
            ),
          ),
          subtitle: Text(
            isbn.format!,
            style: const TextStyle(
              fontFamily: 'ComicSans',
              color: Colors.yellow,
            ),
          ),
          trailing: Text(
            isbn.printLength.toString(),
            style: const TextStyle(
              fontFamily: 'ComicSans',
              color: Colors.yellow,
            ),
          ),
        ),
      ),
    );
  }
}
