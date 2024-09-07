Weather App 🌤️
A beautiful and easy-to-use weather forecasting application developed using Flutter and WeatherAPI. The app provides real-time weather data for your current location or any other city around the world. You can also view a 7-day weather forecast with detailed information about temperature, humidity, wind speed, and more.

Features ✨
🌆 City Search: Enter any city to get its current weather.
🌡️ Current Weather: View current temperature, weather conditions, and additional details like humidity and wind speed.
🌞 7-Day Forecast: Check the weather forecast for the next seven days with daily temperature highs and lows.
🔄 Dynamic UI: Interactive and visually appealing design that changes based on the weather conditions.
📡 Weather API Integration: Fetches real-time weather data using the WeatherAPI.
🚫 Error Handling: Displays error messages when there's a network issue.
Dependencies 📦
cached_network_image
flutter_dotenv (for managing environment variables)
flutter_typeahead
google_fonts
quickalert
API Key Management 🔑
The app uses the WeatherAPI to fetch weather data. To keep the API key secure, it is stored in a .env file located in the assets directory.

Setting up the API Key:
Get your API key from WeatherAPI.

Create a .env file inside the assets directory and add the following:

WEATHER_API_KEY=your_api_key

In the main.dart, the .env file is loaded as follows:

Future<void> main() async {
await dotenv.load(fileName: "assets/.env");
runApp(const MyApp());
}

Access the API key in weather_service.dart using:

final String? apiKey = dotenv.env['WEATHER_API_KEY'];

Screenshots 📸
Home Screen

City Search

7-Day Forecast

How to Run 🛠️
Clone the repository:

git clone https://github.com/abhaysaqi/Weather_app.git

Navigate to the project directory:

cd weather-app

Install dependencies:

flutter pub get

Ensure that your .env file is correctly placed in the assets directory and contains your API key.
Run the app:

flutter run
