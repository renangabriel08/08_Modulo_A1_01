import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moduloa1/styles/cores.dart';
import 'package:moduloa1/widgets/toast.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int index = 0;
  List questoes = [];
  bool click = false;
  bool loading = true;
  String alternativaSelecionada = '';

  List respostasRel = [[], [], []];

  int score = 0;

  ultima() {
    if (respostasRel.toString() == questoes[index]['resposta'].toString()) {
      score += int.parse(questoes[index]['peso'].toString());
    }

    fim();
  }

  startApp() async {
    String json = await rootBundle.loadString('assets/bancoQuestoes.json');
    Map dados = jsonDecode(json);
    questoes = dados['perguntas'];

    loading = false;
    setState(() {});
  }

  proximo() {
    if (questoes[index]['tipo'] == 'ME') {
      if (!click) {
        click = true;

        if (alternativaSelecionada ==
            questoes[index]['alternativas'][questoes[index]['resposta']]) {
          score += int.parse(questoes[index]['peso'].toString());
        }
      } else {
        index++;
        click = false;
      }
    } else if (questoes[index]['tipo'] == 'VF') {
      if (alternativaSelecionada ==
          questoes[index]['alternativas'][questoes[index]['resposta']]) {
        score += int.parse(questoes[index]['peso'].toString());
      }
      alternativaSelecionada = '';
      index++;
    } else if (questoes[index]['tipo'] == 'REL') {
      if (respostasRel.toString() == questoes[index]['resposta'].toString()) {
        score += int.parse(questoes[index]['peso'].toString());
      }
      respostasRel = [[], [], []];
      index++;
      setState(() {});
    }

    setState(() {});
  }

  fim() {
    MyToast.get(context, 'Score final: $score');

    Navigator.pop(context);
  }

  @override
  void initState() {
    startApp();

    accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (!loading) {
          if (questoes[index]['tipo'] == 'VF') {
            if (event.x < -2) {
              alternativaSelecionada = 'Verdadeiro';
            } else if (event.x > 2) {
              alternativaSelecionada = 'Falso';
            }

            setState(() {});
          }
        }
      },
      onError: (error) {},
      cancelOnError: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (!loading) {
      if (questoes[index]['tipo'] == 'REL') {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Quiz My Brain'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              width: width,
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(questoes[index]['enunciado']),
                    Container(height: 16),
                    if (questoes[index]['tipo'] == 'ME')
                      Column(
                        children: [
                          for (var alternativa
                              in questoes[index]['alternativas'])
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  alternativaSelecionada = alternativa;
                                  setState(() {});
                                },
                                child: Container(
                                  width: width,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color:
                                          (alternativa ==
                                                  questoes[index]['alternativas'][questoes[index]['resposta']] &&
                                              click)
                                          ? Colors.red
                                          : alternativaSelecionada ==
                                                alternativa
                                          ? Cores.azulClaro
                                          : Cores.preto,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      alternativa,
                                      style: TextStyle(
                                        color:
                                            (alternativa ==
                                                    questoes[index]['alternativas'][questoes[index]['resposta']] &&
                                                click)
                                            ? Colors.red
                                            : alternativaSelecionada ==
                                                  alternativa
                                            ? Cores.azulClaro
                                            : Cores.preto,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                    if (questoes[index]['tipo'] == 'VF')
                      Row(
                        children: [
                          for (var alternativa
                              in questoes[index]['alternativas'])
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  alternativaSelecionada = alternativa;
                                  setState(() {});
                                },
                                child: Container(
                                  width: width * .4,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color:
                                          (alternativa ==
                                                  questoes[index]['alternativas'][questoes[index]['resposta']] &&
                                              click)
                                          ? Colors.red
                                          : alternativaSelecionada ==
                                                alternativa
                                          ? Cores.azulClaro
                                          : Cores.preto,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      alternativa,
                                      style: TextStyle(
                                        color:
                                            (alternativa ==
                                                    questoes[index]['alternativas'][questoes[index]['resposta']] &&
                                                click)
                                            ? Colors.red
                                            : alternativaSelecionada ==
                                                  alternativa
                                            ? Cores.azulClaro
                                            : Cores.preto,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                    if (questoes[index]['tipo'] == 'REL')
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (
                                int i = 0;
                                i < questoes[index]['alternativas'][0].length;
                                i++
                              )
                                Draggable(
                                  data: {
                                    'index': i,
                                    'value':
                                        questoes[index]['alternativas'][0][i],
                                  },
                                  feedback: Container(
                                    width: width * .27,
                                    height: height * .15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Cores.preto,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        questoes[index]['alternativas'][0][i],
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    width: width * .27,
                                    height: height * .15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Cores.preto,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        questoes[index]['alternativas'][0][i],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Container(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (
                                int i = 0;
                                i < questoes[index]['alternativas'][1].length;
                                i++
                              )
                                DragTarget(
                                  builder:
                                      (
                                        context,
                                        candidateData,
                                        rejectedData,
                                      ) => Container(
                                        width: width * .27,
                                        height: height * .15,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Cores.preto,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            questoes[index]['alternativas'][1][i],
                                            style: TextStyle(
                                              color:
                                                  questoes[index]['alternativas'][1][i]
                                                      .contains(':')
                                                  ? Cores.azulClaro
                                                  : Cores.preto,
                                            ),
                                          ),
                                        ),
                                      ),
                                  onAccept: (Map data) {
                                    if (!questoes[index]['alternativas'][1][i]
                                        .contains(':')) {
                                      questoes[index]['alternativas'][1][i] +=
                                          ': ${data['value']}';

                                      respostasRel[data['index']].add(
                                        data['index'],
                                      );
                                      respostasRel[data['index']].add(i);
                                    }
                                    setState(() {});
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),

                    Container(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => fim(),
                          child: Text('Encerrar'),
                        ),
                        ElevatedButton(
                          onPressed: () => questoes.length == index + 1
                              ? ultima()
                              : proximo(),
                          child: Text('Próximo'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
