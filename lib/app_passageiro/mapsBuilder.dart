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
  late double lat1 = -22.424031;
  late double lat2 = -22.427900;
  late double lng1 = -45.450108;
  late double lng2 = -45.448231;
  late var local_ini_lat;
  late var local_ini_long;
  late var local_fim_lat;
  late var local_fim_long;

  Future<Trajeto> getTrajeto() async {
    const uri = "${url}trajeto.php?id=25";
    var response = await http.get(Uri.parse(uri));
    Trajeto trajeto = Trajeto.fromJson(jsonDecode(response.body));
    defineMarkers(trajeto);
    return trajeto;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> defineMarkers(Trajeto trajeto) async {
    late Marker markerVeiculo = Marker(
      markerId: new MarkerId('1'),
      infoWindow: InfoWindow(
        title: 'Partida: ${trajeto.localInicio}',
      ),
      position: LatLng(
        double.parse(trajeto.latitude),
        double.parse(trajeto.longitude),
      ),
    );

    late Marker markerLocalInicio = Marker(
        markerId: new MarkerId('2'),
        position: LatLng(double.parse(trajeto.localInicioLat),
            double.parse(trajeto.localInicioLong)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    late Marker markerLocalFim = Marker(
        markerId: new MarkerId('3'),
        position: LatLng(double.parse(trajeto.localFimLat),
            double.parse(trajeto.localFimLong)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));

    setState(() {
      markers.add(markerVeiculo);
      markers.add(markerLocalInicio);
      markers.add(markerLocalFim);
    });
  }

  @override
  void initState() {
    _loadTrajeto = getTrajeto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
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
            return Center(child: Text('error'));
          },
          onLoading: (context) => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
