import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:itajubus/app_motorista/list_trajetos.dart';
import '../constants.dart';

class FuncionarioLogin extends StatefulWidget {
  const FuncionarioLogin({Key? key}) : super(key: key);

  @override
  State<FuncionarioLogin> createState() => _FuncionarioLoginState();
}

class _FuncionarioLoginState extends State<FuncionarioLogin> {
  late var id_func;
  late var cpf_get_func;
  late var get_senha;
  late var verificaSenha;
  late var verificaCpf;
  var resposta;

  Future admLogin() async {
    var uri = '${url}funcionario_login.php?cpf=${cpf_get_func}';
    var response = await http.get(Uri.parse(uri));
    var json = convert.jsonDecode(response.body);
    print(json);

    if (json == null) {
      setState(() {
        resposta = null;
        verificaSenha = false;
      });
      validaLogin();
    } else {
      setState(() {
        resposta = json;
        verificaSenha = json[0]['senha_login'];
        id_func = json[0]['id'];
      });
      validaLogin();
    }
  }

  Future validaLogin() async {
    if (verificaSenha == get_senha) {
      var uri = '${url}trajeto_copia.php?id_funcionario=${id_func}';
      var response = await http.get(Uri.parse(uri));
      var listaTrajeto = convert.jsonDecode(response.body);

      if (listaTrajeto == null || listaTrajeto == '') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Aviso!"),
                content: Text("Você não está escalado para nenhum trajeto"),
                actions: <Widget>[
                  // define os botões na base do dialogo
                  FlatButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } else {
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ListTrajetos(int.parse(id_func))));
        });
      }
    } else if (resposta == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Ops!"),
            content: Text("CPF não encontrado"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (verificaSenha == false || verificaSenha != get_senha) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Ops!"),
            content: Text("CPF ou Senha inválidos!"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login motorista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(label: Text("CPF")),
              onChanged: ((value) {
                setState(() {
                  cpf_get_func = value;
                });
              }),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                label: Text("Senha"),
              ),
              onChanged: (value) {
                setState(() {
                  get_senha = value;
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  admLogin();
                },
                child: Text('Entrar')),
          ]),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
