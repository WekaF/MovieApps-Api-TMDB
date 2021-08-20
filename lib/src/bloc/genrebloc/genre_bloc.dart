import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermovie/src/bloc/genrebloc/genre_bloc.event.dart';
import 'package:fluttermovie/src/bloc/genrebloc/genre_bloc_state.dart';
import 'package:fluttermovie/src/model/genre.dart';
import 'package:fluttermovie/src/service/api_service.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState>{
  GenreBloc() : super(GenreLoading());


  // ignore: unused_element
  Stream<GenreState> _mapMovieEventStateToState()async*{
    final service = ApiService();
    yield GenreLoading();
    try {

      List<Genre> genreList = await service.getGenreList();
      yield GenreLoaded(genreList);
    } on Exception catch (e) {
      print(e);
      yield GenreError();
    } 
  }

  @override
  Stream<GenreState> mapEventToState(GenreEvent event) async* {
    if(event is GenreEventStarted){
      yield* _mapMovieEventStateToState();
    }
  }

}