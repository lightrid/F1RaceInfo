//
//  Driver.swift
//  F1RaceInfo
//
//  Created by Mykhailo Kviatkovskyi on 09.06.2021.
//

import Foundation

struct FormulaData: Decodable {
    var mrData: MRData
    
    enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}
struct MRData: Decodable {
    var xmlns: String
    var series: String
    var url: String
    var limit: String
    var offset: String
    var total: String
    var driverTable: DriverTable?
    var raceTable: RaceTable?
    
    enum CodingKeys: String, CodingKey {
        case xmlns
        case series
        case url
        case limit
        case offset
        case total
        case driverTable = "DriverTable"
        case raceTable = "RaceTable"
    }
}

struct DriverTable: Decodable {
    var drivers: [Driver]
    
    enum CodingKeys: String, CodingKey {
        case drivers = "Drivers"
    }
}

struct RaceTable: Decodable {
    var season: String
    var position: String?
    var races: [Race]
    
    enum CodingKeys: String, CodingKey {
        case season
        case position
        case races = "Races"
        
    }
}

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

struct Results: Decodable {
    var position: String
    var driver: Driver
    var time: Time?
    
    enum CodingKeys: String, CodingKey {
        case position
        case driver = "Driver"
        case time = "Time"
    }
}

struct Time: Decodable {
    var time: String
    
    enum CodingKeys: String, CodingKey {
        case time
    }
}
struct Driver: Decodable {
    
    var driverId: String
    var url: String
    var firstName: String
    var lastName: String
    var permanentNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case driverId
        case url
        case firstName = "givenName"
        case lastName = "familyName"
        case permanentNumber
    }
}
