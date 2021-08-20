import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermovie/src/bloc/moviedetail/movie_detail_event.dart';
import 'package:fluttermovie/src/bloc/moviedetail/movie_detail_state.dart';
import 'package:fluttermovie/src/service/api_service.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState>{
  MovieDetailBloc() : super(MovieDetailLoading());


 Stream<MovieDetailState> _mapMovieEventStartedToState(int id) async* {
    final aservice = ApiService();
    yield MovieDetailLoading();
    try {
      final movieDetail = await aservice.getMovieDetail(id);

      yield MovieDetailLoaded(movieDetail);
    } on Exception catch (e) {
      print(e);
      yield MovieDetailError();
    }
  }

  @override
    Stream<MovieDetailState> mapEventToState(MovieDetailEvent event) async* {
    if (event is MovieDetailEventStated) {
      yield* _mapMovieEventStartedToState(event.id);
    }
  }

}