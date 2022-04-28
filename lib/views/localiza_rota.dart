import 'dart:ffi';
import '../constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocalizaRota extends StatefulWidget {
  const LocalizaRota({Key? key}) : super(key: key);

  @override
  State<LocalizaRota> createState() => _LocalizaRotaState();
}

class _LocalizaRotaState extends State<LocalizaRota> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set<Marker>();
  late double latitude = 0;
  late double longitude = 0;
  late double lat = latitude;
  late double lng = longitude;

  final dropValueRota = ValueNotifier('');
  List<dynamic> dropRota = [];

  Future<void> buscaRota() async {
    var uri = '${url}trajeto.php';
    var response = await http.get(Uri.parse(uri));
    var json = convert.jsonDecode(response.body);

    setState(() {
      dropRota = json;
      lat = -22.4160038;
      lng = -45.4477867;
    });
  }

  Future<void> getRota() async {
    var uri = '${url}trajeto.php';
    var response = await http.get(Uri.parse(uri));
    var json = convert.jsonDecode(response.body);

    setState(() {
      latitude = double.parse(json[0]['latitude']);
      longitude = double.parse(json[0]['longitude']);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final Marker marker =
        Marker(markerId: new MarkerId('1'), position: LatLng(lat, lng));
    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 400,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                    target: LatLng(-22.4160038, -45.4477867), zoom: 15),
                markers: markers,
              ),
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
    buscaRota();
    getRota();
  }
}
