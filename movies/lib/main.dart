import 'package:flutter/material.dart';

import 'package:movies/src/pages/Home_Page.dart';
import 'package:movies/src/pages/Pelicula_Detalle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Peliculas',

      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {

        '/' : (BuildContext context) => HomePage(),
        'detalle' : (BuildContext context) => PeliculaDetalle(),

      },
    );
  }
}