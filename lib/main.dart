import 'gerarFrases.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Verbora',
      theme: ThemeData(
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

enum Direction {up, down, left, right}

class _TelaInicialState extends State<TelaInicial> {
  @override
  List<int> LocalSnake = [48, 68, 88];
  int LocalComida = Random().nextInt(700);
  bool iniciar = false;
  Direction direction = Direction.down;
  List<int> mapa = List.generate(760, (index) => index);
  bool timerLigado = false;
  Timer timer =Timer(Duration.zero, () {});

  IniciarJogo() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }

    iniciar = true;
    LocalSnake = [48, 68, 88];

    timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      AtualizarSnake();
      if (Morte()) {
        MorteTela();
        timer.cancel();
      }
    });
  }

  AtualizarSnake() {
    setState(() {
      switch (direction) {
        case Direction.down:
          if (LocalSnake.last > 740) {
            LocalSnake.add(LocalSnake.last - 760 + 20);
          } else {
            LocalSnake.add(LocalSnake.last + 20);
          }
          break;

        case Direction.up:
          if (LocalSnake.last < 20) {
            LocalSnake.add(LocalSnake.last + 760 - 20);
          } else {
            LocalSnake.add(LocalSnake.last - 20);
          }
          break;

        case Direction.right:
          if (((LocalSnake.last + 1) % 20) == 0) {
            LocalSnake.add(LocalSnake.last + 1 - 20);
          } else {
            LocalSnake.add(LocalSnake.last + 1);
          }
          break;
        
        case Direction.left:
          if ((LocalSnake.last % 20) == 0) {
            LocalSnake.add(LocalSnake.last - 1 + 20);
          } else {
            LocalSnake.add(LocalSnake.last - 1);
          }
          break;
        
        default:
      }
      if (LocalSnake.last == LocalComida) {
        mapa.removeWhere((element) => LocalSnake.contains(element));
        LocalComida = mapa[Random().nextInt(mapa.length - 1)];
      } else {
        LocalSnake.removeAt(0);
      }
    });
  }

  bool Morte() {
    final ListaSnake = List.from(LocalSnake);
    if (LocalSnake.length > ListaSnake.toSet().length) {
      return true;
    } else {
      return false;
    }
  }

  MorteTela() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Você morreu.'),
        content: Text('Suas frases geradas foram: \n${gerarFrases(LocalSnake.length - 3).join('\n')}'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Tentar Novamente')),
          TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Sair'))
        ],
      );
    },
  ).then((value) {
    if (value == true) {
      IniciarJogo();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (detalhes) {
            if (direction != Direction.up && detalhes.delta.dy > 0) {
              direction = Direction.down;
            }
            if (direction != Direction.down && detalhes.delta.dy < 0) {
              direction = Direction.up;
            }
          },
          onHorizontalDragUpdate: (detalhes) {
            if (direction != Direction.left && detalhes.delta.dx > 0) {
              direction = Direction.right;
            }
            if (direction != Direction.right && detalhes.delta.dx < 0) {
              direction = Direction.left;
            }
          },
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 760,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20),
            itemBuilder: (context, index) {
              if (LocalSnake.contains(index)) {
                return Container(
                  color: Color(0xFFBB80B3),
                );
              }
              if (index == LocalComida) {
                return Container(
                  color: Color(0xFFFFCA3A),
                );
              }
              return Container(
                color: Colors.white,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          IniciarJogo();
        },
      ),
    );
  }
}
