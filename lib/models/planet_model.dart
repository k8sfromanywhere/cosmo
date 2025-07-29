import 'dart:ui';

class PlanetModel {
  final String id;
  final String name;
  final String description;
  final String imageAsset;
  String? distanceFromEarth;
  String? constellation;
  final Color color1;
  final Color color2;

  PlanetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    this.distanceFromEarth,
    this.constellation,
    required this.color1,
    required this.color2,
  });
}
