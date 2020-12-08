import 'package:flutter/material.dart';
import 'package:usuariov3/usuario.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UsuarioDB db = UsuarioDB();
  Usuario user = Usuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: db.initDB(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _mostrarLista(context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _agregarUsuario,
          tooltip: 'Increment',
          child: Icon(Icons.add)),
    );
  }

  _mostrarLista(BuildContext context) {
    return FutureBuilder(
      future: db.getAllusuarios(),
      builder: (BuildContext context, AsyncSnapshot<List<Usuario>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: <Widget>[
              for (Usuario usuario in snapshot.data)
                ListTile(
                  title: Text(usuario.nombre +
                      '-' +
                      usuario.direccion +
                      '-' +
                      usuario.numero.toString()),
                )
            ],
          );
        } else {
          return Center(
            child: Text("Agregar Usuarios"),
          );
        }
      },
    );
  }

  _agregarUsuario() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Nombre"),
                onChanged: (text) {
                  setState(() {
                    user.setNombre(text);
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Direccion"),
                onChanged: (text) {
                  setState(() {
                    user.setDireccion(text);
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Numero"),
                onSubmitted: (text) {
                  setState(() {
                    user.setNumero(int.parse(text));
                    db.insert(user);
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }
}
