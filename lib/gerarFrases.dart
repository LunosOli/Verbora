import 'dart:math';

gerarFrases(int num) {
  num = (num ~/ 3) * 3;
  List<String> Sujeitos = ['Ela ', 'Ele ', 'Você ', 'Maria ', 'João ', 'Pedro ', 'José ', 'Lucas '];
  List<String> Verbos = ['foi ', 'comeu ', 'correu ', 'brincou ', 'dormiu ', 'andou ', 'cantou '];
  List<String> Objetos = ['na casa.', 'no trabalho.', 'na escola.', 'no parque.', 'na praia.', 'no cinema.', 'no restaurante.', 'na biblioteca.', 'no hospital.', 'no supermercado.'];
  List<String> Frases = [];

  for (int i = 0; i < num; i += 3) {
    String sujeito = Sujeitos[Random().nextInt(Sujeitos.length)];
    String verbo = Verbos[Random().nextInt(Verbos.length)];
    String objeto = Objetos[Random().nextInt(Objetos.length)];
    String frase = sujeito + verbo + objeto;
    Frases.add(frase);
  }

  return Frases;
}
