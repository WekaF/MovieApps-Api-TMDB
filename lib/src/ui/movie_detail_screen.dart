import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttermovie/src/bloc/moviedetail/movie_detail.bloc.dart';
import 'package:fluttermovie/src/bloc/moviedetail/movie_detail_event.dart';
import 'package:fluttermovie/src/bloc/moviedetail/movie_detail_state.dart';
import 'package:fluttermovie/src/model/cast.dart';
import 'package:fluttermovie/src/model/movie.dart';
import 'package:fluttermovie/src/model/movie_detail.dart';
import 'package:fluttermovie/src/model/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailBloc()..add(MovieDetailEventStated(movie.id)),
      child: WillPopScope(
          child: Scaffold(
            body: _buildDetailBody(context),
          ),
          onWillPop: () async => true),
    );
  }
}

Widget _buildDetailBody([BuildContext context]) {
  return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
    if (state is MovieDetailLoading) {
      return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator()
            : CupertinoActivityIndicator(),
      );
    } else if (state is MovieDetailLoaded) {
      MovieDetail detail = state.detail;
      return SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/original/${detail.backdropPath}',
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Platform.isAndroid
                      ? CircularProgressIndicator()
                      : CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/img_not_found.jpg'),
                      ),
                    ),
                  ),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Container(
                  padding: EdgeInsets.only(top: 120),
                  child: GestureDetector(
                    onTap: () async {
                      final youtubeUrl =
                          'https://www.youtube.com/embed/${detail.trailerId}';
                      if (await canLaunch(youtubeUrl)) {
                        await launch(youtubeUrl);
                      }
                    },
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.play_circle,
                            color: Colors.yellow,
                            size: 65,
                          ),
                          Text('Tonton',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              )),
                          Text(
                            detail.originalTitle.toUpperCase(),
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overview'.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 35,
                        child: Text(
                          detail.overview,
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Release date'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                detail.releaseDate,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Colors.yellow, fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'run time'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                detail.runtime,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      color: Colors.yellow,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Budget'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                detail.budget,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Colors.yellow, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Screenshot'.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 155,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => VerticalDivider(
                            color: Colors.transparent,
                            width: 5,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: detail.movieImage.backdrops.length,
                          itemBuilder: (context, index) {
                            Screenshoot image =
                                detail.movieImage.backdrops[index];
                            return Container(
                              child: Card(
                                elevation: 3,
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                      child: Platform.isAndroid
                                          ? CircularProgressIndicator()
                                          : CupertinoActivityIndicator(),
                                    ),
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${image.imagePath}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Cast'.toUpperCase(),
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 110,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) => VerticalDivider(
                            color: Colors.transparent,
                            width: 5,
                          ),
                          itemCount: detail.castlist.length,
                          itemBuilder: (context, index) {
                            Cast cast = detail.castlist[index];
                            return Container(
                              child: Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                        imageBuilder: (context, imageBuilder) {
                                          return Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              image: DecorationImage(
                                                image: imageBuilder,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                        placeholder: (context, url) =>
                                            Container(
                                          width: 80,
                                          height: 80,
                                          child: Platform.isAndroid
                                              ? CircularProgressIndicator()
                                              : CupertinoActivityIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
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
                                        cast.name.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                              fontSize: 8,
                                              color: Colors.black54,
                                            ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Center(
                                      child: Text(
                                        cast.character.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                fontSize: 8,
                                                color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  });
}
