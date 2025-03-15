//
//  StorageManager.swift
//  diplom_1
//
//  Created by Сергей Недведский on 8.01.25.
//

import Foundation
import UIKit

extension String {
    fileprivate static let cities = "cities"
}

final class StorageManagaer {

    static let shared = StorageManagaer()

    private init() {

    }

    func deleteCity(city: StorageCity) -> [StorageCity] {
        UserDefaults.standard.set(
            encodable: loadCities().filter { $0.name != city.name },
            forKey: .cities)
        return loadCities()
    }

    func saveCity(city: StorageCity) -> Bool {
        var cities = loadCities()
        let result = cities.filter { $0.name == city.name }
        if result.isEmpty {
            cities.insert(city, at: 0)
            UserDefaults.standard.set(encodable: cities, forKey: .cities)
            return true
        } else {
            return false
        }
    }

    func saveChangedCities(cities: [StorageCity]) {
        UserDefaults.standard.set(encodable: cities, forKey: .cities)
    }

    func loadCities() -> [StorageCity] {
        let cities = UserDefaults.standard.value(
            [StorageCity].self, forKey: .cities)
        //        UserDefaults.standard.removeObject(forKey: String.cities)
        return cities ?? []
    }
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }

    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data)
        {
            return value
        }
        return nil
    }
}
