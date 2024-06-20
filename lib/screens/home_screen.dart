import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:openrec/main.dart';
import 'package:openrec/screens/settings_screen.dart';
import 'package:record/record.dart';

final record = Record();
bool isRecording = false;
bool isPaused = false;
bool first = true;
String currentName = "";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    if (recPath == "") {
      Future(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              const Text("Please select a folder to store your recordings in."),
          action: SnackBarAction(
            label: "Settings",
            onPressed: () async {
              Navigator.of(context)
                  .push(
                      MaterialPageRoute(builder: (context) => const Settings()))
                  .then((value) => setState(() {}));
            },
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("OpenRec"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Settings()));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Center(child: getMic()));
  }

  Widget getMic() {
    if (isRecording == false) {
      return Stack(
        children: [
          Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () async {
                  AudioEncoder a = AudioEncoder.AAC;

                  if (encoder == "AAC_HE") {
                    a = AudioEncoder.AAC_HE;
                  } else if (encoder == "AAC_LD") {
                    a = AudioEncoder.AAC_LD;
                  }

                  DateTime now = DateTime.now();

                  currentName =
                      "$recPath/${now.toString().split(".")[0].replaceAll(":", "#")}.mp3";

                  await record.start(path: currentName, encoder: a);

                  setState(() {
                    isRecording = true;
                  });
                },
                icon: const Icon(Icons.mic),
                iconSize: 60.0,
              )),
        ],
      );
    } else {
      return Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () async {
                if (isPaused == false) {
                  isPaused = true;
                  await record.pause();
                } else {
                  isPaused = false;
                  await record.resume();
                }
              },
              icon: isPaused
                  ? const Icon(Icons.play_circle)
                  : const Icon(Icons.pause_circle),
              iconSize: 60.0,
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: FutureBuilder(
                future: getAmp(),
                builder: (BuildContext context, data) {
                  if (data.hasError) {
                    return Center(child: Text("${data.error}"));
                  } else if (data.hasData) {
                    var items = data.data as Amplitude;

                    return Center(child: Text("Amplitude: ${items.current}"));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () async {
                await record.stop();
                setState(() {
                  isRecording = false;
                });
                first = true;
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Succesfully saved!"),
                  action: SnackBarAction(
                      label: "Open",
                      onPressed: () {
                        OpenFilex.open(currentName);
                      }),
                ));
              },
              icon: const Icon(Icons.stop_circle),
              iconSize: 60.0,
            ),
          )
        ],
      );
    }
  }

  Future<Amplitude> getAmp() async {
    Amplitude amp = await record.getAmplitude();
    if (first == true) {
      first = false;
    } else {
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {});
    return amp;
  }
}
