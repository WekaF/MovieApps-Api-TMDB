import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermovie/src/bloc/moviebloc/movie_bloc.dart';
import 'package:fluttermovie/src/bloc/moviebloc/movie_bloc_event.dart';
import 'package:fluttermovie/src/bloc/moviebloc/movie_bloc_state.dart';
import 'package:fluttermovie/src/bloc/personbloc/person.bloc_state.dart';
import 'package:fluttermovie/src/bloc/personbloc/person_bloc.dart';
import 'package:fluttermovie/src/bloc/personbloc/person_bloc_event.dart';
import 'package:fluttermovie/src/component/home_appbar.dart';
import 'package:fluttermovie/src/model/movie.dart';
import 'package:fluttermovie/src/model/person.dart';
import 'package:fluttermovie/src/ui/category_screen.dart';
import 'package:fluttermovie/src/ui/movie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(MovieEventStarted(0, '')),
        ),
        BlocProvider<PersonBloc>(
            create: (_) => PersonBloc()..add(PersonEventStarted())),
      ],
      child: Scaffold(
        appBar: HomeAppbar(),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraint.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return Center(
                        child: Platform.isAndroid
                            ? CircularProgressIndicator()
                            : CupertinoActivityIndicator(),
                      );
                    } else if (state is MovieLoaded) {
                      List<Movie> movies = state.movieList;
                      print(movies.length);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CarouselSlider.builder(
                            itemCount: movies.length,
                            itemBuilder: (BuildContext context, int index) {
                              Movie movie = movies[index];
                              print(movie.backdropPath);
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> MovieDetailScreen(movie: movie,)),);
                                },
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: <Widget>[
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        placeholder: (context, url) =>
                                            Platform.isAndroid
                                                ? CircularProgressIndicator()
                                                : CupertinoActivityIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets\images\img_not_found.jpg'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 15, left: 15),
                                      child: Text(
                                        movie.title.toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            options: CarouselOptions(
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(microseconds: 500),
                              pauseAutoPlayOnTouch: true,
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                BuildWidgetCategory(),
                                Text(
                                  'trending person of the week'.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    BlocBuilder<PersonBloc, PersonState>(
                                        builder: (context, state) {
                                      if (state is PersonLoading) {
                                        return Center();
                                      } else if (state is PersonLoaded) {
                                        List<Person> personList =
                                            state.personList;
                                        return Container(
                                          height: 110,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            separatorBuilder:
                                                (context, index) =>
                                                    VerticalDivider(
                                              color: Colors.transparent,
                                              width: 5,
                                            ),
                                            itemCount: personList.length,
                                            itemBuilder: (context, index) {
                                              Person person = personList[index];
                                              return Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                      ),
                                                      elevation: 3,
                                                      child: ClipRRect(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              'https://image.tmdb.org/t/p/w200${person.profilepath}',
                                                          imageBuilder: (context,
                                                              imageProvider) {
                                                            return Container(
                                                              height: 80,
                                                              width: 80,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                image: DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            );
                                                          },
                                                          placeholder:
                                                              (context, url) =>
                                                                  Container(
                                                            width: 80,
                                                            height: 80,
                                                            child: Center(
                                                              child: Platform
                                                                      .isAndroid
                                                                  ? CircularProgressIndicator()
                                                                  : CupertinoActivityIndicator(),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                            width: 80,
                                                            height: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/img_not_found.jpg'),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Center(
                                                        child: Text(
                                                          person.name,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        child: Text('Something wrong!'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
