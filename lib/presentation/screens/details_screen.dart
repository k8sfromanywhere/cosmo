import 'dart:async';
import 'dart:convert';
import 'package:cosmo/models/planet_model.dart';
import 'package:cosmo/presentation/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  final PlanetModel planet;

  const DetailsScreen({super.key, required this.planet});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isLoading = true;
  String? _error;

  // Анимация печати текста
  String displayedText = '';
  Timer? _timer;
  int _currentIndex = 0;
  late String _fullText;

  @override
  void initState() {
    super.initState();
    _fullText = widget.planet.description;
    Future.delayed(const Duration(microseconds: 300));
    _loadPlanetInfo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    // Отменяем старый таймер, если есть
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_currentIndex < _fullText.length) {
        setState(() {
          displayedText += _fullText[_currentIndex++];
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _loadPlanetInfo() async {
    const appId = 'a68328c7-c146-4dff-a5da-5cd318450fba';
    const appSecret =
        '2c6397f08a407f1417f3fbb191b29ff1e81b5999a37f3ddc030680c39a3f8308df7c2c2e71e1bc9a56a76b82e9ccf8b82bb52a9c6b0e9439ab53af686aa6cfd944f085e94a59896e7c1497b6480024544ae2461f7fdd4aedc9526f89382c806105d761ca553feb35b12a5cc91a994131';
    final credentials = base64Encode(utf8.encode('$appId:$appSecret'));

    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    final timeStr = DateFormat('HH:mm:ss').format(now);

    final uri = Uri.https(
      'api.astronomyapi.com',
      '/api/v2/bodies/positions/${widget.planet.id}',
      {
        'latitude': '38.775867',
        'longitude': '-84.397330',
        'elevation': '0',
        'from_date': dateStr,
        'to_date': dateStr,
        'time': timeStr,
      },
    );

    try {
      final resp = await http.get(
        uri,
        headers: {
          'Authorization': 'Basic $credentials',
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode != 200) {
        throw Exception('Status ${resp.statusCode}');
      }

      final body = json.decode(resp.body) as Map<String, dynamic>;
      final table =
          (body['data'] as Map<String, dynamic>?)?['table']
              as Map<String, dynamic>?;
      final rows = table?['rows'] as List<dynamic>?;
      if (rows == null || rows.isEmpty) throw Exception('No rows in response');

      final firstCell =
          (rows.first as Map<String, dynamic>)['cells'] as List<dynamic>?;
      if (firstCell == null || firstCell.isEmpty) throw Exception('No cells');

      final cell = firstCell.first as Map<String, dynamic>;

      final kmString = cell['distance']?['fromEarth']?['km'];
      final constellationName =
          cell['position']?['constellation']?['name'] as String?;

      if (!mounted) return;
      setState(() {
        if (kmString != null) {
          final kmVal = double.tryParse(kmString.toString());
          widget.planet.distanceFromEarth =
              kmVal != null ? '${kmVal.toStringAsFixed(2)} км' : '$kmString км';
        }
        widget.planet.constellation = constellationName;
        _isLoading = false;

        // после получения данных дополняем текст и перезапускаем печать
        final extra =
            '\n\nРасстояние до Земли: ${widget.planet.distanceFromEarth}\nСозвездие: ${widget.planet.constellation}';
        _fullText += extra;
        _startTyping();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  //   @override
  //   Widget build(BuildContext context) {
  //     final p = widget.planet;

  //     return Scaffold(
  //       appBar: AppBar(title: Text(p.name)),
  //       body: GradientBackground(
  //         colors1: p.color1,
  //         colors2: p.color2,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
  //           child:
  //               _isLoading && displayedText.isEmpty
  //                   ? const Center(child: CircularProgressIndicator())
  //                   : _error != null
  //                   ? Center(
  //                     child: Text(
  //                       'Ошибка загрузки:\n$_error',
  //                       textAlign: TextAlign.center,
  //                       style: const TextStyle(color: Colors.white),
  //                     ),
  //                   )
  //                   : SingleChildScrollView(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Center(
  //                           child: Hero(
  //                             tag: p.name,
  //                             child: Image.asset(
  //                               p.imageAsset,
  //                               height: 200,
  //                               width: 200,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 20),
  //                         Text(
  //                           p.name,
  //                           style: GoogleFonts.roboto(
  //                             textStyle: const TextStyle(
  //                               fontSize: 24,
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(height: 12),
  //                         Text(
  //                           displayedText,
  //                           style: GoogleFonts.roboto(
  //                             textStyle: const TextStyle(
  //                               fontSize: 16,
  //                               color: Colors.white70,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //         ),
  //       ),
  //     );
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final p = widget.planet;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          p.name,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: GradientBackground(
        colors1: p.color1,
        colors2: p.color2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1) Всегда показываем Hero-изображение
              Center(
                child: Hero(
                  tag: p.name,
                  child: Image.asset(p.imageAsset, height: 300, width: 300),
                ),
              ),
              const SizedBox(height: 20),

              // 3) Блок контента: либо спиннер, либо текст, либо ошибка
              Center(
                child:
                    _isLoading && displayedText.isEmpty
                        ? const CircularProgressIndicator(color: Colors.white)
                        : _error != null
                        ? Text(
                          'Ошибка загрузки:\n$_error',
                          style: const TextStyle(color: Colors.black),
                        )
                        : SingleChildScrollView(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              // textAlign: TextAlign.start,
                              displayedText,
                              style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
