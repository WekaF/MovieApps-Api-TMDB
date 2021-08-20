import 'package:equatable/equatable.dart';
import 'package:fluttermovie/src/model/genre.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  List<Object> get props => [];
}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genreList;
  const GenreLoaded(this.genreList);

  List<Object> get props => [genreList];

}

class GenreError extends GenreState {}
