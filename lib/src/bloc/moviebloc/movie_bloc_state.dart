import 'package:equatable/equatable.dart';
import 'package:fluttermovie/src/model/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  List<Object> get props => [];
}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movieList;
  const MovieLoaded(this.movieList);

  List<Object> get props => [movieList];

}

class MoviesError extends MovieState {}
