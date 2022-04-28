import 'package:flutter/material.dart';
import 'dart:async';

class TesteTimer extends StatefulWidget {
  const TesteTimer({Key? key}) : super(key: key);

  @override
  State<TesteTimer> createState() => _TesteTimerState();
}

class _TesteTimerState extends State<TesteTimer> {
  String teste = '';
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 950), (timer) {
      teste = "Testando ${DateTime.now().second}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teste')),
      body: Center(
        child: Column(
          children: [
            Text(
              teste,
              style: TextStyle(fontSize: 30),
            ),
            FlatButton(
                onPressed: (() {
                  _timer.cancel();
                }),
                child: Text('Stop'))
          ],
        ),
      ),
    );
  }
}
