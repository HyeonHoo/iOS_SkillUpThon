//
//  Weatherinformation.swift
//  Weather
//
//  Created by 신현호 on 2023/06/22.
//

import Foundation

struct WeatherInformation: Codable {    //codable dms deco enco 준수하는타입
    //json 형식을 주고받기위해 codable 프로토콜을 채택합니다.
  let weather: [Weather]
  let temp: Temp
  let name: String  //도시이름을 가져옵니다.

  enum CodingKeys: String, CodingKey {
    case weather
    case temp = "main"
    case name
  }
}

struct Weather: Codable {
  let id: Int
  let main: String
  let description: String
  let icon: String
}

struct Temp: Codable {
  let temp: Double
  let feelsLike: Double
  let minTemp: Double
  let maxTemp: Double

  enum CodingKeys: String, CodingKey { //CodingKey json 키와 프로퍼티 이름이 달라도 매핑가능하게 해줍니다.
    case temp
    case feelsLike = "feels_like"
    case minTemp = "temp_min"
    case maxTemp = "temp_max"
  }
}
