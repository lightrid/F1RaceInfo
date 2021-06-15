//
//  Race.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 12.06.2021.
//

import Foundation

struct Race: Decodable {
    var season: Int
    var round: Int
    var url: String
    var raceName: String
    var results: [Results]
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case season
        case round
        case url
        case raceName
        case results = "Results"
        case date
    }
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let seasonString = try container.decode(String.self, forKey: .season)
        let roundString = try container.decode(String.self, forKey: .round)
        let dateString =  try container.decode(String.self, forKey: .date)
        
        guard let seasonInt = Int(seasonString), let roundInt = Int(roundString) else {
            let context = DecodingError.Context(codingPath: container.codingPath,
                                                debugDescription: "Could not parse json key to a Int object")
            throw DecodingError.dataCorrupted(context)
        }
        guard let date = Race.formatter.date(from: dateString) else {
            let context = DecodingError.Context(codingPath: container.codingPath,
                                                debugDescription: "Could not parse json key to a Date object")
            throw DecodingError.dataCorrupted(context)
        }
        
        season = seasonInt
        round = roundInt
        self.date = date
        
        results = try container.decode([Results].self, forKey: .results)
        raceName = try container.decode(String.self, forKey: .raceName)
        url = try container.decode(String.self, forKey: .url)
    }
}
