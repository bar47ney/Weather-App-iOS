//
//  City.swift
//  diplom_3
//
//  Created by Сергей Недведский on 23.02.25.
//
// MARK: - FiveDaysWeather
struct FiveDaysWeather: Decodable {
    let cod: String
//    let message: Int?
//    let cnt: Int?
    let list: [List]
//    let city: City?
}

// MARK: - City
struct City: Decodable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}


// MARK: - List
struct List: Decodable {
    let main: FiveMain
//    let visibility: Int
    let dt_txt: String
    let weather: [FiveWeather]
    let wind: FiveWind
//    let dt: Int?
//    let clouds: Clouds?
//    let pop: Int?
//    let sys: FiveSys?
}

struct CurrentWeather: Decodable{
    let coord: Coord?
    let weather: [Weather?]
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let id: Int?
    let name: String?
    let cod: Int?
}

struct Coord: Decodable{
    let lat: Double?
    let lon: Double?
}


struct Weather: Decodable{
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct FiveWeather: Decodable{
    let description: String
    let icon: String
}

struct Main: Decodable{
    let temp: Double?
    let pressure: Int?
    let humidity: Int?
    let temp_min: Double?
    let temp_max: Double?
}

struct FiveMain: Decodable{
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Decodable{
    let speed: Double?
    let deg: Int?
}

struct FiveWind: Decodable{
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Clouds: Decodable{
    let all: Int?
}

struct Sys: Decodable{
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

struct FiveSys: Decodable{
    let pod: String?
}

