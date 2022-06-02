import 'dart:convert';
import 'dart:convert' as convert;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/funcionarios/funcionarios.dart';
import 'package:itajubus/widgets/customFutureBuilder.dart';
import '/../constants.dart';

class EditarFuncionario extends StatefulWidget {
  int id;

  EditarFuncionario(this.id);

  @override
  State<EditarFuncionario> createState() => _EditarFuncionarioState();
}

class _EditarFuncionarioState extends State<EditarFuncionario> {
  var _getFunc;
  String nome_funcionario = '';
  String cpf = '';
  String data_nascimento = '';
  String matricula = '';
  String senha_login = '';
  var nome_init;
  var cpf_init;
  var data_nascimento_init;
  var matricula_init;
  var senha_init;
  var resposta_delete;

  Future getFuncionario() async {
    var uri = "${url}funcionario.php?id=${widget.id}";
    var response = await http.get(Uri.parse(uri));
    print(response.body);
    var json = convert.jsonDecode(response.body);

    setState(() {
      nome_init = json[0]['nome'];
      cpf_init = json[0]['cpf'];
      data_nascimento_init = json[0]['data_nascimento'];
      matricula_init = json[0]['matricula'];
      senha_init = json[0]['senha_login'];
    });

    return json;
  }

  void EditarFuncionario() async {
    if (nome_funcionario == '' || nome_funcionario == null) {
      setState(() {
        nome_funcionario = nome_init;
      });
    }
    if (cpf == '' || cpf == null) {
      setState(() {
        cpf = cpf_init;
      });
    }
    if (data_nascimento == '' || data_nascimento == null) {
      setState(() {
        data_nascimento = data_nascimento_init;
      });
    }

    if (matricula == '' || matricula == null) {
      setState(() {
        matricula = matricula_init;
      });
    }

    if (senha_login == '' || senha_login == null) {
      setState(() {
        senha_login = senha_init;
      });
    }

    var user = {
      "id": widget.id,
      "nome": "${nome_funcionario}",
      "cpf": "${cpf}",
      "data_nascimento": "${data_nascimento}",
      "matricula": "${matricula}",
      "senha_login": "${senha_login}"
    };
    String data = jsonEncode(user);
    print(data);
    var uri = '${url}funcionario.php?id=${widget.id}';
    print(uri);
    /*  */
    var response = await http.put(Uri.parse(uri), body: data);
    print(response.body);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text("Sucesso!"),
          content:
              Text("Funcionario '${nome_funcionario}' atualizado com sucesso"),
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

  Future<void> deletaFuncionario() async {
    var uri = "${url}funcionario.php?id=${widget.id}";
    var response = await http.delete(Uri.parse(uri));
    print(response.body);
    resposta_delete = response.body;
    print(widget.id);

    if (resposta_delete == null || resposta_delete == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("ALERTA!"),
              content: Text(
                  "Certifique-se de que o funcionario não estejá escalado para nenhuma rota antes de excluí-lo"),
              actions: [
                FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("Ok"))
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext contexte) {
            return AlertDialog(
              title: Text("Deletado!"),
              content: Text("Funcionário '${nome_init}' deletado com sucesso!"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Funcionarios()));
                    },
                    child: Text("ok"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Editar Funcionario'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Excluir?"),
                      content: Text("Excluir funcionario '${nome_init}'?"),
                      actions: <Widget>[
                        // define os botões na base do dialogo
                        FlatButton(
                          child: const Text("Sim"),
                          onPressed: () {
                            deletaFuncionario();
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: const Text("Cancelar"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          )
        ],
      ),
      body: CustomFutureBuilder(
        future: _getFunc,
        onEmpty: (context) {
          return Center(child: Text('Não há dados disponiveis'));
        },
        onComplete: (context, funcionarios) {
          return SingleChildScrollView(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: nome_init,
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
                    TextFormField(
                      initialValue: cpf_init,
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
                      initialValue: data_nascimento_init,
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
                    TextFormField(
                      initialValue: matricula_init,
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
                    TextFormField(
                      initialValue: senha_init,
                      onChanged: (text) {
                        setState(() {
                          senha_login = text;
                        });
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Senha: (Modifique para alterar a senha)',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () => {EditarFuncionario()},
                      child: Text('Salvar'),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        onError: (context, error) {
          return Center(child: Text((error).toString()));
        },
        onLoading: (context) => Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFunc = getFuncionario();
  }
}

/*
  
*/