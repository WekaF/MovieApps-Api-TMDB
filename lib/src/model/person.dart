class Person {
  final String id;
  final String gender;
  final String name;
  final String profilepath;
  final String knowdepart;
  final String popularity;

  Person(
      {this.id,
      this.gender,
      this.name,
      this.profilepath,
      this.knowdepart,
      this.popularity});

  factory Person.fromJson(dynamic json) {
    if (json == null) {
      return Person();
    }
    return Person(
        id: json['id'].toString(),
        gender: json['gender'].toString(),
        name: json['name'],
        profilepath: json['profile_path'],
        knowdepart: json['know_for_departement'],
        popularity: json['popularity'].toString());
  }
}
