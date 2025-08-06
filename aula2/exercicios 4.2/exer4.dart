import 'aluno.dart';

void main() {
  Aluno aluno = Aluno("Fulano de Tal", "123456");

  aluno.lancaNota(6.3);
  aluno.lancaNota(5.2);
  aluno.lancaNota(9.4);

  print(aluno);
}
