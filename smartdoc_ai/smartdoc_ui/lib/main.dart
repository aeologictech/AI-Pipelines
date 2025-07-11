import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(SmartDocApp());
}

class SmartDocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DocumentSearchScreen(),
    );
  }
}

class DocumentSearchScreen extends StatefulWidget {
  @override
  _DocumentSearchScreenState createState() => _DocumentSearchScreenState();
}

class _DocumentSearchScreenState extends State<DocumentSearchScreen> {
  File? _file;
  String _question = '';
  String _answer = '';
  bool _loading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() => _file = File(result.files.single.path!));
    }
  }

  Future<void> _askQuestion() async {
    if (_file == null || _question.isEmpty) return;

    setState(() {
      _loading = true;
      _answer = '';
    });

    var request = http.MultipartRequest('POST', Uri.parse('http://localhost:8000/ask'));
    request.files.add(await http.MultipartFile.fromPath('file', _file!.path));
    request.fields['question'] = _question;

    var res = await request.send();
    var body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      setState(() {
        _answer = json.decode(body)['answer'];
        _loading = false;
      });
    } else {
      setState(() {
        _answer = 'Error: ${res.statusCode}';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SmartDoc Search AI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Upload PDF'),
          ),
          if (_file != null) Text('Selected: ${_file!.path}'),
          TextField(
            decoration: InputDecoration(labelText: 'Enter your question'),
            onChanged: (val) => _question = val,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _askQuestion,
            child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Ask'),
          ),
          SizedBox(height: 20),
          Text(_answer),
        ]),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(SmartDocApp());
}

class SmartDocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DocumentSearchScreen(),
    );
  }
}

class DocumentSearchScreen extends StatefulWidget {
  @override
  _DocumentSearchScreenState createState() => _DocumentSearchScreenState();
}

class _DocumentSearchScreenState extends State<DocumentSearchScreen> {
  File? _file;
  String _question = '';
  String _answer = '';
  bool _loading = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() => _file = File(result.files.single.path!));
    }
  }

  Future<void> _askQuestion() async {
    if (_file == null || _question.isEmpty) return;

    setState(() {
      _loading = true;
      _answer = '';
    });

    var request = http.MultipartRequest('POST', Uri.parse('http://localhost:8000/ask'));
    request.files.add(await http.MultipartFile.fromPath('file', _file!.path));
    request.fields['question'] = _question;

    var res = await request.send();
    var body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      setState(() {
        _answer = json.decode(body)['answer'];
        _loading = false;
      });
    } else {
      setState(() {
        _answer = 'Error: ${res.statusCode}';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SmartDoc Search AI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Upload PDF'),
          ),
          if (_file != null) Text('Selected: ${_file!.path}'),
          TextField(
            decoration: InputDecoration(labelText: 'Enter your question'),
            onChanged: (val) => _question = val,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _askQuestion,
            child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Ask'),
          ),
          SizedBox(height: 20),
          Text(_answer),
        ]),
      ),
    );
  }
}



