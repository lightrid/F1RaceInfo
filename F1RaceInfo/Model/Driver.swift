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

struct WinnerDrivers {
    var driver: Driver
    var raceName: String
}

struct RaceTable: Decodable {
    var season: String
    var position: String
    var races: [Races]
    
    enum CodingKeys: String, CodingKey {
        case season
        case position
        case races = "Races"
    }
}

struct Races: Decodable {
    var season: String
    var round: String
    var url: String
    var raceName: String
    var results: [Results]
    
    enum CodingKeys: String, CodingKey {
        case season
        case round
        case url
        case raceName
        case results = "Results"
    }
}

struct Results: Decodable {
    var position: String
    var driver: Driver
    
    enum CodingKeys: String, CodingKey {
        case position
        case driver = "Driver"
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
