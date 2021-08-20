import 'package:equatable/equatable.dart';
import 'package:fluttermovie/src/model/person.dart';

abstract class PersonState extends Equatable {
  const PersonState();

  List<Object> get props => [];
}

class PersonLoading extends PersonState {
  List<Person> get personList => null;
}

class PersonLoaded extends PersonState {
  final List<Person> personList;
  const PersonLoaded(this.personList);

  List<Object> get props => [personList];

}

class PersonError extends PersonState {}
