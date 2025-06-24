import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moduloa1/styles/cores.dart';
import 'package:moduloa1/widgets/toast.dart';

class Genius extends StatefulWidget {
  const Genius({super.key});

  @override
  State<Genius> createState() => _GeniusState();
}

class _GeniusState extends State<Genius> {
  List cores = [];

  int score = 0;
  int clicks = 0;
  int nivel = 1;
  int tempo = 0;
  bool habilitado = true;
  bool iniciado = false;
  Timer? timer;
  String linguagem = 'pt';
  final player = AudioPlayer();

  List coresFaladas = [];
  List coresClicadas = [];

  start() {
    iniciado = true;
    setState(() {});

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => setState(() {
        tempo++;
      }),
    );

    falar();
  }

  clickCard(cor) async {
    cor['aceso'] = true;
    clicks++;
    setState(() {});

    await player.play(AssetSource('genius/mouse-click-sound.mp3'));
    coresClicadas.add(cor['index']);
    await Future.delayed(const Duration(seconds: 1));
    cor['aceso'] = false;

    setState(() {});
    if (coresClicadas.length == nivel) {
      if (coresClicadas.toString() == coresFaladas.toString()) {
        score++;
        if (score % 2 == 0) {
          nivel++;
          clicks++;
        }
      } else {
        stop();
      }
    }

    if (clicks == nivel) {
      clicks = 0;
      coresClicadas.clear();
      coresFaladas.clear();
      falar();
    }
  }

  falar() async {
    habilitado = false;
    setState(() {});

    for (int i = 0; i < nivel; i++) {
      int index = Random().nextInt(5);
      coresFaladas.add(index);

      await player.play(AssetSource('genius/$linguagem/$index.mp3'));
      await Future.delayed(const Duration(milliseconds: 500));
    }

    habilitado = true;
    setState(() {});
  }

  stop() {
    MyToast.get(context, 'Fim de jogo! Score: $score');

    score = 0;
    clicks = 0;
    nivel = 1;
    tempo = 0;
    habilitado = true;
    iniciado = false;
    timer?.cancel();
    coresFaladas = [];
    coresClicadas = [];

    setState(() {});
  }

  @override
  void initState() {
    if (window.locale.languageCode == 'es') {
      linguagem = 'es';
    } else if (window.locale.languageCode == 'en') {
      linguagem = 'en';
    } else {
      linguagem = 'pt';
    }

    cores = List.generate(
      5,
      (index) => {
        'cor': index == 0
            ? Colors.green
            : index == 1
            ? Colors.blue
            : index == 2
            ? Colors.yellow
            : index == 3
            ? Colors.orange
            : Colors.red,
        'index': index,
        'aceso': false,
      },
    );

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Genius Play'),
      ),
      body: Container(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nível: $nivel'),
                  Text(
                    '${(tempo ~/ 60).toString().padLeft(2, '0')}:${(tempo % 60).toString().padLeft(2, '0')}',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score: $score'),
                  ElevatedButton(onPressed: () => (), child: Text('Restart')),
                ],
              ),
              DropdownButtonFormField(
                value: linguagem,
                items: [
                  DropdownMenuItem(value: 'pt', child: Text('Português')),
                  DropdownMenuItem(value: 'en', child: Text('Inglês')),
                  DropdownMenuItem(value: 'es', child: Text('Espanhol')),
                ],
                onChanged: (value) {
                  linguagem = value.toString();
                },
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (var cor in cores)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => clickCard(cor),
                        child: Container(
                          width: 120,
                          height: 120,
                          color: !habilitado ? Colors.grey : cor['cor'],
                          child: Center(
                            child: cor['aceso']
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Cores.branco,
                                          blurRadius: 20,
                                          spreadRadius: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: () => iniciado ? stop() : start(),
                child: Text(iniciado ? 'STOP' : 'START'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
