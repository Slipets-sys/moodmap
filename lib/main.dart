import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

void main() {
  runApp(MoodMapApp());
}

class MoodMapApp extends StatefulWidget {
  @override
  _MoodMapAppState createState() => _MoodMapAppState();
}

class _MoodMapAppState extends State<MoodMapApp> {
  Locale _locale = Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: HomePage(setLocale: setLocale),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(Locale) setLocale;

  HomePage({required this.setLocale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoodHistoryPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              if (Localizations.localeOf(context).languageCode == 'en') {
                setLocale(Locale('uk'));
              } else {
                setLocale(Locale('en'));
              }
            },
          ),
        ],
      ),
      body: MoodSelector(),
    );
  }
}

class MoodSelector extends StatefulWidget {
  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  String? _selectedMood;

  Future<void> _saveMood() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    String moodEntry = '${now.toIso8601String()}|$_selectedMood';
    List<String> moodHistory = prefs.getStringList('moodHistory') ?? [];
    moodHistory.add(moodEntry);
    await prefs.setStringList('moodHistory', moodHistory);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${S.of(context).moodSaved}: $_selectedMood')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(S.of(context).selectMood),
        for (var mood in [
          S.of(context).happy,
          S.of(context).sad,
          S.of(context).neutral,
        ])
          RadioListTile<String>(
            title: Text(mood),
            value: mood,
            groupValue: _selectedMood,
            onChanged: (value) {
              setState(() {
                _selectedMood = value;
              });
            },
          ),
        ElevatedButton(
          onPressed: _selectedMood == null ? null : _saveMood,
          child: Text(S.of(context).saveMood),
        ),
      ],
    );
  }
}

class MoodHistoryPage extends StatefulWidget {
  @override
  _MoodHistoryPageState createState() => _MoodHistoryPageState();
}

class _MoodHistoryPageState extends State<MoodHistoryPage> {
  List<String> _moodHistory = [];

  @override
  void initState() {
    super.initState();
    _loadMoodHistory();
  }

  Future<void> _loadMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _moodHistory = prefs.getStringList('moodHistory') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).moodHistory),
      ),
      body: _moodHistory.isEmpty
          ? Center(child: Text(S.of(context).noMoodHistory))
          : ListView.builder(
              itemCount: _moodHistory.length,
              itemBuilder: (context, index) {
                final entry = _moodHistory[index].split('|');
                final date = entry[0];
                final mood = entry[1];
                return ListTile(
                  title: Text(mood),
                  subtitle: Text(date),
                );
              },
            ),
    );
  }
}
