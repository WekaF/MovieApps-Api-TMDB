import 'package:equatable/equatable.dart';

class Screenshoot extends Equatable {
  final String aspect;
  final String imagePath;
  final int height;
  final int width;
  final String countryCode;
  final double voteAverage;
  final int voteCount;

  Screenshoot(
      {this.aspect,
      this.imagePath,
      this.height,
      this.width,
      this.countryCode,
      this.voteAverage,
      this.voteCount});

  factory Screenshoot.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Screenshoot();
    }

    return Screenshoot(
        aspect: json['aspect_ratio'].toString(), //double.tryParse(json['aspect_ratio'])?.toString() ?? 1.0,
        imagePath: json['file_path'],
        height: json['height'],
        width: json['width'],
        countryCode: json['iso_639_1'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count']);
  }

  @override
  List<Object> get props =>
      [aspect, imagePath, height, width, countryCode, voteAverage, voteCount];
}
