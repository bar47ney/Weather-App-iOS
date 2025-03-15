//  NetworkService.swift
//  lesson_26
//
//  Created by Сергей Недведский on 23.01.25.
//

import Foundation

private enum TypeWeather: String {
    case current = "weather?q="
    case forecast = "forecast?q="
}

private enum Units: String {
    case standard
    case imperial
    case metric
}

private enum Lang: String {
    case ru
    case en
}

private enum RequestType: String {
    case GET
    case POST
}

extension String {
    static let baseURL = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = "&appid=97049d9a9a5984874c8430bcbb41475a"
    static let units = "&units="
    static let lang = "&lang="
}

protocol INetworkService {
    func getCurrentWeatherOfCity(
        from city: String, completion: @escaping (Data?) -> Void)
    func getFiveDaysWeatherOfCity(
        from city: String, completion: @escaping (Data?) -> Void)
}

final class NetworkService: INetworkService {

    func getCurrentWeatherOfCity(
        from city: String, completion: @escaping (Data?) -> Void
    ) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.sendRequest(.current, requestType: .GET, from: city) { data in
                completion(data)
            }
//        }
    }

    func getFiveDaysWeatherOfCity(
        from city: String, completion: @escaping (Data?) -> Void
    ) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.sendRequest(.forecast, requestType: .GET, from: city) { data in
                completion(data)
            }
//        }
    }

    private func sendRequest(
        _ type: TypeWeather,
        requestType: RequestType = .GET,
        from city: String,
        completion: @escaping (Data?) -> Void
    ) {
        guard
            let url = URL(
                string: .baseURL + type.rawValue + city + .apiKey + .units
                    + Units.metric.rawValue + .lang + Lang.ru.rawValue)
        else { return }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
