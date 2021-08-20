import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermovie/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:fluttermovie/src/model/movie.dart';
import 'package:fluttermovie/src/service/api_service.dart';

import 'movie_bloc_event.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState>{
  MovieBloc() : super(MovieLoading());


  // ignore: unused_element
  Stream<MovieState> _mapMovieEventStateToState(int movieId, String query)async*{
    final service = ApiService();
    yield MovieLoading();
    try {

      List<Movie> movieList;
      if(movieId == 0){
        movieList = await service.getnowPlayingMovie();
      }else{
         movieList = await service.getMoviebyGenre(movieId);
      }
      yield MovieLoaded(movieList);
    } on Exception catch (e) {
      print(e);
      yield MoviesError();
    } 
  }

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if(event is MovieEventStarted){
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

}