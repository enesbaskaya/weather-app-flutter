import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

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
    return await results;
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: FutureBuilder(
        future: getWeather(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          else {
            var data = snapshot.data['result'];
            return getBody(data);
          }
        },
      ),
    );
  }

  getBody(var data) {
    var firstDay = data[0];
    /*var secondDay = data[1];
    var thirdDay = data[2];
    var fourthDay = data[3];
    var fifthDay = data[4];
    var sixthDay = data[5];
    var seventhDay = data[6];*/
    DateTime now = DateTime.now();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.transparent.withOpacity(0.6), BlendMode.dstATop),
                image: (now.hour > 19 || now.hour < 5)
                    ? AssetImage("assets/image/gece.jpg")
                    : AssetImage("assets/image/gunduz.jpg")),
          ),
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    firstDay['day'].toString() != null
                        ? firstDay['day'].toString()
                        : '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    firstDay['date'].toString() != null
                        ? firstDay['date'].toString()
                        : '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    firstDay['icon'],
                    placeholderBuilder: (context) =>
                        CircularProgressIndicator(),
                    height: 21.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    firstDay['description'].toString().toUpperCase() != null
                        ? firstDay['description'].toString().toUpperCase()
                        : '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.thermometerHalf,
                    size: 18,
                    color: Colors.red[700],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    firstDay['degree'].toString().split('.')[0] != null
                        ? firstDay['degree'].toString().split('.')[0] + "\u00B0"
                        : "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
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
                    firstDay['degree'].toString().split('.')[0] != null
                        ? firstDay['degree'].toString().split('.')[0] + "\u00B0"
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
                    '' /*firstDay['degree'].toString() != null
                    ? firstDay['degree'].toString() + "\u00B0"
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
