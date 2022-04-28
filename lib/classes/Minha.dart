import 'package:flutter/material.dart';
import 'package:itajubus/views/Tela02.dart';

class Minha extends StatefulWidget {
  const Minha({Key? key}) : super(key: key);

  @override
  State<Minha> createState() => _MinhaState();
}

class _MinhaState extends State<Minha> {
  var idLocal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste carai'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
              ),
              onChanged: (text) {
                setState(() {
                  idLocal = text;
                });
              },
            ),
            RaisedButton(
              onPressed: () {
                print("Tela 1: ${idLocal}");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Tela02(idLocal)));
              },
              child: Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
