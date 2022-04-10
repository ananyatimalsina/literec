import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:literec/main.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: ListView(children: [
        ListTile(
          title: Text("Recording Path: " + recPath),
          subtitle: const Text("Click to change"),
          isThreeLine: true,
          onTap: () async {
            String? selectedDirectory =
                await FilePicker.platform.getDirectoryPath();

            if (selectedDirectory != null) {
              prefs.setString("recPath", selectedDirectory);
              recPath = selectedDirectory;
            }
          },
        ),
        const Divider(),
        Center(
          child: DropdownButton<String>(
            value: encoder,
            onChanged: (String? newValue) {
              setState(() {
                prefs.setString(newValue!, "encoder");
                encoder = newValue;
              });
            },
            items: <String>[
              "AAC",
              "AAC_HE",
              "AAC_LD",
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        )
      ]),
    );
  }
}
