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

  List filteredData;

  var _searchView = new TextEditingController();

  bool _firstSearch = true;

  String _querry = "";


  _HomePageState(){
    _searchView.addListener((){
      if (_searchView.text.isEmpty){
        setState(() {
          _firstSearch = false;
          _querry = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _querry = _searchView.text.toLowerCase();
        });
      }
    });
  }

  Future getData() async {
    http.Response response = await http.get("https://opensky-network.org/api/states/all");
    debugPrint(response.body);
    data = json.decode(response.body);
    setState(() {
      flightData = data["states"];
      filteredData = flightData;
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
        body: new Container(
          margin: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0  ),
          child: new Column(
            children: <Widget>[
              _createSearchView(),
              _firstSearch ? _createListView(): _performSearch()
            ],
          ),
        )
    );
  }


  
  Widget _createListView(){
    return Flexible(child:ListView.builder(
        itemCount: filteredData == null ? 0 : filteredData.length,
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
                              createCountryFlagUrl(filteredData[index][2])),
                        ),
                      ),
                      textField(filteredData[index][2]),
                      textField(filteredData[index][1]),
                      textField(filteredData[index][0])
                    ]
                ),
              )
          );
        })
    );
}

  Widget _performSearch(){
    print("Filtering");
    List toFilter = new List.from(flightData);
    toFilter.removeWhere((item) => !item[2].toString().toLowerCase().contains(_querry));
    filteredData = toFilter;
    return _createListView();
  }

  Widget _createSearchView() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: _searchView,
        decoration: InputDecoration(
          hintText: "Write country name",
          hintStyle: new TextStyle(color: Colors.grey)
        ),
        textAlign: TextAlign.center,
      ),
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



