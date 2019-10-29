import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/Pelicula_Model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';
import 'package:movies/src/providers/peliculas_provider.dart' as prefix0;
import 'package:movies/src/search/Search_Delegate.dart';
import 'package:movies/src/widgets/Card_Swiper_Widget.dart';
import 'package:movies/src/widgets/Movie_Horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cines',
            style: TextStyle(fontSize: 30.0, color: Color(0xffb74093))),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch()
                );
            },
          )
        ],
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _swiperTarjetas(),
          _footer(context),
        ],
      )),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),

          ),
          Text('Populares', style: Theme.of(context).textTheme.subhead),
          SizedBox(height: 10.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,// el getter 
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares,
                  );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
