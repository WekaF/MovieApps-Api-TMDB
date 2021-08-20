import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermovie/src/bloc/personbloc/person.bloc_state.dart';
import 'package:fluttermovie/src/bloc/personbloc/person_bloc_event.dart';
import 'package:fluttermovie/src/model/person.dart';
import 'package:fluttermovie/src/service/api_service.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(PersonLoading());

  Stream<PersonState> _mapMovieEventStateToState() async* {
    final service = ApiService();
    yield PersonLoading();
    try {
      List<Person> personList = await service.getPersonList();
      yield PersonLoaded(personList); 
    } on Exception catch (e) {
      print(e);
      yield PersonError();
    }
  }

  @override
  Stream<PersonState> mapEventToState(PersonEvent event) async* {
    if (event is PersonEventStarted) {
      yield* _mapMovieEventStateToState();
    }
  }
}
