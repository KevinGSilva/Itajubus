import 'package:flutter/material.dart';
import 'package:itajubus/app_adm/funcionarios/funcionarios.dart';
import 'package:itajubus/app_adm/locais/editar_locais.dart';
import 'package:itajubus/app_adm/locais/cadastra_local.dart';
import 'package:itajubus/app_adm/locais/locais.dart';
import 'package:itajubus/app_adm/rastreadores/cadastra_rastreador.dart';
import 'package:itajubus/app_adm/rastreadores/rastreadores.dart';
import 'package:itajubus/app_adm/rotas/cadastra_rota.dart';
import 'package:itajubus/app_adm/rotas/rotas.dart';
import 'package:itajubus/app_adm/veiculos/cadastra_veiculo.dart';
import 'package:itajubus/app_adm/veiculos/veiculos.dart';
import 'package:itajubus/myapp.dart';

class TelaAdm extends StatefulWidget {
  const TelaAdm({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TelaAdm> createState() => _TelaAdmState();
}

class _TelaAdmState extends State<TelaAdm> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text('Itajubus'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 330,
                    height: 120,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Locais()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/local_icon.png',
                              width: 200,
                              height: 80,
                            ),
                            const Text(
                              'Locais',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 330,
                    height: 120,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Funcionarios()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/funcionarios.png',
                              width: 200,
                              height: 80,
                            ),
                            const Text(
                              'Funcionarios',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 330,
                    height: 120,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Veiculos()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/veiculo.png',
                              width: 200,
                              height: 80,
                            ),
                            const Text(
                              'Veiculos',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 330,
                    height: 120,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Rastreadores()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/rastreador.png',
                              width: 200,
                              height: 80,
                            ),
                            const Text(
                              'Rastreadores',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 330,
                    height: 120,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Rotas()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/trajeto_icon.png',
                              width: 200,
                              height: 80,
                            ),
                            const Text(
                              'Trajetos',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
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
