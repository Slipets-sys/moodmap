import 'package:flutter/material.dart';

void main() {
  runApp(const MoodMapApp());
}

class MoodMapApp extends StatelessWidget {
  const MoodMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: MoodSelector(),
        ),
      ),
    );
  }
}

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? _selectedMood;

  final List<Map<String, String>> _moods = [
    {'emoji': '😃', 'label': 'Весело'},
    {'emoji': '😢', 'label': 'Сумно'},
    {'emoji': '😐', 'label': 'Нейтрально'},
    {'emoji': '😠', 'label': 'Злість'},
    {'emoji': '😌', 'label': 'Спокійно'},
    {'emoji': '😫', 'label': 'Втома'},
  ];

  void _saveMood() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Настрій збережено: $_selectedMood')),
    );
    setState(() {
      _selectedMood = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'MoodMap',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Як ти себе почуваєш?',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _moods.map((mood) {
              final isSelected = _selectedMood == mood['label'];
              return ChoiceChip(
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      mood['emoji']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(mood['label']!),
                  ],
                ),
                selected: isSelected,
                selectedColor: Colors.blue.shade100,
                onSelected: (_) {
                  setState(() {
                    _selectedMood = mood['label'];
                  });
                },
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedMood == null ? null : _saveMood,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Зберегти'),
            ),
          ),
        ],
      ),
    );
  }
}
