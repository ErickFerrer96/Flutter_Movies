import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/Pelicula_Model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    ;
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        //Genera movimiento de las pelis
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) {
         
         peliculas[index].uniqueId='${peliculas[index].id}-crearTarjeta';
         
          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.pushNamed(context,'detalle',arguments: peliculas[index]),
                  child: FadeInImage(
                    image: NetworkImage(
                        peliculas[index].getPosterImg()), //Jala la imagen
                    placeholder:
                        AssetImage('assets/img/no-image.jpg'), //En lo que carga
                    fit: BoxFit.cover, //llena la imagen
                  ),
                )),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
