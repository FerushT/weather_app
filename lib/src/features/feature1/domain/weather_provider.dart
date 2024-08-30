import 'package:flutter/material.dart'; // Importiert Material Design Widgets für Flutter.
import 'weather_service.dart'; // Importiert den Service zum Abrufen von Wetterdaten.
import 'weather_models.dart'; // Importiert die Modelle für Wetterdaten und Wettervorhersage.

// Provider für das Wetter und die Vorhersagen.
class WeatherProvider with ChangeNotifier {
  WeatherData? _weatherData; // Speichert die aktuellen Wetterdaten.
  List<WeatherForecastData> _weatherForecast =
      []; // Speichert die Wettervorhersagedaten.
  bool isLoading = false; // Gibt an, ob gerade Wetterdaten geladen werden.

  WeatherData? get weatherData =>
      _weatherData; // Gibt die aktuellen Wetterdaten zurück.
  List<WeatherForecastData> get weatherForecast =>
      _weatherForecast; // Gibt die Wettervorhersagedaten zurück.

  Future<void> fetchWeather(String cityName) async {
    // Methode zum Abrufen der Wetterdaten und Vorhersagen.
    isLoading = true; // Setzt den Ladezustand auf true.
    notifyListeners(); // Benachrichtigt alle Abonnenten über den Zustand.
    try {
      _weatherData = await WeatherService()
          .fetchWeather(cityName); // Ruft die aktuellen Wetterdaten ab.
      _weatherForecast = await WeatherService()
          .fetchWeatherForecast(cityName); // Ruft die Wettervorhersagedaten ab.
    } catch (e) {
      _weatherData =
          null; // Setzt die Wetterdaten auf null, wenn ein Fehler auftritt.
      _weatherForecast = []; // Setzt die Wettervorhersage auf eine leere Liste.
    } finally {
      isLoading =
          false; // Setzt den Ladezustand auf false, nachdem die Daten geladen wurden.
      notifyListeners(); // Benachrichtigt alle Abonnenten über den Zustand.
    }
  }
}
