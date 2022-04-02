import UIKit
import CoreLocation

struct Forecast: Codable {
    struct Daily: Codable {
        let dt: Date
        struct Temp: Codable {
            let min: Double
            let max: Double
        }
        let temp: Temp
        let humidity: Int
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
            var weatherIconURL: URL {
                let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
                return URL(string: urlString)!
            }
        }
        let weather: [Weather]
        let clouds: Int
        let pop: Double
    }
    let daily: [Daily]
}



let apiService = APIService.shared
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "E, MMM, d"

CLGeocoder().geocodeAddressString("München") { (placemarks, error) in
    if let error = error {
        print(error.localizedDescription)
    }
    if let lat = placemarks?.first?.location?.coordinate.latitude,
       let lon = placemarks?.first?.location?.coordinate.longitude {
        print("Lat: \(lat); Lon: \(lon)")
        
        apiService.getJSON(urlString:
                            "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&lang=de&appid=7e5da986d80232efd714c8abf2a1db1b",
                           dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
            switch result {
            case .success(let forecast):
                for day in forecast.daily {
                    print(dateFormatter.string(from: day.dt))
                    print("   Max:  ", day.temp.max)
                    print("   Max:  ", day.temp.min)
                    print("   Humidity:  ", day.humidity)
                    print("   Description:  ", day.weather[0].description)
                    print("   Clouds:  ", day.clouds)
                    print("   pop:  ", day.pop)
                    print("   IconURL:  ", day.weather[0].weatherIconURL)
                }
            case .failure(let apiError):
                switch apiError {
                case .error(let errorString):
                    print(errorString)
                }
            }

        }
        
        
    }
}



