import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:itajubus/constants.dart';

class TelaMotorista extends StatefulWidget {
  const TelaMotorista({Key? key}) : super(key: key);

  @override
  State<TelaMotorista> createState() => _TelaMotoristaState();
}

class _TelaMotoristaState extends State<TelaMotorista> {
  var status_rastreador;
  var id_rastreador;
  var id_funcionario;
  late int situacao;
  var checking = 'assets/images/load.png';
  var status;
  var textButton = '---';

  Future buscaMotorista() async {
    var uri = '${url}trajeto_copia.php?id=19';
    var response = await http.get(Uri.parse(uri));
    var funcionario = convert.jsonDecode(response.body);

    setState(() {
      id_funcionario = funcionario[0]['id_funcionario'];
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
      } else {
        checking = 'assets/images/X_checking.png';
        textButton = 'Ligar';
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
      });
      print(situacao);
    } else {
      setState(() {
        situacao = 0;
        status = 0;
        checking = 'assets/images/X_checking.png';
        textButton = 'Ligar';
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
      appBar: AppBar(title: Text('Checking')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaMotorista();
  }
}
