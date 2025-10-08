import 'package:flutter/material.dart';
import 'dart:math';

const kCorAtivaCartao = Color(0xFF1E164B);
const kCorInativaCartao = Color(0xFF111328);
const kCorContainerInferior = Color(0xFF638ED6);
const kAlturaContainerInferior = 80.0;

const kEstiloRotulo = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

const kEstiloNumero = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

const kEstiloBotaoGrande = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kEstiloTituloResultado = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kEstiloResultado = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kEstiloIMC = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
);

const kEstiloCorpo = TextStyle(
  fontSize: 22.0,
);


void main() {
  runApp(const CalculadoraIMC());
}

class CalculadoraIMC extends StatelessWidget {
  const CalculadoraIMC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF0A0E21),
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const PaginaPrincipal(),
    );
  }
}

enum Genero {
  masculino,
  feminino,
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  _PaginaPrincipalState createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  Genero? generoSelecionado;
  int altura = 180;
  int peso = 65;
  int idade = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CALCULADORA IMC')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () {
                      setState(() {
                        generoSelecionado = Genero.masculino;
                      });
                    },
                    cor: generoSelecionado == Genero.masculino
                        ? kCorAtivaCartao
                        : kCorInativaCartao,
                    filhoCartao: const ConteudoIcone(
                      icone: Icons.male,
                      rotulo: 'MASCULINO',
                    ),
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    aoPressionar: () {
                      setState(() {
                        generoSelecionado = Genero.feminino;
                      });
                    },
                    cor: generoSelecionado == Genero.feminino
                        ? kCorAtivaCartao
                        : kCorInativaCartao,
                    filhoCartao: const ConteudoIcone(
                      icone: Icons.female,
                      rotulo: 'FEMININO',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CartaoPadrao(
              cor: kCorAtivaCartao,
              filhoCartao: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ALTURA', style: kEstiloRotulo),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(altura.toString(), style: kEstiloNumero),
                      const Text('cm', style: kEstiloRotulo),
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: const Color(0xFF8D8E98),
                      thumbColor: const Color(0xFFEB1555),
                      overlayColor: const Color(0x29EB1555),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 30.0),
                    ),
                    child: Slider(
                      value: altura.toDouble(),
                      min: 120.0,
                      max: 220.0,
                      onChanged: (double novoValor) {
                        setState(() {
                          altura = novoValor.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CartaoPadrao(
                    cor: kCorAtivaCartao,
                    filhoCartao: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('PESO', style: kEstiloRotulo),
                        Text(peso.toString(), style: kEstiloNumero),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BotaoArredondado(
                              icone: Icons.remove,
                              aoPressionar: () {
                                setState(() {
                                  peso--;
                                });
                              },
                            ),
                            const SizedBox(width: 10.0),
                            BotaoArredondado(
                              icone: Icons.add,
                              aoPressionar: () {
                                setState(() {
                                  peso++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: CartaoPadrao(
                    cor: kCorAtivaCartao,
                    filhoCartao: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('IDADE', style: kEstiloRotulo),
                        Text(idade.toString(), style: kEstiloNumero),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BotaoArredondado(
                              icone: Icons.remove,
                              aoPressionar: () {
                                setState(() {
                                  idade--;
                                });
                              },
                            ),
                            const SizedBox(width: 10.0),
                            BotaoArredondado(
                              icone: Icons.add,
                              aoPressionar: () {
                                setState(() {
                                  idade++;
                                });
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BotaoInferior(
            textoBotao: 'CALCULAR',
            aoTocar: () {
              Calculadora calc = Calculadora(altura: altura, peso: peso);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaginaResultados(
                    resultadoIMC: calc.calcularIMC(),
                    resultadoTexto: calc.obterResultado(),
                    interpretacao: calc.obterInterpretacao(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BotaoInferior extends StatelessWidget {
  const BotaoInferior({super.key, required this.aoTocar, required this.textoBotao});

  final VoidCallback aoTocar;
  final String textoBotao;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoTocar,
      child: Container(
        color: kCorContainerInferior,
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: kAlturaContainerInferior,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Center(
          child: Text(textoBotao, style: kEstiloBotaoGrande),
        ),
      ),
    );
  }
}

class BotaoArredondado extends StatelessWidget {
  const BotaoArredondado({super.key, required this.icone, required this.aoPressionar});
  final IconData icone;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6.0,
      onPressed: aoPressionar,
      constraints: const BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
      child: Icon(icone),
    );
  }
}

class CartaoPadrao extends StatelessWidget {
  const CartaoPadrao({super.key, required this.cor, this.filhoCartao, this.aoPressionar});

  final Color cor;
  final Widget? filhoCartao;
  final VoidCallback? aoPressionar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: aoPressionar,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: filhoCartao,
      ),
    );
  }
}

class ConteudoIcone extends StatelessWidget {
  const ConteudoIcone({super.key, required this.icone, required this.rotulo});
  final IconData icone;
  final String rotulo;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icone,
          size: 80.0,
        ),
        const SizedBox(height: 15.0),
        Text(rotulo, style: kEstiloRotulo),
      ],
    );
  }
}

class Calculadora {
  Calculadora({required this.altura, required this.peso});

  final int altura;
  final int peso;

  late double _imc;

  String calcularIMC() {
    _imc = peso / pow(altura / 100, 2);
    return _imc.toStringAsFixed(1);
  }

  String obterResultado() {
    if (_imc >= 25) {
      return 'Acima do peso';
    } else if (_imc > 18.5) {
      return 'Normal';
    } else {
      return 'Abaixo do peso';
    }
  }

  String obterInterpretacao() {
    if (_imc >= 25) {
      return 'Você está com o peso acima do normal. Tente se exercitar mais.';
    } else if (_imc > 18.5) {
      return 'Excelente! Seu peso está normal.';
    } else {
      return 'Você está com o peso abaixo do normal. Tente se alimentar um pouco mais.';
    }
  }
}

class PaginaResultados extends StatelessWidget {
  const PaginaResultados(
      {super.key, required this.resultadoIMC,
      required this.resultadoTexto,
      required this.interpretacao});

  final String resultadoIMC;
  final String resultadoTexto;
  final String interpretacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CALCULADORA IMC'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Seu Resultado',
                style: kEstiloTituloResultado,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: CartaoPadrao(
              cor: kCorAtivaCartao,
              filhoCartao: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    resultadoTexto.toUpperCase(),
                    style: kEstiloResultado,
                  ),
                  Text(
                    resultadoIMC,
                    style: kEstiloIMC,
                  ),
                  Text(
                    interpretacao,
                    textAlign: TextAlign.center,
                    style: kEstiloCorpo,
                  ),
                ],
              ),
            ),
          ),
          BotaoInferior(
            textoBotao: 'RE-CALCULAR',
            aoTocar: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
