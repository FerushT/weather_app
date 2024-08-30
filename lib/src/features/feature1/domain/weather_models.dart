// Klasse zum Speichern der aktuellen Wetterdaten.
class WeatherData {
  final double temperature;
  final String description;
  final String cityName;
  final int humidity;
  final double windSpeed;
  final String icon;

  WeatherData({
    required this.temperature,
    required this.description,
    required this.cityName,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
  });

  // Methode zum Erstellen eines WeatherData-Objekts aus JSON-Daten.
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    double temperatureInCelsius = json["main"]["temp"] -
        273.15; // Konvertiert die Temperatur von Kelvin nach Celsius.
    double roundedTemperature = double.parse(temperatureInCelsius
        .toStringAsFixed(1)); // Rundet die Temperatur auf eine Dezimalstelle.

    return WeatherData(
      temperature: roundedTemperature,
      description: json["weather"][0]
          ["description"], //setzt die Beschreibung des Wetters.
      cityName: json["name"],
      humidity: json["main"]["humidity"],
      windSpeed: json["wind"]["speed"],
      icon: json["weather"][0]["icon"],
    );
  }

  // Methode zum Konvertieren des WeatherData-Objekts in ein JSON-Format.
  Map<String, dynamic> toJson() => {
        'temperature': temperature, // Gibt die Temperatur zurück.
        'description': description,
        'cityName': cityName,
        'humidity': humidity,
        'windSpeed': windSpeed,
        'icon': icon,
      };
}

// Klasse zum Speichern der Wettervorhersagedaten.
class WeatherForecastData {
  final DateTime date;
  final double temperature;
  final String description; // Beschreibung des Wetters (z.B. "klarer Himmel").
  final String icon;

  WeatherForecastData({
    required this.date, // Initialisiert das Datum.
    required this.temperature,
    required this.description,
    required this.icon,
  });

  // Methode zum Erstellen eines WeatherForecastData-Objekts aus JSON-Daten.
  factory WeatherForecastData.fromJson(Map<String, dynamic> json) {
    double temperatureInCelsius = json["main"]["temp"] -
        273.15; // Konvertiert die Temperatur von Kelvin nach Celsius.
    double roundedTemperature = double.parse(temperatureInCelsius
        .toStringAsFixed(1)); // Rundet die Temperatur auf eine Dezimalstelle.

    return WeatherForecastData(
      date: DateTime.parse(json["dt_txt"]), // Setzt das Datum und die Uhrzeit.
      temperature: roundedTemperature,
      description: json["weather"][0]["description"],
      icon: json["weather"][0]["icon"],
    );
  }
}
