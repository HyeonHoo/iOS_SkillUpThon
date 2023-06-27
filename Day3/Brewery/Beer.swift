//
//  Beer.swift
//  Brewary
//
//  Created by 신현호 on 2023/06/22.
//

import Foundation

struct Beer: Decodable {
    let id: Int?    //데이터 nil 일 수 있으니까 옵셔널 형으로 선언.
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodParing: [String]?
    
    var tagLine: String {   //요청받은 값 문자열을 변환하는 작업
        let tags = taglineString?.components(separatedBy: ". ") //. 단위로 구분
        let hashtags = tags?.map { "#" + $0.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: " #")
        }
        return hashtags?.joined(separator: " ") ?? ""   //#tap #good
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case taglineString = "tagline"
        case imageURL = "image_url"
        case brewersTips = "brewers_tips"
        case foodParing = "food_pairing"
    }
}
