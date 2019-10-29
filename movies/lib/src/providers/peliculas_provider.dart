import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/src/models/Actores_Model.dart';
import 'package:movies/src/models/Pelicula_Model.dart';

class PeliculasProvider {
  String _apikey = '75d112d15d5ebd38ac80016341a937e3';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<
      List<
          Pelicula>>.broadcast(); //Si no pongo el broadcast solo 1 widget escucha, con broadcast escucha muchos

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  // lo llamamos cuando getpopulares aparece es la entrada de datos al stream
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController
        ?.close(); //si le pongo "?" hace algo solo si tiene info
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(
        url); //Va a retornar toda la respuesta http y la guardamos en una variable
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    //print(peliculas.items[0].title); solo para checar el titulo de las peliculas
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.http(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.http(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    popularesSink(_populares);

    _cargando = false; // para que el usuario no gaste todos sus datos

    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData =
        json.decode(resp.body); //Transforma la info en un mapa con ese body

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query ) async {

    final url = Uri.http(_url, '3/search/movie',
        {'api_key': _apikey, 
        'language': _language,
        'query'   : query
        });

    return await _procesarRespuesta(url);
  }
}
