import 'package:flutter/material.dart'; // Basisbibliothek für UI-Elemente und Material-Design.
import 'package:provider/provider.dart'; // Bibliothek zur Verwaltung des App-States.
import 'package:shared_preferences/shared_preferences.dart'; // Bibliothek zum Speichern von Daten auf dem Gerät.
import 'package:intl/intl.dart'; // Bibliothek zur Formatierung von Datum und Uhrzeit.
import 'package:weather_app/src/features/feature1/domain/weather_animation.dart'; // Korrekte Import-Anweisung für WeatherAnimation
import '../domain/weather_provider.dart'; // Import der Wetterlogik (WeatherProvider)

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherScreenState createState() =>
      _WeatherScreenState(); // Erzeugt den Zustand (State) für den Bildschirm.
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName =
      ""; // Variable, um den eingegebenen Stadtnamen zu speichern.

  @override
  void initState() {
    super
        .initState(); // Führt die Standardinitialisierungen der übergeordneten Klasse aus.
    _loadCityName(); // Lädt den gespeicherten Stadtnamen, wenn der Bildschirm gestartet wird.
  }

  void _loadCityName() async {
    final prefs = await SharedPreferences
        .getInstance(); // Holt sich eine Instanz von SharedPreferences.
    final savedCityName =
        prefs.getString('cityName'); // Liest den gespeicherten Stadtnamen.
    if (savedCityName != null && savedCityName.isNotEmpty) {
      setState(() {
        cityName = savedCityName; // Setzt den geladenen Stadtnamen.
      });
      Provider.of<WeatherProvider>(context, listen: false).fetchWeather(
          savedCityName); // Holt das Wetter für die gespeicherte Stadt.
    }
  }

  void _saveCityName(String cityName) async {
    final prefs = await SharedPreferences
        .getInstance(); // Holt sich eine Instanz von SharedPreferences.
    prefs.setString('cityName', cityName); // Speichert den Stadtnamen.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Erlaubt es dem Inhalt, hinter der App-Leiste (AppBar) zu erscheinen.
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Macht die App-Leiste durchsichtig.
        elevation: 0, // Entfernt den Schatten der App-Leiste.
        title: const Text(
          "Wetter", // Titel der App-Leiste.
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
              100.0), // Höhe des Eingabefelds unter der App-Leiste.
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                cityName =
                    value; // Aktualisiert den Stadtnamen, während der Benutzer tippt.
              },
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  _saveCityName(
                      value); // Speichert den eingegebenen Stadtnamen.
                  Provider.of<WeatherProvider>(context, listen: false)
                      .fetchWeather(
                          value); // Holt das Wetter für die eingegebene Stadt.
                }
              },
              decoration: const InputDecoration(
                hintText: "Ort eingeben",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const SizedBox.expand(
            child: WeatherAnimation(),
          ), // Animations Widget für den Screen.
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              if (weatherProvider.isLoading) {
                // Zeigt einen Ladeindikator an, wenn Daten geladen werden.
                return const Center(child: CircularProgressIndicator());
              } else if (weatherProvider.weatherData == null) {
                // Wenn keine Wetterdaten verfügbar sind
                return const Center(child: Text("Geben Sie einen Ort ein"));
              } else {
                final iconUrl =
                    "http://openweathermap.org/img/wn/${weatherProvider.weatherData!.icon}@2x.png"; // URL für das Wetter-Icon.

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 70, bottom: 100),
                      ),
                      Image.network(
                        iconUrl, // Wetter-Icon wird aus dem Internet geladen.
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
                              "http://openweathermap.org/img/wn/${forecast.icon}@2x.png"; // URL für das Vorhersage-Icon.
                          return ListTile(
                            leading: Image.network(
                              forecastIconUrl, // Vorhersage-Icon.
                              width: 50,
                              height: 50,
                            ),
                            title: Text(
                              "${forecast.temperature}°C - ${forecast.description}", // Temperatur und Beschreibung der Vorhersage.
                            ),
                            subtitle: Text(
                              DateFormat('dd-MM-yyyy').format(
                                  forecast.date), // Datum der Vorhersage.
                            ),
                          );
                        }).toList(), // Wandelt die Vorhersagen in eine Liste von Widgets um.
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
            // Überprüft, ob ein Stadtname eingegeben wurde.
            Provider.of<WeatherProvider>(context, listen: false).fetchWeather(
                cityName); // Aktualisiert das Wetter für die eingegebene Stadt.
          }
        },
        backgroundColor: Color.fromARGB(255, 19, 176, 255),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
