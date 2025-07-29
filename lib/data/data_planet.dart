import 'package:cosmo/models/planet_model.dart';
import 'package:flutter/material.dart';

class PlanetData {
  static List<PlanetModel> getPlanet() {
    //todo
    return [
      // PlanetModel(
      //   name: 'Солнце',
      //   description:
      //       'Звезда в центре нашей Солнечной системы, вокруг которой обращаются все планеты, астероиды, кометы и другие космические тела.',
      //   imageAsset: 'assets/images/sun.png',
      //   distanceFromSun: 'Расстояние до Солнца: ~58 млн км',
      //   color1: const Color.fromARGB(255, 231, 118, 13),
      //   color2: const Color.fromARGB(255, 36, 1, 1),
      // ),
      PlanetModel(
        id: 'mercury',
        name: 'Меркурий',
        description:
            'Самая близкая к Солнцу и самая маленькая планета Солнечной системы. У неё практически нет атмосферы, поэтому поверхность сильно нагревается днём и очень охлаждается ночью.',
        imageAsset: 'assets/images/mercury.png',
        color1: Colors.black,
        color2: Colors.grey,
      ),
      PlanetModel(
        id: 'venus',
        name: 'Венера',
        description:
            'Вторая планета от Солнца и самая горячая в Солнечной системе из-за парникового эффекта плотной CO₂-атмосферы. Нередко её называют «утренней» или «вечерней звездой».',
        imageAsset: 'assets/images/venus.png',
        color1: const Color.fromARGB(255, 73, 51, 16),
        color2: Colors.white,
      ),
      PlanetModel(
        id: 'earth',
        name: 'Земля',
        description:
            'Третья планета от Солнца и единственная известная нам, где есть жизнь. Имеет жидкую воду на поверхности и атмосферу с высоким содержанием кислорода.',
        imageAsset: 'assets/images/earth.png',
        color1: const Color.fromARGB(255, 3, 23, 51),
        color2: Colors.black,
      ),
      PlanetModel(
        id: 'mars',
        name: 'Марс',
        description:
            '«Красная планета» из-за оксида железа на поверхности. Здесь находится самая высокая гора Солнечной системы – вулкан Олимп.',
        imageAsset: 'assets/images/mars.png',
        color1: const Color.fromARGB(255, 67, 36, 8),
        color2: const Color.fromARGB(255, 65, 50, 40),
      ),
      PlanetModel(
        id: 'jupiter',
        name: 'Юпитер',
        description:
            'Крупнейшая планета Солнечной системы, газовый гигант с гигантским штормом «Большое красное пятно», бушующим сотни лет.',
        imageAsset: 'assets/images/jupiter.png',
        color1: const Color.fromARGB(255, 40, 26, 2),
        color2: const Color.fromARGB(255, 126, 159, 175),
      ),
      PlanetModel(
        id: 'saturn',
        name: 'Сатурн',
        description:
            'Газовый гигант, знаменитый своими кольцами из льда и камня. Вторая по размеру планета после Юпитера.',
        imageAsset: 'assets/images/saturn.png',
        color1: const Color.fromARGB(255, 48, 39, 8),
        color2: const Color.fromARGB(255, 123, 116, 96),
      ),
      PlanetModel(
        id: 'uranus',
        name: 'Уран',
        description:
            'Ледяной гигант с осью, отклонённой почти на 98°, из-за чего кажется, что он «катается на боку». Атмосфера богата метаном.',
        imageAsset: 'assets/images/uranus.png',
        color1: const Color.fromARGB(255, 8, 70, 87),
        color2: const Color.fromARGB(255, 167, 174, 178),
      ),
      PlanetModel(
        id: 'neptune',
        name: 'Нептун',
        description:
            'Самая дальняя от Солнца признанная планета. Ледяной гигант с сильными ветрами и ярко-голубым оттенком из-за метана в атмосфере.',
        imageAsset: 'assets/images/neptune.png',
        color1: const Color.fromARGB(255, 3, 20, 43),
        color2: const Color.fromARGB(255, 205, 200, 200),
      ),
    ];
  }
}
