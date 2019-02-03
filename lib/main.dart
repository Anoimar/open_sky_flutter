import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


final countriesNamedDifferentlyInIcao = {
  "ISLAMIC REPUBLIC OF IRAN":"Iran",
  "SYRIAN ARAB REPUBLIC":"Syria",
  "KINGDOM OF THE NETHERLANDS":"Netherlands",
  "RUSSIAN FEDERATION":"Russia",
  "REPUBLIC OF KOREA":"South_Korea",
  "REPUBLIC OF MOLDOVA":"Moldova",
  "VIET NAM":"Vietnam",
};


void main(){
  runApp(MaterialApp(
    home: HomePage(),
  ));
}


class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  Map data;
  List flightData;


  Future getData() async {
    http.Response response = await http.get("https://opensky-network.org/api/states/all");
    debugPrint(response.body);
    data = json.decode(response.body);
    setState(() {
      flightData = data["states"];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Open SKY"),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
            itemCount: flightData == null ? 0 : flightData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,8.0,0.0),
                            child: Image(
                              height: 48.0,
                              width: 56.0,
                              image: NetworkImage(
                                  createCountryFlagUrl(flightData[index][2])),
                            ),
                          ),
                          textField(flightData[index][2]),
                          textField(flightData[index][1]),
                          textField(flightData[index][0])
                        ]
                    ),
                  )
              );
            })
    );
  }

  Widget textField(flightDataText){
    return Expanded(
      flex: 1,
      child: Text(flightDataText,
        style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700
        ),),
    );
  }

  String createCountryFlagUrl(String countryName) {
    var flagCountryName = countriesNamedDifferentlyInIcao.containsKey(countryName.toUpperCase()) ? countriesNamedDifferentlyInIcao[countryName.toUpperCase()] : countryName ;
    return "http://www.sciencekids.co.nz/images/pictures/flags680/${flagCountryName.replaceAll(" ", "_")}.jpg";
  }

}


