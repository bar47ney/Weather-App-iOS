//
//  ExamplePresenter.swift
//  lesson_26
//
//  Created by Сергей Недведский on 23.01.25.
//
import Foundation

protocol IWeatherPresenter {
    func getCurrentWeather(
        from city: String,
        completion: @escaping (CurrentWeather?, Int?) -> Void)
    func deleteCity(city: StorageCity, completion: @escaping ([StorageCity]) -> Void)
}

final class WeatherPresenter: IWeatherPresenter {
    private let service: INetworkService = NetworkService()

    func deleteCity(city: StorageCity, completion: @escaping ([StorageCity]) -> Void) {
        completion(StorageManagaer.shared.deleteCity(city: city))
    }
    
    func getCurrentWeather(
        from city: String,
        completion: @escaping (CurrentWeather?, Int?) -> Void
    ) {

        service.getCurrentWeatherOfCity(from: city) { [weak self] data in
            guard let data else {
                completion(nil, nil)
                return
            }

            guard
                let json = try? JSONSerialization.jsonObject(
                    with: data, options: .mutableLeaves)
            else {
                completion(nil, nil)
                return
            }

            if let json = json as? [String: Any] {
                guard
                    let cod = json["cod"] as? Int
                else {
                    completion(nil, 404)
                    return
                }
                if cod == 200 {
                    let weather = try? JSONDecoder().decode(
                        CurrentWeather.self, from: data)
                    completion(weather ?? nil, cod)
                } else {
                    completion(nil, 404)
                }
            } else {
                completion(nil, nil)
                return
            }
        }
    }
}
