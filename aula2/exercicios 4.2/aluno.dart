class Aluno {
  String nome;
  String matricula;
  List<double> notas = [];

  Aluno(this.nome, this.matricula);

  void lancaNota(double nota) {
    notas.add(nota);
  }

  @override
  String toString() {
    return 'Aluno: $nome, Matrícula: $matricula, Notas: $notas';
  }
}
