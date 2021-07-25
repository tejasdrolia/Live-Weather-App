import '../services/location.dart';
import '../services/networking.dart';

const String Appkey = '9b17e41dce816eaf2e64de7026a711e0';
const String openweathermap =
    "https://api.openweathermap.org/data/2.5/weather?";

class WeatherModel {
  Future<dynamic> getWeatherdiffcity(String cityname) async {
    NetworkHelper networkobj = NetworkHelper(
        url: Uri.parse(
            "${openweathermap}q=$cityname&appid=$Appkey&units=metric"));
    var weatherdata = await networkobj.getData();

    return weatherdata;
  }

  Future<dynamic> getWeatherinfo() async {
    Location locationobj = Location();
    await locationobj.getCurrentLocation();

    NetworkHelper networkhelperobj = NetworkHelper(
        url: Uri.parse(
            '${openweathermap}lat=${locationobj.latitude}&lon=${locationobj.longitude}&appid=$Appkey&units=metric'));
    var weatherData =
        await networkhelperobj.getData(); // Wait for this to happen first
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(var temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
