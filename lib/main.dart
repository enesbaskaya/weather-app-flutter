import 'dart:convert';

import 'package:flutter/material.dart';
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
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            getCard(data)
          ],
        ),
      ],
    );
  }

  getCard(var data) {
    var secondDay = data[1];
    var thirdDay = data[2];
    var fourthDay = data[3];
    var fifthDay = data[4];
    var sixthDay = data[5];
    var seventhDay = data[6];
    print(sixthDay);
    print(seventhDay);
    return
      Column(
        children: [
          Padding(
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
                          child: Text(
                              secondDay['date'] + ' - ' + secondDay['day']),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              secondDay['icon'],
                              placeholderBuilder: (context) =>
                                  CircularProgressIndicator(),
                              height: 20.0,
                            ),
                            Text(
                              secondDay['description'].toString().capitalize(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(
                                secondDay['degree'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(secondDay['night'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(secondDay['humidity']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
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
                          child: Text(
                              thirdDay['date'] + ' - ' + thirdDay['day']),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              thirdDay['icon'],
                              placeholderBuilder: (context) =>
                                  CircularProgressIndicator(),
                              height: 20.0,
                            ),
                            Text(
                              thirdDay['description'].toString().capitalize(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(
                                thirdDay['degree'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(thirdDay['night'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(thirdDay['humidity']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
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
                          child: Text(
                              fourthDay['date'] + ' - ' + fourthDay['day']),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              secondDay['icon'],
                              placeholderBuilder: (context) =>
                                  CircularProgressIndicator(),
                              height: 20.0,
                            ),
                            Text(
                              fourthDay['description'].toString().capitalize(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(
                                fourthDay['degree'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(fourthDay['night'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(fourthDay['humidity']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
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
                          child: Text(
                              fifthDay['date'] + ' - ' + fifthDay['day']),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              fifthDay['icon'],
                              placeholderBuilder: (context) =>
                                  CircularProgressIndicator(),
                              height: 20.0,
                            ),
                            Text(
                              fifthDay['description'].toString().capitalize(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(
                                fifthDay['degree'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(fifthDay['night'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(fifthDay['humidity']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
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
                          child: Text(
                              sixthDay['date'] + ' - ' + sixthDay['day']),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              sixthDay['icon'],
                              placeholderBuilder: (context) =>
                                  CircularProgressIndicator(),
                              height: 20.0,
                            ),
                            Text(
                              sixthDay['description'].toString().capitalize(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(
                                sixthDay['degree'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(sixthDay['night'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(sixthDay['humidity']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
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
                          child: Text(
                              seventhDay['date'] + ' - ' + seventhDay['day']),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.network(
                              seventhDay['icon'],
                              placeholderBuilder: (context) =>
                                  CircularProgressIndicator(),
                              height: 20.0,
                            ),
                            Text(
                              seventhDay['description'].toString().capitalize(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(
                                seventhDay['degree'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(seventhDay['night'].toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.thermometerHalf,
                              size: 18,
                            ),
                            Text(seventhDay['humidity']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
