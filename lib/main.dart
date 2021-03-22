import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:weather_app/extension/extension.dart';
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
                    color: Color(0xffdb562e),
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
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Haftanın Diğer Günleri',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Color(0xff7a7472)),
                ),
              ),
              Expanded(child: getCard(data))
            ],
          ),
        ),
      ],
    );
  }

  getCard(var data) {
    List days = data;
    return ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, position) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              daysCard(days[position]),
              SizedBox(
                height: 18,
              ),
            ],
          );
        });
  }

  daysCard(day) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 2,
              offset: Offset(
                0,
                0,
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Center(
                    child: Text(day['date'] + ' - ' + day['day']),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.network(
                        day['icon'],
                        placeholderBuilder: (context) =>
                            CircularProgressIndicator(),
                        height: 20.0,
                      ),
                      Text(
                        day['description'].toString().capitalize(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.weatherSunny,
                        color: Colors.amber,
                      ),
                      Text(day['degree'].toString().split('.')[0]),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.weatherNight,
                        color: Color(0xFF0D253F),
                        size: 20,
                      ),
                      Text(day['night'].toString().split('.')[0]),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.waterPercent,
                        color: Colors.blue,
                      ),
                      Text(day['humidity']),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
