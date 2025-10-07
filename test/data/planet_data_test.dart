import 'package:cosmo/data/data_planet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlanetData.getPlanet', () {
    final planets = PlanetData.getPlanet();

    test('returns all predefined planets', () {
      expect(planets.length, 8);
      expect(
        planets.map((p) => p.id),
        containsAll([
          'mercury',
          'venus',
          'earth',
          'mars',
          'jupiter',
          'saturn',
          'uranus',
          'neptune',
        ]),
      );
    });

    test('provides localized names and assets for each planet', () {
      for (final planet in planets) {
        expect(planet.name, isNotEmpty, reason: 'name for ${planet.id}');
        expect(
          planet.description,
          isNotEmpty,
          reason: 'description for ${planet.id}',
        );
        expect(
          planet.imageAsset,
          allOf(startsWith('assets/images/'), endsWith('.png')),
          reason: 'imageAsset for ${planet.id}',
        );
      }
    });
  });
}
