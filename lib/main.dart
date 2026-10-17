import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Gesture Lab, STEP 2 (REFINED): the same three gestures, plus two changes
// made after testing. Search for "REFINEMENT" to find them.
//   1. Tap        -> ElevatedButton increases a counter
//   2. Long press -> GestureDetector changes a card's color
//   3. Swipe      -> Dismissible removes a task from a list

void main() {
  runApp(const GestureLabApp());
}

class GestureLabApp extends StatelessWidget {
  const GestureLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const GestureLabPage(),
    );
  }
}

// Stateful, because the counters, the color, and the task list all change.
class GestureLabPage extends StatefulWidget {
  const GestureLabPage({super.key});

  @override
  State<GestureLabPage> createState() => _GestureLabPageState();
}

class _GestureLabPageState extends State<GestureLabPage> {
  int _tapCount = 0;
  int _pressCount = 0;
  int _colorIndex = 0;

  final List<Color> _colors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.indigo,
    Colors.pink,
  ];

  final List<String> _tasks = <String>[
    'Buy groceries',
    'Finish the Flutter lab',
    'Call a friend',
    'Go for a walk',
  ];

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      appBar: AppBar(title: const Text('Gesture Lab')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          // ---------- GESTURE 1: TAP ----------
          Text('1. Tap', style: titleStyle),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _tapCount++;
              });
            },
            child: const Text('Tap me'),
          ),
          const SizedBox(height: 8),
          Text('You tapped the button $_tapCount times.'),
          const SizedBox(height: 24),

          // ---------- GESTURE 2: LONG PRESS ----------
          Text('2. Long press', style: titleStyle),
          const SizedBox(height: 8),
          GestureDetector(
            onLongPress: () {
              // REFINEMENT 2: a small vibration confirms the long press was recognized.
              HapticFeedback.mediumImpact();
              setState(() {
                _pressCount++;
                _colorIndex = (_colorIndex + 1) % _colors.length;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _colors[_colorIndex],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Press and hold me\nLong presses: $_pressCount',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ---------- GESTURE 3: SWIPE ----------
          Text('3. Swipe', style: titleStyle),
          const SizedBox(height: 8),
          const Text(
            'Swipe a task left or right to delete it. You can undo it.',
          ),
          const SizedBox(height: 8),
          for (final String task in _tasks)
            Dismissible(
              key: ValueKey<String>(task),
              onDismissed: (DismissDirection direction) {
                // REFINEMENT 1: remember the position, then offer Undo,
                // so an accidental swipe is easy to recover from.
                final int index = _tasks.indexOf(task);
                setState(() {
                  _tasks.removeAt(index);
                });
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('Deleted "$task"'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          setState(() {
                            _tasks.insert(
                              index.clamp(0, _tasks.length).toInt(),
                              task,
                            );
                          });
                        },
                      ),
                    ),
                  );
              },
              background: Container(
                color: Colors.red.shade200,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: const Icon(Icons.delete),
              ),
              secondaryBackground: Container(
                color: Colors.red.shade200,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete),
              ),
              child: ListTile(title: Text(task)),
            ),
          if (_tasks.isEmpty) const Text('All tasks cleared.'),
        ],
      ),
    );
  }
}
