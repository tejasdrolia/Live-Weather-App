import 'package:live_weather_app/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:live_weather_app/utilities/constants.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.weatherdata});
  final weatherdata;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  int conditionid;
  String nameofcity;
  String icon;
  var message;
  int temperature;
  @override
  void initState() {
    // TODO: implement initState
    print(widget
        .weatherdata); // widget keyword is used to access "LocationScreen" data in "LocationScreenState"
    super.initState();
    UpdateUI(widget.weatherdata);
  }

  void UpdateUI(dynamic weatherinfo) {
    setState(() {
      if (weatherinfo == null) // this is done for any failure
      {
        icon = "error";
        message = "unable to get Data";
        temperature = 0;
        nameofcity = "";
        return; // instead of return you can write else on next part
      }
      conditionid = weatherinfo['weather'][0]['id'];
      var temp = weatherinfo['main']['temp'];
      temperature = temp.toInt();

      nameofcity = weatherinfo['name'];

      WeatherModel weatherModel = WeatherModel();
      icon = weatherModel.getWeatherIcon(conditionid);
      message = weatherModel.getMessage(temperature);

      print('temp = $temp');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage('images/location_background.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      WeatherModel weatherdataobj = WeatherModel();
                      var newWeatherinfo =
                          await weatherdataobj.getWeatherinfo();
                      UpdateUI(newWeatherinfo);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                    onPressed: () async {
                      var Typedcityname = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CityScreen()),
                      );
                      print(Typedcityname);
                      if (Typedcityname != null) {
                        // creating new obj
                        var WeatherDataDiffCity =
                            await weather.getWeatherdiffcity(Typedcityname);
                        UpdateUI(WeatherDataDiffCity);
                      }
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$icon️',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$message in $nameofcity!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
