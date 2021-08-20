import 'package:equatable/equatable.dart';
import 'package:fluttermovie/src/model/movie_detail.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  List<Object> get props => [];
}

class MovieDetailLoading extends MovieDetailState{}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail detail;
  const MovieDetailLoaded(this.detail);

  List<Object> get props => [detail];

}

class MovieDetailError extends MovieDetailState {}
