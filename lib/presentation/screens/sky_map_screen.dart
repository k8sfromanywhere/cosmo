import 'package:flutter/material.dart';
import 'package:cosmo/services/astronomy_api_service.dart';

/// Модель одной звезды
class Star {
  final String id;
  final String name;
  final double ra; // градусы
  final double dec; // градусы

  Star({
    required this.id,
    required this.name,
    required this.ra,
    required this.dec,
  });
}

/// Экран отображения созвездий
class ConstellationScreen extends StatefulWidget {
  final AstronomyApiService apiService;
  final double latitude;
  final double longitude;

  const ConstellationScreen({
    super.key,
    required this.apiService,
    required this.latitude,
    required this.longitude,
  });

  @override
  _ConstellationScreenState createState() => _ConstellationScreenState();
}

class _ConstellationScreenState extends State<ConstellationScreen> {
  List<Star> _stars = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStars();
  }

  Future<void> _loadStars() async {
    final now = DateTime.now();
    final date =
        "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";

    try {
      final raw = await widget.apiService.fetchAllPositions(
        latitude: widget.latitude,
        longitude: widget.longitude,
        fromDate: date,
        toDate: date,
        time:
            "${now.hour.toString().padLeft(2, '0')}:"
            "${now.minute.toString().padLeft(2, '0')}:"
            "${now.second.toString().padLeft(2, '0')}",
      );

      final rows =
          (raw['data']['table']['rows'] as List).cast<Map<String, dynamic>>();
      final stars =
          rows.map((row) {
            final entry = row['entry'] as Map<String, dynamic>;
            final cell = (row['cells'] as List).first as Map<String, dynamic>;
            final eq = cell['position']['equatorial'] as Map<String, dynamic>;

            return Star(
              id: entry['id'],
              name: entry['name'],
              ra: (eq['rightAscension']['hours'] as num) * 15.0, // 1h = 15°
              dec: (eq['declination']['degrees'] as num).toDouble(),
            );
          }).toList();

      setState(() {
        _stars = stars;
        _loading = false;
      });
    } catch (e) {
      // обработка ошибок
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка загрузки: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Созвездия рядом')),
      body:
          _loading
              ? Center(child: CircularProgressIndicator())
              : _buildSkyView(context),
    );
  }

  Widget _buildSkyView(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final points = _stars.map((s) => _project(s, size)).toList();
    final connections =
        <List<int>>[]; // TODO: тут можно подгрузить реальные контуры

    return InteractiveViewer(
      boundaryMargin: EdgeInsets.all(100),
      minScale: 0.5,
      maxScale: 5.0,
      child: GestureDetector(
        onTapUp: (d) => _onTap(d.localPosition, points),
        child: CustomPaint(
          size: size,
          painter: ConstellationPainter(points, connections),
        ),
      ),
    );
  }

  Offset _project(Star s, Size size) {
    // эквиректангулярная проекция (очень упрощённая)
    final x = (s.ra / 360.0) * size.width;
    final y = ((90 - s.dec) / 180.0) * size.height;
    return Offset(x, y);
  }

  void _onTap(Offset pos, List<Offset> pts) {
    const thresh = 10.0;
    for (var i = 0; i < pts.length; i++) {
      if ((pts[i] - pos).distance < thresh) {
        final star = _stars[i];
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text(star.name),
                content: Text(
                  'RA: ${star.ra.toStringAsFixed(2)}°\n'
                  'Dec: ${star.dec.toStringAsFixed(2)}°',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Закрыть'),
                  ),
                ],
              ),
        );
        break;
      }
    }
  }
}

/// Рисует точки и соединительные линии
class ConstellationPainter extends CustomPainter {
  final List<Offset> starPoints;
  final List<List<int>> connections;

  ConstellationPainter(this.starPoints, this.connections);

  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..style = PaintingStyle.fill;
    final linePaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // линии
    for (var link in connections) {
      canvas.drawLine(starPoints[link[0]], starPoints[link[1]], linePaint);
    }

    // точки
    for (var p in starPoints) {
      canvas.drawCircle(p, 3.0, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ConstellationPainter old) => false;
}
