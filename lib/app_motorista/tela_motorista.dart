import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_motorista/funcionario_login.dart';
import 'dart:convert' as convert;
import 'package:itajubus/constants.dart';

class TelaMotorista extends StatefulWidget {
  int id;

  TelaMotorista(this.id);

  @override
  State<TelaMotorista> createState() => _TelaMotoristaState();
}

class _TelaMotoristaState extends State<TelaMotorista> {
  var status_rastreador;
  var id_rastreador;
  var id_funcionario;
  late int situacao;
  var txt_situacao = '---';
  var checking = 'assets/images/load.png';
  var status;
  var textButton = 'buscando...';

  Future buscaMotorista() async {
    var uri = '${url}trajeto_copia.php?id=${widget.id}';
    var response = await http.get(Uri.parse(uri));
    var resposta = response.body;
    print(resposta);

    if (resposta == '' || resposta == null) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Ops!"),
            content: Text("Você não está escalado para nenhum trajeto"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FuncionarioLogin()));
                },
              ),
            ],
          );
        },
      );
    }

    var funcionario = convert.jsonDecode(response.body);

    setState(() {
      id_funcionario = funcionario[0]['id'];
      id_rastreador = funcionario[0]['id_rastreador'];
    });
    print('$id_rastreador func $id_funcionario');

    var uri2 = '${url}rastreador_copia.php?id=$id_rastreador';
    var response1 = await http.get(Uri.parse(uri2));
    var json = convert.jsonDecode(response1.body);

    setState(() {
      status = int.parse(status = json[0]['situacao']);
      if (status == 1) {
        checking = 'assets/images/V_checking.png';
        textButton = 'Desligar';
        txt_situacao = 'LIGADO';
      } else {
        checking = 'assets/images/X_checking.png';
        textButton = 'Ligar';
        txt_situacao = 'DESLIGADO';
      }
    });
    print(status);
  }

  Future updateRastreador() async {
    print(status);
    if (status == 0) {
      setState(() {
        situacao = 1;
        status = 1;
        checking = 'assets/images/V_checking.png';
        textButton = 'Desligar';
        txt_situacao = 'LIGADO';
      });
      print(situacao);
    } else {
      setState(() {
        situacao = 0;
        status = 0;
        checking = 'assets/images/X_checking.png';
        textButton = 'Ligar';
        txt_situacao = 'DESLIGADO';
      });
      print(situacao);
    }

    var rastreador = {"id": id_rastreador, "situacao": situacao};
    String data = convert.jsonEncode(rastreador);
    var uri = '${url}rastreador.php';
    print(rastreador);
    var response = await http.put(Uri.parse(uri), body: data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ativar Rastreador')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "O rastreador desta rota está ${txt_situacao}.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Para iniciar a viagem, o rastreador deve estar LIGADO.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Quando chegar ao destino, deixe-o DESLIGADO!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 100,
                ),
                Image.asset(
                  '$checking',
                  width: 150,
                  height: 150,
                ),
                ElevatedButton(
                  onPressed: () {
                    updateRastreador();
                  },
                  child: Text(textButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaMotorista();
  }
}
