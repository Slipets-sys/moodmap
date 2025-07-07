import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const MoodMapApp());
}

class MoodEntry {
  final String mood;
  final DateTime date;

  MoodEntry({required this.mood, required this.date});

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'date': date.toIso8601String(),
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      mood: json['mood'],
      date: DateTime.parse(json['date']),
    );
  }
}

class MoodMapApp extends StatelessWidget {
  const MoodMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodMap',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedMood;
  final List<MoodEntry> _moodHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('moodHistory') ?? [];

    setState(() {
      _moodHistory.clear();
      _moodHistory.addAll(
        data.map((e) => MoodEntry.fromJson(jsonDecode(e))),
      );
    });
  }

  Future<void> _saveMood() async {
  if (_selectedMood == null) return;

  final entry = MoodEntry(mood: _selectedMood!, date: DateTime.now());
  _moodHistory.insert(0, entry);

  final prefs = await SharedPreferences.getInstance();
  final data = _moodHistory.map((e) => jsonEncode(e.toJson())).toList();
  await prefs.setStringList('moodHistory', data);

  if (!mounted) return;

  setState(() {
    _selectedMood = null;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${AppLocalizations.of(context)!.moodSaved}: ${entry.mood}',
      ),
    ),
  );
}

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MoodHistoryPage(moodHistory: _moodHistory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _openHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(local.selectMood,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedMood,
              isExpanded: true,
              hint: Text(local.selectMood),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMood = newValue;
                });
              },
              items: <String>[
                local.happy,
                local.sad,
                local.angry,
                local.calm,
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              onPressed: _selectedMood == null ? null : _saveMood,
              label: Text(local.saveMood),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
onPressed: () async {
  final navigator = Navigator.of(context); // ✅ зберігаємо до await

  final prefs = await SharedPreferences.getInstance();
  final moodData = prefs.getStringList('moodHistory') ?? [];

  final history = moodData.map((entry) {
    final decoded = jsonDecode(entry);
    return MoodEntry(
      mood: decoded['mood'],
      date: DateTime.parse(decoded['date']),
    );
  }).toList();

  navigator.push(
    MaterialPageRoute(
      builder: (context) => MoodHistoryPage(moodHistory: history),
    ),
  );
},

              icon: const Icon(Icons.auto_awesome),
              label: Text(local.moodHistory),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodHistoryPage extends StatelessWidget {
  final List<MoodEntry> moodHistory;

  const MoodHistoryPage({super.key, required this.moodHistory});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(local.moodHistory),
        backgroundColor: Colors.teal,
      ),
      body: moodHistory.isEmpty
          ? Center(
              child: Text(
                local.noMoodHistory,
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: moodHistory.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final entry = moodHistory[index];
                final formattedDate =
                    '${entry.date.day.toString().padLeft(2, '0')}.${entry.date.month.toString().padLeft(2, '0')}.${entry.date.year}';

                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.teal),
                  title: Text(entry.mood),
                  subtitle: Text(formattedDate),
                );
              },
            ),
    );
  }
}
