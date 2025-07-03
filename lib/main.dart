import 'package:flutter/material.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MoodMapApp());
}

class MoodMapApp extends StatefulWidget {
  const MoodMapApp({super.key});

  @override
  State<MoodMapApp> createState() => _MoodMapAppState();
}

class _MoodMapAppState extends State<MoodMapApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodMap',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: const MoodSelector(),
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

  void _saveMood() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.moodSaved}: $_selectedMood'),
      ),
    );
    setState(() {
      _selectedMood = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      children: [
        Text(local.selectMood),
        DropdownButton<String>(
          value: _selectedMood,
          hint: Text(local.selectMood),
          onChanged: (String? newValue) {
            setState(() {
              _selectedMood = newValue;
            });
          },
          items: <String>[
            local.happy,
            local.sad,
            local.neutral,
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        ElevatedButton(
          onPressed: _selectedMood == null ? null : _saveMood,
          child: Text(local.saveMood),
        ),
      ],
    );
  }
}

class MoodHistoryPage extends StatefulWidget {
  const MoodHistoryPage({super.key});

  @override
  State<MoodHistoryPage> createState() => _MoodHistoryPageState();
}

class _MoodHistoryPageState extends State<MoodHistoryPage> {
  final List<String> _moodHistory = [];

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.moodHistory),
      ),
      body: _moodHistory.isEmpty
          ? Center(child: Text(local.noMoodHistory))
          : ListView.builder(
              itemCount: _moodHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_moodHistory[index]),
                );
              },
            ),
    );
  }
}
