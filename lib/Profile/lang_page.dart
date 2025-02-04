import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  final List<Map<String, dynamic>>? initialLanguages;
  const LanguagePage({Key? key, this.initialLanguages}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _oralLevelController = TextEditingController();
  final TextEditingController _writtenLevelController = TextEditingController();

  List<Map<String, dynamic>> _languages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialLanguages != null) {
      _languages.addAll(widget.initialLanguages!);
    }
  }

  void _addLanguage(String language, int oralLevel, int writtenLevel) {
    setState(() {
      _languages.add({
        'language': language,
        'oralLevel': oralLevel,
        'writtenLevel': writtenLevel,
      });
    });
  }

  void _removeLanguage(int index) {
    setState(() {
      _languages.removeAt(index);
    });
  }

  void _saveChanges() {
    Navigator.pop(context, _languages);
  }

  Future<void> _showAddLanguageDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _languageController,
                decoration: InputDecoration(labelText: 'Language'),
              ),
              DropdownButtonFormField<int>(
                value: 10,
                items: List.generate(11, (index) => index).map((level) {
                  return DropdownMenuItem<int>(
                    value: level,
                    child: Text('Level $level'),
                  );
                }).toList(),
                onChanged: (value) {
                  _oralLevelController.text = value.toString();
                },
                decoration: InputDecoration(labelText: 'Oral Level'),
              ),
              DropdownButtonFormField<int>(
                value: 10,
                items: List.generate(11, (index) => index).map((level) {
                  return DropdownMenuItem<int>(
                    value: level,
                    child: Text('Level $level'),
                  );
                }).toList(),
                onChanged: (value) {
                  _writtenLevelController.text = value.toString();
                },
                decoration: InputDecoration(labelText: 'Written Level'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addLanguage(
                  _languageController.text,
                  int.parse(_oralLevelController.text),
                  int.parse(_writtenLevelController.text),
                );
                _languageController.clear();
                _oralLevelController.clear();
                _writtenLevelController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddLanguageDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  final language = _languages[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Text(language['language'][0].toUpperCase()),
                      ),
                      title: Text(language['language']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Oral: Level ${language['oralLevel']}'),
                          Text('Written: Level ${language['writtenLevel']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeLanguage(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _languages.isEmpty ? null : _saveChanges, 
              child: Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }
}