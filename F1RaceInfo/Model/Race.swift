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
        self.season = Int(seasonString) ?? 0
        
        let roundString = try container.decode(String.self, forKey: .round)
        self.round = Int(roundString) ?? 0
        
        let dateString =  try container.decode(String.self, forKey: .date)
        self.date = Race.formatter.date(from: dateString) ?? Date()
        
        self.results = try container.decode([Results].self, forKey: .results)
        self.raceName = try container.decode(String.self, forKey: .raceName)
        self.url = try container.decode(String.self, forKey: .url)
        
    }
    
}
