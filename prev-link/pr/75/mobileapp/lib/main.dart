import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:mobileapp/domain/model/Binding.dart';
import 'package:mobileapp/enum/selectedType.dart';
import 'package:mobileapp/screens/homepage/choose_place.dart';
import 'package:mobileapp/screens/homepage/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Até onde chega a cultura',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SelectedType _selectedType = SelectedType.BIBLIOTECAS;
  List<Marker> _markers = [];
  int _selectedIndex = 0;
  bool _isLoadingMarkers = false;

  @override
  void initState() {
    _loadSelectedType();
    super.initState();
  }

  Marker _createMarker(Binding binding) {
    List<double> point = binding.geo.value
        .split(' ')
        .map((point) => double.parse(point))
        .toList();
    LatLng lng = LatLng(point[1], point[0]);

    return Marker(
        point: lng,
        builder: (ctx) => Container(
              child: Icon(_selectedType.iconData),
            ));
  }

  _cleanMarkers() {
    if (_markers.length > 0) {
      setState(() {
        _markers = [];
      });
    }
  }

  _loadSelectedType() async {
    _cleanMarkers();
    setState(() {
      _isLoadingMarkers = true;
    });

    List<Binding> bindings = await _selectedType.getBindings;

    setState(() {
      _markers = bindings.map(_createMarker).toList();
      _isLoadingMarkers = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Até onde chega a cultura'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(39.526015, -8.123343),
              zoom: 7.0,
            ),
            layers: [
              TileLayerOptions(
                  tileProvider:
                      NetworkTileProvider(), // Needed for the map to render in Linux
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: _markers,
              ),
            ],
          ),
          ChoosePlace(
            onPlaceChange: _onPlaceChange,
            selectedIndex: _selectedIndex,
          ),
          if (_isLoadingMarkers)
            Loading(
              name: _selectedType.name,
            )
        ],
      ),
    );
  }

  void _onPlaceChange(SelectedType selectedType, int selectedIndex) {
    setState(() {
      _selectedType = selectedType;
      _selectedIndex = selectedIndex;
    });
    _loadSelectedType();
  }
}
