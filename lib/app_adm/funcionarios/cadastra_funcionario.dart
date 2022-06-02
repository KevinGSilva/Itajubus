import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/funcionarios/funcionarios.dart';
import '../../constants.dart';
import 'package:date_time_picker/date_time_picker.dart';

class CadastraFuncionario extends StatefulWidget {
  const CadastraFuncionario({Key? key}) : super(key: key);

  @override
  State<CadastraFuncionario> createState() => _CadastraFuncionarioState();
}

class _CadastraFuncionarioState extends State<CadastraFuncionario> {
  final dropIdTipoFuncionarioValue = ValueNotifier('');
  final dropFuncionarioValue = ValueNotifier('');
  List<dynamic> dropIdTipoFuncionario = [];
  List<dynamic> dropFuncionario = [];
  var id_func;
  String nome_funcionario = '';
  String cpf = '';
  String data_nascimento = '';
  String matricula = '';
  String senha_login = '';
  String id_tipo_funcionario = '';

  Future<void> buscaFuncionario() async {
    var uri = '${url}funcionario.php';
    var response = await http.get(Uri.parse(uri));
    var funcionario = convert.jsonDecode(response.body);

    setState(() {
      dropFuncionario = funcionario;
    });
  }

  void cadastraFuncionarios() async {
    var user = {
      "nome": "${nome_funcionario}",
      "cpf": "${cpf}",
      "data_nascimento": "${data_nascimento}",
      "matricula": "${matricula}",
      "senha_login": "${senha_login}",
      "id_tipo_funcionario": 2
    };
    String data = jsonEncode(user);
    print(data);
    var uri = '${url}funcionario.php';
    if (nome_funcionario == '' ||
        cpf == '' ||
        data_nascimento == '' ||
        matricula == '' ||
        senha_login == '' ||
        id_tipo_funcionario == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Erro!"),
            content: const Text("Todos os campos devem ser preenchidos!"),
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
    if (data_nascimento.length != 10) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Erro!"),
            content: const Text("Insira uma data de nascimento válida!"),
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
    if (cpf.length != 11) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Erro!"),
            content: const Text("Insira um CPF válido!"),
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
    } else {
      var response = await http.post(Uri.parse(uri), body: data);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Sucesso!"),
            content:
                Text("Funcionario '$nome_funcionario'  cadastrado com sucesso"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Funcionarios()));
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
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Funcionarios()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blueAccent,
        title: const Text('Cadastrar funcionários'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      nome_funcionario = text;
                    });
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      labelText: 'Nome', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      cpf = text;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'CPF (sem pontos e traço)',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                DateTimePicker(
                  icon: Icon(Icons.event),
                  initialValue: '',
                  dateMask: 'dd MM yyy',
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  dateLabelText: 'Data de nascimento',
                  onChanged: (val) {
                    setState(() {
                      data_nascimento = val;
                    });
                  },
                  validator: (val) {
                    print('validator ${val}');
                    return null;
                  },
                  onSaved: (val) => print('save ${val}'),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      matricula = text;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Matrícula', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      senha_login = text;
                    });
                  },
                  obscureText: true,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      labelText: 'Senha para login',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    cadastraFuncionarios();
                  },
                  child: Text('Cadastrar'),
                )
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
    buscaFuncionario();
  }
}
