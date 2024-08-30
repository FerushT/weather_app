import 'dart:convert'; // Zum Konvertieren von JSON-Daten.
import 'package:http/http.dart' as http; // Für HTTP-Anfragen an die API.
import 'package:intl/intl.dart'; // Zum Formatieren von Datum und Uhrzeit.
import 'weather_models.dart'; // Importiert die Modelle für die Wetterdaten.

// Klasse zum Abrufen der Wetterdaten und Wettervorhersagen von der API.
class WeatherService {
  final String apiKey =
      "4c407794b98aa0be50c4c77b766fa704"; // API-Schlüssel für den Zugriff auf die Wetterdaten.

  Future<WeatherData?> fetchWeather(String cityName) async {
    // Methode, um aktuelle Wetterdaten abzurufen
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=${Uri.encodeComponent(cityName)}&appid=$apiKey&lang=de"; // URL für die aktuelle Wetter-API.

    final response =
        await http.get(Uri.parse(url)); // Sendet eine GET-Anfrage an die API.

    if (response.statusCode == 200) {
      // Überprüft, ob die Anfrage erfolgreich war.
      final data = json.decode(response.body); // Dekodiert die JSON-Antwort.
      return WeatherData.fromJson(
          data); // Konvertiert die Daten in ein WeatherData-Objekt und gibt es zurück.
    } else {
      throw Exception(
          "Fehlerstatuscode: ${response.statusCode}"); // Wirft eine Ausnahme, wenn ein Fehler auftritt.
    }
  }

  Future<List<WeatherForecastData>> fetchWeatherForecast(
      String cityName) async {
    // Methode, um die Wettervorhersage abzurufen.
    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=${Uri.encodeComponent(cityName)}&appid=$apiKey&lang=de"; // URL für die Wettervorhersage-API.

    final response =
        await http.get(Uri.parse(url)); // Sendet eine GET-Anfrage an die API.

    if (response.statusCode == 200) {
      // Überprüft, ob die Anfrage erfolgreich war.
      final data = json.decode(response.body); // Dekodiert die JSON-Antwort.
      List<dynamic> forecastList =
          data["list"]; // Extrahiert die Liste der Vorhersagen.
      Map<String, WeatherForecastData> dailyMaxTemperatures =
          {}; // Erstellt eine Map, um die Tageshöchsttemperaturen zu speichern.

      // Berechnung der Tageshöchsttemperaturen.
      for (var item in forecastList) {
        // Durchläuft die Liste der Vorhersagen.
        WeatherForecastData forecast = WeatherForecastData.fromJson(
            item); // Konvertiert die JSON-Daten in ein WeatherForecastData-Objekt.
        String formattedDate = DateFormat('dd-MM-yyyy')
            .format(forecast.date); // Formatiert das Datum der Vorhersage.

        if (!dailyMaxTemperatures.containsKey(formattedDate)) {
          // Überprüft, ob das Datum schon in der Map enthalten ist.
          dailyMaxTemperatures[formattedDate] =
              forecast; // Fügt die Vorhersage hinzu, wenn das Datum noch nicht enthalten ist.
        } else {
          if (forecast.temperature >
              dailyMaxTemperatures[formattedDate]!.temperature) {
            // Vergleicht die Temperaturen, um die Höchsttemperatur zu bestimmen.
            dailyMaxTemperatures[formattedDate] =
                forecast; // Aktualisiert die Map mit der höheren Temperatur.
          }
        }
      }

      // Rückgabe der Liste von Tageshöchsttemperaturen.
      return dailyMaxTemperatures.values
          .take(5)
          .toList(); // Gibt die ersten 5 Tageshöchsttemperaturen zurück.
    } else {
      throw Exception(
          "Fehlerstatuscode: ${response.statusCode}"); // Wirft eine Ausnahme, wenn ein Fehler auftritt.
    }
  }
}
