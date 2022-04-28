import 'package:flutter/material.dart';
import 'package:itajubus/app_adm/funcionarios.dart';
import 'package:itajubus/app_motorista/tela_motorista.dart';
import 'package:itajubus/app_adm/cadastra_funcionario.dart';
import 'package:itajubus/app_adm/cadastra_local.dart';
import 'package:itajubus/app_adm/cadastra_rastreador.dart';
import 'package:itajubus/app_adm/cadastra_rota.dart';
import 'package:itajubus/app_adm/cadastra_veiculo.dart';
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
            Navigator.pushReplacement(
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
                    width: 170,
                    height: 170,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CadastraLocal()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/local_icon.png',
                              width: 200,
                              height: 100,
                            ),
                            const Text(
                              'Cadastrar Locais',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CadastraRota()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/trajeto_icon.png',
                              width: 200,
                              height: 100,
                            ),
                            const Text(
                              'Cadastrar Trajeto',
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
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
                              height: 100,
                            ),
                            const Text(
                              'Funcionários',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TelaMotorista()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/find_icon.png',
                              width: 200,
                              height: 100,
                            ),
                            const Text(
                              'Localizar',
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CadastraVeiculo()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/veiculo.png',
                              width: 200,
                              height: 100,
                            ),
                            const Text(
                              'Cadastrar Veículos',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Card(
                      color: Colors.white38,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CadastraRastreador()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/rastreador.png',
                              width: 200,
                              height: 100,
                            ),
                            const Text(
                              'Cadastrar rastreador',
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
