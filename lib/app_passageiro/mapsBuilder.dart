import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:itajubus/models/trajeto_model.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/constants.dart';
import 'package:itajubus/views/my_home_page.dart';

import '../widgets/customFutureBuilder.dart';

class mapsBuilder extends StatefulWidget {
  const mapsBuilder({Key? key}) : super(key: key);

  @override
  _mapsBuilderState createState() => _mapsBuilderState();
}

class _mapsBuilderState extends State<mapsBuilder> {
  late GoogleMapController mapController;
  late Future<Trajeto> _loadTrajeto;
  Set<Marker> markers = Set<Marker>();
  late BitmapDescriptor pinLocationIcon;

  var dropTrajeto = [];
  final dropValueTrajeto = ValueNotifier('');

  late var local_ini_lat;
  late var local_ini_long;
  late var local_fim_lat;
  late var local_fim_long;

  late var rota;

  Future<Trajeto> getTrajeto() async {
    const uri = "${url}trajeto.php?id=25";
    var response = await http.get(Uri.parse(uri));
    Trajeto trajeto = Trajeto.fromJson(jsonDecode(response.body));
    defineMarkers(trajeto);
    return trajeto;
  }

  Future<void> getTrajetos() async {
    const uri = "${url}trajeto_copia.php";
    var response = await http.get(Uri.parse(uri));
    var json = jsonDecode(response.body);

    setState(() {
      dropTrajeto = json;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> defineMarkers(Trajeto trajeto) async {
    late Marker markerVeiculo = Marker(
      markerId: MarkerId('1'),
      infoWindow: const InfoWindow(
        title: 'Veículo',
      ),
      position: LatLng(
        double.parse(trajeto.latitude),
        double.parse(trajeto.longitude),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    late Marker markerLocalInicio = Marker(
        markerId: MarkerId('2'),
        position: LatLng(double.parse(trajeto.localInicioLat),
            double.parse(trajeto.localInicioLong)),
        infoWindow: InfoWindow(title: 'Partida: ${trajeto.localInicio}'));

    late Marker markerLocalFim = Marker(
        markerId: MarkerId('3'),
        position: LatLng(double.parse(trajeto.localFimLat),
            double.parse(trajeto.localFimLong)),
        infoWindow: InfoWindow(title: 'Chegada: ${trajeto.localFim}'));

    setState(() {
      markers.add(markerVeiculo);
      markers.add(markerLocalInicio);
      markers.add(markerLocalFim);
    });
  }

  @override
  void initState() {
    getTrajetos();
    _loadTrajeto = getTrajeto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trajetos'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ValueListenableBuilder(
                    valueListenable: dropValueTrajeto,
                    builder: (BuildContext context, String value, _) {
                      return SizedBox(
                        width: 300,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 300,
                          isExpanded: true,
                          icon: const Icon(Icons.local_library_outlined),
                          hint: const Text('Selecione o trajeto'),
                          decoration: InputDecoration(
                              label: const Text('Trajetos'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          value: (value.isEmpty) ? null : value,
                          onChanged: (escolha) {
                            setState(() {
                              dropValueTrajeto.value = escolha.toString();
                            });
                          },
                          items: dropTrajeto
                              .map((op) => DropdownMenuItem(
                                    value: op['id'].toString(),
                                    child: Text(op['rota']),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
              ),
            ),
            Center(
              child: SizedBox(
                width: 350,
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  child: CustomFutureBuilder<Trajeto>(
                    future: _loadTrajeto,
                    onEmpty: (context) {
                      return Center(child: Text('Não há dados disponiveis'));
                    },
                    onComplete: (context, trajeto) {
                      return GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(double.parse(trajeto.latitude),
                                double.parse(trajeto.longitude)),
                            zoom: 14),
                        markers: markers,
                      );
                    },
                    onError: (context, error) {
                      return Center(
                          child: Text(
                              'Algo deu errado. Tente novamente mais tarde...'));
                    },
                    onLoading: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
