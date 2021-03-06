import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:screen_loader/screen_loader.dart';
import 'package:timugo/src/models/place.dart';
import 'package:dio/dio.dart';
import 'package:timugo/src/providers/user.dart';
import 'package:timugo/src/widgets/appbar.dart';

//Widgets
import 'package:timugo/src/widgets/divider_with_text.dart';
import 'package:timugo/src/pages/directions/application/pages/saveaddress_page.dart';

class NewTripLocationView extends StatefulWidget {
  @override
  _NewTripLocationViewState createState() => _NewTripLocationViewState();
}

class _NewTripLocationViewState extends State<NewTripLocationView>
    with ScreenLoader<NewTripLocationView> {
  TextEditingController _searchController = new TextEditingController();
  Timer _throttle;
  String _heading;
  String address;
  List<Place> _placesList;
  final List<Place> _suggestedList = [];

  @override
  void initState() {
    super.initState();
    _heading = "Busquedas";
    _placesList = _suggestedList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_throttle?.isActive ?? false) _throttle.cancel();
    _throttle = Timer(const Duration(milliseconds: 500), () {
      getLocationResults(_searchController.text);
    });
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      setState(() {
        _heading = "Busquedas";
      });
      return;
    }
    String busq = input.replaceAll(new RegExp(r'[^\w\s]+'), '');
    print(busq);
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String apiKey = 'AIzaSyDsPifARDpIqrgAS8TBQtyI7baFlXh3Lu4';
    String request =
        '$baseURL?input=$busq&language=es&location=3.4372201,-76.5224991&radius=500&key=$apiKey';
    Response response = await Dio().get(request);
    final predictions = response.data['predictions'];
    List<Place> _displayResults = [];

    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      double averageBudget = 200.0;
      _displayResults.add(Place(name, averageBudget));
    }

    setState(() {
      _heading = "Resultados";
      _placesList = _displayResults;
    });
  }

  @override
  loader() {
    return SpinKitCircle(
      color: Colors.blue,
    );
  }

  @override
  loadingBgBlur() => 10.0;

  @override
  Widget screen(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        onPressed:(){
         Navigator.of(context).pop();
        }
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Ingresa tu dirección ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                textAlign: TextAlign.left,
              ),
              subtitle: Text('ej: calle 23 # 70-81 barrio .. '),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new DividerWithText(
                dividerText: _heading,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildPlaceCard(context, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaceCard(BuildContext context, int index) {
    return Hero(
      tag: "SelectedTrip-${_placesList[index].name}",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: InkWell(
                child: Row(children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                  child: ListTile(
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_right),
                                  onPressed: () async {
                                    setState(() {
                                      address = _placesList[index].name;
                                    });

                                    await this
                                        .performFuture(_getAddressFromLatLng);
                                  },
                                ),
                                title: Text(
                                  _placesList[index].name,
                                  style: (TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                                ),
                                leading: Icon(Icons.place),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                onTap: () async {
                  setState(() {
                    address = _placesList[index].name;
                  });

                  await this.performFuture(_getAddressFromLatLng);
                }),
          ),
        ),
      ),
    );
  }

  Future _getAddressFromLatLng() async {
    final userInfo = Provider.of<UserInfo>(context);
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      List<Placemark> placemark =
          await geolocator.placemarkFromAddress(address);
      Placemark place = placemark[0];
      setState(() {
        userInfo.loca = place.position;
      });
    } catch (e) {
      print(e);
    }
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FormDirections(
                    address: address,
                    position: userInfo.loca,
                  )),
        );
    return true;
  }
}
