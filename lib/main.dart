import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const ColorPaletteApp());
}

class ColorPaletteApp extends StatelessWidget {
  const ColorPaletteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Color Palette Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const PaletteScreen(),
    );
  }
}

class PaletteScreen extends StatefulWidget {
  const PaletteScreen({super.key});

  @override
  State<PaletteScreen> createState() => _PaletteScreenState();
}

class _PaletteScreenState extends State<PaletteScreen> {
  List<Color> colors = [];
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _generateColors();
  }

  void _generateColors() {
    RandomColor randomColor = RandomColor();
    setState(() {
      colors = List.generate(5, (_) => randomColor.randomColor());
    });
    _confettiController.play();
  }

  void _copyColor(Color color) {
    final messenger = ScaffoldMessenger.of(context);
    String hex =
        '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    Clipboard.setData(ClipboardData(text: hex)).then((_) {
      messenger.showSnackBar(
        SnackBar(content: Text('Copied $hex to clipboard!')),
      );

    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[300]!, Colors.purple[300]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Color Palette Generator',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _copyColor(colors[index]),
                        child: Animate(
                          effects: const [
                            FadeEffect(),
                            ScaleEffect(),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '#${colors[index].value
                                    .toRadixString(16)
                                    .padLeft(8, '0').substring(2).toUpperCase()}',
                                style: TextStyle(
                                  color: colors[index].computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _generateColors,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: Colors.pink[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Generate New Palette',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ).animate().shake(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow],
            ),
          ),
        ],
      ),
    );
  }
}