import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      title: 'Hava Durumu',
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  var res;

  Future getWeather() async {
    Map<String, String> headers = {
      'content-type': "application/json",
      'authorization': "apikey 2gPgUiMZaSw2Uykcq73D2R:1cn687kqWA6vXubUnYI73b"
    };
    http.Response response = await http.get(
        'https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=istanbul',
        headers: headers);
    var results = jsonDecode(response.body);
    print(results['result']);
    setState(() {
      res = results['result'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody(res));
  }

  getBody(var res) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Istanbul Hava Durumu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  res[0]['day'].toString() != null
                      ? res[0]['day'].toString()
                      : '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  res[0]['date'].toString() != null
                      ? res[0]['date'].toString()
                      : '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  res[0]['description'].toString().toUpperCase() != null
                      ? res[0]['description'].toString().toUpperCase()
                      : '',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                res[0]['degree'].toString() != null
                    ? res[0]['degree'].toString() + "\u00B0"
                    : "",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text('Gündüz Derece'),
                  trailing: Text(
                    res[0]['degree'].toString() != null
                        ? res[0]['degree'].toString() + "\u00B0"
                        : "",
                  ),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text('Gece Derece'),
                  trailing: Text("12"),
                ),
                ListTile(
                  leading: SvgPicture.network(
                    'https://image.flaticon.com/icons/svg/143/143788.svg',
                    placeholderBuilder: (context) =>
                        CircularProgressIndicator(),
                    height: 24.0,
                  ),
                  title: Text('Hava Durumu'),
                  trailing: Text(
                    '' /*res[0]['degree'].toString() != null
                    ? res[0]['degree'].toString() + "\u00B0"
                    : ""*/
                    ,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
