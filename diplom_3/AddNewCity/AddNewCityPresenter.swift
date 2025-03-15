//
//  ExamplePresenter.swift
//  lesson_26
//
//  Created by Сергей Недведский on 23.01.25.
//
import Foundation

private enum WeatherAPI {
    case clear
    case fewClouds
    case scatteredClouds
    case brokenclouds
    case showerRain
    case rain
    case thunderstorm
    case snow
    case mist
    case cloudywithclearing
    case overcast
    case smallrain
    //additional
    case smallsnow
    case rainAndSnow
    case snowAndRain
}

protocol IAddNewCityPresenter {
    func addNewCity(
        from city: String, completion: @escaping (Bool) -> Void)
    func setBackgroundVideo(
        for description: String, completion: @escaping (URL?) -> Void)
    func getFiveWeather(
        from city: String, completion: @escaping (FiveDaysWeather?) -> Void)
}

final class AddNewCityPresenter: IAddNewCityPresenter {
    private let service: INetworkService = NetworkService()

    func addNewCity(
        from city: String,
        completion: @escaping (Bool) -> Void
    ) {
        completion(
            StorageManagaer.shared.saveCity(city: StorageCity(name: city)))
    }

    func setBackgroundVideo(
        for description: String, completion: @escaping (URL?) -> Void
    ) {
        guard let weather = WeatherAPI(description: description) else {
            completion(nil)
            return
        }

        let videoURL: URL

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = Constansts.timeFormatToView
        guard let hours = Int(formatter.string(from: date)) else { return }
        if hours > Constansts.checkThemeTimeFrom
            || hours < Constansts.checkThemeTimeTo
        {
            switch weather {
            case .clear:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/9245420/9245420-uhd_1440_2068_30fps.mp4"
                )!
            case .fewClouds:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/5605814/5605814-hd_1080_1920_25fps.mp4"
                )!
            case .scatteredClouds:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/9669392/9669392-hd_1080_1920_30fps.mp4"
                )!
            case .brokenclouds:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/9669392/9669392-hd_1080_1920_30fps.mp4"
                )!

            case .showerRain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/19320840/19320840-hd_1080_1920_30fps.mp4"
                )!

            case .rain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/7681540/7681540-uhd_1440_2560_24fps.mp4"
                )!
            case .thunderstorm:
                videoURL = URL(
                    string:
                        "https://cdn.pixabay.com/video/2024/08/31/229128_large.mp4"
                )!

            case .snow:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/19320840/19320840-hd_1080_1920_30fps.mp4"
                )!
            case .mist:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/18359332/18359332-uhd_1440_2560_30fps.mp4"
                )!

            case .overcast:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/5605814/5605814-hd_1080_1920_25fps.mp4"
                )!
            case .smallrain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/8549588/8549588-hd_1080_1920_25fps.mp4"
                )!
            case .smallsnow:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/19320840/19320840-hd_1080_1920_30fps.mp4"
                )!
            case .rainAndSnow:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/6620814/6620814-uhd_1440_2732_25fps.mp4"
                )!
            case .snowAndRain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/19320840/19320840-hd_1080_1920_30fps.mp4"
                )!
            case .cloudywithclearing:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/5605814/5605814-hd_1080_1920_25fps.mp4"
                )!
            }
        } else {
            switch weather {
            case .clear:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/6813908/6813908-uhd_1440_2496_30fps.mp4"
                )!
            case .fewClouds:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/9669392/9669392-hd_1080_1920_30fps.mp4"
                )!
            case .scatteredClouds:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/9669392/9669392-hd_1080_1920_30fps.mp4"
                )!
            case .brokenclouds:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/9669392/9669392-hd_1080_1920_30fps.mp4"
                )!

            case .showerRain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/8549517/8549517-hd_1080_1920_25fps.mp4"
                )!

            case .rain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/8549517/8549517-hd_1080_1920_25fps.mp4"
                )!
            case .thunderstorm:
                videoURL = URL(
                    string:
                        "https://cdn.pixabay.com/video/2024/08/31/229128_large.mp4"
                )!

            case .snow:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/6620814/6620814-uhd_1440_2732_25fps.mp4"
                )!
            case .mist:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/15238832/15238832-hd_1080_1920_30fps.mp4"
                )!

            case .overcast:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/6707366/6707366-hd_1080_1920_30fps.mp4"
                )!
            case .smallrain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/8549588/8549588-hd_1080_1920_25fps.mp4"
                )!
            case .smallsnow:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/6620814/6620814-uhd_1440_2732_25fps.mp4"
                )!
            case .rainAndSnow:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/6620814/6620814-uhd_1440_2732_25fps.mp4"
                )!
            case .snowAndRain:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/6620814/6620814-uhd_1440_2732_25fps.mp4"
                )!
            case .cloudywithclearing:
                videoURL = URL(
                    string:
                        "https://videos.pexels.com/video-files/9669392/9669392-hd_1080_1920_30fps.mp4"
                )!
            }
        }

        completion(videoURL)
    }

    func getFiveWeather(
        from city: String, completion: @escaping (FiveDaysWeather?) -> Void
    ) {
        service.getFiveDaysWeatherOfCity(from: city) { [weak self] data in
            guard let data else { return }
            completion(self?.parseFiveWeather(data: data))
        }
    }

    private func parseFiveWeather(data: Data) -> FiveDaysWeather? {
        guard
            let json = try? JSONSerialization.jsonObject(
                with: data, options: .mutableLeaves)
        else { return nil }

        if let json = json as? [String: Any] {
            guard
                let cod = json["cod"] as? String,

                let list = json["list"] as? [[String: Any]],

                let parseList = parseList(data: list)

            else {
                return nil
            }
            return FiveDaysWeather(cod: cod, list: parseList)
        } else {
            return nil
        }

    }

    private func parseList(data: [[String: Any]]) -> [List]? {
        var list: [List] = []
        for jsonDict in data {
            guard
                let dt_txt = jsonDict["dt_txt"] as? String,

                //                let visibility = jsonDict["visibility"] as? Int,

                let main = jsonDict["main"] as? [String: Any],

                let parseMain = parseMain(data: main),

                let weather = jsonDict["weather"] as? [[String: Any]],

                let parseWeather = parseWeather(data: weather),

                let wind = jsonDict["wind"] as? [String: Any],

                let parseWind = parseWind(data: wind)
            else {
                return nil
            }
            let elem = List(
                main: parseMain, dt_txt: dt_txt,
                weather: parseWeather, wind: parseWind)
            list.append(elem)
        }
        return list
    }

    private func parseMain(data: [String: Any]) -> FiveMain? {
        guard
            let temp = data["temp"] as? Double,

            let feels_like = data["feels_like"] as? Double,

            let pressure = data["pressure"] as? Int,

            let humidity = data["humidity"] as? Int
        else {
            return nil
        }
        return FiveMain(
            temp: temp, feels_like: feels_like, pressure: pressure,
            humidity: humidity
        )
    }

    private func parseWeather(data: [[String: Any]]) -> [FiveWeather]? {
        var weatherArray: [FiveWeather] = []
        for jsonDict in data {
            guard
                let description = jsonDict["description"] as? String,
                let icon = jsonDict["icon"] as? String
            else {
                return nil
            }
            let elem = FiveWeather(description: description, icon: icon)
            weatherArray.append(elem)
        }
        return weatherArray
    }

    private func parseWind(data: [String: Any]) -> FiveWind? {
        guard
            let speed = data["speed"] as? Double,

            let deg = data["deg"] as? Int,

            let gust = data["gust"] as? Double
        else {
            return nil
        }
        return FiveWind(speed: speed, deg: deg, gust: gust)
    }

}

extension WeatherAPI {
    init?(description: String) {
        switch description {
        case "ясно":
            self = .clear
        case "малооблачно":
            self = .fewClouds
        case "переменная облачность":
            self = .scatteredClouds
        case "разорванная облачность":
            self = .brokenclouds
        case "ливень":
            self = .showerRain
        case "дождь":
            self = .rain
        case "гроза":
            self = .thunderstorm
        case "снег":
            self = .snow
        case "туман":
            self = .mist
        case "облачно с прояснениями":
            self = .cloudywithclearing
        case "пасмурно":
            self = .overcast
        case "небольшой дождь":
            self = .smallrain

        case "облачно":
            self = .overcast
        case "небольшой снег":
            self = .smallsnow
        case "дождь со снегом":
            self = .rainAndSnow
        case "снег с дождём":
            self = .snowAndRain
        default:
            return nil
        }
    }
}
