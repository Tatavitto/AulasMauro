import 'package:flutter/material.dart';

void main() {
  runApp(const PetAgeApp());
}

const kCorFundo = Color(0xFF1E164B);
const kCorSelecionada = Color.fromARGB(255, 45, 11, 237);
const kCorBotaoCalcular = Color(0xFF638ED6);
const kAlturaContainerInferior = 80.0;
const kEstiloRotulo = TextStyle(fontSize: 18.0, color: Colors.grey);
const kEstiloNumero = TextStyle(fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.bold);
const kEstiloAnimal = TextStyle(fontSize: 18.0, color: Colors.white);

enum Animal { gato, cachorro }

class PetAgeApp extends StatefulWidget {
  const PetAgeApp({super.key});

  @override
  State<PetAgeApp> createState() => _PetAgeAppState();
}

class _PetAgeAppState extends State<PetAgeApp> {
  Animal? animalSelecionado;
  double peso = 20.0;
  int idade = 5;
  String idadeFisiologica = '--';

  // Mapas com os dados da tabela fornecida
  final Map<int, int> idadeGatos = {
    1: 15, 2: 24, 3: 28, 4: 32, 5: 36, 6: 40, 7: 44, 8: 48,
    9: 52, 10: 56, 11: 60, 12: 64, 13: 68, 14: 72, 15: 76, 16: 80,
    17: 84, 18: 88, 19: 92, 20: 96, 21: 100,
  };

  final Map<int, List<int?>> idadeCachorros = {
    1: [15, 15, 15, 15], 2: [24, 24, 24, 24], 3: [28, 28, 30, 32],
    4: [32, 33, 35, 37], 5: [36, 37, 40, 42], 6: [40, 42, 45, 49],
    7: [44, 47, 50, 56], 8: [48, 51, 55, 64], 9: [52, 56, 61, 71],
    10: [56, 60, 66, 78], 11: [60, 65, 72, 86], 12: [64, 69, 77, 93],
    13: [68, 74, 82, 101], 14: [72, 78, 88, 108], 15: [76, 83, 93, 115],
    16: [80, 87, 99, 123], 17: [84, 92, 104, null], 18: [88, 96, 109, null],
    19: [92, 101, 115, null], 20: [96, 105, 120, null],
  };

  void calcularIdade() {
    if (animalSelecionado == null) return;

    setState(() {
      if (animalSelecionado == Animal.gato) {
        idadeFisiologica = idadeGatos[idade]?.toString() ?? '--';
      } else {
        int categoriaPeso;
        if (peso <= 9.07) {
          categoriaPeso = 0;
        } else if (peso <= 22.7) {
          categoriaPeso = 1;
        } else if (peso <= 40.8) {
          categoriaPeso = 2;
        } else {
          categoriaPeso = 3;
        }

        if (idadeCachorros.containsKey(idade)) {
          final idadeCalculada = idadeCachorros[idade]![categoriaPeso];
          idadeFisiologica = idadeCalculada?.toString() ?? '--';
        } else {
          idadeFisiologica = '--';
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('IDADE PET')),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          animalSelecionado = Animal.gato;
                        });
                      },
                      child: Caixa(
                        cor: animalSelecionado == Animal.gato ? kCorSelecionada : kCorFundo,
                        filho: const ConteudoCaixaAnimal(icone: Icons.pets, texto: 'GATO'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          animalSelecionado = Animal.cachorro;
                        });
                      },
                      child: Caixa(
                        cor: animalSelecionado == Animal.cachorro ? kCorSelecionada : kCorFundo,
                        filho: const ConteudoCaixaAnimal(icone: Icons.pets, texto: 'CACHORRO'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Caixa(
                cor: kCorFundo,
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('PESO (kg)', style: kEstiloRotulo),
                    const SizedBox(height: 10),
                    Text('${peso.toStringAsFixed(1)} kg', style: kEstiloNumero),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbColor: Colors.red,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                        overlayColor: const Color(0x29EB1555),
                      ),
                      child: Slider(
                        min: 1.0,
                        max: 50.0,
                        value: peso,
                        onChanged: animalSelecionado == Animal.cachorro ? (double novoValor) {
                          setState(() {
                            peso = novoValor;
                          });
                        } : null,
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
                    child: Caixa(
                      cor: kCorFundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('IDADE (anos)', style: kEstiloRotulo),
                          const SizedBox(height: 10),
                          Text(idade.toString(), style: kEstiloNumero),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BotaoRedondo(
                                icone: Icons.remove,
                                aoPressionar: () {
                                  setState(() {
                                    if (idade > 1) idade--;
                                  });
                                },
                              ),
                              const SizedBox(width: 15),
                              BotaoRedondo(
                                icone: Icons.add,
                                aoPressionar: () {
                                  setState(() {
                                    if (idade < 21) idade++;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Caixa(
                      cor: kCorFundo,
                      filho: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('IDADE FISIOLÓGICA', style: kEstiloRotulo),
                          const SizedBox(height: 10),
                          Text(idadeFisiologica, style: kEstiloNumero),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: calcularIdade,
              child: Container(
                color: kCorBotaoCalcular,
                width: double.infinity,
                height: kAlturaContainerInferior,
                margin: const EdgeInsets.only(top: 10.0),
                child: const Center(
                  child: Text(
                    'CALCULAR',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({super.key, required this.cor, this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cor,
      ),
      child: filho,
    );
  }
}

class ConteudoCaixaAnimal extends StatelessWidget {
  const ConteudoCaixaAnimal({super.key, required this.icone, required this.texto});
  final IconData icone;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icone, color: Colors.white, size: 80.0),
        const SizedBox(height: 15),
        Text(texto, style: kEstiloAnimal),
      ],
    );
  }
}

class BotaoRedondo extends StatelessWidget {
  const BotaoRedondo({super.key, required this.icone, required this.aoPressionar});
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
      child: Icon(icone, color: Colors.white,),
    );
  }
}