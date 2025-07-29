import 'package:flutter/material.dart';
import 'package:cosmo/data/data_planet.dart';
import 'package:cosmo/presentation/screens/details_screen.dart';
import 'package:cosmo/presentation/widgets/gradient_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageCtrl = PageController(viewportFraction: 0.6);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl.addListener(() {
      final page = _pageCtrl.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planets = PlanetData.getPlanet();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Solar system')),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1) фон звёзд
          Positioned.fill(
            child: Image.asset(
              'assets/images/stars.jpg',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.3),
            ),
          ),

          // 2) фрагмент Солнца
          Positioned(
            top: -size.width * 0.55,
            left: -size.width * 0.25,
            child: Image.asset(
              'assets/images/sun.png',
              width: size.width * 1.5,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 70),

          // 3) карусель планет
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: size.height * 0.6,
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: planets.length,
                itemBuilder: (ctx, i) {
                  final p = planets[i];
                  return PlanetCard(
                    planet: p,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(planet: p),
                          ),
                        ),
                  );
                },
              ),
            ),
          ),

          // 4) индикаторы
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: DotsIndicator(
                count: planets.length,
                currentIndex: _currentPage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Простая карточка для планеты
class PlanetCard extends StatelessWidget {
  final dynamic planet;
  final VoidCallback onTap;

  const PlanetCard({super.key, required this.planet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.none,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: GradientBackground(
          colors1: planet.color1.withOpacity(0.05),
          colors2: planet.color2,
          child: Padding(
            padding: EdgeInsets.only(top: 40, bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Hero(
                  tag: planet.name,
                  child: Image.asset(
                    planet.imageAsset,
                    height: 180,
                    width: 180,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  planet.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Простой индикатор точками
class DotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const DotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white54,
          ),
        );
      }),
    );
  }
}
