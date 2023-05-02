import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  TextEditingController nota1Controller = TextEditingController();
  TextEditingController nota2Controller = TextEditingController();
  TextEditingController faltasController = TextEditingController();
  TextEditingController cargaHorariaController = TextEditingController();

  String _aprovado = "";
  int _pesoSelecionadoNota1 = 1;
  int _pesoSelecionadoNota2 = 1;
  List<int> pesos = [1, 2, 3, 4];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFields() {
    nota1Controller.text = "";
    nota2Controller.text = "";
    faltasController.text = "";
    cargaHorariaController.text = "";
    _pesoSelecionadoNota1 = 1;
    _pesoSelecionadoNota2 = 1;
    setState(() {
      _aprovado = "";
    });
  }

  void _calcularMedia() {
    setState(() {
      double nota1 = double.parse(nota1Controller.text);
      double nota2 = double.parse(nota2Controller.text);
      double faltas = double.parse(faltasController.text);
      double cargaHoraria = double.parse(cargaHorariaController.text);
      nota1 *= _pesoSelecionadoNota1;
      nota2 *= _pesoSelecionadoNota2;
      double media = (nota1 + nota2) / (_pesoSelecionadoNota1 + _pesoSelecionadoNota2);
      double frequencia = (cargaHoraria - faltas) / cargaHoraria;

      if (media < 6 && frequencia < 0.25) {
        _aprovado = "Reprovado. \nNota: ${media.toStringAsPrecision(3)} \nFrequência: ${(frequencia*100).toStringAsFixed(0)}%";
      } else if (media < 6 && frequencia >= 0.25) {
        _aprovado = "Em recuperação. \nNota: ${media.toStringAsPrecision(3)} \nFrequência: ${(frequencia*100).toStringAsFixed(0)}%";
      } else if (media >= 6 && frequencia < 0.25) {
        _aprovado = "Reprovado. \nNota: ${media.toStringAsPrecision(3)} \nFrequência: ${(frequencia*100).toStringAsFixed(0)}%";
      } else if (media >= 6 && frequencia >= 0.25 && frequencia < 0.75) {
        _aprovado = "Em recuperação. \nNota: ${media.toStringAsPrecision(3)} \nFrequência: ${(frequencia*100).toStringAsFixed(0)}%";
      } else {
        _aprovado = "Aprovado! \nNota: ${media.toStringAsPrecision(3)} \nFrequência: ${(frequencia*100).toStringAsFixed(0)}%";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lançar Notas"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Form (
          key: _formKey,
          child: Column(
          crossAxisAlignment: 
            CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school, size: 120, color: Colors.black),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nota 1",
                labelStyle: TextStyle(color: Colors.black)),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 25),
              controller: nota1Controller,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira a nota 1.";
                } else if (double.tryParse(value) == null) {
                  return "Insira um valor numérico.";
                }
                return null;
              },
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Selecione o peso:",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ...pesos.map((int peso) {
                        return Expanded(
                          child: RadioListTile(
                            title: Text("Peso $peso"),
                            value: peso,
                            groupValue: _pesoSelecionadoNota1,
                            onChanged: (int? value) {
                              setState(() {
                                _pesoSelecionadoNota1 = value!;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nota 2",
                labelStyle: TextStyle(color: Colors.black)),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 25),
              controller: nota2Controller,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira a nota 2.";
                } else if (double.tryParse(value) == null) {
                  return "Insira um valor numérico.";
                }
                return null;
              },
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Selecione o peso da segunda nota:",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ...pesos.map((int peso) {
                        return Expanded(
                          child: RadioListTile(
                            title: Text("Peso $peso"),
                            value: peso,
                            groupValue: _pesoSelecionadoNota2,
                            onChanged: (int? value) {
                              setState(() {
                                _pesoSelecionadoNota2 = value!;
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Número de Faltas",
                labelStyle: TextStyle(color: Colors.black)),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 25),
              controller: faltasController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira o número de faltas.";
                } else if (double.tryParse(value) == null) {
                  return "Insira um valor numérico.";
                }
                return null;
              },
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), 
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Carga horária da disciplina",
                labelStyle: TextStyle(color: Colors.black)),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 25),
              controller: cargaHorariaController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Insira a carga horária da disciplina.";
                } else if (double.tryParse(value) == null) {
                  return "Insira um valor numérico.";
                }
                return null;
              },
            ),),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black), 
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _calcularMedia();
                }
              },
              child: const Text(
                "Calcular",
                style: TextStyle(color: Colors.white, fontSize: 25,),
              ),
            ),
            Text(
              _aprovado,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.green, fontSize: 25),
            ),
          ],
        ),),
      )
      
    );
  }
}