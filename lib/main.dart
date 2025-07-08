import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'l10n/app_localizations.dart';
import 'map_page.dart'; // ✅ ДОДАНО

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
      _moodHistory.addAll(data.map((e) => MoodEntry.fromJson(jsonDecode(e))));
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
        builder: (context) => MoodHistoryPage(moodHistory: _moodHistory),
      ),
    );
  }

  final Map<String, String> _moodEmoji = {
    'Happy': '😊 Happy',
    'Sad': '😢 Sad',
    'Angry': '😠 Angry',
    'Calm': '😌 Calm',
    'Щасливий': '😊 Щасливий',
    'Сумний': '😢 Сумний',
    'Злий': '😠 Злий',
    'Спокійний': '😌 Спокійний',
  };

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
                  child: Text(_moodEmoji[value] ?? value),
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
                final navigator = Navigator.of(context);

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
                    builder: (context) =>
                        MoodHistoryPage(moodHistory: history),
                  ),
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: Text(local.moodHistory),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
              label: Text(local.mapTitle),
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
                    DateFormat('dd.MM.yyyy').format(entry.date);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _moodColors[entry.mood] ?? Colors.grey,
                    child: Text(
                      _moodIcons[entry.mood] ?? '🙂',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  title: Text(entry.mood),
                  subtitle: Text(formattedDate),
                );
              },
            ),
    );
  }

  static const Map<String, Color> _moodColors = {
    'Happy': Colors.yellow,
    'Sad': Colors.blue,
    'Angry': Colors.red,
    'Calm': Colors.green,
    'Щасливий': Colors.yellow,
    'Сумний': Colors.blue,
    'Злий': Colors.red,
    'Спокійний': Colors.green,
  };

  static const Map<String, String> _moodIcons = {
    'Happy': '😊',
    'Sad': '😢',
    'Angry': '😠',
    'Calm': '😌',
    'Щасливий': '😊',
    'Сумний': '😢',
    'Злий': '😠',
    'Спокійний': '😌',
  };
}
