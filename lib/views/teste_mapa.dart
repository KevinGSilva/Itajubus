import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../constants.dart';

class TesteMapa extends StatefulWidget {
  const TesteMapa({Key? key}) : super(key: key);

  @override
  State<TesteMapa> createState() => _TesteMapaState();
}

class _TesteMapaState extends State<TesteMapa> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set<Marker>();
  late double lat = 0;
  late double lng = 0;
  bool loading = false;

  final dropValueRota = ValueNotifier('');
  List<dynamic> dropRota = [];

  late Builder mapa;
  late Builder mapa1;

  Future buscaRota() async {
    var uri = '${url}trajeto.php';
    var response = await http.get(Uri.parse(uri));
    var json = convert.jsonDecode(response.body);

    setState(() {
      dropRota = json;
      lat = double.parse(json[0]['latitude']);
      lng = double.parse(json[0]['longitude']);
      loading = true;
    });

    /* late Marker marker =
        Marker(markerId: new MarkerId('1'), position: LatLng(lat, lng));
    setState(() {
      markers.add(marker);
    });

    return mapa = Builder(builder: (context) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 400,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                CameraPosition(target: LatLng(lat, lng), zoom: 15),
            markers: markers,
          ),
        ),
      );
    }); */
  }

  Future<Widget> googleMap() async {
    Marker marker =
        Marker(markerId: new MarkerId('1'), position: LatLng(lat, lng));
    setState(() {
      markers.add(marker);
    });

    return mapa = Builder(builder: (context) {
      return SingleChildScrollView(
        child: SizedBox(
          height: 400,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition:
                CameraPosition(target: LatLng(lat, lng), zoom: 15),
            markers: markers,
          ),
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    while (mapa == null) {}
    return Scaffold(
      appBar: AppBar(title: const Text('Rastrear')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: ValueListenableBuilder(
                  valueListenable: dropValueRota,
                  builder: (BuildContext context, String value, _) {
                    return SizedBox(
                      width: 300,
                      child: DropdownButtonFormField(
                        menuMaxHeight: 300,
                        isExpanded: true,
                        icon: const Icon(Icons.alt_route),
                        hint: const Text('Selecione...'),
                        decoration: InputDecoration(
                            label: const Text('Rota'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6))),
                        value: (value.isEmpty) ? null : value,
                        onChanged: (escolha) {
                          setState(() {
                            dropValueRota.value = escolha.toString();
                            //local_partida = dropValuePartida.value;
                          });
                        },
                        items: dropRota
                            .map((op) => DropdownMenuItem(
                                  value: op['id'].toString(),
                                  child: Text(op['rota']),
                                ))
                            .toList(),
                      ),
                    );
                  }),
            ),
            Center(child: Text('${lat} + ${lng}')),
            const SizedBox(
              height: 15,
            ),
            mapa,
            ElevatedButton(
                onPressed: () => {buscaRota()}, child: const Text('Atualizar'))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleMap();
  }
}
