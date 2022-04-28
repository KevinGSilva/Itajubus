import 'package:flutter/material.dart';

// Importar bibliotecas
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TesteCoordenada extends StatefulWidget {
  @override
  _TesteCoordenadaState createState() => _TesteCoordenadaState();
}

class _TesteCoordenadaState extends State<TesteCoordenada> {
  // Lista de pontos adicionados ao clicar na tela <LatLng>
  List<LatLng> tappedPoints = [];

// funcao que atualiza o estado do mapa e salva a coordenada na lista tappedPoints.
  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      print(latlng);
      tappedPoints.add(latlng);
    });
  }

  @override
  Widget build(BuildContext context) {
    var markers = tappedPoints.map((latlng) {
      return Marker(
        // dimensao dos marcadores
        width: 80.0,
        height: 80.0,
        // coordenadas do marcadores.
        point: latlng,
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Mostrar uma SnackBar quando clicar em um marcador
            Scaffold.of(ctx).showSnackBar(SnackBar(
                content: Text("Latitude =" +
                    latlng.latitude.toString() +
                    " :: Longitude = " +
                    latlng.longitude.toString())));
          },
          child: Container(
            child: Icon(
              // Icone do marcador
              Icons.pin_drop,
              color: Colors.red,
            ),
          ),
        ),
      );
    }).toList();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter - Mapa"),
        ),
        body: FlutterMap(
          options: MapOptions(
            // Coordenada central do mapa.
            center: LatLng(-15.799862, -47.864195),
            // Quantidade de zoom do mapa.
            zoom: 17,
            onTap: _handleTap,
          ),
          layers: [
            // Url do mapa.
            TileLayerOptions(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayerOptions(markers: markers),
          ],
        ),
      ),
    );
  }
}
