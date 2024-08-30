import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/features/feature1/domain/weather_animation.dart';
import '../domain/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = "";
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCityName();
  }

  void _loadCityName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCityName = prefs.getString('cityName');
    if (savedCityName != null && savedCityName.isNotEmpty) {
      setState(() {
        cityName = savedCityName;
        _textController.text = savedCityName;
      });
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeather(savedCityName);
    }
  }

  void _saveCityName(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cityName', cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Wetter",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textController,
              onChanged: (value) {
                cityName = value;
              },
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  _saveCityName(value);
                  Provider.of<WeatherProvider>(context, listen: false)
                      .fetchWeather(value);
                }
              },
              decoration: InputDecoration(
                hintText: "Ort eingeben",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textController.clear(); // Löscht den Text im Textfeld
                    setState(() {
                      cityName = ""; // Setzt die cityName-Variable zurück
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const SizedBox.expand(
            child: WeatherAnimation(),
          ),
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              if (weatherProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (weatherProvider.weatherData == null) {
                return const Center(child: Text("Geben Sie einen Ort ein"));
              } else {
                final iconUrl =
                    "http://openweathermap.org/img/wn/${weatherProvider.weatherData!.icon}@2x.png";

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 70, bottom: 100),
                      ),
                      Image.network(
                        iconUrl,
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        weatherProvider.weatherData!.cityName,
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        "${weatherProvider.weatherData!.temperature}°C",
                        style: const TextStyle(fontSize: 48),
                      ),
                      Text(
                        weatherProvider.weatherData!.description,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Luftfeuchtigkeit: ${weatherProvider.weatherData!.humidity}%",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Windgeschwindigkeit: ${weatherProvider.weatherData!.windSpeed} m/s",
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 24.0),
                      Column(
                        children:
                            weatherProvider.weatherForecast.map((forecast) {
                          final forecastIconUrl =
                              "http://openweathermap.org/img/wn/${forecast.icon}@2x.png";
                          return ListTile(
                            leading: Image.network(
                              forecastIconUrl,
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              "${forecast.temperature}°C - ${forecast.description}",
                            ),
                            subtitle: Text(
                              DateFormat('dd-MM-yyyy').format(forecast.date),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (cityName.isNotEmpty) {
            Provider.of<WeatherProvider>(context, listen: false)
                .fetchWeather(cityName);
          }
        },
        backgroundColor: Color.fromARGB(255, 19, 176, 255),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
