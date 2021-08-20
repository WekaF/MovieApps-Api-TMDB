import 'package:equatable/equatable.dart';
import 'package:fluttermovie/src/model/screenshot.dart';
class MovieImage extends Equatable {
  final List<Screenshoot> backdrops;
  final List<Screenshoot> posters;

  const MovieImage({this.backdrops, this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> result) {
    if (result == null) {
      return MovieImage();
    }

    return MovieImage(
      backdrops: (result['backdrops'] as List)
              ?.map((b) => Screenshoot.fromJson(b))
              ?.toList() ??
          List.empty(),
      posters: (result['posters'] as List)
              ?.map((b) => Screenshoot.fromJson(b))
              ?.toList() ??
          List.empty(),
    );
  }

  @override
  List<Object> get props => [backdrops, posters];
}