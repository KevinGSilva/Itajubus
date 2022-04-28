import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:itajubus/models/trajeto_model.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/constants.dart';

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

  Future<Trajeto> getTrajeto() async {
    const uri = "${url}trajeto.php?id=1";
    var response = await http.get(Uri.parse(uri));
    Trajeto trajeto = Trajeto.fromJson(jsonDecode(response.body));
    defineMarkers(trajeto);
    return trajeto;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> defineMarkers(Trajeto trajeto) async {
    late Marker marker = Marker(
        markerId: new MarkerId('1'),
        position: LatLng(
            double.parse(trajeto.latitude), double.parse(trajeto.longitude)));
    setState(() {
      markers.add(marker);
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
      appBar: AppBar(),
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
                  zoom: 15),
              markers: markers,
            );
          },
          onError: (context, error) {
            return Center(child: Text(error.message));
          },
          onLoading: (context) => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
